//
//  dic_model.swift
//  JXT
//
//  Created by 1039soft on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class dic_model: NSObject {
    class func getmodel(dic:NSDictionary) ->exam
    {
       
        let temp=exam()
        let hostids:(NSString) = dic["id"] as! NSString
        temp.hostID=hostids.integerValue
        temp.carType=dic["cartype"] as! String
        temp.className=dic["classname"] as! String
        temp.chaptersType=dic["chapterstype"] as! String
        let qn = dic["questionnum"] as! NSString
        temp.questionNum=qn.intValue
        temp.absorbedType=dic["absorbedtype"] as! String
        temp.questionType=dic["questiontype"] as! String
        temp.questionBody=dic["questionbody"] as! String
        temp.answerA=dic["answera"] as! String
        temp.answerB=dic["answerb"] as! String
        temp.answerC=dic["answerc"] as! String
        temp.answerD=dic["answerd"] as! String
       
        temp.answerWere=dic["answere"] as! String
        temp.rightAnswer=dic["rightanswer"] as! String
        temp.questionPicture=dic["questionpicture"] as! String
        temp.account=dic["account"] as! String
        let qr = dic["questionrank"] as! NSString
        temp.questionRank=qr.intValue
        let ic = dic["iscollection"] as! String
        if ic == "是"
        {
            temp.isCollection=true
        }
        else
        {
            temp.isCollection=false
        }
        
        let iec:(String) = dic["isexclude"] as! String
        if iec == "是"
        {
            temp.isExclude=true
        }
        else
        {
            temp.isExclude=false
        }
        
        
        return temp
    }

}
