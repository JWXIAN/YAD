//
//  ChanegExam.swift
//  JXT
//
//  Created by 1039soft on 15/8/10.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ChanegExam: UIViewController {

    
    @IBOutlet weak var 更新文字: UILabel!
    @IBOutlet weak var w1: NSLayoutConstraint!
    @IBOutlet weak var w2: NSLayoutConstraint!
    @IBOutlet weak var w3: NSLayoutConstraint!
    @IBOutlet weak var w4: NSLayoutConstraint!
    @IBOutlet weak var w5: NSLayoutConstraint!
    @IBOutlet weak var w6: NSLayoutConstraint!
    @IBOutlet weak var w7: NSLayoutConstraint!
    @IBOutlet weak var w8: NSLayoutConstraint!
    @IBOutlet weak var w9: NSLayoutConstraint!
  
    @IBOutlet weak var anim: DGActivityIndicatorView!
    
    @IBOutlet weak var send: UIButton!

    //确定
    @IBAction func send(sender: UIButton) {
        

        let userde=NSUserDefaults.standardUserDefaults()
      if whichButton==nil
      {
        whichButton="C"
      }
       userde.setObject(whichButton, forKey: "whichButton")
       userde.synchronize()
        if userde.boolForKey("shouci")
        {
           
            let jwTabBar=JWTarBarController()
          
//            self.navigationController?.pushViewController(jwTabBar, animated: true)
            self.presentViewController(jwTabBar, animated: true, completion: nil)
            userde.setBool(false, forKey: "shouci")
            userde.synchronize()
           
        }
        else
        {
          self.navigationController?.popViewControllerAnimated(true)

         
        }
        
        
        
    }
    //MARK: - 全局变量
    let buttonHighView = UIImageView(image: UIImage(named: "sign-check-icon"))
    var tag = String?()
    var tag2 = String?()
    var whichButton = String?("C")
    let endPic = UIImageView()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
   
    

      
        w1.constant=self.view.frame.size.width/4
        w2.constant=w1.constant
        w3.constant=w1.constant
        w4.constant=w1.constant
        w5.constant=w1.constant
        w6.constant=w1.constant
        w7.constant=w1.constant
        w8.constant=w1.constant
        w9.constant=w1.constant
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
       
//        self.navigationController?.navigationBarHidden=true
      
        //初始化数据
        anim.type=DGActivityIndicatorAnimationType.RotatingSquares
        anim.tintColor=UIColor(red: 67/255, green: 153/255, blue: 213/255, alpha: 1)
        anim.size=17
        更新文字.font=UIFont.systemFontOfSize(更新文字.frame.size.height*0.9)
        anim.hidden=true
        

        
       
        
        
        send.titleLabel?.font=UIFont.systemFontOfSize(send.frame.size.height*0.4)
              
        for 按钮 in self.view.subviews
        {
            if 按钮.isKindOfClass(ExamButton)
            {
            
                let button:(ExamButton)=按钮 as! (ExamButton)
          
                button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                           }
        }
        
    }

    //MARK: - 按钮事件
    func buttonAction(button:ExamButton)
    {
        //临时获取数据库
//        
//        var count = 1
//        while count <= 30
//            
//        {
//        var surl = String(format: "http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=mnks&prc=prc_app_getquestion&parms=cx=%d",count)
//
//        var url = NSURL(string: surl)
//        var request = NSURLRequest(URL: url!)
//        var received = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//        var obj = NSJSONSerialization.JSONObjectWithData(received!, options: NSJSONReadingOptions(0), error: nil)
//
//            let dic2:(NSDictionary) = obj as! NSDictionary
//            let head:(NSDictionary) = dic2["head"] as! NSDictionary
//            let head_statecode:(String) = head["statecode"] as! String
//            if head_statecode=="2000"
//            {
//                for dic in dic2["body"] as! NSArray
//                {
//                    
//                    let body:(NSDictionary) = dic as! NSDictionary
//                    var upmodel = dic_model.getmodel(body)
//                 
//                    
//                    exam.save(upmodel)
//                }
//                 count++
//                println("count= " + String(count))
//            }
//            else
//            {
//                println("失败")
//                break;
//            }
////
//        }




        
        drawWaitAnimation(true)
        //查找第一条字段并比对数据库版本
        let dataID = exam.find(1)
        let model:(exam) = dataID
//        model.dataVersions="0"
//        exam.update(model)
//        exam.save(model)
//        print(model.dataVersions)
        
        
        tag=button.titleLabel?.text
       if tag != tag2
       {

        
        if button.titleLabel?.text == "小车"
        {
            whichButton="C"
        }
        if button.titleLabel?.text == "货车"
        {
            whichButton="B"
        }
        if button.titleLabel?.text == "客车"
        {
            whichButton="A"
        }
        if button.titleLabel?.text == "摩托"
        {
            whichButton="DEF"
        }
        if button.titleLabel?.text == "教练员"
        {
            whichButton="ZJ"
        }
        if button.titleLabel?.text == "货运"
        {
            whichButton="ZB"
        }
        if button.titleLabel?.text == "危险品"
        {
            whichButton="ZC"
        }
        if button.titleLabel?.text == "客运"
        {
            whichButton="ZA"
        }
        if button.titleLabel?.text == "出租车"
        {
            whichButton="ZD"
        }
        
        
        //创建选择后对号图片
        buttonHighView.frame=CGRect(x: button.bounds.size.width/2, y: button.bounds.size.height/2-5, width: button.bounds.size.width*1/5, height: button.bounds.size.height*1/5)
        buttonHighView.contentMode=UIViewContentMode.ScaleAspectFit
        button.addSubview(buttonHighView)
        
        NetInfoGet.getCodeInfoAndCallback { (obj) -> Void in
            
            let dic2:(NSDictionary) = obj as! NSDictionary
            let head:(NSDictionary) = dic2["head"] as! NSDictionary
            let head_statecode:(String) = head["statecode"] as! String
            if head_statecode=="2000"
            {
                for dic in dic2["body"] as! NSArray
                {
                    let body:(NSDictionary) = dic as! NSDictionary
                    let version:(String) = body["version"] as! String
                    
                    if version == model.dataVersions
                    {
                        self.drawWaitAnimation(false)
                    }
                    else
                    {
                        
                      
                         NetInfoGet.getDataList(self.whichButton, callback: { (obj) -> Void in
                            let dic2:(NSDictionary) = obj as! NSDictionary
                            let head:(NSDictionary) = dic2["head"] as! NSDictionary
                            let head_statecode:(String) = head["statecode"] as! String
                            if head_statecode=="2000"
                            {
                                for dic in dic2["body"] as! NSArray
                                {
                                
                                    let body:(NSDictionary) = dic as! NSDictionary
                                    let upmodel = dic_model.getmodel(body)
                                    upmodel.dataVersions=version
                                   
                                    exam.save(upmodel)
                                }
                            }
                         self.drawWaitAnimation(false)
                        })
                    }
                }
            }
        }
       tag2=tag
        }
      else
       {
        whichButton="C"
        drawWaitAnimation(false)
         buttonHighView.removeFromSuperview()
         tag2=""
       }
  
        
    }
    //MARK: - 打开侧边栏
    func openOrCloseLeftList(){
        let tempAppDelegate:(AppDelegate) = UIApplication.sharedApplication().delegate as! AppDelegate
        if tempAppDelegate.LeftSlideVC.closed
        {
            tempAppDelegate.LeftSlideVC.openLeftView()
        }
        else
        {
            tempAppDelegate.LeftSlideVC.closeLeftView()
        }
    }
    
    //MARK: - 加载动画方法
    func drawWaitAnimation(isshow:Bool)
    {
        if isshow
        {
            anim.hidden=false
            anim.startAnimating()
            更新文字.text="正在更新题库"
            
            endPic.removeFromSuperview()
        }
        else
        {
            anim.hidden=true
            anim.stopAnimating()
            endPic.frame=anim.frame
            endPic.image=UIImage(named: "sign-check-icon")
            self.view.addSubview(endPic)
            更新文字.text="已更新至最新题库"    

        }
    }

}
