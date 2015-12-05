//
//  YADUserInfoModifyAPI.h
//  JXT
//
//  Created by JWX on 15/12/5.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBack) (id result);
typedef void (^callDicBack) (NSDictionary *result);

@interface YADUserInfoModifyAPI : NSObject

/**
 *  修改密码
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)updateAccountPassWord:(NSArray *)arrInfo result:(callBack)result;

@end
