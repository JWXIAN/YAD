//
//  YADLoginAPI.m
//  JXT
//
//  Created by JWX on 15/12/4.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADLoginAPI.h"
#import "JWLoginModel.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JsonPaser.h"

@implementation YADLoginAPI

#pragma mark - 登录验证
+ (void)getUserLoginWithAccountPassWord:(NSDictionary *)loginInfo callback:(callBack)result{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=studentLogin&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><accountId>%@</accountId><passWord>%@</passWord><methodName>studentLogin</methodName></MAP_TO_XML>", schoolID, loginInfo[@"loginAccount"], loginInfo[@"loginPassWord"]];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWLoginModel *stuLogin = [JsonPaser parserStuLoginByDictionary:dic];
        result(stuLogin);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

#pragma mark - 获取注册车型选择
+ (void)getRegisterCarType:(callDicBack)result{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString* school_id=[ud objectForKey:@"drivecode"];
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_getcxlist&parms=p=1",school_id];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        result(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
    
}

#pragma mark - 注册
+ (void)postRegisterInfo:(NSArray *)info carType:(NSString *)carType Callback:(callDicBack)callback{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString* school_id=[ud objectForKey:@"drivecode"];
    
    NSString *path =@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self";
    NSString* path_tail=[NSString stringWithFormat:@"name=%@|mobile=%@|sfz=%@|remark=%@|cx=%@",info[0],info[1],info[2], info[3], carType];
    path_tail=[path_tail stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic=@{@"SCHOOL_ID":school_id,@"prc":@"prc_jxt_outregister",@"parms":path_tail};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

@end
