//
//  YADHomeAPI.h
//  JXT
//
//  Created by JWX on 15/12/7.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBack) (id result);
typedef void (^callDicBack) (NSDictionary *result);

@interface YADHomeAPI : NSObject

/**
 *  获取首页轮播图片
 *
 *  @param result 回调结果
 *
 *  @since 1.0
 */
+ (void)getHomeScrollImage:(callDicBack)result;

@end
