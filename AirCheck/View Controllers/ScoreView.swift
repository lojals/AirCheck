//
//  ScoreView.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/24/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    var lbl:UILabel!
    var options = Array<UIButton>()
    var active:Int!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lbl               = UILabel(frame: CGRectMake(0,15,self.frame.size.width,15))
        lbl.text          = "¿Que tan grave o severo es su reporte?"
        lbl.textColor     = UIColor.whiteColor()
        lbl.textAlignment = .Center
        lbl.font          = UIFont.systemFontOfSize(14)
        self.addSubview(lbl)
        
        let w = CGFloat(self.frame.size.height - 45)
        
        let spacer = (self.frame.size.width - ((CGFloat(5)-1)*w + (10*(CGFloat(5)-1)) + 45))/2
        
        for i in 1...5{
            let btn = UIButton(frame: CGRectMake((CGFloat(i)-1)*w + (10*(CGFloat(i)-1)) + spacer,45,w,w))
            btn.backgroundColor = UIColor.whiteColor()
            btn.setTitleColor(UIColor(red:0.18, green:0.22, blue:0.25, alpha:1.00), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            btn.setTitle("\(i)", forState: .Normal)
            btn.layer.cornerRadius = w/2
            btn.tag = i
            btn.addTarget(self, action: Selector("setOption:"), forControlEvents: .TouchUpInside)
            self.addSubview(btn)
            options.append(btn)
        }
    }
    
    func setOption(sender:UIButton){
        active = sender.tag
        for (index,btn) in options.enumerate(){
            if index+1 == sender.tag{
                btn.backgroundColor = UIColor(red:0.95, green:0.45, blue:0.15, alpha:1.00)
                btn.selected = true
            }else{
                btn.backgroundColor = UIColor.whiteColor()
                btn.selected = false
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
