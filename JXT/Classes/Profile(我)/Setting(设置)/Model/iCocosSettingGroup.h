//
//  iCocosSettingGroup.h
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.

#import <Foundation/Foundation.h>

@interface iCocosSettingGroup : NSObject
@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目


@end
