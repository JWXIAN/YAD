//
//  YADLoginAPI.h
//  JXT
//
//  Created by JWX on 15/12/4.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBack) (id result);
typedef void (^callDicBack) (NSDictionary *result);
@interface YADLoginAPI : NSObject
/**
 *  用户登录
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)getUserLoginWithAccountPassWord:(NSDictionary *)loginInfo callback:(callBack)result;

/**
 *  获取注册车型
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)getRegisterCarType:(callDicBack)result;

/**
 *  注册用户
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+(void)postRegisterInfo:(NSArray *)info carType:(NSString *)carType Callback:(callDicBack)callback;


@end
