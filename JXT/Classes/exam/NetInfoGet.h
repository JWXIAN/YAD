//
//  NetInfoGet.h
//  JXT
//
//  Created by 1039soft on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void  (^MyCallback)(id obj);
@interface NetInfoGet : NSObject

//获取数据库版本
+(void)getCodeInfoAndCallback:(MyCallback)callback;
//获取数据库内容
+(void)getDataList:(NSString* )carType callback:(MyCallback)callback;

//获取许愿墙列表
+(void)getWishListAndCallBack:(MyCallback)callback;
//给许愿墙加愿力      什么鬼名字！！  好中二("▔□▔)/
+(void)givewWishPowerWithStuID:(NSString* )stuID callBack:(MyCallback)callback;
//许愿  = =
+(void)sendWishWithMessage:(NSString* )message callBack:(MyCallback)callback;

@end
