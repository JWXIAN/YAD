//
//  SelectViewController.swift
//  JXT
//
//  Created by 1039soft on 15/8/18.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBAction func closeButton(sender: UIButton) {
        
//       
        UIView.transitionWithView(self.view.superview!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            }, completion: nil)

     
    }
 
    var allCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
      NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("selectbutton"), name: "selectbutton", object: nil)
       
    }
    //MARK: - coleectionView代理
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        return allCount
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SelectCell
        cell.cellButton.setTitle(String(indexPath.row+1), forState: UIControlState.Normal)
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.view.width-2*7)/6, height: (self.view.width-2*7)/6)
    }
    //MARK: - 通知
    func selectbutton()
    {
        UIView.transitionWithView(self.view.superview!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
           
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            }, completion: nil)
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
