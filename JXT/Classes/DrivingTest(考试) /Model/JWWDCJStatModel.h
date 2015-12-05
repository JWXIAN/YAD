//
//  JWWDCJStatModel.h
//  JXT
//
//  Created by JWX on 15/9/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWWDCJStatModel : NSObject

@property (nonatomic, copy)NSString *issuccess;                         //是否成功
@property (nonatomic, copy)NSString *statecode;                      //状态识别码
@property (nonatomic, copy)NSString *stateinfo;                      //状态信息

/**存放我的成绩信息*/
@property (nonatomic, strong)NSArray *body;
@end
