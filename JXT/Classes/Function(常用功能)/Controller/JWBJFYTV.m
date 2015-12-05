//
//  JWBJFYTV.m
//  JXT
//
//  Created by JWX on 15/10/12.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWBJFYTV.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+MJExtension.h"
#include "PrefixHeader.pch"
#import "JWBJFYCell.h"
#import "RJBlurAlertView.h"
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
#import "WXApi.h"
#import "JWgetpay.h"
#import "JWWeChatHeadModel.h"

/**微信支付API*/
#import "JWWeChatPayAPI.h"
/**支付宝API*/
#import "JWAliPayAPI.h"

@interface JWBJFYTV ()
/**缴费信息*/
@property (nonatomic, strong) NSArray *arrData;
///**支付信息*/
//@property (nonatomic, strong) NSMutableArray *btnPayCell;
/**支付平台*/
@property (nonatomic, strong) NSString *payType;

/**自定义底部菜单弹出View*/
@property (nonatomic, strong) UIView *btnViewOne;
@property (nonatomic, strong) UIView *btnViewTwo;

@end

@implementation JWBJFYTV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JWColor(245, 245, 245);
    self.tableView.rowHeight = 83;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    /**支付类型*/
//    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//    NSLog(@"%@", [ud objectForKey:@"wzPayType"]);
    
    [MBProgressHUD showMessage:@"正在请求补缴费用信息"];
    [self loadData:@"请求补缴费用" payType:@""];
    
    /**微信支付成功通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeChatPayBJFYMsg:) name:@"WeChatPayBJFYMsg" object:nil];
    
    /**支付宝支付成功通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayBJFYSuccess:) name:@"AliPayBJFYSuccess" object:nil];
    
    /**cell点击补缴btn通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payBtnIndex:) name:@"payBtnIndex" object:nil];
}

/**微信支付成功通知*/
- (void)WeChatPayBJFYMsg:(NSNotification *)nc{
    if([nc.object isEqualToString:@"支付成功"]){
        [MBProgressHUD showMessage:@"正在确定支付情况"];
        [self loadData:@"支付成功" payType:@"WX"];
    }
}

/**支付宝成功通知*/
- (void)AliPayBJFYSuccess:(NSNotification *)nc{
    //nc.object  -- 支付成功
    if([nc.object isEqualToString:@"支付成功"]){
        [MBProgressHUD showMessage:@"正在确定支付情况"];
        [self loadData:@"支付成功" payType:@"ZFB"];
    }
}

/**点击缴费Btn*/
- (void)payBtnIndex:(NSNotification *)nc{
    //加载支付方式
    [self loadPayDown];
    /**支付类型*/
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    //存支付方式
    [ud setObject:@"payBJFY" forKey:@"wzPayType"];
    //nc.object 点击按钮行
    [ud setObject:nc.object forKey:@"payCellIndexRow"];
    
//    /**支付类型*/
//    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//    [ud setObject:@"payBJFY" forKey:@"wzPayType"];
//    NSLog(@"-------%@", nc.object);
//    NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:0 inSection:[nc.object integerValue]];
//    JWBJFYCell *cell = (JWBJFYCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
//    
//    NSString *strtxt = [NSString stringWithFormat:@"\n补缴类型: %@\n补缴金额: %@\n欠费时间: %@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text];
//    
//    RJBlurAlertView *alertView = [[RJBlurAlertView alloc] initWithTitle:@"补缴信息" text:strtxt cancelButton:YES];
//    
//    alertView.backgroundColor = [UIColor whiteColor];
//    [alertView.okButton setTitle:@"使用支付宝补缴" forState:UIControlStateNormal];
//    [alertView.cancelButton setTitle:@"使用微信支付补缴" forState:UIControlStateNormal];
//    [alertView.cancelButton setBackgroundColor:[UIColor redColor]];
//    [alertView setCompletionBlock:^(RJBlurAlertView *alert, UIButton *button) {
//        //存补缴信息
//        NSString *str_sf_type = [[_arrData objectAtIndex:[nc.object integerValue]] valueForKey:@"p_sf_type"];
//        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//        [ud setObject:cell.lblPXF.text forKey:@"lblPXF"];
//        [ud setObject:cell.lblBJJE.text forKey:@"lblBJJE"];
//        [ud setObject:cell.lblDate.text forKey:@"lblDate"];
//        [ud setObject:str_sf_type forKey:@"sfType"];
//        
//        if (button == alert.okButton) {
//            [MBProgressHUD showMessage:@"正在支付..."];
//#pragma mark - 支付宝支付API
////            NSString *money = @"0.01";
//            ////支付宝交易价格1表示1元
//            NSString *money = [NSString stringWithFormat:@"%.2f", [cell.lblBJJE.text floatValue]];
//            [JWAliPayAPI AliPayAPI:@"补缴费用" payDescribe:[NSString stringWithFormat:@"补缴类型:%@ 金额:%@ 欠费时间:%@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text] payMoney:money];
//        }else{
//            [MBProgressHUD showMessage:@"正在支付..."];
//#pragma mark - 微信支付API
//            //微信交易价格1表示0.01元，10表示0.1元
//            NSInteger money = [cell.lblBJJE.text floatValue]*100;
////            NSInteger money = 1;
//            [JWWeChatPayAPI WeChatPayAPI:[NSString stringWithFormat:@"补缴类型:%@ 金额:%@ 欠费时间:%@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text] payMoney:[NSString stringWithFormat:@"%ld", money]];
//        }
//    }];
//    
//    [alertView show];
}
/**支付方式*/
- (void)loadPayDown{
    //遮盖View
    _btnViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h-210)];
    _btnViewOne.backgroundColor = [UIColor blackColor];
    _btnViewOne.alpha = 0.5;
    [self.view addSubview:_btnViewOne];
    
    //白色View
    _btnViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnViewOne.frame), self.view.mj_w, 150)];
    _btnViewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_btnViewTwo];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _btnViewTwo.mj_w, 30)];
    lblTitle.text = @"请选择支付方式";
    lblTitle.font = [UIFont fontWithName:@"PingFangSC-Thin" size:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    //    <color key="NSColor" cocoaTouchSystemColor="darkTextColor"/>
    //    <font key="NSFont" size="20" name="PingFangSC-Thin"/>
    
    [_btnViewTwo addSubview:lblTitle];
    
    //添加微信 View按钮
    UIButton *btnWeChatPay = [[UIButton alloc] initWithFrame:CGRectMake(0, 43, _btnViewTwo.mj_w, 44)];
    [btnWeChatPay setTitle:@"微信支付" forState:UIControlStateNormal];
    [btnWeChatPay setBackgroundColor:JWColor(110, 204, 120)];
    [btnWeChatPay addTarget:self action:@selector(btnWeChatPayClick) forControlEvents:UIControlEventTouchUpInside];
    btnWeChatPay.titleLabel.font = [UIFont systemFontOfSize:20];
    [_btnViewTwo addSubview:btnWeChatPay];
    
    //添加支付宝 View按钮
    UIButton *btnAliPay = [[UIButton alloc] initWithFrame:CGRectMake(0, 95, _btnViewTwo.mj_w, 44)];
    [btnAliPay setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btnAliPay setBackgroundColor:JWColor(50, 180, 248)];
    [btnAliPay addTarget:self action:@selector(btnAliPayClick) forControlEvents:UIControlEventTouchUpInside];
    btnAliPay.titleLabel.font = [UIFont systemFontOfSize:20];
    [_btnViewTwo addSubview:btnAliPay];
}
/**微信支付btn*/
- (void)btnWeChatPayClick{
    [self pay:@"微信支付"];
}
/**支付宝支付btn*/
- (void)btnAliPayClick{
    [self pay:@"支付宝"];
}
/**支付API*/
- (void)pay:(NSString *)payInfo{
    /**支付类型*/
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSInteger cellRow = [[ud objectForKey:@"payCellIndexRow"] integerValue];
    
    NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:0 inSection:cellRow];
    JWBJFYCell *cell = (JWBJFYCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
    
//    NSString *strtxt = [NSString stringWithFormat:@"\n补缴类型: %@\n补缴金额: %@\n欠费时间: %@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text];
    //存补缴信息
    NSString *str_sf_type = [[_arrData objectAtIndex:cellRow] valueForKey:@"p_sf_type"];
    [ud setObject:cell.lblPXF.text forKey:@"lblPXF"];
    [ud setObject:cell.lblBJJE.text forKey:@"lblBJJE"];
    [ud setObject:cell.lblDate.text forKey:@"lblDate"];
    [ud setObject:str_sf_type forKey:@"sfType"];
    
    if ([payInfo isEqualToString:@"支付宝"]) {
        [MBProgressHUD showMessage:@"正在支付..."];
#pragma mark - 支付宝支付API
        //            NSString *money = @"0.01";
        ////支付宝交易价格1表示1元
        NSString *money = [NSString stringWithFormat:@"%.2f", [cell.lblBJJE.text floatValue]];
        [JWAliPayAPI AliPayAPI:@"补缴费用" payDescribe:[NSString stringWithFormat:@"补缴类型:%@ 金额:%@ 欠费时间:%@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text] payMoney:money];
    }else if([payInfo isEqualToString:@"微信支付"]){
        [MBProgressHUD showMessage:@"正在支付..."];
#pragma mark - 微信支付API
        //微信交易价格1表示0.01元，10表示0.1元
        NSInteger money = [cell.lblBJJE.text floatValue]*100;
        //            NSInteger money = 1;
        [JWWeChatPayAPI WeChatPayAPI:[NSString stringWithFormat:@"补缴类型:%@ 金额:%@ 欠费时间:%@", cell.lblPXF.text, cell.lblBJJE.text, cell.lblDate.text] payMoney:[NSString stringWithFormat:@"%ld", money]];
    }
    [_btnViewOne removeFromSuperview];
    [_btnViewTwo removeFromSuperview];
}
/**请求补缴费用详情*/
- (void)loadData:(NSString *)strType payType:(NSString *)payType{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *strXH = [ud objectForKey:@"person_id"];
    NSString *path;
    if ([strType isEqualToString:@"请求补缴费用"]) {
        path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=prc_getStuQKList&parms=stuId=%@",school_id, strXH];
    }else if([strType isEqualToString:@"支付成功"]){
        /**
         money：支付金额
         zftype:支付费用（费用代码_支付方式）
         1039-杨成虎  10:19:59
         支付方式：wx:微信，zfb:支付宝，yl：银联
         */
        
        path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=self&SCHOOL_ID=%@&prc=proc_BuJiaoFY&parms=stuId=%@|money=%@|zftype=%@_%@",school_id, strXH, [ud objectForKey:@"lblBJJE"], [ud objectForKey:@"sfType"], payType];
        NSLog(@"path%@", path);
    }
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    //    NSLog(@"%@",path);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            if([strType isEqualToString:@"请求补缴费用"]){
//                _arrData = [dic valueForKey:@"body"];
                _arrData = @[@{@"stu_id":@"0113060495", @"p_sf_type":@"FY001",@"typename":@"培训费", @"p_date":@"2013-6-27 14:59:11", @"p_money":@"0.00"},@{@"stu_id":@"0113060495", @"p_sf_type":@"FY001",@"typename":@"科一补考费", @"p_date":@"2013-6-27 14:59:11", @"p_money":@"173.00"}, @{@"stu_id":@"0113060495", @"p_sf_type":@"FY001",@"typename":@"培训费", @"p_date":@"2013-6-27 14:59:11", @"p_money":@"0.00"}];
                [self.tableView reloadData];
                [MBProgressHUD hideHUD];
            }else if ([strType isEqualToString:@"支付成功"]){
                [self.tableView reloadData];
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:strType];
            }
        }else{
            if([strType isEqualToString:@"请求补缴费用"]){
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"无补缴费用记录"];
            }else if ([strType isEqualToString:@"支付成功"]){
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"请稍后查询支付情况"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWBJFYCell *cell = [JWBJFYCell cellWithTableView:tableView];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor=[JWColor(226, 226, 226) CGColor];
    cell.btnLJBJ.tag = indexPath.section;
    cell.lblDate.text = [[_arrData objectAtIndex:indexPath.section] valueForKey:@"p_date"];
    cell.lblBJJE.text = [[_arrData objectAtIndex:indexPath.section] valueForKey:@"p_money"];
    cell.lblPXF.text = [[_arrData objectAtIndex:indexPath.section] valueForKey:@"typename"];
    return cell;
}
@end
