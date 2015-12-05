//
//  AppDelegate.h
//  JXT
//
//  Created by 李莉 on 15/6/19.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LeftSlideViewController.h"
#import "JWNavController.h"
#import "WXApi.h"
//#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property(strong,nonatomic)   JWNavController* navi;


@end

