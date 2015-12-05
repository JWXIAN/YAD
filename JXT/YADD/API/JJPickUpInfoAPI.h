//
//  JJPickUpInfoAPI.h
//  JXT
//
//  Created by JWX on 15/12/3.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBack) (NSDictionary* result);
@interface JJPickUpInfoAPI : NSObject

/**
 *  获取预约接送信息
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)getPickUpInfo:(callBack)result;

/**
 *  取消预约接送
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)cancelPickUpInfo:(NSString *)pickID callback:(callBack)result;


/**
 *  保存预约接送信息
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)savePickUpInfo:(NSDictionary *)pickInfo callback:(callBack)result;
@end
