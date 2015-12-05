//
//  JWpriceModel.m
//  JXT
//
//  Created by 1039soft on 15/7/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWpriceModel.h"

@implementation JWpriceModel
+(JWpriceModel *)parserStuLoginByDictionary:(NSDictionary *)dic
{
    JWpriceModel* jwp=[[JWpriceModel alloc]init];
    jwp.issuccess=dic[@"issuccess"];
    jwp.statecode=dic[@"statecode"];
    jwp.stateinfo=dic[@"stateinfo"];
    if (![dic[@"head"][@"stateinfo"] isEqualToString:@"失败"]) {
         jwp.body=dic[@"body"];
    }
//    for (NSDictionary* dic2 in jwp.body) {
//        jwp.kemu=dic2[@"科目"];
//        jwp.danjia=dic2[@"单价"];
//        
//    }
    return jwp;
}
@end
