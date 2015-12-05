//
//  JWgetappointment.m
//  JXT
//
//  Created by 1039soft on 15/7/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWgetappointment.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
@implementation JWgetappointment
//预约验证
+(void)Verificationappointment:(NSDictionary* )userinfo andCallback:(MyCallback)callback
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* schid=[user objectForKey:@"drivecode"];//驾校ID
    NSString* perid=[user objectForKey:@"per_id"];
    NSString* path;
    if (userinfo.count>2) {
        path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=CheckTimeIsOrNo&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><stuid>%@</stuid><kemu>%@</kemu><shiduan>%@</shiduan><carid>%@</carid><methodName>CheckTimeIsOrNo</methodName></MAP_TO_XML>",schid,perid,userinfo[@"kemu"],userinfo[@"shiduan"],userinfo[@"carid"]];
       
        path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
        path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
        path=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//                    JWExamScheduleInfo *examSchedule = [JsonPaser parserExamScheduleByDictionary:dic];
             
                    callback(dic);

    }
    
    
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
}
}
//保存预约
+(void)saveappointment:(NSDictionary* )userinfo andCallback:(MyCallback)callback
{
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* schid=[user objectForKey:@"drivecode"];//驾校ID
    NSString* y_lea=[user objectForKey:@"train_learnid"];    NSString* path;
    if (userinfo.count>2) {
#warning mark ordercode字段意义不详。传nil失败，随便传值可以成功
        path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?"];
        
        NSString* path2=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><yue_ddate>%@</yue_ddate><yue_t>%@</yue_t><yue_car>%@</yue_car><yue_learnno>%@</yue_learnno><yue_type>%@</yue_type><yue_today>%@</yue_today><ordercode>1</ordercode><remark>app预约</remark><teacher>%@</teacher><tearcharID>%@</tearcharID><methodName>SaveYueInfo</methodName></MAP_TO_XML>",schid,userinfo[@"yue_ddate"],userinfo[@"yue_t"],userinfo[@"carid"],y_lea,userinfo[@"yue_type"],userinfo[@"yue_today"],userinfo[@"teacher"],userinfo[@"tearcharID"]];
        path2 =[path2 stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
        path2 =[path2 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        path2 =[path2 stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        path2 =[path2 stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
        
        NSLog(@"%@",path2);
        NSDictionary* catch=@{@"methodName":@"SaveYueInfo",@"xmlStr":path2};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:path parameters:catch success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
           
                callback(dic);
            
        }
         
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //        [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"加载数据失败"];
             }];
    }

}
+(void)getWeatherInfoAndCallBack:(MyCallback)callback
{
    
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* schid=[user objectForKey:@"nowCityName"];//当前城市
   
    
    NSString* path =[NSString stringWithFormat:@"https://api.heweather.com/x3/weather?city=%@&key=0bd5c8f732e74629892fc32f9c214e45",schid];

        path=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            //                    JWExamScheduleInfo *examSchedule = [JsonPaser parserExamScheduleByDictionary:dic];
          
            callback(dic);
            
        }
         
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //        [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"加载数据失败"];
             }];
    

}
+ (void)getLeisureWithDay:(NSString*)day time:(NSString*)time Callback:(MyCallback)callback
{
    
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString *schoolID=[user objectForKey:@"drivecode"];//驾校ID
    NSString *perID=[user objectForKey:@"per_id"];
    
    NSString* path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_app_getfreetime&parms=stuid=%@%%7Cdate=%@%%7Ctime=%@",schoolID,perID,day,time];
    
    path=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path=[path stringByReplacingOccurrencesOfString:@"%257C" withString:@"%7C"];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //                    JWExamScheduleInfo *examSchedule = [JsonPaser parserExamScheduleByDictionary:dic];
        
        callback(dic);
        
    }
     
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"加载数据失败"];
         }];
    

}

@end
