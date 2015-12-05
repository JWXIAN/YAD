//
//  AppDelegate.m
//  JXT
//
//  Created by 李莉 on 15/6/19.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "AppDelegate.h"
#import "JWTarBarController.h"
#import "JWDLTVController.h"
#import "JWDLTVController.h"
#import "JWDLTVController.h"
#import "JWLoginController.h"
//推送
#import "APService.h"
//友盟统计
#import "MobClick.h"
#import "MobClickSocialAnalytics.h"

//分享
#import <ShareSDK/ShareSDK.h>
//新浪微博SDK头文件
#import "WeiboSDK.h"
//微信SDK头文件
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//支付
#import <AlipaySDK/AlipaySDK.h>

#import "JWNewfeatureVC.h"

#import "LeftSortsViewController.h"


#import "PrefixHeader.pch"

//数据库读写
#import "NSObject+BaseModelCommon.h"
#import "MJProperty.h"
#import "MJType.h"
#import "FBShimmeringView.h"
#import "exam.h"

//JS
#import "JPEngine.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

#import "JWMyNewsTV.h"

#import "UserDefaultsKey.h"

#import <BaiduMapAPI_Base/BMKMapManager.h>

//开放平台key
#import "OpenPlatformKey.h"
//崩溃日志

@interface AppDelegate ()
//判断是否点击推送消息
@property (nonatomic) BOOL isLaunchedByNotification;

@property(strong,nonatomic) BMKMapManager *mapManager;
@end

@implementation AppDelegate

/*  开启JSPatch并且下载与版本匹配的JS文件.
 *  文件存放在赵东勇使用的静态文件路径下/iOSJS/下
 *  文件名格式为：ios-version.js，例如ios-2.1.1.js
 */
- (void)startJPEngine
{
   
    // JSPatch动态补丁
    [JPEngine startEngine];
    
    const NSString *fileName = @"JSPatch-";

    // 服务端存放路径
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* versionJS = [NSString stringWithFormat:@"/**%@*/",version];
    NSString *url =@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=iosupdateYAD";
    
    // 沙盒存放路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@%@.js", fileName, version];
    
    // 存放入沙盒的blcok
    void (^saveAndEvaluateBlock)(NSString *) = ^(NSString *script) {

        if ( [script hasPrefix:versionJS]) {
            NSError* error;
         
            [script writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [JPEngine evaluateScript:script];
        }
    };
    
    // 从沙盒读取的blcok
    void (^fetchAndEvaluateBlcok)() = ^() {
        
        NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if ( [script hasPrefix:versionJS] ) {
            
            [JPEngine evaluateScript:script];
        }
    };
    
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if   (netStatus != AFNetworkReachabilityStatusNotReachable)  {
        
        // 下载JS文件
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   
                                   if ( connectionError ) {
                                       fetchAndEvaluateBlcok();
                                       
                                   } else {
                                       NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       if (script && script.length > 0 ) {
                                           saveAndEvaluateBlock(script);
                                       } else {
                                           fetchAndEvaluateBlcok();
                                       }
                                   }
                               }];
    } else {
        fetchAndEvaluateBlcok();
    }
}

/**友盟统计*/
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    /**友盟统计*/
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
   
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
//    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [self startJPEngine];
    
    //百度地图
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图验证失败");
    }
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
#pragma mark - 版本新特性
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        // 2.设置根控制器
        NSUserDefaults *usus=[NSUserDefaults standardUserDefaults];
//        {
//            if ([usus boolForKey:@"issuccess"])
//             {
//                 JWTarBarController* tabbar= [[JWTarBarController alloc] init];
//                 self.window.rootViewController = tabbar;
//               [usus setBool:NO forKey:@"shouci"];
//
//            }
//            else
//            {
//                JWLoginController* login = [[JWLoginController alloc] init];
//                self.window.rootViewController =login;
//                [usus setBool:NO forKey:@"shouci"];
//            }
//        }
        JWTarBarController* tabbar= [[JWTarBarController alloc] init];
        self.window.rootViewController = tabbar;
        [usus setBool:NO forKey:@"shouci"];
    } else { // 这次打开的版本和上一次不一样，显示新特性
     
        
        JWNewfeatureVC* newf = [[JWNewfeatureVC alloc] init];
        NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
        [user setBool:YES forKey:@"shouci"];
        [user synchronize];

        self.window.rootViewController = newf;
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     [APService clearAllLocalNotifications];//清楚本地通知
    
    //保存是否已经登录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user boolForKey:UserIsaAlreadyLogin_Bool]!=YES) {
        [user setBool:NO forKey:UserIsaAlreadyLogin_Bool];
        [user synchronize];
    }
         
    /**友盟统计*/
    [self umengTrack];
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
#pragma mark - 微信支付
    BOOL isok = [WXApi registerApp:@"wxc1452ee4722071a5"];
    if (isok) {
        NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }

#pragma mark - 分享
    [self shareSDK];
    
#pragma mark - 推送
    [APService clearAllLocalNotifications];
    NSString *ismessage= [user objectForKey:@"message"];
    if (![ismessage isEqualToString:@"SWITCH_NO"]) {

        // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
        // Required
        [APService setupWithOption:launchOptions];
        
    }
    //接收未启动app时的推送消息
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary *aps = [remoteNotification valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
 
    if(content != nil){
        //存时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [formatter stringFromDate:[NSDate date]];
        
        //保存推送消息到plist文件
        [JWMyNewsTV setNews:content newsDate:date newsType:@"推送消息"];
        _isLaunchedByNotification = YES;
    }else{
        _isLaunchedByNotification = NO;
    }
    
    //    [教练关注提醒]您关注的教练 [张三(1001)] 有空余时段可约了！
    
    if ([content containsString:@"教练关注提醒"]) {
        JWTarBarController* tabbar= [[JWTarBarController alloc] init];
        tabbar.selectedIndex=1;
//        _navi=[[JWNavController alloc]initWithRootViewController:tabbar];
//        _navi.navigationBarHidden=YES;
//        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
//        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:_navi];
        self.window.rootViewController = tabbar;
    }
    
    return YES;
}

#pragma mark - 分享
- (void)shareSDK{
        //分享
        //[ShareSDK registerApp:ShareSDKAppKey];//字符串api20为您的ShareSDK的AppKey
        //微博
        [ShareSDK connectSinaWeiboWithAppKey:@"113741987"
                                   appSecret:@"014c957f764d3a067f3f847a0d311e7e"
                                 redirectUri:@"http://www.sharesdk.cn"];
        //添加腾讯微博应用 注册网址 http://dev.t.qq.com
        [ShareSDK connectTencentWeiboWithAppKey:@"1104314312"
                                      appSecret:@"PKmjjbU4iqhJpIRb"
                                    redirectUri:@"http://www.sharesdk.cn"
                                       wbApiCls:[WeiboSDK class]];
    
        //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
        [ShareSDK connectQZoneWithAppKey:@"1104314312"
                               appSecret:@"PKmjjbU4iqhJpIRb"
                       qqApiInterfaceCls:[QQApiInterface class]
                         tencentOAuthCls:[TencentOAuth class]];
    
        //添加QQ应用  注册网址  http://mobile.qq.com/api/
        [ShareSDK connectQQWithQZoneAppKey:@"1104314312"
                         qqApiInterfaceCls:[QQApiInterface class]
                           tencentOAuthCls:[TencentOAuth class]];
    
        //添加微信应用  http://open.weixin.qq.com
        [ShareSDK connectWeChatWithAppId:@"wxc1452ee4722071a5"
                               appSecret:@"21e42b052001cc3d04803b4e481c04be"
                               wechatCls:[WXApi class]];
    
        //连接短信分享
        [ShareSDK connectSMS];
        //连接邮件
        [ShareSDK connectMail];
        //连接打印
        [ShareSDK connectAirPrint];
        //连接拷贝
        [ShareSDK connectCopy];
}

#pragma mark - 微信支付
-(void)onReq:(BaseReq *)req{
}

#pragma mark - 微信支付返回
- (void)onResp:(BaseResp *)resp{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    BOOL payInfo = NO;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                //成功代码:0
                if([[ud objectForKey:@"wzPayType"] isEqualToString:@"payBJFY"]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatPayBJFYMsg" object:@"支付成功"];
                    payInfo = YES;
                }else if ([[ud objectForKey:@"wzPayType"] isEqualToString:@"payGMXS"]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatPayGMXSMsg" object:@"支付成功"];
                }
                strMsg = @"支付成功!";
                //                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeCommon:
                //错误代码:-1  签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                NSLog(@"支付失败! ");
                break;
            case WXErrCodeUserCancel:
                //错误代码:-2 用户点击取消并返回
                strMsg = @"取消支付";
                //                NSLog(@"用户取消－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeSentFail:
                //发送失败
                strMsg = @"发送失败";
                break;
            case WXErrCodeUnsupport:
                //微信不支持
                strMsg = @"微信不支持";
                break;
            case WXErrCodeAuthDeny:
                //授权失败
                strMsg = @"授权失败";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    if(payInfo == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

#pragma mark 运行时消息推送UMLOG
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    // Required
    [APService handleRemoteNotification:userInfo];
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSLog(@"运行时消息推送UMLOG------%@", content);
    if(content != nil){
        //存时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [formatter stringFromDate:[NSDate date]];
        
        //保存推送消息到plist文件
        [JWMyNewsTV setNews:content newsDate:date newsType:@"推送消息"];
    }
    if ([content containsString:@"教练关注提醒"]) {
        JWTarBarController* tabbar= [[JWTarBarController alloc] init];
        tabbar.selectedIndex=1;
        self.window.rootViewController =tabbar;
       
    }
    
}
#pragma mark 消息推送  Remote Notification 特性
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler//后台消息推送
{
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
    NSString *str=[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]];
    NSLog(@"消息推送------%@", str);
    if(str!=nil){
        //存时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [formatter stringFromDate:[NSDate date]];
        
        //保存推送消息到plist文件
        [JWMyNewsTV setNews:str newsDate:date newsType:@"通知消息"];
    }
    
    NSDate *now=[NSDate date];
    NSTimeInterval secondsPerDay1 = 1;
    NSDate *yesterDay = [now dateByAddingTimeInterval:secondsPerDay1];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [APService setLocalNotification:yesterDay alertBody:str badge:-1 alertAction:nil identifierKey:nil userInfo:nil soundName:nil region:nil regionTriggersOnce:nil category:nil];
    }
    else {
        [APService setLocalNotification:yesterDay alertBody:str badge:-1 alertAction:nil identifierKey:nil userInfo:nil soundName:nil];
        
    }
#else
    [APService setLocalNotification:yesterDay alertBody:str badge:-1 alertAction:nil identifierKey:nil userInfo:nil soundName:nil];
#endif
    completionHandler(UIBackgroundFetchResultNewData);
    
    //点击推送消息
    if(!_isLaunchedByNotification){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMyNewVC" object:nil];
    }
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
   
    NSString *strURL = [url absoluteString];
    //微信支付
    if([strURL hasPrefix:@"wxc1452ee4722071a5"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return nil;
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
        }];
    }
    
    //微信支付
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        return nil;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
#pragma mark - 后台进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self jsStart];
//     [self startJPEngine];
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService clearAllLocalNotifications];//清楚本地通知
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
