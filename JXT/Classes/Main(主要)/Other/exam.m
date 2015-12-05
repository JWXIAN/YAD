//
//  exam.m
//  db
//
//  Created by 1039soft on 15/8/11.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "exam.h"

@implementation exam
//重写打印方法
-(NSString *)description{
NSString* str=[NSString stringWithFormat:@"carType=%@,className=%@,chaptersType=%@,questionNum=%d,absorbedType=%@,questionType=%@,questionBody=%@,answer=%@,rightAnswer=%@,questionPicture=%@,account=%@,questionRank=%d,isCollection=%@,isExclude=%@,dataVersions=%@",_carType,_className,_chaptersType,_questionNum,_absorbedType,_questionType,_questionBody,_answerA,_rightAnswer,_questionPicture,_account,_questionRank,@(_isCollection),@(_isExclude),_dataVersions];
    str=[str stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
 
    return str;
    
}



@end
