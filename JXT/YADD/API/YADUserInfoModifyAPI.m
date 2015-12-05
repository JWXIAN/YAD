//
//  YADUserInfoModifyAPI.m
//  JXT
//
//  Created by JWX on 15/12/5.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADUserInfoModifyAPI.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JsonPaser.h"
#import "ChangePassword.h"

@implementation YADUserInfoModifyAPI

#pragma mark - 修改密码
+ (void)updateAccountPassWord:(NSArray *)arrInfo result:(callBack)result{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accountID =[ud objectForKey:@"accountID"];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    //    NSString *newPassword = [ud objectForKey:@"currentPassword"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=updateMima&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><accountId>%@</accountId><oldpassWord>%@</oldpassWord><newpassWord>%@</newpassWord><methodName>updateMima</methodName></MAP_TO_XML>",schoolID,accountID,arrInfo[0],arrInfo[2]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        ChangePassword *changePassword = [JsonPaser parserChangePasswordByDictionary:dic];
        result(changePassword);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
    }];
}

@end
