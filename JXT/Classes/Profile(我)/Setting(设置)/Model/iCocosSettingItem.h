//
//  iCocosSettingItem.h
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//  一个Item对应一个Cell
// 用来描述当前cell里面显示的内容，描述点击cell后做什么事情

#import <Foundation/Foundation.h>

typedef enum {
    iCocosSettingItemTypeNone, // 什么也没有
    iCocosSettingItemTypeArrow, // 箭头
    iCocosSettingItemTypeSwitch // 开关
} iCocosSettingItemType;

@interface iCocosSettingItem : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) iCocosSettingItemType type;// Cell的样式
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title type:(iCocosSettingItemType)type;
@end
