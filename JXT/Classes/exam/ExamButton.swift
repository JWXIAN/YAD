//
//  ExamButton.swift
//  JXT
//
//  Created by 1039soft on 15/8/14.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ExamButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.font=UIFont.systemFontOfSize(self.titleLabel!.size.height*0.4)
        self.titleLabel?.textAlignment=NSTextAlignment.Center
        self.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font=UIFont.systemFontOfSize(self.titleLabel!.frame.size.height*0.7)
        self.titleLabel?.textAlignment=NSTextAlignment.Center
        self.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
    }
    //返回背景边界
    override func backgroundRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    //返回图片边界
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: self.bounds.size.width*1/3, y: self.bounds.size.height*1/6, width: self.bounds.size.width*1/3, height: self.bounds.size.height*0.9/2)
    }
    //返回title边界
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: self.frame.size.height*1.2/2, width: self.frame.size.width, height: self.frame.size.height*0.9/2)
    }

}
