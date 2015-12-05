//
//  YADPickUpInfoVC.m
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADPickUpInfoVC.h"
#import "YADPickUpInfoTV.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "YADPickUpTV.h"

@interface YADPickUpInfoVC ()
@property (nonatomic, strong) YADPickUpInfoTV *pickUpInfo;
@end

@implementation YADPickUpInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)itView{
    self.view.backgroundColor = [UIColor whiteColor];
    _pickUpInfo = [[YADPickUpInfoTV alloc] initWithStyle:UITableViewStyleGrouped];
    _pickUpInfo.view.frame = CGRectMake(0, 0, self.view.mj_w, self.view.mj_h-55);
    [self.view addSubview:_pickUpInfo.view];
    [self.view addSubview:[self footerView]];
}
#pragma mark - 底部
- (UIView *)footerView{
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.mj_h-50-64, self.view.mj_w-100, 44)];
    [btnSubmit setTitle:@"我要预约" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSubmit setBackgroundColor:JWColor(232, 94, 84)];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    return btnSubmit;
}

- (void)btnSubmitClick{
    YADPickUpTV *pickUp = [[YADPickUpTV alloc] initWithStyle:UITableViewStyleGrouped];
    pickUp.studentLogin =_studentLogin;
    pickUp.title = @"预约接送(VIP用户)";
    pickUp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pickUp animated:YES];
}
@end
