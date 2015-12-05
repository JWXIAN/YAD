//
//  JWWDCJStatBodyModel.h
//  JXT
//
//  Created by JWX on 15/9/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWWDCJStatBodyModel : NSObject
/**考试用时*/
@property (nonatomic, copy)NSString *kaotime;
/**考试分数*/
@property (nonatomic, copy)NSString *kaofenshu;
/**考试时间*/
@property (nonatomic, copy)NSString *starttime;
/**客户端*/
@property (nonatomic, copy)NSString *clientcode;
@end
