//
//  Share.h
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/21.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Share : NSObject
@property (nonatomic,assign)BOOL issuccess;                     //是否成功
@property (nonatomic,copy)NSString *statecode;                  // 状态码 ???
@property (nonatomic,copy)NSString *stateinfo;                  //  状态信息 ???
@property (nonatomic,copy)NSString *result;                     //分享的内容

@end
