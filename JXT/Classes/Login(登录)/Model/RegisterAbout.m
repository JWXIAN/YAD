//
//  RegisterAbout.m
//  JXT
//
//  Created by 1039soft on 15/8/4.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "RegisterAbout.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation RegisterAbout
//获取注册车型
+(void)GetCarCallback:(MyCallback)callback
{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString* school_id=[ud objectForKey:@"drivecode"];
    
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_getcxlist&parms=p=1",school_id];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
    }];

}
//添加注册
+(void)PostRegisterInfo:(NSDictionary*)info view:(UIView*)view Callback:(MyCallback)callback
{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString* school_id=[ud objectForKey:@"drivecode"];
    
    NSString *path =@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self";
    NSString* path_tail=[NSString stringWithFormat:@"name=%@|mobile=%@|sfz=%@|remark=%@|cx=%@",info[@"name"],info[@"mobile"],info[@"IDcard"], info[@"bmly"], info[@"category"]];
    path_tail=[path_tail stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic=@{@"SCHOOL_ID":school_id,@"prc":@"prc_jxt_outregister",@"parms":path_tail};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        view.userInteractionEnabled=YES;
        [MBProgressHUD showError:@"请求网络失败"];
    }];
    

}
@end
