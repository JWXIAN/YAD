//
//  YADRegisterTV.m
//  JXT
//
//  Created by JWX on 15/12/4.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADRegisterTV.h"
#import "YADRegisterTVCell.h"
#import "AFNetworking.h"
#import "UIView+MJExtension.h"
#import "SVProgressHUD.h"
#import "UILabel+JWContentSize.h"
#import "PrefixHeader.pch"
#import "YADLoginAPI.h"
#import "PopoverView.h"

@interface YADRegisterTV () <UITextFieldDelegate>
/**车型*/
@property (nonatomic, strong) NSArray *arrRegisterCarType;
//车型
@property (nonatomic, strong) NSString *carType;
/**选择车型*/
@property (nonatomic, strong) UIButton *btnCar;
@end

@implementation YADRegisterTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itRegisterCarType];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 加载车型
- (void)itRegisterCarType{
    [YADLoginAPI getRegisterCarType:^(NSDictionary *result) {
        if ([[result valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            _arrRegisterCarType = [result valueForKeyPath:@"body.typename"];
        }
    }];
}
#pragma mark - 加载视图
- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //底部视图
    self.tableView.tableFooterView = [self ittableFootView];
}

- (UIView *)ittableFootView{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 100)];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"请选择车型:";
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [UIColor grayColor];
    CGSize size = [lbl JWContentSize];
    lbl.frame = CGRectMake(32, 16, size.width, size.height);
    [view addSubview:lbl];
    
    //选择车型
    _btnCar = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame)+16, 9, 100, 30)];
    _btnCar.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnCar setTitle:@"点击选择车型" forState:UIControlStateNormal];
    _btnCar.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnCar setBackgroundColor:JWColor(232, 94, 84)];
    [_btnCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnCar.layer.cornerRadius = 5;
    [_btnCar addTarget:self action:@selector(btnCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnCar];
    
    //完成注册
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_btnCar.frame)+30, self.view.mj_w-50, 44)];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRegister setTitle:@"确定注册" forState:UIControlStateNormal];
    btnRegister.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnRegister setBackgroundColor:JWColor(232, 94, 84)];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRegister.layer.cornerRadius = 10;
    [btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRegister];
    
    return view;
}

#pragma mark - 选择车型
- (void)btnCarClick:(UIButton *)sender{
    if (_arrRegisterCarType.count > 0) {
        CGPoint point = CGPointMake(self.tableView.tableFooterView.mj_x +180, self.tableView.tableFooterView.mj_y+100);
        PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:_arrRegisterCarType images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
            [sender setTitle:_arrRegisterCarType[index] forState:UIControlStateNormal];
            _carType=_arrRegisterCarType[index];
        };
        [pop show];
    }else{
        [SVProgressHUD showErrorWithStatus:@"没有车辆信息"];
    }
}

- (void)btnRegisterClick{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arrTitle = @[@"姓名", @"手机号", @"身份证号", @"报名来源"];
    if ([_btnCar.titleLabel.text isEqualToString:@"点击选择车型"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择车型"];
    }else{
        for (id obj in self.tableView.visibleCells) {
            YADRegisterTVCell *cell = obj;
            if (cell.textDetail.text.length == 0) {
                [arr addObject:@"nil"];
            }else{
                [arr addObject:cell.textDetail.text];
            }
        }
        int l = 0;
        for (int i=0; i<arr.count; i++) {
            if ([arr[i] isEqualToString:@"nil"]) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@", arrTitle[i]]];
                break;
            }else{
                l +=1;
            }
        }
        //确定注册
        if (l == 4) {
            NSString *str = arr[1];
            if (str.length == 11) {
                str = arr[2];
                if ([self checkUserIdCard:str]) {
                    [self registerAPI:arr carType:_btnCar.titleLabel.text];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            }
        }
    }
}
#pragma mark - 注册API
- (void)registerAPI:(NSArray *)arrInfo carType:(NSString *)carType{
    
    __weak __typeof(self) weakSelf = self;
    [YADLoginAPI postRegisterInfo:arrInfo carType:carType Callback:^(NSDictionary *result) {
        if ([[result valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }
    }];
}
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *)idCard
{
    if (idCard.length <= 0) {
        
        return NO;
    }
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 60;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADRegisterTVCell *cell = [YADRegisterTVCell cellWithTableView:tableView];
    [cell cellWithTitle:indexPath];
    cell.textDetail.delegate = self;
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self btnRegisterClick];
    return YES;
}

@end
