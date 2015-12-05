//
//  SelectCell.swift
//  JXT
//
//  Created by 1039soft on 15/8/18.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class SelectCell: UICollectionViewCell {
    @IBOutlet weak var cellButton: UIButton!
   
    @IBAction func click(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("selectbutton", object: sender.titleLabel?.text)
        
    }
    
}
