//
//  ChaptersTableCell.swift
//  JXT
//
//  Created by 1039soft on 15/8/19.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ChaptersTableCell: UITableViewCell {
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var cellBody: UILabel!
    @IBOutlet weak var cellCount: UILabel!
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var num = arc4random_uniform(10)
        if num == 0
        {
            num=1
        }
        let imageName = String(format: "圈%d", num)
       
        headImage.image=UIImage(named: imageName)
       
    }

    
}
