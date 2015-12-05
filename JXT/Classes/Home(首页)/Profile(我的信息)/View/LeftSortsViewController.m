//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"

#import "iCocosSettingViewController.h"

#import "JXT-swift.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
//    CGRect frame= self.view.frame;
//
//    frame.size.width=self.view.frame.size.width* 2.f/3.f;
//    
    tableview.frame = self.view.frame;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.backgroundColor=[UIColor clearColor];
//    tableview.backgroundView=imageview;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableview.tableHeaderView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ljyuyuebg-1"]];
    [self.view addSubview:tableview];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:cell.frame.size.height*0.4];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"选择题库";

    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"设置";
    }
//    } else if (indexPath.row == 2) {
//        cell.textLabel.text = @"网上营业厅";
//    } else if (indexPath.row == 3) {
//        cell.textLabel.text = @"个性装扮";
//    } else if (indexPath.row == 4) {
//        cell.textLabel.text = @"我的收藏";
//    } else if (indexPath.row == 5) {
//        cell.textLabel.text = @"我的相册";
//    } else if (indexPath.row == 6) {
//        cell.textLabel.text = @"设置";
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    if(indexPath.row==0)
    {
        UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        ChanegExam* exam=[story instantiateViewControllerWithIdentifier:@"changeexam"];
        [tempAppDelegate.navi pushViewController:exam animated:YES];
      
    }
    if (indexPath.row==1) {
        iCocosSettingViewController *setting = [[iCocosSettingViewController alloc] init];
       [tempAppDelegate.navi pushViewController:setting animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
