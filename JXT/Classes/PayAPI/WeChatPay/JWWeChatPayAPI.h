//
//  JWWeChatPayAPI.h
//  JXT
//
//  Created by JWX on 15/10/13.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWWeChatPayAPI : NSObject

/**微信支付API*/
+ (void)WeChatPayAPI:(NSString *)payInfo payMoney:(NSString *)payMoney;

/**解析XML*/
+ (void)http:(NSString *)xml;

/**产生随机字符串*/
+ (NSString *)generateTradeNo;

/**产生随机数*/
+ (NSString *)getOrderNumber;

//将订单号使用md5加密
+ (NSString *)md5:(NSString *)str;
@end
