//
//  JWVehicleGroupModel.h
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWVehicleGroupModel : NSObject

/** 首字母索引 */
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)venicleGroupWithDict:(NSDictionary *)dict;

+ (NSArray *)venicleGroups;

@end
