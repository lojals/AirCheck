//
//  NotificationView.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/24/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit
import pop

class NotificationView: UIView {
    
    private var lblAlert:UILabel!
    private var btnClose:UIButton!
    var text:String! {didSet{reloadNotification()}}
    

    init(text:String){
        super.init(frame: CGRectZero)
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.95)
        self.alpha = 0
        
        lblAlert           = UILabel()
        lblAlert.text          = self.text
        lblAlert.textAlignment = .Justified
        lblAlert.font          = UIFont.systemFontOfSize(13)
        lblAlert.translatesAutoresizingMaskIntoConstraints = false
        lblAlert.numberOfLines = 0
        lblAlert.textColor     = UIColor(red:0.18, green:0.22, blue:0.25, alpha:1.00)
        lblAlert.sizeToFit()
        self.addSubview(lblAlert)
        
        btnClose = UIButton()
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.setImage(UIImage(named: "btnClose"), forState: .Normal)
        btnClose.addTarget(self, action: Selector("closeNotification"), forControlEvents: .TouchUpInside)
        self.addSubview(btnClose)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[lblAlert][btnClose(50)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["lblAlert" : lblAlert,"btnClose":btnClose]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[lblAlert]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["lblAlert" : lblAlert]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btnClose]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["btnClose" : btnClose]))
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadNotification(){
        lblAlert?.text = self.text
        lblAlert?.sizeToFit()
    }
    
    func showNotification(){
        let animation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.toValue               = 1
        self.pop_addAnimation(animation, forKey: "hideMenu")
    }
    
    func closeNotification(){
        let animation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.toValue               = 0
        self.pop_addAnimation(animation, forKey: "hideMenu")
    }
    
    func showNotificationAutoDismiss(){
        self.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.15, alpha:1.00).colorWithAlphaComponent(0.95)
        showNotification()
        self.lblAlert.textColor = UIColor.whiteColor()
        let  _ = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("closeNotification"), userInfo: nil, repeats: false)
    }
    
}
