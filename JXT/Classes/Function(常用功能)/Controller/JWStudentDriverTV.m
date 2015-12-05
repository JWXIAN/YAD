//
//  JWStudentDriverTV.m
//  JXT
//
//  Created by JWX on 15/9/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWStudentDriverTV.h"
#import "JWStudentDriverCell.h"
#import "JWDLTVController.h"
#import "JWmoneyViewController.h"
#import "JWexamTableViewController.h"
#import "JWRecordVC.h"
#import "WMPageConst.h"
#import "PrefixHeader.pch"
#import "JWPerInfoVC.h"
#import "JXT-swift.h"
#import "LightVC.h"
#import "JWMapLBSVC.h"
#import "JWBJFYTV.h"
#import "JWTarBarController.h"
@interface JWStudentDriverTV ()

@end

@implementation JWStudentDriverTV

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"常用功能";
    self.tableView.rowHeight = 61;
    self.tableView.backgroundColor = JWColor(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    JWStudentDriverCell *cell = [JWStudentDriverCell cellWithTV:tableView indexPathRow:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor=[JWColor(226, 226, 226) CGColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UIStoryboard* story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString*  whichButton = [user objectForKey:@"whichButton"];
    NSString* _className =[user objectForKey:@"xuanzekemuzhihou"];
    if (!_className) {
        _className=@"科目一";
    }
    if ([_className isEqualToString:@"科目二"] || [_className isEqualToString:@"科目三"]) {
         _className=@"科目一";
    }
    if (indexPath.section==0)//预约练车
    {
        
        self.tabBarController.selectedIndex=1;
        JWTarBarController* tabbar = (JWTarBarController *)self.tabBarController;
        tabbar.pageVC.selectIndex=1;
    }
    else if (indexPath.section==1)//预约记录
    {
        JWRecordVC *discover = [[JWRecordVC alloc] init];
                discover.title=@"预约记录";
                [self.navigationController pushViewController:discover animated:YES];
    }
    else if (indexPath.section==2)//购买学时
    {
                JWmoneyViewController* money = [story instantiateViewControllerWithIdentifier:@"money"];
        
                [self.navigationController pushViewController:money animated:YES];
    }
    else if (indexPath.section==3)//补缴费用
    {
        JWBJFYTV *bjfy = [[JWBJFYTV alloc] init];
        bjfy.title = @"补缴费用";
        bjfy.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bjfy animated:YES];

    }
    else if (indexPath.section==4)//考试记录
    {
        UITableViewController* examLog = [story instantiateViewControllerWithIdentifier:@"examLog"];
        [self.navigationController pushViewController:examLog animated:YES];
    }
    else if (indexPath.section==5)//灯光和语音模拟
    {
        LightVC* litght = [story instantiateViewControllerWithIdentifier:@"light"];
        [self.navigationController pushViewController:litght animated:YES];
    }
    else if (indexPath.section==6)//周边
    {
        JWMapLBSVC *mapLBS = [[JWMapLBSVC alloc] init];
        mapLBS.title = @"周边搜索";
        mapLBS.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mapLBS animated:YES];
    }else if(indexPath.section == 7){ //模拟考试
        JWPerInfoVC *dt = [[JWPerInfoVC alloc] init];
        
        dt.title=@"模拟考试";
        if (whichButton) {
            dt.lblKSTM_name=_className;
        }
        else
        {
            dt.lblKSTM_name=[NSString stringWithFormat:@"%@考试",whichButton];
        }
        dt.lblKSCX_name=whichButton;
        dt.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dt animated:YES];
    }
}

@end
