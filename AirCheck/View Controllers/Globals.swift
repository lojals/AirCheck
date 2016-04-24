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
    case drowming = "drowning"
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
    
    init(){
        self.name       = ""
        self.image      = ""
        self.value      = ""
        self.key        = ""
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
        let syn      = OptionNode(synOpt)
        report.addChild(syn)
        
    
        let syn1Opt = Option()
        syn1Opt.image = "btnLayers"
        syn1Opt.name  = "SIN 1"
        let s1 = OptionNode(syn1Opt)
        syn.addChild(s1)
        
        let syn2Opt = Option()
        syn2Opt.image = "btnLayers"
        syn2Opt.name  = "SIN 2"
        let s2 = OptionNode(syn2Opt)
        syn.addChild(s2)
        
        
        let syn3Opt = Option()
        syn3Opt.image = "btnLayers"
        syn3Opt.name  = "SIN 3"
        let s3 = OptionNode(syn3Opt)
        syn.addChild(s3)
                
        let syn4Opt = Option()
        syn4Opt.image = "btnLayers"
        syn4Opt.name  = "SIN 4"
        let s4 = OptionNode(syn4Opt)
        syn.addChild(s4)
        
        let syn5Opt = Option()
        syn5Opt.image = "btnLayers"
        syn5Opt.name  = "SIN 1"
        let s5 = OptionNode(syn5Opt)
        syn.addChild(s5)
        

        let syn6Opt = Option()
        syn6Opt.image = "btnLayers"
        syn6Opt.name  = "SIN 3"
        let s6 = OptionNode(syn6Opt)
        syn.addChild(s6)
        
        //
        
        let polOpt   = Option()
        polOpt.image = "btnLayers"
        polOpt.name  = "POL"
        let pol      = OptionNode(polOpt)
        report.addChild(pol)
        
        
        let pol1Opt = Option()
        pol1Opt.image = "btnLayers"
        pol1Opt.name  = "POL 1"
        let p1 = OptionNode(pol1Opt)
        pol.addChild(p1)
        
        
        let pol2Opt = Option()
        pol2Opt.image = "btnLayers"
        pol2Opt.name  = "POL 2"
        let p2 = OptionNode(pol2Opt)
        pol.addChild(p2)
        
        
        let pol3Opt = Option()
        pol3Opt.image = "btnLayers"
        pol3Opt.name  = "POL 1"
        let p3 = OptionNode(pol3Opt)
        pol.addChild(p3)
        
        
        let pol4Opt = Option()
        pol4Opt.image = "btnLayers"
        pol4Opt.name  = "POL 1"
        let p4 = OptionNode(pol4Opt)
        pol.addChild(p4)
        
        
        let pol5Opt = Option()
        pol5Opt.image = "btnLayers"
        pol5Opt.name  = "POL 1"
        let p5 = OptionNode(pol5Opt)
        pol.addChild(p5)
        
    }
}