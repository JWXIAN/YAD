//
//  JWVenicleHeadModel.h
//  JXT
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWVenicleHeadModel : NSObject

@property (nonatomic,assign)BOOL issuccess;                     //是否成功
@property (nonatomic,copy)NSString *statecode;                  // 状态码 ???
@property (nonatomic,copy)NSString *stateinfo;                  //  状态信息 ???

@property (nonatomic,strong)NSMutableArray *driTeachersList;
@end
