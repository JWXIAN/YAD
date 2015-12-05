//
//  JJPickUpInfoAPI.m
//  JXT
//
//  Created by JWX on 15/12/3.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JJPickUpInfoAPI.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation JJPickUpInfoAPI

#pragma mark - 获取预约接送信息
+ (void)getPickUpInfo:(callBack)result{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud objectForKey:@"train_learnid"]
    NSString* path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_getyyjslist&parms=stuid=%@", [ud objectForKey:@"drivecode"], [ud objectForKey:@"train_learnid"]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        result(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

#pragma mark - 取消预约接送
+ (void)cancelPickUpInfo:(NSString *)pickID callback:(callBack)result{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud objectForKey:@"train_learnid"]
    NSString* path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_qxjs&parms=id=%@", [ud objectForKey:@"drivecode"], pickID];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        result(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

#pragma mark - 保存预约
+ (void)savePickUpInfo:(NSDictionary *)pickInfo callback:(callBack)result{
    
    NSString* path = [NSString stringWithFormat:@"xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_yyjs&parms=stuid=%@|mobile=%@|jstime=%@|jsadd=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"drivecode"] ,[[NSUserDefaults standardUserDefaults] objectForKey:@"train_learnid"] ,pickInfo[@"pickUpPhone"], pickInfo[@"pickUpMakeTime"], pickInfo[@"pickUpAdd"]];
    NSLog(@"%@", path);
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
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
