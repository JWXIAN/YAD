//
//  StuExamInfo.h
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/21.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuExamInfo : NSObject

@property (nonatomic,copy)NSString *examID;  //考试编号???
@property (nonatomic,copy)NSString *examName;//考试科目
@property (nonatomic,copy)NSString *examResult;//考试结果
@property (nonatomic,copy)NSString *examDate;//考试日期
@property (nonatomic,copy)NSString *examAddress;//考试地址

@end
