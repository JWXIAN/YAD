//
//  JWgetpay.h
//  JXT
//
//  Created by 1039soft on 15/7/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void  (^MyCallback)(id obj);
@interface JWgetpay : NSObject
//获取物品清单
+(void)requestClassandPrice:(NSString *)schoolID andCallback:(MyCallback)callback;
//获取支付key
+(void)requestpaykey:(NSString *)schoolID andCallback:(MyCallback)callback;
//获取是否可以支付
+(void)requestpayissuccess:(NSString *)schoolID andCallback:(MyCallback)callback;
//支付成功后上传信息
+(void)postpayinfo:(NSString *)schoolID info:(NSDictionary*)info andCallback:(MyCallback)callback;
/**获取微信支付信息*/
+(void)requestWeChatkey:(NSString *)schoolID andCallback:(MyCallback)callback;
@end
