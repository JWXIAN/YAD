//
//  ChatCell.swift
//  JXT
//
//  Created by 1039soft on 15/9/10.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!//姓名
    @IBOutlet weak var message: UIButton!//内容
    @IBOutlet weak var time: UILabel!//发送时间
    @IBOutlet weak var zan: UILabel!//点赞数
    @IBOutlet weak var bg_view: UIImageView!//背景图片


    
    @IBOutlet weak var time_bottom: NSLayoutConstraint!//时间底部
    @IBOutlet weak var bgView_H: NSLayoutConstraint!//背景图片高
    
    @IBOutlet weak var bgView_W: NSLayoutConstraint!//背景图片宽
    
    @IBOutlet weak var bgView_left: NSLayoutConstraint!//背景图片距离左侧距离
    @IBOutlet weak var message_h: NSLayoutConstraint!

    
    @IBOutlet weak var name_left: NSLayoutConstraint!//姓名距离左边间距
    
//    var zanBtn = CatZanButton()

    func biaoQianImage(imageName:String) -> UIImage
    {
       
        // 加载原有图片
        let norImage = UIImage(named: imageName)
        let h = (norImage?.size.height)! * 0.75 //获取原图片百分之75的高度
        let h_1 = (norImage?.size.height)! * 0.25 //获取原图片百分之25的高度
        // 生成可以拉伸指定位置的图片
        let newImage = norImage?.resizableImageWithCapInsets(UIEdgeInsets(top:h_1 , left: 0, bottom: h, right: 0), resizingMode: UIImageResizingMode.Stretch)
      
        return newImage!;
    }
    
    func setInfo(messageInfo:WishMessageModel,cellNum:NSInteger)
    {
        
        //设置背景图片
        bg_view.image=biaoQianImage("biaoqian")
        
        bgView_H.constant=self.height
        bgView_W.constant=self.width/2
        
        //设置姓名
        nameLabel.text=messageInfo.stuname
        
        //设置时间
        time.text=messageInfo.xytime
        
        //设置点赞数
        zan.text=messageInfo.zan
        
        
        
        
        
        //设置消息
        message.titleLabel!.numberOfLines = 0;
        message.titleEdgeInsets.left=10 //设置文字左间距
        message.titleEdgeInsets.right=10
        
        message.setTitle(messageInfo.xycontent, forState: UIControlState.Normal)
        
        
        
        
        var zanBtn:CatZanButton
        
  
        if cellNum%2 == 0
        {
            name_left.constant=8
            bgView_left.constant=0

            zanBtn = CatZanButton(frame: CGRect(x:self.width/2 - 45, y: self.height-65, width: 20, height: 20), zanImage: UIImage(named: "Zan"), unZanImage: UIImage(named: "UnZan"))
            
            
        }
        else//奇数行
        {
            bgView_left.constant=self.width/2-2
            name_left.constant=self.width/2+8

            zanBtn = CatZanButton(frame: CGRect(x: self.width - 45, y:  self.height-65, width: 20, height: 20), zanImage: UIImage(named: "Zan"), unZanImage: UIImage(named: "UnZan"))
        }
        
        //设置点赞
        
        var zanButton:CatZanButton//临时变量
        zanBtn.removeFromSuperview()
        zanBtn.clickHandler = { (zanButton) -> Void in
            if zanBtn.isZan//点赞状态
            {
                self.zan.text=String(format: "%d", (Int((self.zan.text)!))! + 1 )
                NetInfoGet.givewWishPowerWithStuID(messageInfo.id, callBack: { (obj) -> Void in
                    MBProgressHUD.showSuccess("您成功的给TA增加了一点愿力！")
                })
            }
            else
            {
                self.zan.text=String(format: "%d", (Int((self.zan.text)!))! - 1 )
            }
            
        }
     
    for obj in self.contentView.subviews
    {
     if obj.isKindOfClass(CatZanButton)
     {
       obj.removeFromSuperview()
     }
    }
      zanBtn.removeFromSuperview()
      self.contentView.addSubview(zanBtn)
        
        self.layoutIfNeeded()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
   }
