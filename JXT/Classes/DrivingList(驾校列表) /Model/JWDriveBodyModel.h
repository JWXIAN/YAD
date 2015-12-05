//
//  JWDriveBodyModel.h
//  JXT
//
//  Created by JWX on 15/6/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWDriveBodyModel : NSObject

@property (nonatomic,copy)NSString *driveID;                // 驾校ID ???
@property (nonatomic,copy)NSString *qyid;                   // 驾校编号
@property (nonatomic,copy)NSString *qyname;                 // 驾校名称
@property (nonatomic,copy)NSString *begindate;              // 开始日期
@property (nonatomic,copy)NSString *enddate;                // 结束日期
@property (nonatomic,copy)NSString *shengfen;               // 省份
@property (nonatomic,copy)NSString *shiqu;                  // 市区
@property (nonatomic,copy)NSString *connstring;             // 服务器链接 ???
@property (nonatomic,copy)NSString *state;                  // 当前状态
@property (nonatomic,copy)NSString *nid;                    // 驾校序号？
@property (nonatomic,copy)NSString *qytype;                 // 类别???

//- (instancetype)initWithDict:(NSDictionary *)dict;
//+ (instancetype)driveWithDict:(NSDictionary *)dict;
//
//// 传入一个包含字典的数组，返回一个HMCar模型的数组
//+ (NSArray *)drivesWithArray:(NSArray *)array;

@end
