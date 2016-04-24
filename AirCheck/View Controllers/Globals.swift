//
//  Globals.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import Foundation


enum ReportType:String{
    case symptoms  = "syptoms"
    case pollution = "pollution"
}

enum ReportSubType:String{
    case fire     = "fire"
    case smoke    = "smoke"
    case drowning = "drowning"
    case cough    = "cough"
    case dust     = "dust"
    case eye      = "eye"
    case flu      = "flu"
    case traffic  = "traffic"
}



class OptionNode {
    var value: Option!
    
    var parent: OptionNode?
    var children = [OptionNode]()
    
    init(_ option: Option) {
        self.value = option
    }
    
    func addChild(node: OptionNode) {
        children.append(node)
        node.parent = self
    }
    
    func search(value: String) -> OptionNode? {
        if (value == (self.value).name) {
            return self
        }
        for child in children {
            if let found = child.search(value) {
                return found
            }
        }
        return nil
    }
}



class Option {
    var name:String!
    var image:String!
    var value:String!
    var key:String!
    var level:Int!
    
    init(){
        self.name       = ""
        self.image      = ""
        self.value      = ""
        self.key        = ""
        self.level      = 1
    }
}


class OptionTree{
    static let sharedInstance = OptionTree()
    let tree:OptionNode?
    
    init(){
        let option = Option()
        tree       = OptionNode(option)
        
        let reportOpt   = Option()
        reportOpt.image = "btnReport"
        reportOpt.name  = "REPORTAR"
        let report      = OptionNode(reportOpt)
        tree?.addChild(report)
        
        
        let layersOpt   = Option()
        layersOpt.image = "btnLayers"
        layersOpt.name  = "CAPAS"
        let layers      = OptionNode(layersOpt)
        tree?.addChild(layers)
        
        
        //
        
        let synOpt   = Option()
        synOpt.image = "btnLayers"
        synOpt.name  = "SYM".uppercaseString
        synOpt.value = ReportType.symptoms.rawValue
        let syn      = OptionNode(synOpt)
        report.addChild(syn)
        
    
        let syn1Opt = Option()
        syn1Opt.image = "cough_c"
        syn1Opt.name  = "TOS"
        syn1Opt.value = ReportSubType.cough.rawValue
        let s1 = OptionNode(syn1Opt)
        syn.addChild(s1)
        
        let syn2Opt = Option()
        syn2Opt.image = "drowning_c"
        syn2Opt.name  = "FALTA DE AIRE"
        syn2Opt.value = ReportSubType.drowning.rawValue
        let s2 = OptionNode(syn2Opt)
        syn.addChild(s2)
        
        
        let syn3Opt = Option()
        syn3Opt.image = "eye_c"
        syn3Opt.name  = "IRRITACIÓN"
        syn3Opt.value = ReportSubType.eye.rawValue
        let s3 = OptionNode(syn3Opt)
        syn.addChild(s3)
                
        let syn4Opt = Option()
        syn4Opt.image = "flu_c"
        syn4Opt.name  = "CONGESTION"
        syn4Opt.value = ReportSubType.flu.rawValue
        let s4 = OptionNode(syn4Opt)
        syn.addChild(s4)
    
        
        //
        
        let polOpt   = Option()
        polOpt.image = "btnLayers"
        polOpt.name  = "POL"
        polOpt.value  = ReportType.pollution.rawValue
        let pol      = OptionNode(polOpt)
        report.addChild(pol)
        
        
        let pol1Opt = Option()
        pol1Opt.image = "fire_c"
        pol1Opt.name  = "FUEGO"
        pol1Opt.value = ReportSubType.fire.rawValue
        let p1 = OptionNode(pol1Opt)
        pol.addChild(p1)
        
        
        let pol2Opt = Option()
        pol2Opt.image = "dust_c"
        pol2Opt.name  = "POLVO"
        pol2Opt.value = ReportSubType.dust.rawValue
        let p2 = OptionNode(pol2Opt)
        pol.addChild(p2)
        
        
        let pol3Opt = Option()
        pol3Opt.image = "smoke_c"
        pol3Opt.name  = "HUMO"
        pol3Opt.value = ReportSubType.smoke.rawValue
        let p3 = OptionNode(pol3Opt)
        pol.addChild(p3)
        
        
        let pol4Opt = Option()
        pol4Opt.image = "traffic_c"
        pol4Opt.name  = "TRAFICO"
        pol4Opt.value = ReportSubType.traffic.rawValue
        let p4 = OptionNode(pol4Opt)
        pol.addChild(p4)
        
    }
}