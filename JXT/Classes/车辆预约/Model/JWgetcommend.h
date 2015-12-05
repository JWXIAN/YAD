//
//  JWgetcommend.h
//  JXT
//
//  Created by 1039soft on 15/7/8.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWgetcommend : NSObject
typedef void  (^MyCallback)(id obj);
//获取赞
+(void)getcommend:(NSString* )teacherID andCallback:(MyCallback)callback;
//点赞
+(void)postcommend:(NSDictionary* )teacherinfo andCallback:(MyCallback)callback;
//获取评价列表
+(void)showappraise:(NSString*)teachercode view:(id)view  andCallback:(MyCallback)callback;
//关注
+(void)attention:(NSString* )teachercode andCallback:(MyCallback)callback;
//取消关注
+(void)unattention:(NSString* )teachercode andCallback:(MyCallback)callback;
@end
