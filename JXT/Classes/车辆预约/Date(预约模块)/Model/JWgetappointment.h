//
//  JWgetappointment.h
//  JXT
//
//  Created by 1039soft on 15/7/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void  (^MyCallback)(id obj);
@interface JWgetappointment : NSObject
/**预约验证*/
+ (void)Verificationappointment:(NSDictionary* )userinfo andCallback:(MyCallback)callback;
/**保存预约*/
+ (void)saveappointment:(NSDictionary* )userinfo andCallback:(MyCallback)callback;
/**获取天气信息*/
+ (void)getWeatherInfoAndCallBack:(MyCallback)callback;
/**
 *  空段查询
 *
 *  @param day      日期 e.g. 2005-01-01-2015-10-31
 *  @param time     时间 e.g. 10:10-11:00
 *  @param callback 回调结果
 *
 *  @since 2.0.2
 */
+ (void)getLeisureWithDay:(NSString*)day time:(NSString*)time Callback:(MyCallback)callback;
@end
