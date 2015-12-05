//
//  ChaptersTable.swift
//  JXT
//
//  Created by 1039soft on 15/8/19.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ChaptersTable: UITableViewController{
   
    var allArr = NSArray()//原始数组
    var fenArr = NSArray()//列表名称数组
    var infoDic = NSMutableDictionary()//存放每一组数据
    var cellBody = String()
    var cellTemp = NSMutableArray()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.tableView.tableFooterView=UIView()
        


     
           
            if #available(iOS 8.0, *) {
                self.tableView.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
        
       let tempArr = NSMutableArray()

        for obj in allArr
        {
           let temp = obj as! exam
            if self.title == "章节练习"
            {
               tempArr.addObject(temp.chaptersType)
            }
            else if self.title == "专项练习"
            {
                let arr = temp.absorbedType.componentsSeparatedByString(",")
                for obj in arr
                {
                    if obj != ""
                    {
                        if obj != "&nbsp;"
                        {
                           tempArr.addObject(obj) 
                        }
                        
                    }
                   
                }
                
            }
           
        }
        fenArr=Tool_swift.arrayWithMemberIsOnly(tempArr)
        
        for var i = 0;i<fenArr.count;i++
        {
           let tempArr2 = NSMutableArray()
            for obj in allArr
            {
                
                let temp = obj as! exam
                if self.title == "章节练习"
                {
                    if temp.chaptersType == fenArr[i] as! String
                    {
                        tempArr2.addObject(temp)
                    }
                }
               else if self.title == "专项练习"
                {
                    let arr = temp.absorbedType.componentsSeparatedByString(",")
                     for obj in arr
                    {
                       
                    if obj == fenArr[i] as! String
                     {
                        tempArr2.addObject(temp)
                     }
                    }
                }
                
            }
            
            infoDic.setObject(tempArr2, forKey: String(i))
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
        return fenArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChaptersTableCell
        
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
        let cellTemp =  infoDic[String(indexPath.row)] as! NSMutableArray
      cell.cellBody.text = fenArr[indexPath.row] as? String
      cell.cellCount.text = String(cellTemp.count)

      return cell
    }
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! ChaptersTableCell
      
//        cellTemp =  infoDic[String(indexPath.row)] as! NSMutableArray
        cellTemp = infoDic[String(indexPath.row)] as! NSMutableArray
        let story = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("shunxu") as! ExamTopBodyView
//        let user = NSUserDefaults.standardUserDefaults()
//        let moveNum = user.integerForKey(String(cell.cellBody.text!))
        cellBody=String(cell.cellBody.text!)
        story.arr=cellTemp
 
        story.title=self.title
        self.navigationController?.pushViewController(story, animated: true)
        
      
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
}
