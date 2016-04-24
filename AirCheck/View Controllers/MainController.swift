//
//  ViewController.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit
import Mapbox
import SwiftyJSON
import pop


class Report {
    var idAPI:String!
    var type:String!
    var subType:String!
    var location:CLLocationCoordinate2D!
    var level:Int!
    
    init(){
        self.idAPI    = ""
        self.type     = ReportType.pollution.rawValue
        self.subType  = ReportSubType.fire.rawValue
        self.location = CLLocationCoordinate2D(latitude: 4.622624242821189, longitude: -74.12797451019287)
        self.level    = 1
    }
    
    init(json:JSON){
        self.idAPI    = json["_id"].stringValue
        self.type     = json["json"].stringValue
        self.subType  = json["subtype"].stringValue
        let longitude = json["location"]["longitude"].doubleValue
        let latitude  = json["location"]["latitude"].doubleValue
        self.level    = json["level"].intValue
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toDictionary() -> [String : AnyObject]{
        let location = ["longitude":self.location.longitude,"latitude":self.location.latitude]
        let dic      = ["type":self.type,"subtype":self.subType,"location":location,"level":level]
        return dic as! [String : AnyObject]
    }
}



class MainController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    var options:OptionSelector!
    var optionsPosition:NSLayoutConstraint!
    var reports:Array<Report> =  Array<Report>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AIRCHECKER"
        
        mapView.delegate = self
        mapView.zoomLevel = 18
        mapView.showsUserLocation = true
        
        self.addUIComponents()
        self.addUIConstraints()
        
        let menu = UIBarButtonItem(image: UIImage(named: "btnMenu"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("openMenu"))
        self.navigationItem.setLeftBarButtonItem(menu, animated: false)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportsLoaded:", name: "reportsLoaded", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploadReport:", name: "uploadReport", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "processLayers:", name: "processLayers", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportCreated:", name: "reportCreated", object: nil)
        
        
        APIManager.sharedInstance.getAllReports()
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
    
    func reportsLoaded(notification:NSNotification){
        if mapView.annotations?.count > 0{
            mapView.removeAnnotations(mapView.annotations!)
        }
        reports.removeAll()
        guard let value = notification.object else{ return }
        let json = JSON(value)
        for report in json{
            let rep        = Report(json: report.1)
            let ann        = MGLPointAnnotation()
            ann.title      = String(reports.count)
            ann.subtitle   = rep.subType
            ann.coordinate = rep.location
            reports.append(rep)
            self.mapView.addAnnotation(ann)
        }
    }
    
    func reportCreated(notification:NSNotification){
        let actionSheet = UIAlertController(title: "Cool! 🍃", message: "Reporte creado!", preferredStyle: UIAlertControllerStyle.ActionSheet)

        let option2 = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(actionSheet: UIAlertAction!) in ()})
        actionSheet.addAction(option2)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func openMenu(){
        
    }
    
    func uploadReport(notification:NSNotification){
        let report = notification.object as! Report
        report.location = self.mapView.userLocation?.coordinate
        APIManager.sharedInstance.uploadReport(report)
    }
    
    func processLayers(notification:NSNotification){
        print(notification.object!)
        switch notification.object! as! String{
            case "all": APIManager.sharedInstance.getAllReports()
            case "pollution": APIManager.sharedInstance.getPollutionReports()
            case "syptoms": APIManager.sharedInstance.getSymptomsReports()
            default: print("default")
        }
    }
}


extension MainController:OptionSelectorDelegate{
    func openSelector() {
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
        optionsPosition.pop_addAnimation(animation, forKey: "closeSelector")
    }
    
    func extendSelector() {
        let animation:POPSpringAnimation =  POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        animation.springSpeed      = 20.0
        animation.springBounciness = 15.0
        animation.toValue          = -265
        optionsPosition.pop_addAnimation(animation, forKey: "expandSelector")
    }
}


extension MainController:MGLMapViewDelegate{
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        guard let subTitle = annotation.subtitle else {return nil}
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(subTitle!)
        if annotationImage == nil {
            let sub = subTitle != "" ? subTitle : "fire"
            print(sub)
            var image = UIImage(named: sub!)!
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: sub!)
        }
        return annotationImage
    }
}
