//
//  ExamCollectionCell.swift
//  JXT
//
//  Created by 1039soft on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class ExamCollectionCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate
{
  
    var isClean = true
    var examModel = exam()
    var cellNum = Int()
    var submit = UIButton()//多选题提交
    var selectNum = 0 //多选题选择数
    var over = Int()
//    var cell = ExamTableCell()
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeadView: UIView!
    @IBOutlet weak var tableFootView: UIView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionHeadView: UIImageView!
   
    @IBOutlet weak var questionBodyView: UIImageView!
  
    @IBOutlet weak var difficultyStar: UIImageView!
    
    @IBOutlet weak var explainLabel: UILabel!
    
    
    @IBOutlet weak var questionBodyView_H: NSLayoutConstraint!
  
   
    override func awakeFromNib() {
        super.awakeFromNib()
        ceshi()
      
            
          if #available(iOS 8.0, *) {
              table.layoutMargins=UIEdgeInsetsZero
          } else {
              // Fallback on earlier versions
          }
          
        
       
       
        
        table.estimatedRowHeight=50
        table.rowHeight=UITableViewAutomaticDimension
        
        questionTitle.sizeToFit()
        questionTitle.font=UIFont.systemFontOfSize(questionHeadView.bounds.height*0.8)
      
       
       
        //MARK: - 接收按钮通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("cleanOfExam"), name: "cleanOfExam", object: nil)//排除本题
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("collectOfExam:"), name: "collectOfExam", object: nil)
        //收藏本题
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("explainOfExam:"), name: "explainOfExam", object: nil)
        //解释
     
        
    }
    //MARK: -  设置tableheadview
    func cellSet (info:exam,overNum:Int?)
    {
     
 
        over=overNum ?? 0
        examModel=info
        if info.questionType == "判断题"
        {
            cellNum=2
            questionHeadView.image=UIImage(named: "pd")
        }
        else if info.questionType == "多选题"
        {
            cellNum=5
            questionHeadView.image=UIImage(named: "duox")
        }
            
        else
        {
            questionHeadView.image=UIImage(named: "dx")
            cellNum=4
            
        }
        
      table.reloadData()
        
        
        questionTitle.text=examModel.questionBody
        if examModel.questionPicture.hasPrefix("http")
        {
            questionBodyView.sd_setImageWithURL(NSURL(string: examModel.questionPicture))
            //FIXME: - 这里如果是整体更新数据库的话，可能会更新图片地址成本地地址，需要写入document目录并取出
        }
        else
        {
         
//         var err = NSErrorPointer()
           
            questionBodyView.image=UIImage(named: examModel.questionPicture)
            
        }
        
        
        if examModel.questionPicture=="&nbsp;"
        {
            questionBodyView_H.constant=0
            self.layoutIfNeeded()
            
        }
        else
        {
            questionBodyView_H.constant=100
            self.layoutIfNeeded()
        }
       
        
        tableHeadView.height=questionBodyView.y + questionBodyView_H.constant+10
//        table.tableHeaderView?.height=questionBodyView.y + questionBodyView_H.constant+10

        let dif = examModel.questionRank
        switch dif{
        case 1:
            difficultyStar.image=UIImage(named: "xing_one")
        case 2:
            difficultyStar.image=UIImage(named: "xing_two")
        case 3:
            difficultyStar.image=UIImage(named: "xing_three")
        case 4:
            difficultyStar.image=UIImage(named: "xing_four")
        case 5:
            difficultyStar.image=UIImage(named: "xing_five")
        default:
            difficultyStar.image=UIImage(named:"xing_three")
            break
        }
//        examModel.account
        explainLabel.text=examModel.account
        let s:NSString = explainLabel.text!
        let att:NSDictionary = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 15)!]
        let siz = CGSizeMake(explainLabel.width, CGFloat(MAXFLOAT))
        let rect = s.boundingRectWithSize(siz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: att as? [String : AnyObject], context: nil)
//        let rect = s.boundingRectWithSize(siz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: att as [NSObject : AnyObject], context: nil)
        explainLabel.bounds=rect
     
        tableFootView.height=difficultyStar.height + rect.height + 120
       
        
    var bol = false
        for key in overNumArr.allKeys
    {
        
       if overNum == key.integerValue
       {
        bol = true
       }
    
    }
        
         if bol == true//做过的题
         {
          
            for  key in overNumArr.allKeys
            {
            table.tableFooterView?.hidden=false
            for num in overNumArr[String(over)] as! NSMutableDictionary
            {
                
                let index_s = num.key.integerValue
                let index = NSIndexPath(forRow: index_s, inSection: 0)

                let cell = table.cellForRowAtIndexPath(index) as? ExamTableCell
                cell?.userInteractionEnabled=false
                if index_s < 4
                {

                    cell?.questiontitle.textColor = num.value as! UIColor
                    
                }
                else
                {
                    cell?.hidden=true
                }
               
                
              }
            }

         }
         else //未做过的题
         {
            table.tableFooterView?.hidden=true
            for var a = 0; a<table.numberOfRowsInSection(0);a++
            {
                let index = NSIndexPath(forRow: a, inSection: 0)
                let cell = table.cellForRowAtIndexPath(index) as! ExamTableCell
                cell.userInteractionEnabled=true
                if a < 4
                {
                    
                    cell.questiontitle.textColor = UIColor.blackColor()
                    
                }
                else
                {
                    cell.hidden=false
                }
                cell.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 1)
               
            }
            
        }

        table.reloadData()
    }
  
    //MARK: - tableview代理
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cellNum
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier2) as! ExamTableCell
       let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier2, forIndexPath: indexPath) as! ExamTableCell
       
            if #available(iOS 8.0, *) {
                cell.layoutMargins=UIEdgeInsetsZero
            } else {
                // Fallback on earlier versions
            }
        
       
        cell.selectionStyle=UITableViewCellSelectionStyle.None
       
//
        if examModel.questionType == "判断题"
        {
            if indexPath.row == 0
            {
                cell.questiontitle.text="对"
                cell.headimage.image=UIImage(named: "a")
                
                //            cell.cellinfo("a", title: examModel.answerA)
                
            }
            else if  indexPath.row == 1
            {
                cell.questiontitle.text="错"
                cell.headimage.image=UIImage(named: "b")
                //print(examModel.answerB)
                //            cell.cellinfo("b", title: examModel.answerB)
            }
            
            if  cell.questiontitle.textColor == UIColor.redColor()
            {
                cell.headimage.image=UIImage(named: "错")
            }
            if  cell.questiontitle.textColor == UIColor.greenColor()
            {
                cell.headimage.image=UIImage(named: "对")
            }

        }
            
        else
        {
        if indexPath.row == 0
        {
            cell.questiontitle.text=examModel.answerA
            cell.headimage.image=UIImage(named: "a")
            
//            cell.cellinfo("a", title: examModel.answerA)
            
        }
        else if  indexPath.row == 1
        {
            cell.questiontitle.text=examModel.answerB
            cell.headimage.image=UIImage(named: "b")
            //print(examModel.answerB)
//            cell.cellinfo("b", title: examModel.answerB)
        }
        else if  indexPath.row == 2
        {
            cell.questiontitle.text=examModel.answerC
            cell.headimage.image=UIImage(named: "c")
            //print(examModel.answerC)
//            cell.cellinfo("c", title:examModel.answerC)
        }
        else if  indexPath.row == 3
        {
            cell.questiontitle.text=examModel.answerD
            cell.headimage.image=UIImage(named: "d")
            //print(examModel.answerD)
//            cell.cellinfo("d", title: examModel.answerD)
        }
        
        
        if  cell.questiontitle.textColor == UIColor.redColor()
        {
            cell.headimage.image=UIImage(named: "错")
        }
        if  cell.questiontitle.textColor == UIColor.greenColor()
        {
            cell.headimage.image=UIImage(named: "对")
        }
        
         if  indexPath.row == 4
        {

          var cellFrame = cell.frame
          cellFrame.origin.x=15
          cellFrame.origin.y=10
          cellFrame.size.width=UIScreen.mainScreen().bounds.width-30
          cellFrame.size.height-=10
          submit.frame=cellFrame
          submit.setTitle("确定", forState: UIControlState.Normal)
          submit.backgroundColor=UIColor(white: 0.9, alpha: 1)
          submit.layer.cornerRadius=20
          submit.enabled=false
            submit.addTarget(self, action: Selector("submit:"), forControlEvents: UIControlEvents.TouchUpInside)
          cell.addSubview(submit)
        }
        }

        return cell
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row==4
        {
            return nil
        }
        return indexPath
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      
        
        //MARK: - 多选题
        if cellNum==5 //多选题
        {
         let cell = table.cellForRowAtIndexPath(indexPath) as! ExamTableCell
         if cell.backgroundColor == UIColor(red: 1, green: 1, blue: 1, alpha: 1)//选中
         {
            cell.backgroundColor=UIColor(white: 0.9, alpha: 1)
            switch indexPath.row
            {
            case 0:
                 cell.headimage.image=UIImage(named: "a_1")  //多选题选中后图片
            case 1:
                 cell.headimage.image=UIImage(named: "b_1")  //多选题选中后图片
            case 2:
                 cell.headimage.image=UIImage(named: "c_1")  //多选题选中后图片
            case 3:
                 cell.headimage.image=UIImage(named: "d_1")  //多选题选中后图片
            default:
                break
            }
           
            selectNum++
          
         }
         else
         {
            cell.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            switch indexPath.row
            {
            case 0:
                 cell.headimage.image=UIImage(named: "a")
            case 1:
                cell.headimage.image=UIImage(named: "b")
            case 2:
                cell.headimage.image=UIImage(named: "c")
            case 3:
                cell.headimage.image=UIImage(named: "d")
            default:
                break
            }
           
            selectNum--
            
            
            }
         if selectNum>1//选择超过两个题按钮才变为可选
         {
          submit.backgroundColor=UIColor.greenColor()
          submit.enabled=true
         }
         else
         {
           submit.backgroundColor=UIColor(white: 0.9, alpha: 1)
            submit.enabled=false
          }
        }
        //MARK: - 非多选题
    else//非多选题
        {
     
        
        let rightAnswer = examModel.rightAnswer
            print(rightAnswer)
        let cellNow = table.cellForRowAtIndexPath(indexPath) as! ExamTableCell
    
        var answer = Int()
        
        if rightAnswer.hasPrefix("1")
        {
            answer=0
        }
        if rightAnswer.hasPrefix("2")
        {
            answer=1
        }
        if rightAnswer.hasPrefix("3")
        {
            answer=2
        }
        if rightAnswer.hasPrefix("4")
        {
            answer=3
        }
        
        if answer == indexPath.row  //答案正确
        {
            
            examModel.answerWere="false";
            exam.update(examModel)
            cellNow.headimage.image=UIImage(named: "对")//设置正确图片
            cellNow.questiontitle.textColor=UIColor.greenColor()
                        
//            var collection:UICollectionView = self.superview as! UICollectionView
            
            NSNotificationCenter.defaultCenter().postNotificationName("passquestion", object: nil)
            
            
            
        }
        else //答案错误
        {
            tableFootView.hidden=false
            
            cellNow.headimage.image=UIImage(named: "错")
            cellNow.questiontitle.textColor=UIColor.redColor()
            let index=NSIndexPath(forRow: answer, inSection: indexPath.section)
            
            let cellRight=table.cellForRowAtIndexPath(index) as! ExamTableCell
            cellRight.headimage.image=UIImage(named: "对")
            cellRight.questiontitle.textColor=UIColor.greenColor()
//            let user =  NSUserDefaults.standardUserDefaults()
            examModel.answerWere="true"
            exam.update(examModel)
            
            NSNotificationCenter.defaultCenter().postNotificationName("errorExplain", object: nil)
        }
        let dic = NSMutableDictionary()
        var i = 0
            
            
        for obj in tableView.visibleCells
        {
            let cellTemp = obj as! ExamTableCell
            cellTemp.userInteractionEnabled=false
            dic.setObject(cellTemp.questiontitle.textColor, forKey: String(i))
            i++
        }
       
        overNumArr.setObject(dic, forKey: String(over))//保存做过的题
        //        print(tableView.numberOfRowsInSection(indexPath.section))
        
      
      }
//     tableView.reloadData()
    }

    //MARK:- 通知
  
    func cleanOfExam()//排除
    {
       
        if isClean
        {
            
            examModel.isExclude=true
            exam.update(examModel)
            isClean=false
            MBProgressHUD.showSuccess("排除成功")
        }
        else
        {
            examModel.isExclude=false
            exam.update(examModel)
            isClean=true
            MBProgressHUD.showSuccess("取消排除成功")
        }
    }
    func collectOfExam(obj:NSNotification)//收藏
    {
        let title = obj.object as! String
      if title == "取消收藏"
      {
        examModel.isCollection = true
        exam.save(examModel)
        MBProgressHUD.showSuccess("收藏成功")
        
       }
        else
      {

        
        examModel.isCollection = false
        
        exam.save(examModel)
        MBProgressHUD.showSuccess("取消收藏成功")
      }
        
        
    }
    func explainOfExam(sender:NSNotification)//解释
    {
        if sender.object as! String == "收起解释"
       {
        tableFootView.hidden=true
       }
        else
       {
        tableFootView.hidden=false
        }
       
        
    }
    //MARK - 多选题按钮
    func submit(sender:UIButton)
    {
      var  key = 0
      let  tempSring = NSMutableString() //保存选择的cell序号
        var temp:String
     for obj in table.visibleCells
     {
        
       let cell = obj as! ExamTableCell
       if cell.backgroundColor == UIColor(white: 0.9, alpha: 1)
       {
        
    
        temp = String(format: "%d,", key)
         tempSring.appendString(temp)
        
       }
         key++
     }
     
        
        let letterString = tempSring.substringToIndex(tempSring.length-1)//保存处理好的选择的cell序号
        
//
        //TODO: - 如果不对，接口没用英文逗号隔开
        var rightAnswer = examModel.rightAnswer as NSString  //正确答案序号
        rightAnswer = rightAnswer.stringByReplacingOccurrencesOfString("1", withString: "0")
        rightAnswer = rightAnswer.stringByReplacingOccurrencesOfString("2", withString: "1")
        rightAnswer = rightAnswer.stringByReplacingOccurrencesOfString("3", withString: "2")
        rightAnswer = rightAnswer.stringByReplacingOccurrencesOfString("4", withString: "3")
        
         var arr = rightAnswer.componentsSeparatedByString(",")
        if arr.count > 4
        {
            arr.removeLast()
        }
       
        if  letterString == rightAnswer as String  //全部回答正确
        {
          
            examModel.answerWere="false";
            exam.update(examModel)
            
            
           for obj in arr
           {
            let objS = obj as NSString
            
            let index = NSIndexPath(forRow: objS.integerValue, inSection: 0)
            let cell = table.cellForRowAtIndexPath(index) as! ExamTableCell
          
            cell.headimage.image=UIImage(named: "对")//设置正确图片
            cell.questiontitle.textColor=UIColor.greenColor()
            }
           
            NSNotificationCenter.defaultCenter().postNotificationName("passquestion", object: nil)//回答正确跳过
            
        }
        else
        {
            MBProgressHUD.showError("滑动到下一题");
             NSNotificationCenter.defaultCenter().postNotificationName("errorExplain", object: nil)//回答错误展开解释
            examModel.answerWere="true";
            exam.update(examModel)
            tableFootView.hidden=false
            for obj in arr
            {
                
                let objS = obj as NSString
                let index = NSIndexPath(forRow: objS.integerValue, inSection: 0)
                let cell = table.cellForRowAtIndexPath(index) as! ExamTableCell
                
                cell.headimage.image=UIImage(named:"对")
                cell.questiontitle.textColor=UIColor.greenColor()
            }
            
            let temp = letterString.componentsSeparatedByString(",")
            
            for obj in temp
            {
                let num = Int(obj)
                let index = NSIndexPath(forRow: num!, inSection: 0)
                let cell = table.cellForRowAtIndexPath(index) as! ExamTableCell
                if cell.questiontitle.textColor != UIColor.greenColor()
                {
                    cell.headimage.image=UIImage(named: "错")
                    cell.questiontitle.textColor=UIColor.redColor()
                }
            }
            
        }
        
        let dic = NSMutableDictionary()
        var i = 0
        for obj in table.visibleCells
        {
          
            let cellTemp = obj as! ExamTableCell
            cellTemp.userInteractionEnabled=false
            if i<4
            {
                 dic.setObject(cellTemp.questiontitle.textColor, forKey: String(i))
            }
           
            i++
        }
        overNumArr.setObject(dic, forKey: String(over))//保存做过的题
        let index = NSIndexPath(forRow: 4, inSection: 0)
        let cell = table.cellForRowAtIndexPath(index) as! ExamTableCell
        cell.hidden=true
        
     
//
    }
    func ceshi()
    {
//        println("这里是123")
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
