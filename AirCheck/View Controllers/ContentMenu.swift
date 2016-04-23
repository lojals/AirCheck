//
//  ContentMenu.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

class Option {
    var name:String!
    var image:String!
    var value:String!
    var key:String!
    var subOptions:[Option]?
}

class ContentMenu: UIView {

    var btnReport:FlexibleAlignButton!
    var btnLayers:FlexibleAlignButton!
    
    init(){
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addUIComponents()
        self.addUIConstraints()
    }
    
    func addUIComponents(){
        btnReport = FlexibleAlignButton()
        btnReport.translatesAutoresizingMaskIntoConstraints = false
        btnReport.setTitle("REPORTAR", forState: .Normal)
        btnReport.setImage(UIImage(named: "btnReport"), forState: .Normal)
        btnReport.alignment = .ImageTop
        btnReport.titleLabel?.font = UIFont.systemFontOfSize(11)
        btnReport.gap = 5
        self.addSubview(btnReport)
        
        btnLayers = FlexibleAlignButton()
        btnLayers.translatesAutoresizingMaskIntoConstraints = false
        btnLayers.setTitle("CAPAS", forState: .Normal)
        btnLayers.setImage(UIImage(named: "btnLayers"), forState: .Normal)
        btnLayers.titleLabel?.font = UIFont.systemFontOfSize(11)
        btnLayers.alignment = .ImageTop
        btnLayers.gap = 5
        
        self.addSubview(btnLayers)
    }
    
    func addUIConstraints(){
        let views = ["btnReport":btnReport,"btnLayers":btnLayers]
         self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
         self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 181))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btnReport(85)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btnLayers(85)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[btnReport(85)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[btnLayers(85)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
