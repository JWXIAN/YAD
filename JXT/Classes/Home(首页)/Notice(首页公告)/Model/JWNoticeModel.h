//
//  JWNoticeModel.h
//  JXT
//
//  Created by JWX on 15/6/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWNoticeModel : NSObject

@property (nonatomic,assign)BOOL issuccess;                     //是否成功
@property (nonatomic,copy)NSString *statecode;                  // 状态码 ???
@property (nonatomic,copy)NSString *stateinfo;                  //  状态信息 ???
@property (nonatomic,copy)NSString *result;                     //公告内容

///** 数组，存放的是notice的模型数据 */
//@property (nonatomic, strong) NSMutableArray *notices;
@end
