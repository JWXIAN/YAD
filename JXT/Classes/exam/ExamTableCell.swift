//
//  ExamTableCell.swift
//  JXT
//
//  Created by 1039soft on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ExamTableCell: UITableViewCell {

    @IBOutlet weak var headimage: UIImageView!
    @IBOutlet weak var questiontitle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
//   
//    func cellinfo(image:String,title:String)
//    {
//        questiontitle.font=UIFont.systemFontOfSize(headimage.height*0.5)
//        headimage.image=UIImage(named: image)
//        
//        
//        questiontitle.text=title
//     
//    }
//     func cellHeight()->CGFloat
//    {
//        let s:NSString = questiontitle.text!
//        let att:NSDictionary = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: headimage.height*0.6)!]
//        let siz = CGSizeMake(questiontitle.width, CGFloat(MAXFLOAT))
//        let rect = s.boundingRectWithSize(siz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: att as [NSObject : AnyObject], context: nil)
//        questiontitle.frame=rect
//     
//       return rect.height+20
//    }
//  
}
