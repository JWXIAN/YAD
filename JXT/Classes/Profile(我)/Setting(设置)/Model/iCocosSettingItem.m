//
//  iCocosSettingItem.m
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "iCocosSettingItem.h"

@implementation iCocosSettingItem
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title type:(iCocosSettingItemType)type
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.type = type;
    return item;
}
@end
