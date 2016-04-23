//
//  OptionSelector.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

protocol OptionSelectorDelegate{
    func openSelector()
    func closeSelector()
}

class OptionSelector: UIView {
    var isOpen = false
    var openButton:OpenOptionButton!
    var contentView:UIView!
    var delegate:OptionSelectorDelegate?
    
    
    init() {
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addUIComponents()
        self.addUIConstraints()
    }
    
    func addUIComponents(){
        openButton                                           = OpenOptionButton()
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.setImage(UIImage(named: "arrow_up"), forState: .Normal)
        openButton.addTarget(self, action: Selector("openOptions"), forControlEvents: .TouchUpInside)
        self.addSubview(openButton)
        
        contentView                                           = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor                           = UIColor(patternImage: UIImage(named: "Mask")!)
        self.addSubview(contentView)
        
        
        let menu = ContentMenu()
        contentView.addSubview(menu)
        contentView.addConstraint(NSLayoutConstraint(item: menu, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: menu, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0))
        
    }
    
    func addUIConstraints(){
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 160))
        let views =  ["openButton":openButton,"contentView":contentView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[openButton(40)][contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[openButton]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    
    func openOptions(){
        if isOpen{
            delegate?.closeSelector()
            openButton.setImage(UIImage(named: "arrow_up"), forState: .Normal)
        }else{
            delegate?.openSelector()
            openButton.setImage(UIImage(named: "arrow_down"), forState: .Normal)
        }
        isOpen = !isOpen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setMenuStep(step:Int){
    
    }
    
    
}
