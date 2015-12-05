//
//  NetInfoGet.m
//  JXT
//
//  Created by 1039soft on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "NetInfoGet.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation NetInfoGet
+(void)getCodeInfoAndCallback:(MyCallback)callback
{
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=mnks&prc=prc_app_getversion&parms=jxid=0001"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
    }];

}
+(void)getDataList:(NSString* )carType callback:(MyCallback)callback
{
    
    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?";
    NSString* temp=[NSString stringWithFormat:@"cx=%@",carType];
    temp=[temp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic=@{@"methodName":@"mnks",@"prc":@"prc_app_getquestion",@"parms":temp};
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
    }];

}
+(void)getWishListAndCallBack:(MyCallback)callback
{
    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=mnks&prc=prc_app_getxylist&parms=count=100";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
    }];
}
+(void)givewWishPowerWithStuID:(NSString* )stuID callBack:(MyCallback)callback
{
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=mnks&prc=prc_app_zan&parms=xyid=%@",stuID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
    }];
}
+(void)sendWishWithMessage:(NSString* )message callBack:(MyCallback)callback
{
    NSString* IDcard = [[NSUserDefaults standardUserDefaults] objectForKey:@"per_idcardno"];
    NSString* StuName = [[NSUserDefaults standardUserDefaults] objectForKey:@"_studentLogin.per_name"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?"];//姓名 身份证号  内容
    NSString* path2 = [NSString stringWithFormat:@"name=%@%%7Cuserid=%@%%7Ccontent=%@",StuName,IDcard,message];
    path2= [path2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = @{@"methodName":@"mnks",@"prc":@"prc_app_xuyuan",@"parms":path2};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
  
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求网络失败"];
        
    }];
}

@end
