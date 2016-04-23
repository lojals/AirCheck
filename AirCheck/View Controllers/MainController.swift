//
//  ViewController.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit
import Mapbox
import pop

class MainController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    var options:OptionSelector!
    var optionsPosition:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AIRCHECKER"
        
        
        mapView.zoomLevel = 18
        mapView.showsUserLocation = true
        self.addUIComponents()
        self.addUIConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 4.62692341302021, longitude: -74.0652171895598), zoomLevel: 13.3418724809409, animated: true)
    }
    
    func addUIComponents(){
        options          = OptionSelector()
        options.delegate = self
        self.view.addSubview(options)
        
        optionsPosition = NSLayoutConstraint(item: self.options, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -40)
    }
    
    func addUIConstraints(){
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[options]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["options" : options]))
        self.view.addConstraint(optionsPosition)
    }
}


extension MainController:OptionSelectorDelegate{
    
    func openSelector() {
        print(mapView.zoomLevel)
        print(mapView.userLocation?.coordinate)
        let animation:POPSpringAnimation =  POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        animation.springSpeed      = 20.0
        animation.springBounciness = 15.0
        animation.toValue          = -132
        optionsPosition.pop_addAnimation(animation, forKey: "openSelector")
    }
    
    
    func closeSelector() {
        let animation:POPSpringAnimation =  POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        animation.springSpeed      = 20.0
        animation.springBounciness = 15.0
        animation.toValue          = -40
        optionsPosition.pop_addAnimation(animation, forKey: "openSelector")
    }
}
