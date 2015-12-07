//
//  YADHomeAPI.m
//  JXT
//
//  Created by JWX on 15/12/7.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADHomeAPI.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation YADHomeAPI

#pragma mark - 获取首页轮播图片
+ (void)getHomeScrollImage:(callDicBack)result{
//    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
//    NSString* school_id=[ud objectForKey:@"drivecode"];
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=67779&prc=prc_app_lunbotu&parms=id=0"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        result(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

@end
