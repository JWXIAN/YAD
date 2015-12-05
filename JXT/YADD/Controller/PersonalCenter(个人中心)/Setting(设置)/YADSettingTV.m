//
//  YADSettingTV.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADSettingTV.h"
#import "YADSettingTVCell.h"
#import "UIView+MJExtension.h"
#import "UserDefaultsKey.h"
#import "JWLoginController.h"
#import "YADLoginTV.h"
#import "PrefixHeader.pch"
#import "YADChangPwdTV.h"
#import "SVProgressHUD.h"

@interface YADSettingTV ()

@end

@implementation YADSettingTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //隐藏多余行
     UIButton *btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 44)];
    
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [btnQuit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        [btnQuit setTitle:@"退出账号" forState:UIControlStateNormal];
        btnQuit.tag = 0;
        [btnQuit setBackgroundColor:JWColor(232, 94, 84)];
    }else{
        [btnQuit setTitle:@"登录账号" forState:UIControlStateNormal];
        [btnQuit setBackgroundColor:JWColor(232, 94, 84)];
        btnQuit.tag = 1;
    }
    [btnQuit addTarget:self action:@selector(btnqQuit:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = btnQuit;
}

- (void)btnqQuit:(UIButton *)sender{
    if (sender.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UserIsaAlreadyLogin_Bool];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self loginView];
    }
}

- (void)loginView{
    YADLoginTV *login = [[YADLoginTV alloc] initWithStyle:UITableViewStyleGrouped];
    login.title = @"用户登录";
    [self.navigationController pushViewController:login animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADSettingTVCell *cell = [YADSettingTVCell cellWithTableView:tableView];
    [cell stCellImageTitle:indexPath];
    if (indexPath.section == 1 && indexPath.row==0) {
        cell.accessoryView = [self pushSwitch];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [cell.contentView addSubview:[self onlineCustomerPhone:@"43242342432432"rectFrame:CGRectMake(CGRectGetMaxX(cell.cellTitle.frame)+10, 7, self.view.mj_w-CGRectGetMaxX(cell.cellTitle.frame)-40, 30)]];
    }
    return cell;
}
#pragma mark - 在线客服电话
- (UIView *)onlineCustomerPhone:(NSString *)strPhone rectFrame:(CGRect)rectFrame{
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:rectFrame];
    lblPhone.text = strPhone;
    lblPhone.font = [UIFont systemFontOfSize:14];
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.textAlignment = NSTextAlignmentRight;
    return lblPhone;
}
//接受推送Click
- (UIView *)pushSwitch{
    UISwitch *sw = [[UISwitch alloc] init];
    sw.on = YES;
    [sw addTarget:self action:@selector(pushSwitchClick) forControlEvents:UIControlEventTouchUpInside];
    return sw;
}
#pragma mark - 接受推送开关
- (void)pushSwitchClick{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
            YADChangPwdTV *pwd = [[YADChangPwdTV alloc] initWithStyle:UITableViewStyleGrouped];
            pwd.title = @"修改密码";
            [self.navigationController pushViewController:pwd animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请登录后修改密码"];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}
@end
