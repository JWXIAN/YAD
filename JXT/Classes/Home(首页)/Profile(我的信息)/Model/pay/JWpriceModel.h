//
//  JWpriceModel.h
//  JXT
//
//  Created by 1039soft on 15/7/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWpriceModel : NSObject
@property (nonatomic,copy)NSString *issuccess;                         //是否成功
@property (nonatomic,copy)NSString *statecode;                      //状态识别码
@property (nonatomic,copy)NSString *stateinfo;
@property(copy,nonatomic) NSArray* body;//body数组

//@property(copy,nonatomic) NSString* kemu;//科目
//@property(copy,nonatomic) NSString* danjia;//单价
+(JWpriceModel *)parserStuLoginByDictionary:(NSDictionary *)dic;
@end
