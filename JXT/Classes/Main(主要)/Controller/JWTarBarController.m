//
//  JWTarBarController.m
//  JJXC
//
//  Created by JWX on 15/10/20.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWTarBarController.h"
#import "JWNavController.h"
#import "PrefixHeader.pch"
#import "YADHomeTV.h"
#import "YADLifeTV.h"
#import "YADPersonalCenterTV.h"
#import "YADDriverVC.h"
#import "UIView+MJExtension.h"
#import "YADWebViewVC.h"

#import "SVProgressHUD.h"

@interface JWTarBarController ()

@end

@implementation JWTarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //首页
    YADHomeTV *home = [[YADHomeTV alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:home title:@"首页" image:@"11" selectedImage:@"12"];
    //在线学车
    YADDriverVC *driver = [[YADDriverVC alloc] init];
    [self addChildVc:driver title:@"在线学车" image:@"21" selectedImage:@"22"];
    //生活助理
    YADLifeTV *or = [[YADLifeTV alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:or title:@"生活助理" image:@"31" selectedImage:@"32"];
    //个人中心
    YADPersonalCenterTV *msg = [[YADPersonalCenterTV alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:msg title:@"个人中心" image:@"41" selectedImage:@"42"];
    
    //全局设置SV样式
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    //全局设置textField光标颜色
    [[UITextField appearance] setTintColor:JWColor(232, 94, 84)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片JWColor(36, 107, 246)
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = JWColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = JWColor(232, 94, 84);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    JWNavController *nav = [[JWNavController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

@end

//#pragma mark - 模拟考试分页
//- (WMPageController *)getDefaultController{
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    NSMutableArray *titles = [[NSMutableArray alloc] init];
//    NSString* carType = [[NSUserDefaults standardUserDefaults] objectForKey:@"whichButton"];
//    
//    for (int i = 0; i < 4; i++) {
//        Class vcClass;
//        NSString *title;
//        switch (i) {
//            case 0:
//                vcClass = [JWKMTestVC class];
//                title = @"科目一";
//                
//                break;
//            case 1:
//                vcClass = [JWCarVC class];
//                title = @"科目二";
//                break;
//            case 2:
//                vcClass = [JWCarVC class];
//                title = @"科目三";
//                break;
//            case 3:
//                vcClass = [JWKMTestVC class];
//                title = @"科目四";
//                break;
//        }
//        [viewControllers addObject:vcClass];
//        
//        [titles addObject:title];
//    }
//    
//    _pageVC= [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
//    _pageVC.pageAnimatable = YES;
//    //    _pageVC.menuItemWidth = self.view.mj_w / 2;
// 
//    if ([carType isEqualToString:@"ZJ"]||[carType isEqualToString:@"ZB"]||[carType isEqualToString:@"ZC"]||[carType isEqualToString:@"ZA"]||[carType isEqualToString:@"ZD"])
//    {
//        if ([carType isEqualToString:@"ZJ"]) {
//            _pageVC.title=@"教练员资格证";
//        }
//        if ([carType isEqualToString:@"ZB"]) {
//            _pageVC.title=@"货运资格证";
//        }
//        if ([carType isEqualToString:@"ZC"]) {
//            _pageVC.title=@"危险品资格证";
//            
//        }
//        if ([carType isEqualToString:@"ZA"]) {
//            _pageVC.title=@"客运资格证";
//            
//        }
//        if ([carType isEqualToString:@"ZD"]) {
//            _pageVC.title=@"出租车资格证";
//            
//        }
//        _pageVC.menuHeight=0;
//    }
//    else
//    {
//        if ([carType isEqualToString:@"C"]) {
//            _pageVC.title=@"小车驾驶证";
//        }
//        if ([carType isEqualToString:@"B"]) {
//            _pageVC.title=@"货车驾驶证";
//            
//        }
//        if ([carType isEqualToString:@"A"]) {
//            _pageVC.title=@"客车驾驶证";
//            
//        }
//        if ([carType isEqualToString:@"DEF"]) {
//            _pageVC.title=@"摩托车驾驶证";
//            
//        }
//        
//         _pageVC.menuHeight=40;
//    }
//   
//    _pageVC.postNotification = YES;
//    
//    return _pageVC;
//}
