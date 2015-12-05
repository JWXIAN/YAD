//
//  exam.h
//  db
//
//  Created by 1039soft on 15/8/11.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "BaseModel.h"

@interface exam : BaseModel
@property(strong,nonatomic)NSString* dataVersions;        //数据库版本
@property(strong,nonatomic)NSString* carType;             //车类型
@property(strong,nonatomic)NSString* className;           //科目名称
@property(strong,nonatomic)NSString* chaptersType;        //章节类别
@property(assign,nonatomic)int       questionNum;         //题号
@property(strong,nonatomic)NSString* absorbedType;        //专项类别
@property(strong,nonatomic)NSString* questionType;        //题目类别 (单选 多选 判断...)
@property(strong,nonatomic)NSString* questionBody;        //题目内容
@property(strong,nonatomic)NSString* answerA;             //题目所有答案 (用,(英文)隔开)
@property(strong,nonatomic)NSString* answerB;
@property(strong,nonatomic)NSString* answerC;
@property(strong,nonatomic)NSString* answerD;
@property(strong,nonatomic)NSString* answerWere;          //是否回答错误     //true or false
@property(strong,nonatomic)NSString* rightAnswer;         //正确答案
@property(strong,nonatomic)NSString* questionPicture;     //题目图片
@property(strong,nonatomic)NSString* account;             //题目解释
@property(assign,nonatomic)int       questionRank;        //题目难度
@property(assign,nonatomic)BOOL      isCollection;        //是否收藏
@property(assign,nonatomic)BOOL      isExclude;           //是否排除


@end
