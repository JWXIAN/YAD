//
//  JWDriveHeadModel.h
//  JXT
//
//  Created by JWX on 15/6/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWDriveHeadModel : NSObject

@property (nonatomic,copy)NSString *issuccess;                 // 是否成功
@property (nonatomic,copy)NSString *statecode;              //状态码
@property (nonatomic,copy)NSString *stateinfo;              //状态信息

/** 数组，存放的是Body的模型数据 */
@property (nonatomic, strong) NSMutableArray *driveHeads;



@end
