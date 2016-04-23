//
//  FlexibleAlignButton.h
//
//  Created by Pham Hoang Le on 13/3/14.
//  Copyright (c) 2014 namanhams. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonAlignment) {
	// Vertical
	kButtonAlignmentLabelTop,
	kButtonAlignmentImageTop,
	
	// Horizontal
	kButtonAlignmentLabelLeft,
	kButtonAlignmentImageLeft
};

@interface FlexibleAlignButton : UIButton

@property (nonatomic, assign) ButtonAlignment alignment;

/*!
 @discussion gap Used as a vertical gap between label and image if alignment is vertical, 
 or horizontal gap if alignment is horizontal
 */
@property (nonatomic, assign) CGFloat gap;

@end
