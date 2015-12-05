//
//  NewMessageViewController.swift
//  JXT
//
//  Created by 1039soft on 15/9/11.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController,UITextViewDelegate {
    

    @IBOutlet weak var message: UITextView!//要发布的消息
    
    @IBOutlet weak var pleaseHolder: UILabel!
    
    func newWish()
    {
        

        NetInfoGet.sendWishWithMessage(message.text, callBack: { (obj) -> Void in
            let dic:NSDictionary = obj as! NSDictionary
            let head:NSDictionary = dic["head"] as! NSDictionary
          
            if head["statecode"]?.integerValue == 2000
            {
                for obj in dic["body"] as! NSArray
                {
                    let result:NSDictionary = obj as! NSDictionary
                    MBProgressHUD.showSuccess(result["result"] as! String )
                }
            }
            else
            {
                MBProgressHUD.showError("许愿失败，过会再试吧")
            }
      
      })
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     self.title="许愿内容"

   message.layer.borderColor=UIColor.grayColor().CGColor
        message.layer.borderWidth=1
        message.delegate=self
    let button = UIButton(frame: CGRectMake(0, 0, 60, 60))
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Right
    button.titleLabel?.textColor=UIColor.whiteColor()
    button.setTitle("许愿", forState: UIControlState.Normal)
    button.addTarget(self, action: Selector("newWish"), forControlEvents: UIControlEvents.TouchUpInside)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    //MARK: - textview代理
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
       pleaseHolder.hidden=true
        
        return true
    }
    
}
