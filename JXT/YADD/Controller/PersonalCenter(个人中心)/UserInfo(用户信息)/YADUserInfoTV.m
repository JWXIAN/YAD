//
//  YADUserInfoTV.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADUserInfoTV.h"
#import "YADUserInfoCell.h"
#import "YADUserInfoHeadCell.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "JiaxiaotongAPI.h"
#import "JWProfileModel.h"
#import "JWExamScheduleInfo.h"
#import "SVProgressHUD.h"
#import "JWmoneyViewController.h"

@interface YADUserInfoTV ()
@property(strong, nonatomic) JWProfileModel* person;
@property(strong,nonatomic) JWExamScheduleInfo *p2;
/**考试详情*/
@property (nonatomic, strong) NSString *strTestInfo;
@end

@implementation YADUserInfoTV

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self itUserInfo];
    [self itView];
}
- (void)itUserInfo{
    [SVProgressHUD show];
    __weak __typeof(self) weakSelf = self;
    [JiaxiaotongAPI requestUserInfoByUserID:nil view:self.view andCallback:^(id obj) {
        weakSelf.person=obj;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:weakSelf.person.per_photo forKey:@"per_photo"];
        //存学号
        [ud setValue:weakSelf.person.per_id forKey:@"person_id"];
        [ud setObject:weakSelf.person.per_id forKey:@"per_id"];
        [ud setObject:weakSelf.person.per_idcardno forKey:@"accountID"];
        [ud setObject:weakSelf.person.per_name forKey:@"per_name"];
        [ud synchronize];
        //请求考试详情
        [JiaxiaotongAPI requestStuExamScheduleByStuExamSchedule:_person.per_id andCallback:^(id obj) {
            weakSelf.p2=obj;
            weakSelf.strTestInfo = weakSelf.p2.tz_name;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }];
    }];
    
}

- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //顶部个人信息
        YADUserInfoHeadCell *headCell = [YADUserInfoHeadCell cellWithTableView:tableView];
        headCell.person = _person;
        return headCell;
    }else{ //行个人信息
        YADUserInfoCell *cell = [YADUserInfoCell cellWithTableView:tableView];
        [cell stCellImageTitle:indexPath userInfo:_person testInfo:_strTestInfo];
        if (indexPath.row == 3) {
            cell.accessoryView = [self buyTime];
        }else if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
- (UIView *)buyTime{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [btn setTitle:@"购买学时" forState:UIControlStateNormal];
    [btn setBackgroundColor:JWColor(232, 94, 84)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnBuyClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnBuyClick{
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    JWmoneyViewController *verify=[story instantiateViewControllerWithIdentifier:@"money"];
    [self.navigationController pushViewController:verify animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 137;
    }else{
        return 44;
    }
}
@end
