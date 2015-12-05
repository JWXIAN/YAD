//
//  JWOrderTY.m
//  JXT
//
//  Created by JWX on 15/7/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWOrderTY.h"
#import "MBProgressHUD+MJ.h"
#import "JsonPaser.h"
#import "JiaxiaotongAPI.h"
#import "AFNetworking.h"
#import "PrefixHeader.pch"


@interface JWOrderTY ()

@end

@implementation JWOrderTY

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lbCH.text = self.ch;
    self.lbDate.text = self.date;
    self.lbJL.text = self.jl;
    self.lbHour.text = self.hour;
    self.lbKM.text = self.km;
    self.lbId.text = self.lbid;
    self.lbSchoolId.text = self.scid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTY:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"退约确认" message:@"确定要退约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else
    {
        [MBProgressHUD showMessage:@"退约中..."];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString* uid=[ud objectForKey:@"train_learnid"];//accountID
        NSString* schoolID=[ud objectForKey:@"drivecode"];
        NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=Tuiyue&schoolId=%@&yuyueID=%@&stucode=%@&ddate=%@",schoolID, self.lbid,uid, self.date];
        
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
        path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
        path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
        NSLog(@"%@",path);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        
        [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
                [MBProgressHUD hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"退约成功"];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"退约失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络繁忙"];
        }];
        
        
    }
}



@end
