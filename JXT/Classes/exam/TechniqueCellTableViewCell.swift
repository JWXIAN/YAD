//
//  TechniqueCellTableViewCell.swift
//  JXT
//
//  Created by 1039soft on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class TechniqueCellTableViewCell: UITableViewCell {

    @IBOutlet weak var head: UIButton!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var deputy: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
      body.font=UIFont.systemFontOfSize(head.height*0.6)
      deputy.font=UIFont.systemFontOfSize(head.height*0.5)
        var num = arc4random_uniform(10)
        if num == 0
        {
            num=1
        }
        let imageName = String(format: "圈%d", num)
//        head.image=UIImage(named: imageName)
        head.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }


}
