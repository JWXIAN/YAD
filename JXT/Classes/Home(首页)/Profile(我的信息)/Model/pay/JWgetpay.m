//
//  JWgetpay.m
//  JXT
//
//  Created by 1039soft on 15/7/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWgetpay.h"
#import "AFNetworking.h"
#import "JWpriceModel.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "JWWeChatHeadModel.h"
#import "JWWeChatModel.h"

@implementation JWgetpay
#pragma mark 获取支付清单
+(void)requestClassandPrice:(NSString *)schoolID andCallback:(MyCallback)callback
{
      NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_getdanjia&parms=pid=1",schoolID];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWpriceModel *examSchedule = [JWpriceModel parserStuLoginByDictionary:dic];
        callback(examSchedule);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];

}

/**获取微信支付信息*/
+(void)requestWeChatkey:(NSString *)schoolID andCallback:(MyCallback)callback
{
    
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=getzfinfo&jxid=%@&type=wx",schoolID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWWeChatHeadModel *head = [JWWeChatHeadModel objectWithKeyValues:dic];
        callback(head);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



//获取支付宝key
+(void)requestpaykey:(NSString *)schoolID andCallback:(MyCallback)callback
{
    
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_payeeInfo&parms=pid=1",schoolID];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWpriceModel *examSchedule = [JWpriceModel parserStuLoginByDictionary:dic];
        callback(examSchedule);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//获取是否可以支付
+(void)requestpayissuccess:(NSString *)schoolID andCallback:(MyCallback)callback
{
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_yanzhengpay&parms=leixing=0",schoolID];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWpriceModel *examSchedule = [JWpriceModel parserStuLoginByDictionary:dic];
        callback(examSchedule);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//支付成功后上传信息
+(void)postpayinfo:(NSString *)schoolID info:(NSDictionary*)info andCallback:(MyCallback)callback
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    
    NSString* ss=[NSString stringWithFormat:@"danjia=%@|keshi=%@|zongjia=%@|kemu=%@|dingdanhao=%@stuid=%@",info[@"danjia"],info[@"keshi"],info[@"zongjia"],info[@"kemu"],info[@"dingdanhao"],[user objectForKey:@"per_id"]];
    
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?"];
    
   
    NSDictionary* dd=@{@"methodName":@"self",@"SCHOOL_ID":schoolID,@"prc":@"prc_app_addmoneysecuss",@"parms":ss};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dd success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWpriceModel *examSchedule = [JWpriceModel parserStuLoginByDictionary:dic];
        callback(examSchedule);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
@end
