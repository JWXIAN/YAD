//
//  StudentWish.swift
//  JXT
//
//  Created by 1039soft on 15/9/10.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class StudentWish: UITableViewController {
    

    
       var messageArr = NSArray()//存放模型数组
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="考前许愿"
        
        
        self.tableView.backgroundView=UIImageView(image: UIImage(named: "xyq_bg"))//设置背景图片
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(image: UIImage(named: "发布"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("writeWish"))
        
     
        



  
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
          self.getinfo()//刷新  
        })
        self.tableView.mj_header.beginRefreshing()
    }
   func getinfo()
   {
    
    NetInfoGet.getWishListAndCallBack { (obj) -> Void in
      
        let dic = obj as! NSDictionary
        let head = dic["head"] as! NSDictionary
        
        if head["statecode"]?.integerValue == 2000
        {
            let arrTemp = dic["body"] as? NSArray
          
            self.messageArr = WishMessageModel.objectArrayWithKeyValuesArray(arrTemp) 
        
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
        }
       
    }
   }
       // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      
        return messageArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier2, forIndexPath: indexPath) as! ChatCell
  
       cell.setInfo(messageArr[indexPath.row] as! WishMessageModel, cellNum: indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      let maxSize = CGSizeMake(CGFloat(UIScreen.mainScreen().bounds.width-150),CGFloat(MAXFLOAT))//设置最大sizie
        let model = messageArr[indexPath.row] as! WishMessageModel
      let textSize = model.xycontent.sizeWithFont(UIFont.systemFontOfSize(15), maxSize: maxSize)//设置许愿框内容框大小
        return textSize.height+120
    }
   //MARK: - 许愿
    func writeWish()
    {
       let story = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle())

    
      self.navigationController?.pushViewController(story.instantiateViewControllerWithIdentifier("newMessage") as! NewMessageViewController , animated: true)
    }
}
