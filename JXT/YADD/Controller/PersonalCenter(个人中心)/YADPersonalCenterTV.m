//
//  YADPersonalCenterTV.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADPersonalCenterTV.h"
#import "YADPersonalCenterTVCell.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "YADUserInfoTV.h"
#import "YADSettingTV.h"
#import "SVProgressHUD.h"
#import "YADPickUpInfoVC.h"
#import "UserDefaultsKey.h"
#import "JWLoginController.h"
#import "JWLoginModel.h"
#import "UIImageView+WebCache.h"
#import "JsonPaser.h"
#import "JWProfileModel.h"
#import "JWCarVC.h"
#import "JWMyNewsTV.h"
#import "JWRecordVC.h"
#import "JWWDCJVC.h"
#import "jxt-swift.h"
#import "YADLoginTV.h"
#import "YADWebViewVC.h"

@interface YADPersonalCenterTV ()
/**学员数据模型*/
@property (nonatomic,strong)JWProfileModel *studentLogin;
//顶部View
@property (nonatomic, strong) UIView *personView;
/**登录*/
@property (nonatomic, strong) UIButton *btnLoginImage;

@end

@implementation YADPersonalCenterTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)itView{
    self.tableView.tableHeaderView = [self loadHeaderView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //禁用弹簧效果
    self.tableView.bounces = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
    //创建右侧barButtonItem
    UIBarButtonItem* right=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(barButtonRightClick)];
    self.navigationItem.rightBarButtonItem=right;
    
}

#pragma mark - 导航右按钮事件
- (void)barButtonRightClick{
    
}

#pragma mark - HeaderView
- (UIView *)loadHeaderView{
    
    _studentLogin = [JsonPaser parserUserInfoByDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserLoginSuccessInfo]];
    
    //1、底层View
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 210)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //2、个人信息
    _personView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 150)];
    _personView.backgroundColor = JWColor(232, 94, 84);
    [headerView addSubview:_personView];
    
    
//    _btnLoginImage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w/2-30, _personView.mj_h/2-30, 60, 60)];
//    _btnLoginImage.layer.cornerRadius = _btnLoginImage.mj_h/2;
//    [_btnLoginImage addTarget:self action:@selector(btnUserImageClick) forControlEvents:UIControlEventTouchUpInside];
    //3.个人头像
    UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.mj_w/2-40, _personView.mj_h/2-40, 80, 80)];
    userPhoto.clipsToBounds = YES;
    userPhoto.layer.cornerRadius = userPhoto.mj_h/2.0;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        [userPhoto sd_setImageWithURL:[NSURL URLWithString:_studentLogin.per_photo] placeholderImage:[UIImage imageNamed:@"个人中心-头像-点击登录"]];
    }else{
        userPhoto.image = [UIImage imageNamed:@"个人中心-头像-点击登录"];
    }
    [_personView addSubview:userPhoto];
    
    //4.提示是否登录 - 登录后显示用户名
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.mj_w/2-40, CGRectGetMaxY(userPhoto.frame)+5, 80, 20)];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        lblName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"_studentLogin.per_name"];
    }else{
        lblName.text = @"请点击登录";
    }
    
    lblName.font = [UIFont systemFontOfSize:14];
    lblName.textColor = [UIColor whiteColor];
    lblName.textAlignment = NSTextAlignmentCenter;
    [_personView addSubview:lblName];
    // 如果登录> - 进入个人信息模块 - 否则跳转登录页面
    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w-60, _personView.mj_h/2-22, 44, 44)];
    [btnInfo setImage:[UIImage imageNamed:@"个人中心-点击登录"] forState:UIControlStateNormal];
//    btnInfo.backgroundColor = [UIColor whiteColor];
    [btnInfo addTarget:self action:@selector(btnUserInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [_personView addSubview:btnInfo];
    
    //3、我的订单 - Button
    
    UIButton *myButtonOrder = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_personView.frame), self.view.mj_w/2-0.5, 50)];
    myButtonOrder.backgroundColor = [UIColor whiteColor];
    [myButtonOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myButtonOrder setTitle:@"我的订单" forState:UIControlStateNormal];
    [myButtonOrder setImage:[UIImage imageNamed:@"个人中心-我的订单"] forState:UIControlStateNormal];
    myButtonOrder.titleLabel.font = [UIFont systemFontOfSize:14];
    [myButtonOrder addTarget:self action:@selector(myButtonOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:myButtonOrder];
    //4、我的收藏 - Button
    UIButton *myButtonCollection = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w/2, CGRectGetMaxY(_personView.frame), self.view.mj_w/2, 50)];
    myButtonCollection.backgroundColor = [UIColor whiteColor];
    [myButtonCollection setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myButtonCollection setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myButtonCollection setImage:[UIImage imageNamed:@"个人中心-我的收藏"] forState:UIControlStateNormal];
    [myButtonCollection addTarget:self action:@selector(myButtonCollectionClick) forControlEvents:UIControlEventTouchUpInside];
    myButtonCollection.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:myButtonCollection];
    return headerView;
}

#pragma mark - 个人头像
- (void)btnUserImageClick{
    //如果未登录 - 跳转登录页面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] != YES) {
        [self loginVC];
    }else{
       //登录 - 更换头像
    }
}

#pragma mark - 进入个人信息
- (void)btnUserInfoClick{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES){
        YADUserInfoTV *userInfo = [[YADUserInfoTV alloc] initWithStyle:UITableViewStyleGrouped];
        userInfo.title = @"个人中心";
        userInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfo animated:YES];
    }else{
        [self loginVC];
    }
}
//登录
- (void)loginVC{
    YADLoginTV *login = [[YADLoginTV alloc] initWithStyle:UITableViewStyleGrouped];
    login.title = @"用户登录";
    [self.navigationController pushViewController:login animated:YES];
}
#pragma mark - 我的订单
- (void)myButtonOrderClick{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool]!=YES) {
        [self loginVC];
    }
}

#pragma mark - 我的收藏
- (void)myButtonCollectionClick{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool]!=YES) {
        [self loginVC];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADPersonalCenterTVCell *cell = [YADPersonalCenterTVCell cellWithTableView:tableView];
    [cell stCellImageTitle:indexPath];
    if (indexPath.row == 9) { //在线客服电话
        [cell.contentView addSubview:[self onlineCustomerPhone:@"43242342432432"rectFrame:CGRectMake(CGRectGetMaxX(cell.cellTitle.frame)+10, 6, self.view.mj_w-CGRectGetMaxX(cell.cellTitle.frame)-40, 30)]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        if (indexPath.row == 1) {//练车预约
            JWCarVC *car = [[JWCarVC alloc] init];
            car.title = @"练车预约";
            [self.navigationController pushViewController:car animated:YES];
        }else if (indexPath.row == 2){//预约记录
            JWRecordVC *record = [[JWRecordVC alloc] init];
            record.title = @"预约记录";
            [self.navigationController pushViewController:record animated:YES];
        }else if (indexPath.row == 3){//考试预约
            
        }else if (indexPath.row == 4){//预约接送
            YADPickUpInfoVC *pickUp = [[YADPickUpInfoVC alloc] init];
            pickUp.title = @"预约接送(VIP用户)";
            pickUp.hidesBottomBarWhenPushed = YES;
            pickUp.studentLogin = _studentLogin;
            [self.navigationController pushViewController:pickUp animated:YES];
        }else if (indexPath.row == 5){//我的成绩
            JWWDCJVC *wdcj = [[JWWDCJVC alloc] init];
            wdcj.title = @"我的成绩";
            [self.navigationController pushViewController:wdcj animated:YES];
        }else if (indexPath.row == 8){//我的评价
            JWRecordVC *record = [[JWRecordVC alloc] init];
            record.title = @"我的评价";
            record.control.selectedSegmentIndex = 2;
            [self.navigationController pushViewController:record animated:YES];
        }
    }else{
        if (indexPath.row==1||indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5||indexPath.row==8) {
            [SVProgressHUD showErrorWithStatus:@"请登录"];
        }
    }
    if (indexPath.row == 0){ //学车流程
        YADWebViewVC *web = [[YADWebViewVC alloc] init];
        web.title = @"学车流程";
        web.strURL = @"182.92.70.91:22223/yianda/xclc.html";
        [self.navigationController pushViewController:web animated:YES];
    }else if (indexPath.row == 6){//我的消息
        JWMyNewsTV *msg = [[JWMyNewsTV alloc] initWithStyle:UITableViewStyleGrouped];
        msg.title = @"我的消息";
        [self.navigationController pushViewController:msg animated:YES];
    }else if (indexPath.row == 9){//在线客服
        
    }else if (indexPath.row == 10){//设置
        YADSettingTV *setting = [[YADSettingTV alloc] initWithStyle:UITableViewStyleGrouped];
        setting.title = @"设置";
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
    }else if (indexPath.row == 7){ //选择题库
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        ChanegExam* car= [story instantiateViewControllerWithIdentifier:@"changeexam"];
        car.title = @"选择题库";
        [self.navigationController pushViewController:car animated:YES];
    }
    
}
@end
