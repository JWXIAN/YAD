//
//  YADPickUpInfoTV.m
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADPickUpInfoTV.h"
#import "YADPickUpInfoCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "JJPickUpInfoAPI.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "YADPickUpInfoModel.h"

@interface YADPickUpInfoTV () <YADPickUpInfoCellDelegate>
@property (nonatomic, strong) NSArray *arrInfo;
@end

@implementation YADPickUpInfoTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itPickAPI];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 退约API
- (void)btnCancelPickUpClick:(NSInteger)btnTag{
    [SVProgressHUD show];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btnTag inSection:0];
    YADPickUpInfoCell *cell = (YADPickUpInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [JJPickUpInfoAPI cancelPickUpInfo:cell.lblID.text callback:^(NSDictionary *result) {
        NSLog(@"%@", result);
        if ([[result valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:@"退约成功"];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"退约失败"];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 获取预约接送信息
- (void)itPickAPI{
    [JJPickUpInfoAPI getPickUpInfo:^(NSDictionary *result) {
        if ([[result valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            _arrInfo = [YADPickUpInfoModel objectArrayWithKeyValuesArray:[result valueForKeyPath:@"body"]];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"异常操作"];
        }
    }];
}
- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 60)];
    
    self.tableView.layer.borderColor = [JWColor(188, 187, 192) CGColor];
    self.tableView.layer.borderWidth = 0.5;
    //顶部
    self.tableView.tableHeaderView = [self headView];
}
- (UIView *)headView{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 20)];
    lbl.text = @"    最近一个月";
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:14];
    return lbl;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADPickUpInfoCell *cell = [YADPickUpInfoCell cellWithTableView:tableView];
    cell.pickUpInfoModel = _arrInfo[indexPath.row];
    cell.delegate = self;
    [cell cellWithIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}
@end
