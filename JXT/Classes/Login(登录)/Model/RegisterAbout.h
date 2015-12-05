//
//  RegisterAbout.h
//  JXT
//
//  Created by 1039soft on 15/8/4.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void  (^MyCallback)(id obj);

@interface RegisterAbout : NSObject
//获取注册车型
+(void)GetCarCallback:(MyCallback)callback;
//添加注册
+(void)PostRegisterInfo:(NSDictionary*)info view:(UIView*)view Callback:(MyCallback)callback;
@end
