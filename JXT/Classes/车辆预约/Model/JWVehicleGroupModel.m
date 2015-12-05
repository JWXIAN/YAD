//
//  JWVehicleGroupModel.m
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWVehicleGroupModel.h"

@implementation JWVehicleGroupModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //        [self setValuesForKeysWithDictionary:dict];
        [self setValue:dict[@"title"] forKey:@"title"];
    }
    return self;
}

+ (instancetype)venicleGroupWithDict:(NSDictionary *)dict
{
 
  
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)venicleGroups
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"groups.plist" ofType:nil]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self venicleGroupWithDict:dict]];
    }
    return arrayM;
}

@end
