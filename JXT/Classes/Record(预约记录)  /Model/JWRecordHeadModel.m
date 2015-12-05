//
//  JWRecordHeadModel.m
//  JXT
//
//  Created by JWX on 15/6/25.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWRecordHeadModel.h"

@implementation JWRecordHeadModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recordHeads = [NSMutableArray array];
    }
    return self;
}

@end
