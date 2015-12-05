//
//  JWgetcommend.m
//  JXT
//
//  Created by 1039soft on 15/7/8.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWgetcommend.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation JWgetcommend
//获取赞
+(void)getcommend:(NSString* )teacherID andCallback:(MyCallback)callback
{
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx"];
    
//    http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=00012&prc=prc_app_getjxzan&parms=teacherid=1001|stuid=130104198810121215
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* str=[user objectForKey:@"drivecode"];
    NSString* str2=[user objectForKey:@"per_idcardno"];
    NSString* tea=[NSString stringWithFormat:@"teacherid=%@|stuid=%@",teacherID,str2];
    NSDictionary* dic=@{@"methodName":@"self",@"SCHOOL_ID":str,@"prc":@"prc_app_getjxzan",@"parms":tea};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
       
        
    }];
 
}
//点赞
+(void)postcommend:(NSDictionary* )teacherinfo andCallback:(MyCallback)callback
{

    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx"];
    
    //    http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=00012&prc=prc_app_getjxzan&parms=teacherid=1001|stuid=130104198810121215|ztype=1
    NSUserDefaults* user2=[NSUserDefaults standardUserDefaults];
    NSString* str=[user2 objectForKey:@"drivecode"];
    NSString* str2=[user2 objectForKey:@"per_idcardno"];
    NSString* tea=[NSString stringWithFormat:@"teacherid=%@|stuid=%@|ztype=%@",teacherinfo[@"teacherID"],str2,teacherinfo[@"ztype"]];
    NSDictionary* dic=@{@"methodName":@"self",@"SCHOOL_ID":str,@"prc":@"prc_app_addzan",@"parms":tea};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
        
    }];


}

//获取评价列表
+(void)showappraise:(NSString*)teachercode view:(id)view  andCallback:(MyCallback)callback
{
    //    http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTrainPingjialist&SCHOOL_ID=49264&train_id=0181
    NSUserDefaults* user2=[NSUserDefaults standardUserDefaults];
    NSString* schoolID=[user2 objectForKey:@"drivecode"];
    NSString* path=[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTrainPingjialist&SCHOOL_ID=%@&train_id=%@",schoolID,teachercode];
   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view];
        [MBProgressHUD showError:@"加载数据失败"];
        
    }];
}
//关注
+(void)attention:(NSString* )teachercode andCallback:(MyCallback)callback
{
    NSUserDefaults* user2=[NSUserDefaults standardUserDefaults];
    NSString* schoolID=[user2 objectForKey:@"drivecode"];
    NSString* stuID=[user2 objectForKey:@"per_id"];

    NSString *path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_guanzhu",schoolID];

    NSString* tea=[NSString stringWithFormat:@"stuid=%@|jlyid=%@",stuID,teachercode];

    NSDictionary* dic=@{@"parms":tea};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic2);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
     
    }];

   
}
//取消关注
+(void)unattention:(NSString* )teachercode andCallback:(MyCallback)callback
{
    NSUserDefaults* user2=[NSUserDefaults standardUserDefaults];
    NSString* schoolID=[user2 objectForKey:@"drivecode"];
    NSString* stuID=[user2 objectForKey:@"per_id"];
    
    NSString *path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_guanzhu",schoolID];
    
    NSString* tea=[NSString stringWithFormat:@"stuid=%@|jlyid=%@",stuID,teachercode];
    
    NSDictionary* dic=@{@"parms":tea};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
        
    }];

}
@end
