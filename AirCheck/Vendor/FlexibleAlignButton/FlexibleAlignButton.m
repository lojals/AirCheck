//
//  FlexibleAlignButton.m
//
//  Created by Pham Hoang Le on 13/3/14.
//  Copyright (c) 2014 namanhams. All rights reserved.
//

#import "FlexibleAlignButton.h"

#define CAP_MAX(x, y) (x = (x > y ? y : x))
#define CAP_MIN(x, y) (x = (x < y ? y : x))

#define ROUND_SIZE(size) CGSizeMake(ceil(size.width), ceil(size.height))

#import <objc/runtime.h>
#import <objc/message.h>

void Swizzle(Class c, SEL orig, SEL new)
{
	Method origMethod = class_getInstanceMethod(c, orig);
	Method newMethod = class_getInstanceMethod(c, new);
	if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
		class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	else
		method_exchangeImplementations(origMethod, newMethod);
}



@interface UILabel (Font)

// Original font is the font that is set by calling 'setFont:', or is the default font used by
// UILabel if 'setFont:' is never called.
// This may not be same value as 'font' property. If 'attributedText' is set, 'font' property
// will be one of the UIFont that is used in the 'attributedText', and is not the original font
- (UIFont *) originalFont;

@end



@implementation UILabel (Font)

#define kOriginalFont @"OriginalFont"

+ (void) load {
	// Swap 'setFont:' method with our custom method
	// We want to intercept the 'setFont' method
	Swizzle([self class], @selector(setFont:), @selector(_setMyFont:));
}

- (void) _setMyFont:(UIFont *)font {
	objc_setAssociatedObject(self, kOriginalFont, font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self _setMyFont:font];
}

- (UIFont *) originalFont {
	UIFont *font = objc_getAssociatedObject(self, kOriginalFont);
	if(! font)
		return self.font;
	else
		return font;
}

- (void) dealloc {
	objc_setAssociatedObject(self, kOriginalFont, nil, OBJC_ASSOCIATION_ASSIGN);
#if !__has_feature(objc_arc)
	[super dealloc];
#endif
}

@end


@interface NSMutableAttributedString (DefaultFont)
// Apply the given font to any range within the current attributed string that doesn't have font
- (void) applyDefaultFont:(UIFont *)font;
@end

@implementation NSMutableAttributedString (DefaultFont)

- (void) applyDefaultFont:(UIFont *)font {
	if(! font)
		return;
	
	[self enumerateAttribute:NSFontAttributeName
					 inRange:NSMakeRange(0, self.length)
					 options:0
				  usingBlock:^(id value, NSRange range, BOOL *stop) {
					  if(! value) {
						  [self addAttribute:NSFontAttributeName
									   value:font
									   range:range];
					  }
				  }];
}

@end



@interface FlexibleAlignButton () {
    BOOL _setupLabel;
    BOOL _setupImage;
}
@end


@implementation FlexibleAlignButton

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self _setup];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self _setup];
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self _setup];
}

- (void) setGap:(CGFloat)gap {
    if(fabs(_gap - gap) < 0.0001)
        return;
	
    _gap = gap;
    [self setNeedsLayout];
}

- (void) setAlignment:(ButtonAlignment)alignment {
	if(_alignment == alignment)
		return;
	
	_alignment = alignment;
	[self setNeedsLayout];
}

- (void) _setup {
	self.clipsToBounds = YES;
	self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.titleLabel.numberOfLines = 0;
	_gap = 5;
	_alignment = kButtonAlignmentLabelTop;
}

// Override
- (void) setContentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment {
	[super setContentVerticalAlignment:contentVerticalAlignment];
	[self setNeedsLayout];
}

// Override
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if(! _setupLabel || ! _setupImage) {
        _setupLabel = true;
        return [super titleRectForContentRect:contentRect];
    }
    
    CGSize sizeThatFits = [self _sizeThatFitsLabel:contentRect];
	const CGFloat width = sizeThatFits.width;
	const CGFloat height = sizeThatFits.height;
    CGFloat x, y;
	
	if(self.alignment == kButtonAlignmentImageTop || self.alignment == kButtonAlignmentLabelTop){
		if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter)
			x = contentRect.origin.x + (contentRect.size.width - width) / 2;
		else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
			x = contentRect.origin.x;
		else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
			x = contentRect.origin.x;
		}
		else {
			x = CGRectGetMaxX(contentRect) - width;
		}
	}
	else {
		CGFloat totalWidth = [self _expectedTotalWidth:contentRect];
		
		if(self.alignment == kButtonAlignmentLabelLeft) {
			if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
				x = contentRect.origin.x;
			else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter)
				x = contentRect.origin.x + (contentRect.size.width - totalWidth) / 2;
			else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
				x = CGRectGetMaxX(contentRect) - totalWidth;
			else
				x = contentRect.origin.x;
		}
		else {
			CGRect imageRect = [self imageRectForContentRect:contentRect];
			x = CGRectGetMaxX(imageRect) + self.gap;
		}
	}
	
	CAP_MIN(x, CGRectGetMinX(contentRect));
	
	if(self.alignment == kButtonAlignmentImageTop || self.alignment == kButtonAlignmentLabelTop) {
		if(self.alignment == kButtonAlignmentLabelTop) {
			CGFloat totalHeight = [self _expectedTotalHeight:contentRect];
			
			if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
				y = contentRect.origin.y;
			else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter)
				y = contentRect.origin.y + (contentRect.size.height - totalHeight) / 2;
			else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
				y = CGRectGetMaxY(contentRect) - totalHeight;
			else
				y = contentRect.origin.y;
		}
		else {
			CGRect imageRect = [self imageRectForContentRect:contentRect];
			y = CGRectGetMaxY(imageRect) + self.gap;
		}
	}
	else {
		if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
			y = contentRect.origin.y;
		else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter)
			y = contentRect.origin.y + (contentRect.size.height - height) / 2;
		else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
			y = CGRectGetMaxY(contentRect) - height;
		else
			y = contentRect.origin.y;
	}

	CAP_MIN(y, CGRectGetMinY(contentRect));
	
//    height = CGRectGetMaxY(contentRect) - y;
//    CAP_MAX(height, sizeThatFits.height);
	
    return CGRectMake((int)x, (int)y, width, height);
}


// Override
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if(! _setupLabel || ! _setupImage) {
        _setupImage = true;
        return CGRectZero;
    }
    
	const CGFloat width = self.currentImage.size.width;//(self.currentImage.size.width < contentRect.size.width ? self.currentImage.size.width : contentRect.size.width);
	const CGFloat height = self.currentImage.size.height;
	CGFloat x, y;
	
	if(self.alignment == kButtonAlignmentImageTop || self.alignment == kButtonAlignmentLabelTop) {
		if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter)
			x = contentRect.origin.x + (contentRect.size.width - width) / 2;
		else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
			x = contentRect.origin.x;
		else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
			x = contentRect.origin.x;
		}
		else {
			x = CGRectGetMaxX(contentRect) - width;
		}
	}
	else {
		CGFloat totalWidth = [self _expectedTotalWidth:contentRect];
		
		if(self.alignment == kButtonAlignmentImageLeft) {
			if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
				x = contentRect.origin.x;
			else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter)
				x = contentRect.origin.x + (contentRect.size.width - totalWidth) / 2;
			else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
				x = CGRectGetMaxX(contentRect) - totalWidth;
			else
				x = contentRect.origin.x;
		}
		else {
			CGRect titleRect = [self titleRectForContentRect:contentRect];
			x = CGRectGetMaxX(titleRect) + self.gap;
		}
	}

	CAP_MIN(x, CGRectGetMinX(contentRect));

	if(self.alignment == kButtonAlignmentImageTop || self.alignment == kButtonAlignmentLabelTop) {
		if(self.alignment == kButtonAlignmentLabelTop) {
			CGRect titleRect = [self titleRectForContentRect:contentRect];
			y = CGRectGetMaxY(titleRect) + self.gap;
		}
		else {
			CGFloat totalHeight = [self _expectedTotalHeight:contentRect];
			
			if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
				y = contentRect.origin.y;
			else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter)
				y = contentRect.origin.y + (contentRect.size.height - totalHeight) / 2;
			else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
				y = CGRectGetMaxY(contentRect) - totalHeight;
			else
				y = contentRect.origin.y;
		}
	}
	else {
		if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
			y = contentRect.origin.y;
		else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter)
			y = contentRect.origin.y + (contentRect.size.height - height) / 2;
		else if(self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
			y = CGRectGetMaxY(contentRect) - height;
		else
			y = contentRect.origin.y;
	}
	
	CAP_MIN(y, CGRectGetMinY(contentRect));

//    height = CGRectGetMaxY(contentRect) - y;
//    CAP_MAX(height, self.currentImage.size.height);
	
    return CGRectMake(x, y, width, height);
}

- (CGFloat) _expectedTotalHeight:(CGRect)contentRect {
	if(self.alignment == kButtonAlignmentImageTop || self.alignment == kButtonAlignmentLabelTop) {
		CGSize labelSize = [self _sizeThatFitsLabel:contentRect];
		return labelSize.height + self.currentImage.size.height + self.gap;
	}
	else
		return 0; // Don't care
}

- (CGFloat) _expectedTotalWidth:(CGRect)contentRect {
	if(self.alignment == kButtonAlignmentImageLeft || self.alignment == kButtonAlignmentLabelLeft) {
		CGSize labelSize = [self _sizeThatFitsLabel:contentRect];
		return labelSize.width + self.currentImage.size.width + self.gap;
	}
	else
		return 0; // Don't care
}

- (CGSize) _sizeThatFitsLabel:(CGRect)contentRect {
    if([self respondsToSelector:@selector(currentAttributedTitle)] && self.currentAttributedTitle) {
        if([self.currentAttributedTitle respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.currentAttributedTitle];
            [mutableAttributedString applyDefaultFont:[self.titleLabel originalFont]];
            CGRect boundingRect = [mutableAttributedString boundingRectWithSize:contentRect.size
                                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                        context:nil];
#if !__has_feature(objc_arc)
            [mutableAttributedString release];
#endif
            
            return ROUND_SIZE(boundingRect.size);
        }
        else {
            CGSize size = [self.currentAttributedTitle size];
            CAP_MAX(size.width, CGRectGetWidth(contentRect));
            CAP_MAX(size.height, CGRectGetHeight(contentRect));
            
            return ROUND_SIZE(size);
        }
    }
    else if(self.currentTitle){
        UIFont *font = self.titleLabel.font;
        
        if([self.currentTitle respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            CGRect boundingRect = [self.currentTitle boundingRectWithSize:contentRect.size
                                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               attributes:@{NSFontAttributeName: font}
                                                                  context:nil];
            return ROUND_SIZE(boundingRect.size);
        }
        else {
            CGSize size = [self.currentTitle sizeWithFont:font
                                        constrainedToSize:contentRect.size
                                            lineBreakMode:self.titleLabel.lineBreakMode];
            return ROUND_SIZE(size);
        }
    }
    else
        return CGSizeZero;
}

@end
