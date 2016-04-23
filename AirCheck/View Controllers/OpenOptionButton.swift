//
//  OpenOptionButton.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

class OpenOptionButton: UIButton {

    override internal var bounds: CGRect { didSet { setNeedsDisplay() } }
    override internal var frame: CGRect { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        let rectanglePath = UIBezierPath(roundedRect: CGRectMake(0, 0, rect.width, rect.height), byRoundingCorners: [UIRectCorner.TopLeft,UIRectCorner.TopRight], cornerRadii: CGSizeMake(rect.height, rect.height))
        rectanglePath.closePath()
        UIColor(red:0.17, green:0.22, blue:0.25, alpha:1.00).setFill()
        rectanglePath.fill()
    }
    

}
