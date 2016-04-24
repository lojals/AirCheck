//
//  OptionCellView.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

class OptionCellView: UICollectionViewCell {
    var btn:UIButton!
    var lbl:UILabel!
    var option:Option!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btn = UIButton(frame: CGRectMake(12,0,60,60))
        btn.setImage(UIImage(named: "btnReport"), forState: .Normal)
        btn.addTarget(self, action: Selector("tap"), forControlEvents: .TouchUpInside)
        self.addSubview(btn)
        
        lbl               = UILabel(frame: CGRectMake(0,65,80,12))
        lbl.textColor     = UIColor.whiteColor()
        lbl.font          = UIFont.systemFontOfSize(11)
        lbl.textAlignment = .Center
        self.addSubview(lbl)
    }
    
    func tap(){
        NSNotificationCenter.defaultCenter().postNotificationName("optionTapped", object: option)
    }
    
    func setOption(option:Option){
        self.option = option
        btn.setImage(UIImage(named: self.option.image), forState: .Normal)
        lbl.text = self.option.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
