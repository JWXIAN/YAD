//
//  WeatherModel.h
//  JXT
//
//  Created by 1039soft on 15/9/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property(strong,nonatomic) NSDictionary* HeWeather_data_service_3;//天气

@property(strong,nonatomic) NSArray* daily_forecast;//未来七天数据
@property(strong,nonatomic) NSArray* hourly_forecast;//当天数据
@property(strong,nonatomic) NSDictionary* cond;//天气状况
//http://www.heweather.com/documents/condition-code  天气代码查询
@property(strong,nonatomic) NSString* code_d;//白天天气代码
@property(strong,nonatomic) NSString* code_n;//夜间天气代码
@property(strong,nonatomic) NSString* date;//日期
@property(strong,nonatomic) NSString* status;//状态码，成功返回 ok
@end
