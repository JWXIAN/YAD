//
//  EliminateViewController.swift
//  JXT
//
//  Created by 1039soft on 15/8/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class EliminateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
   
    @IBOutlet weak var tablview: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var 恢复排除的题: UIButton!
    
    var examModelArr = NSArray?()
    var fenArr = NSArray()
    var infoDic = NSMutableDictionary()//存放每一组数据
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if self.title == "我的收藏"
        {
            image.image=UIImage(named: "暂无收藏")
        }
        else if self.title == "我的错题"
        {
            image.image=UIImage(named: "暂无错题")
        }
        else if self.title == "排除的题"
        {
            image.image=UIImage(named: "暂无排除")
        }
       
        恢复排除的题.setTitle("清空"+self.title!, forState: UIControlState.Normal)
       
        tablview.tableFooterView=UIView()
        tablview.estimatedRowHeight=45
        tablview.rowHeight=UITableViewAutomaticDimension
       
            if #available(iOS 8.0, *) {
                tablview.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
      
        if examModelArr?.count==0
        {
            tablview.userInteractionEnabled=false
            恢复排除的题.userInteractionEnabled=false
            image.hidden=false
           
        }
        else
        {
             let tempArr = NSMutableArray()
            for obj in examModelArr!
            {
                let temp = obj as! exam
                tempArr.addObject(temp.chaptersType)
                
            }
         fenArr = Tool_swift.arrayWithMemberIsOnly(tempArr)
            for var i = 0;i<fenArr.count;i++
            {
                let tempArr2 = NSMutableArray()
                for obj in examModelArr!
                {
                    let temp = obj as! exam
                  
                        if temp.chaptersType == fenArr[i] as! String
                        {
                            tempArr2.addObject(temp)
                        }
            
                }
               
                infoDic.setObject(tempArr2, forKey: String(i))
              
            }
            
        }

        
    }

    //MARK: - tableview DateSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fenArr.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChaptersTableCell
     
       
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
        if indexPath.row == 0
        {
            if self.title == "排除的题"
            {
                cell.cellBody.text="所有排除的题";
            }
            else if self.title == "我的收藏"
            {
                cell.cellBody.text="所有收藏的题";
            }
            else if self.title == "我的错题"
            {
                cell.cellBody.text="所有我做错的题"
            }
            cell.cellCount.text=String( examModelArr!.count)
  
        }
        else
        {
           cell.cellBody.text=fenArr[indexPath.row-1] as? String
           cell.cellCount.text=String(infoDic[String(indexPath.row - 1)]!.count)
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         var tempArr = NSArray()
        
        if indexPath.row == 0
        {
            tempArr=examModelArr!
        }
        else
        {
           
            tempArr=infoDic[String(indexPath.row - 1)] as! NSMutableArray
       
            
        }
        let story = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("shunxu") as! ExamTopBodyView
        story.arr=tempArr
        story.title=self.title
        self.navigationController?.pushViewController(story, animated: true)
    }
    //MARK: - 恢复
    @IBAction func recover(sender: UIButton) {
       UIAlertView(title: "确认删除吗?", message: "删除"+self.title!, delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消").show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
            for obj in examModelArr!
            {
                let model = obj as! exam
                if self.title == "排除的题"
                {
                   model.isExclude=false
                }
                if self.title == "我的收藏"
                {
                    model.isCollection=false
                }
                if self.title == "我的错题"
                {
                    model.answerWere="false"
                }
                exam.update(model)
                image.hidden=false
                tablview.userInteractionEnabled=false
                恢复排除的题.userInteractionEnabled=false
            }
        }
    }

}
