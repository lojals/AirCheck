//
//  GenericNavViewController.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit

class GenericNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.translucent     = false
        self.navigationBar.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        self.navigationBar.tintColor       = UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)
        self.navigationBar.barTintColor    = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00),NSFontAttributeName:UIFont.systemFontOfSize(17)]
        
        
    }
}
