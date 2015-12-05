//
//  ExamTechniqueTableViewController.swift
//  JXT
//
//  Created by 1039soft on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ExamTechniqueTableViewController: UITableViewController {
    var bodyArr = ["合格标准","扣分细则","手势口诀","2013年《机动车驾驶证申领和使用规定》","中华人民共和国道路交通安全法(2011修正)","道路交通安全违法行为处理程序规定","道路交通事故处理程序规定","酒驾新规"];
    var otherArr = ["考试内容及及格标准","2015交规扣分标准","八种交警手势信号口诀","驾驶证申领和使用规定","道路交通安全法","安全违法行为处理程序","事故处理程序规定","酒驾最新处罚条文"]
    
    var bodyArr_4 = ["合格标准","考试流程","2013年《机动车驾驶证申领和使用规定》","中华人民共和国道路交通安全法(2011修正)","道路交通安全违法行为处理程序规定","道路交通事故处理程序规定","酒驾新规"]
    var otherArr_4 = ["考试内容 题目构成","上机考试 考试流程","驾驶证申领和使用规定","道路交通安全法","安全违法行为处理程序","事故处理程序规定","酒驾最新处罚条文"]
    
    var br = []
    var or = []
   var className = String()//当前科目名称
   var cellNum = Int()//单元格数

       override func viewDidLoad() {
        super.viewDidLoad()
     self.title="驾考须知"
        self.tableView.estimatedRowHeight=100
        self.tableView.rowHeight=UITableViewAutomaticDimension
       
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
        self.tableView.tableFooterView=UIView()
   
        if className == "科目四"
        {
            br = bodyArr_4
            or = otherArr_4
            cellNum=7
        }
        else
        {
            br = bodyArr
            or = otherArr
            cellNum = 8
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
        return cellNum
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier2, forIndexPath: indexPath) as! TechniqueCellTableViewCell
       
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
        cell.head.setTitle(String(indexPath.row+1), forState: UIControlState.Normal)
//        if self.title =
        cell.body.text=br[indexPath.row] as? String
        cell.deputy.text=or[indexPath.row] as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let story = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle())
        let helpinfo = story.instantiateViewControllerWithIdentifier("helpinfo") as! HelpInfo
        helpinfo.title=br[indexPath.row] as? String
        if className == "科目四"
        {
            if indexPath.row < 2
            {
                helpinfo.pathName = String(indexPath.row) + "_4"
            }
            else
            {
                helpinfo.pathName = String(indexPath.row + 1)
            }
        }
        else
        {
             helpinfo.pathName = String(indexPath.row)
        }
       
        self.navigationController?.pushViewController(helpinfo, animated: true)
        
    }
}
