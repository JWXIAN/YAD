//
//  ExamTopBodyView.swift
//  JXT
//
//  Created by 1039soft on 15/8/13.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

 let  reuseIdentifier = "reuseIdentifier"
let  reuseIdentifier2 = "cell2"
var overNumArr = NSMutableDictionary()//存放做过的题
class ExamTopBodyView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
     
    
   
    
    @IBOutlet weak var fir_w: NSLayoutConstraint!
    @IBOutlet weak var sec_w: NSLayoutConstraint!
    @IBOutlet weak var thr_w: NSLayoutConstraint!
    @IBOutlet weak var four_w: NSLayoutConstraint!


    @IBOutlet weak var 题号: ExamButton!
    @IBOutlet weak var 排除: ExamButton!
    @IBOutlet weak var 收藏: ExamButton!
    @IBOutlet weak var 解释: ExamButton!
    
    @IBOutlet weak var 提示图片: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    
     var arr = NSArray()
     var isMove = Int()
     var saveNum = Int()
     var  sysV = UIDevice.currentDevice().systemVersion as NSString
    
  
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        fir_w.constant=self.view.frame.size.width/4
        sec_w.constant=fir_w.constant
        thr_w.constant=fir_w.constant
        four_w.constant=fir_w.constant

    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed=true
    }

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if isMove > 0
//        {
//            let index = NSIndexPath(forRow: isMove, inSection: 0)
//           
//           collection.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
//        }
//        
// 
//        
//
//        
//    }
    //MARK: -  触摸事件
   func hideHelpImage()
   {
     提示图片.hidden=true
   }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let userde = NSUserDefaults.standardUserDefaults()
        if userde.boolForKey("shoucitishi") == true
        {
            提示图片.hidden=true
            
           
        }
        else
        {
            提示图片.hidden=false
            let tapGes = UITapGestureRecognizer(target: self, action: Selector("hideHelpImage"))
            提示图片.addGestureRecognizer(tapGes)
            userde.setBool(true, forKey: "shoucitishi")
        }
       
        
       
       if sysV.floatValue < 8.0
       {
         题号.setTitle(String(format: "%d/%d", 1, arr.count), forState: UIControlState.Normal)//设置初始题号
       }
      
      
      
       NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("selectbutton:"), name: "selectbutton", object: nil)//选择题号
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("passquestion"), name: "passquestion", object: nil)//下一题
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("errorExplain"), name: "errorExplain", object: nil)//回答错误展开解释
    }
   
    @IBAction func number(sender: ExamButton) {
        let story = UIStoryboard(name: "Storyboard", bundle:nil)
        let selectView = story.instantiateViewControllerWithIdentifier("selectview") as! SelectViewController
      
      
            selectView.allCount=collection.numberOfItemsInSection(0)
   
          UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            
            self.addChildViewController(selectView)
            self.view.addSubview(selectView.view)
            
          }, completion: nil)
    }
    @IBAction func clean(sender: ExamButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("cleanOfExam", object: nil)
    }
    @IBAction func collect(sender: ExamButton) {
        if sender.titleLabel?.text == "收藏本题"
        {
            sender.setTitle("取消收藏", forState: UIControlState.Normal)
            sender.setImage(UIImage(named: "收藏1"), forState: UIControlState.Normal)
        }
        else
        {
            sender.setTitle("收藏本题", forState: UIControlState.Normal)
            sender.setImage(UIImage(named: "收藏"), forState: UIControlState.Normal)
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("collectOfExam", object: sender.titleLabel?.text)
    }
    @IBAction func explain(sender: ExamButton) {
       
        if  sender.titleLabel?.text == "本题解释"
        {
            sender.setTitle("收起解释", forState: UIControlState.Normal)
             sender.setImage(UIImage(named: "解释1"), forState: UIControlState.Normal)
            
        }
        else
        {
            sender.setTitle("本题解释", forState: UIControlState.Normal)
             sender.setImage(UIImage(named: "解释"), forState: UIControlState.Normal)
            
        }
         NSNotificationCenter.defaultCenter().postNotificationName("explainOfExam", object: sender.titleLabel?.text)
    }
   
    
    //MARK: -  collectionview代理
    
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
//    {
//    //LOAD MORE
//    // you can also add a isLoading bool value for better dealing :D
//    }
//    }
    
    
    //MARK: - iOS7 方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if sysV.floatValue < 8.0
        {
           if scrollView.contentOffset.x % self.view.width == 0
            {
                var index = scrollView.contentOffset.x / self.view.width
                index =  index ?? 0
              let index_int = Int(index)
               
                let examModel = arr[index_int] as! exam
                
                
                
                
                题号.setTitle(String(format: "%d/%d", index_int+1, arr.count), forState: UIControlState.Normal)
                saveNum=index_int
                
                
                
                if examModel.isCollection == true
                {
                    收藏.setTitle("取消收藏", forState: UIControlState.Normal)
                    收藏.setImage(UIImage(named: "收藏1"), forState: UIControlState.Normal)
                }
                else
                {
                    收藏.setTitle("收藏本题", forState: UIControlState.Normal)
                    收藏.setImage(UIImage(named: "收藏"), forState: UIControlState.Normal)
                }
                
                解释.setTitle("本题解释", forState: UIControlState.Normal)
                解释.setImage(UIImage(named: "解释"), forState: UIControlState.Normal)
                let user =   NSUserDefaults.standardUserDefaults()
                user.setInteger(saveNum, forKey: "nextExercise")
                user.synchronize()
                

            }
            
           
        }
       
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       
        return arr.count
       
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ExamCollectionCell
    
        let examModel = arr[indexPath.row] as! exam
        
        cell.cellSet(examModel, overNum: indexPath.row)
        return cell
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
     
    

        
        let examModel = arr[indexPath.row] as! exam
   
   
        
        
      题号.setTitle(String(format: "%d/%d", indexPath.row+1, arr.count), forState: UIControlState.Normal)
        saveNum=indexPath.row
        
     
        
        if examModel.isCollection == true
        {
            收藏.setTitle("取消收藏", forState: UIControlState.Normal)
            收藏.setImage(UIImage(named: "收藏1"), forState: UIControlState.Normal)
        }
        else
        {
            收藏.setTitle("收藏本题", forState: UIControlState.Normal)
            收藏.setImage(UIImage(named: "收藏"), forState: UIControlState.Normal)
        }
       解释.setTitle("本题解释", forState: UIControlState.Normal)
       解释.setImage(UIImage(named: "解释"), forState: UIControlState.Normal)
        let user =   NSUserDefaults.standardUserDefaults()
        user.setInteger(saveNum, forKey: "nextExercise")
        user.synchronize()
        
    }

 //MARK: - 通知

    
    func selectbutton(sender:NSNotification)//选择题号
    {
    
        let temp = sender.object as! String
        let index_row = Int(temp)
      
        let index:NSIndexPath = NSIndexPath(forRow: index_row!-1, inSection: 0)
        collection.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
    }
    func passquestion()//答对自动下一题
    {
        
        let all = collection.numberOfItemsInSection(0)
        let row = NSUserDefaults.standardUserDefaults().integerForKey("nextExercise")
    
        if row+1 < all
        {
            let index = NSIndexPath(forRow: row+1, inSection: 0)
     
            collection.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
           
        }
        else
        {
         MBProgressHUD.showError("已经是最后一题")
        }
        
    }
    func errorExplain()//解释
    {
        解释.setTitle("收起解释", forState: UIControlState.Normal)
        解释.setImage(UIImage(named: "解释1"), forState: UIControlState.Normal)
    }
    override func viewDidDisappear(animated: Bool) {
        overNumArr.removeAllObjects()
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
 }
