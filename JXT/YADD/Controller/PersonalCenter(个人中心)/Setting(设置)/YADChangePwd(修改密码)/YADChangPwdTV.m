//
//  YADChangPwdTV.m
//  JXT
//
//  Created by JWX on 15/12/5.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADChangPwdTV.h"
#import "YADChangPwdTVCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "SVProgressHUD.h"
#import "YADUserInfoModifyAPI.h"
#import "UserDefaultsKey.h"
#import "ChangePassword.h"

@interface YADChangPwdTV () <UITextFieldDelegate>

@end

@implementation YADChangPwdTV

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
    
    self.tableView.tableFooterView = [self btnSureModify];
}
#pragma mark - 确定修改
- (UIView *)btnSureModify{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 60)];
    //隐藏多余行
    UIButton *btnSureModify = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, self.view.mj_w, 44)];
    
    btnSureModify.titleLabel.font = [UIFont systemFontOfSize:15];

    [btnSureModify setTitle:@"确定修改" forState:UIControlStateNormal];
    [btnSureModify setBackgroundColor:JWColor(232, 94, 84)];
    [btnSureModify addTarget:self action:@selector(btnSureModifyClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSureModify];
    
    return view;
}

#pragma mark - 修改密码 按钮
- (void)btnSureModifyClick{
    NSMutableArray *arrInfo = [NSMutableArray array];
    YADChangPwdTVCell *cell;
    [cell.textDetail resignFirstResponder];
    for (id obj in self.tableView.visibleCells) {
        cell = obj;
        if (cell.textDetail.text.length > 0) {
            [arrInfo addObject:cell.textDetail.text];
        }
    }
    if (arrInfo.count == 3) {
        //判断原密码是否正确
        if ([arrInfo[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UserLogin_PassWord]]) {
            //判断新密码是否一致
            if ([arrInfo[1] isEqualToString:arrInfo[2]]) {
                //判断是否跟原密码一致
                if ([arrInfo[1] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UserLogin_PassWord]]) {
                    [SVProgressHUD showErrorWithStatus:@"跟原密码一致"];
                }else{
                    [SVProgressHUD show];
                    //修改密码API
                    [self changPwdAPI:arrInfo];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"新密码不一致"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入正确的原密码"];
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写完整的信息"];
    }
}

#pragma mark - 修改密码API
- (void)changPwdAPI:(NSArray *)arrInfo{
    [YADUserInfoModifyAPI updateAccountPassWord:arrInfo result:^(id result) {
        ChangePassword *cp= result;
        if ([cp.issuccess isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UserIsaAlreadyLogin_Bool];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADChangPwdTVCell *cell = [YADChangPwdTVCell cellWithTableView:tableView];
    [cell cellWithTitle:indexPath];
    cell.textDetail.delegate = self;
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self btnSureModifyClick];
    return YES;
}

@end
