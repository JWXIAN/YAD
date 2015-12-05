//
//  YADLoginTV.m
//  YAD
//
//  Created by JWX on 15/11/27.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADLoginTV.h"
#import "YADLoginTVCell.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "SVProgressHUD.h"
#import "UserDefaultsKey.h"
#import "JiaxiaotongAPI.h"
#import "JWLoginModel.h"
#import "YADLoginAPI.h"
#import "JWTarBarController.h"
#import "jxt-swift.h"
#import "APService.h"
#import "RegisterVC.h"
#import "YADRegisterTV.h"
#import "JWDLTVController.h"

@interface YADLoginTV () <UITextFieldDelegate>
/**学员数据模型*/
@property (nonatomic,strong)JWLoginModel *studentLogin;
@end

@implementation YADLoginTV

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 加载视图
- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //底部视图
    self.tableView.tableFooterView = [self ittableFootView];
    
    //顶部视图
    self.tableView.tableHeaderView = [self ittableHeadView];
}

#pragma mark - 顶部视图
- (UIView *)ittableHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 150)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.mj_w/2-50, 25, 100, 100)];
    iv.image = [UIImage imageNamed:@"亿安达驾校"];
    iv.clipsToBounds = YES;
    iv.layer.cornerRadius = iv.mj_h/2.0;
    iv.layer.borderWidth = 0.5;
    iv.layer.borderColor = [JWColor(188, 187, 192) CGColor];
    
    [view addSubview:iv];
    return view;
}

#pragma mark - 底部视图
- (UIView *)ittableFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 200)];
    
    //登录
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(25, 16, self.view.mj_w-50, 44)];
    btnLogin.layer.cornerRadius = 10;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLogin setBackgroundColor:JWColor(232, 94, 84)];
    [btnLogin addTarget:self action:@selector(btnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnLogin];
    
    //选择驾校
    UIButton *btnSchool = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(btnLogin.frame)+16, 80, 30)];
    [btnSchool setTitle:@"选择驾校" forState:UIControlStateNormal];
    btnSchool.titleLabel.textAlignment = NSTextAlignmentLeft;
    btnSchool.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSchool setTitleColor:JWColor(232, 94, 84) forState:UIControlStateNormal];
    [btnSchool addTarget:self action:@selector(btnSchoolClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSchool];
    
    //新学员注册
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w-105, CGRectGetMaxY(btnLogin.frame)+16, 80, 30)];
    [btnRegister setTitle:@"新学员注册" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:15];
    btnRegister.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnRegister setTitleColor:JWColor(232, 94, 84) forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRegister];
    
    return view;
}

#pragma mark - 选择驾校
- (void)btnSchoolClick{
    JWDLTVController *tb = [[JWDLTVController alloc] init];
    tb.title = @"驾校列表";
    [self.navigationController pushViewController:tb animated:YES];
}
#pragma mark - 注册页面
- (void)btnRegisterClick{
    YADRegisterTV *registerTV = [[YADRegisterTV alloc] initWithStyle:UITableViewStyleGrouped];
    registerTV.title = @"新学员注册";
    [self.navigationController pushViewController:registerTV animated:YES];
}
#pragma mark - 登录
- (void)btnLoginClick{
    NSMutableDictionary *dicInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    YADLoginTVCell *cell = (YADLoginTVCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //关闭键盘
    [cell.textDetail resignFirstResponder];
    if (cell.textDetail.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码/手机号/学员编号"];
    }else{
        //保存账号
        [dicInfo setObject:cell.textDetail.text forKey:@"loginAccount"];
        //验证密码
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = (YADLoginTVCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.textDetail.text.length == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        }else{
            [SVProgressHUD show];
            //保存密码
            [dicInfo setObject:cell.textDetail.text forKey:@"loginPassWord"];
            [[NSUserDefaults standardUserDefaults] setObject:cell.textDetail.text forKey:UserLogin_PassWord];
            //登录API
            [self loginAPI:dicInfo];
        }
    }
}

#pragma mark - 登录API
- (void)loginAPI:(NSMutableDictionary *)dicInfo{

    [YADLoginAPI getUserLoginWithAccountPassWord:dicInfo callback:^(id result) {
        self.studentLogin = (JWLoginModel *)result;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([self.studentLogin.issuccess isEqualToString:@"true"]) {
            //保存身份证号
            NSString *IDCardNum = self.studentLogin.per_idcardno;
            [ud setObject:IDCardNum forKey:@"per_idcardno"];
            //用户名
            [ud setObject:dicInfo[@"loginAccount"] forKey:@"dengluname"];
            //名字
            [ud setObject:_studentLogin.per_name forKey:@"_studentLogin.per_name"];
            //学号
            [ud setObject:_studentLogin.train_learnid forKey:@"train_learnid"];
            //存是否登录成功
            [ud setBool:YES forKey:UserIsaAlreadyLogin_Bool];
            [ud synchronize];
            
            NSString* tags=[ud objectForKey:@"drivecode"];
            
            NSSet *target =[[NSSet alloc]initWithObjects:tags,IDCardNum,nil];
            //设置推送标签
            [APService setTags:target callbackSelector:nil object:nil];
            [SVProgressHUD dismiss];
            if ([ud boolForKey:@"shouci"]) {
                UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
                ChanegExam* ex=[story instantiateViewControllerWithIdentifier:@"changeexam"];
                [self presentViewController:ex animated:YES completion:nil];
            }
            else
            {
                JWTarBarController* jwtab=[[JWTarBarController alloc]init];
                [self presentViewController:jwtab animated:YES completion:nil];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
            [ud setBool:NO forKey:@"issuccess"];
            [ud synchronize];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADLoginTVCell *cell = [YADLoginTVCell cellWithTableView:tableView];
    [cell cellWithTitle:indexPath];
    cell.textDetail.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self btnLoginClick];
    return YES;
}
@end
