//
//  JWTrainHeadModel.h
//  JXT
//
//  Created by JWX on 15/8/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWTrainHeadModel : NSObject

@property (nonatomic,copy)NSString *issuccess;                     //是否成功
@property (nonatomic,copy)NSString *statecode;                  // 状态码 ???
@property (nonatomic,copy)NSString *stateinfo;                  //  状态信息 ???

/**存放的body的数据模型*/
@property (nonatomic,strong)NSMutableArray *body;

@end
