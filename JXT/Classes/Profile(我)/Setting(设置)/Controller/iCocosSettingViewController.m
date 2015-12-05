//
//  iCocosSettingViewController.m
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "iCocosSettingViewController.h"
#import "iCocosPushNoticeViewController.h"
#import "JWDLTVController.h"
#import "JWhelpViewController.h"
#import "JWLoginController.h"
#import "JiaxiaotongAPI.h"
#import "Share.h"
#import "JWAboutViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "jxt-swift.h"
#import "JWMyNewsTV.h"
#import "YADLoginTV.h"

@interface iCocosSettingViewController ()

@end

@implementation iCocosSettingViewController
- (void)viewDidLoad
{
    self.title=@"更多";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    // 1.第0组：3个
    [self add0SectionItems];
    
    // 2.第1组：3个
    [self add1SectionItems];
    
    //3.第2组: 3个
    [self add2SectionItems];
    
    
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{

    // 1.1.公告
    iCocosSettingItem *push = [iCocosSettingItem itemWithIcon:@"sound_Effect" title:@"驾校公告" type:iCocosSettingItemTypeArrow];
    push.operation = ^{
        iCocosPushNoticeViewController *notice = [[iCocosPushNoticeViewController alloc] init];
        [self.navigationController pushViewController:notice animated:YES];
    };
    // 1.2.我的消息
    iCocosSettingItem *myNews = [iCocosSettingItem itemWithIcon:@"xiaoxi2" title:@"我的消息" type:iCocosSettingItemTypeArrow];
    myNews.operation = ^{
        JWMyNewsTV *myNewTV = [[JWMyNewsTV alloc] init];
        myNewTV.hidesBottomBarWhenPushed = YES;
        myNewTV.title = @"我的消息";
        [self.navigationController pushViewController:myNewTV animated:YES];
    };
    
    // 1.3.推送
    iCocosSettingItem *shake = [iCocosSettingItem itemWithIcon:@"handShake" title:@"推送与提醒" type:iCocosSettingItemTypeSwitch];
    shake.operation=^
    {
    };
    // 1.4.意见反馈
    iCocosSettingItem *feedback = [iCocosSettingItem itemWithIcon:@"IDInfo" title:@"意见反馈" type:iCocosSettingItemTypeArrow];
    feedback.operation= ^{
        UIStoryboard *stor=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *yijian = [stor instantiateViewControllerWithIdentifier:@"yijian"];
        [self.navigationController pushViewController:yijian animated:YES];
    };
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    //    group.header = @"基本设置";
    group.items = @[push, myNews, shake, feedback];
    [_allGroups addObject:group];
}

- (void)add1SectionItems
{
    // 2.1.选择驾校
    iCocosSettingItem *update = [iCocosSettingItem itemWithIcon:@"xjx" title:@"选择驾校" type:iCocosSettingItemTypeArrow];
    update.operation = ^{
        
        JWDLTVController* jwr=[[JWDLTVController alloc]init];
        jwr.navigationItem.title=@"选择驾校";
        [self.navigationController pushViewController:jwr animated:YES];
        //        [self presentViewController:jwr animated:YES completion:nil];
    };
    //选择车型
    
    
    
    iCocosSettingItem *chageCar = [iCocosSettingItem itemWithIcon:@"xt" title:@"选择题库" type:iCocosSettingItemTypeArrow];
    chageCar.operation = ^{
//        ChanegExam
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        ChanegExam* car= [story instantiateViewControllerWithIdentifier:@"changeexam"];
        car.title= @"选择题库";
        [self.navigationController pushViewController:car animated:YES];
    };
    //分享
    iCocosSettingItem *share = [iCocosSettingItem itemWithIcon:@"MoreShare" title:@"分享给朋友" type:iCocosSettingItemTypeArrow];
    share.operation=^{
//        [self shareData];
    };
    
    // 2.4.清理缓冲
    iCocosSettingItem *buffer = [iCocosSettingItem itemWithIcon:@"buffer" title:@"清理缓存" type:iCocosSettingItemTypeNone];
    buffer.operation=^{
        [self buffer];
    };
    
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[update,chageCar, share, buffer];
    [_allGroups addObject:group];
}

#pragma mark - 清理缓存
- (void)buffer
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
- (void)clearCacheSuccess
{
    [MBProgressHUD showSuccess:@"缓存清理成功"];
}

#pragma mark 添加第1组的模型数据
- (void)add2SectionItems
{
    // 2.4.修改密码
    iCocosSettingItem *msg = [iCocosSettingItem itemWithIcon:@"MoreMessage" title:@"修改密码" type:iCocosSettingItemTypeArrow];
    msg.operation= ^{
        UIStoryboard *stor=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *yijian = [stor instantiateViewControllerWithIdentifier:@"mima"];
        [self.navigationController pushViewController:yijian animated:YES];
    };
    //    // 2.5.产品推荐
    //    iCocosSettingItem *product = [iCocosSettingItem itemWithIcon:@"MoreNetease" title:@"产品推荐" type:iCocosSettingItemTypeArrow];
    
    // 2.2.帮助
    iCocosSettingItem *help = [iCocosSettingItem itemWithIcon:@"MoreHelp" title:@"帮助" type:iCocosSettingItemTypeArrow];
    help.operation = ^{
        JWhelpViewController *helpVc = [[JWhelpViewController alloc] init];
        helpVc.title = @"学车通操作指南";
        helpVc.labtext=@"什么是学车通？\n\r学车通是由1039公司研发团队针对驾校学员预约约车开发的一款手机应用，方便学员约车、购买课时、选择教练等，学车通在手，约车不再难。\n\r学车通主要功能\n\r1、快捷登陆：选择驾校，输入身份证号即可登陆；\n2、时段预约：根据教练员星级、推荐指数、距离选择教练，自由选择练车时段，方便灵活；\n3、上车认证：在手机生成代表预约记录二维码，供教练扫描核对用；\n4、购买学时：当剩余学时不足学员可通过微信、支付宝购买学时，方便快捷；\n5、评价教练：教练服务好不好，学员说了算，每次练完车都可对教练进行评价；\n6、练车分享：向微信、微博等分享练车、教练评语等(后期更新练车分享成功可获得积分，可兑换课时)；\n7、进度查询：可实时查询每一次每一科的考试进度；\n8、记录查询：可随时查看预约记录、培训记录及退约记录，数据准确可靠；\n9、实时沟通：学员可通过电话、短信和教练员沟通；\n10、官方公告：第一时间获知驾校公告，了解学车动态。\n\r为什么要用学车通？\n预约练车是学车过程中重要的环节，1039公司推出网上约车、微信约车、APP（安卓版+IOS版）约车，旨在为广大学员提供便捷的服务平台，后期我们仍会开发更多利于学员学车的工具及软件，敬请期待！\n\r\nAPP使用有问题怎么办？\n请先和驾校人员沟通，将问题反馈给驾校，如多人反映类似问题，驾校人员会和1039公司技术人员取得联系并及时解决问题！\n\n\n";
        [self.navigationController pushViewController:helpVc animated:YES];
    };
    // 2.6.关于我们
    iCocosSettingItem *about = [iCocosSettingItem itemWithIcon:@"MoreAbout" title:@"关于我们" type:iCocosSettingItemTypeArrow];
    about.operation = ^{
        JWAboutViewController *helpVc = [[JWAboutViewController alloc] init];
        helpVc.title = @"关于";
        [self.navigationController pushViewController:helpVc animated:YES];
    };
    //退出登录
    iCocosSettingItem* exit=[iCocosSettingItem itemWithIcon:@"MorePush" title:@"退出登录" type:iCocosSettingItemTypeNone];
    exit.operation=^{
        NSUserDefaults* uu=[NSUserDefaults standardUserDefaults];
        [uu setBool:NO forKey:@"issuccess"];
        [uu synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    //    group.header = @"JWX";
    //    group.footer = @"JWX";
    group.items = @[msg, help, about,exit];
    [_allGroups addObject:group];
}

//#pragma mark - 分享
//- (void)shareData
//{
//    __block Share* sha;
//    __block NSString* bodyy1;
//    __block NSString* bodyy2;
//    [JiaxiaotongAPI requestShareByShare:nil andCallback:^(id obj) {
//        sha=obj;
////        NSLog(@"shaaaa==%@",sha.result);
//
//        NSRange range = [sha.result rangeOfString:@"("];//匹配得到的下标
////        NSLog(@"rang:%@",NSStringFromRange(range));
//        
//        bodyy1 = [sha.result substringToIndex:range.location];//截取范围内的字符串
//#warning  这个链接是个安卓的。apk没法用
//        bodyy2 = [sha.result substringFromIndex:range.location];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//        
//        //构造分享内容
//        
//        id<ISSContent> publishContent = [ShareSDK content:bodyy1
//                                           defaultContent:@"moren"
//                                                    image:[ShareSDK imageWithPath:imagePath]
//                                                    title:@"学车通"
//                                                      url:@"http://xy.1039.net:60001/xiazai/index.html"
//                                              description:sha.result
//                                                mediaType:SSPublishContentMediaTypeNews];
//        //创建弹出菜单容器
//        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
//        
//        //弹出分享菜单
//        [ShareSDK showShareActionSheet:container
//                             shareList:nil
//                               content:publishContent
//                         statusBarTips:YES
//                           authOptions:nil
//                          shareOptions:nil
//                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    
//                                    if (state == SSResponseStateSuccess)
//                                    {
//                                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                        alertView.frame = CGRectMake(50, 200, 200, 50);
//                                        [alertView show];
////                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                    }
//                                    else if (state == SSResponseStateFail)
//                                    {
//                                        NSString* err=[NSString stringWithFormat:@"分享失败:%@",[error errorDescription]];
//                                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:err delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                        alertView.frame = CGRectMake(50, 200, 200, 50);
//                                        [alertView show];
////                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    }
//                                }];
//        
//    }];
//    
//}
@end