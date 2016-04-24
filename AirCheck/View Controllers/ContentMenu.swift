//
//  ContentMenu.swift
//  AirCheck
//
//  Created by Jorge Raul Ovalle Zuleta on 4/23/16.
//  Copyright © 2016 aircheck. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

class ContentMenu: UICollectionView {
    
    var options:[OptionNode]!
    
    init(){
        let flowLayout = KTCenterFlowLayout()

        flowLayout.itemSize = CGSizeMake(84, 85)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        super.init(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        self.backgroundColor = UIColor.clearColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.registerClass(OptionCellView.self, forCellWithReuseIdentifier: "OptionCellView")
        self.showsHorizontalScrollIndicator = false
        self.delegate        = self
        self.dataSource      = self
    }
    
    func setOptions(options:[OptionNode]){
        self.options = options
        self.reloadTableViewWithAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTableViewWithAnimation() {
        dispatch_async(dispatch_get_main_queue(), {[unowned self] () -> Void in
            UIView.transitionWithView(self,
                duration:0.4,
                options:.TransitionCrossDissolve,
                animations:
                { () -> Void in
                    self.reloadData()
                },
                completion: nil);
        })
    }
}


extension ContentMenu:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCellWithReuseIdentifier("OptionCellView", forIndexPath: indexPath) as! OptionCellView
        cell.setOption(options[indexPath.row].value)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 5, bottom: 0, right: 5)
    }
}


