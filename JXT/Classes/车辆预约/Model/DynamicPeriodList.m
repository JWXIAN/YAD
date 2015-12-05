//
//  DynamicPeriodList.m
//  jiaxiaotong
//
//  Created by 1039soft on 15/6/14.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "DynamicPeriodList.h"

@implementation DynamicPeriodList
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dynPeriodListContents = [NSMutableArray array];
    }
    return self;
}
@end
