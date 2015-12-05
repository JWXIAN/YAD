//
//  WMPageConst.h
//  WMPageController
//
//  Created by JWXian.com on 15/8/11.
//  Copyright (c) 2015年 JW. All rights reserved.
//
//  WMPageController的导航栏的一些默认属性
//  如懒得设置PageController的属性，可在此自行修改

//  标题的尺寸(选中/非选中)
#define WMTitleSizeSelected 15
#define WMTitleSizeNormal   15

//  标题的颜色(选中/非选中) (P.S.标题颜色是可动画的)
//#define WMTitleColorSelected [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1]
//#define WMTitleColorNormal   [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

#define WMTitleColorSelected [UIColor colorWithRed:121.0/255.0 green:191.0/255.0 blue:70.0/255.0 alpha:1.0]
#define WMTitleColorNormal   [UIColor colorWithRed:121.0/255.0 green:191.0/255.0 blue:70.0/255.0 alpha:1.0]

//  导航菜单栏的背景颜色
#define WMMenuBGColor [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]
//  导航菜单栏的高度
#define WMMenuHeight  30
//  导航菜单栏每个item的宽度
#define WMMenuItemWidth 65
//
//  如需要利用观察者来订阅通知，请将 pageController 的 postNotification 设置为 YES
//
//  当一个控制器的视图 被添加到父控制器的时候会发布一个通知
//  可用于判断当前控制器的序号，主要用于当同一个控制器管理时，通过判断序号来加载相应数据
//  传递的数据包含两个信息，当前序号 (index) 以及标题 (title)
//
//  NOTE:由于缓存机制，不会在 controller 移出屏幕时销毁控制器，若想要控制器视图移除屏幕后不再收到通知，可在 -viewWillDisappear: 或 -viewDidDisappear: 中 removeObserver.
static NSString *const WMControllerDidAddToSuperViewNotification = @"WMControllerDidAddToSuperViewNotification";
//  当一个控制器完全被展示在用户面前时发送的通知
//  可用于判断当前控制器的序号，加载或者刷新当前数据.
//  传递的数据包含两个信息，当前序号 (index) 以及标题 title
//
//  NOTE:由于缓存机制，不会在 controller 移出屏幕时销毁控制器，若想要控制器视图移除屏幕后不再收到通知，可在 -viewWillDisappear: 或 -viewDidDisappear: 中removeObserver.并且相应的，在 -viewWillAppear: 中添加 observer
static NSString *const WMControllerDidFullyDisplayedNotification = @"WMControllerDidFullyDisplayedNotification";