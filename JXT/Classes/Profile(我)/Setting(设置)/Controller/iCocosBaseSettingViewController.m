//
//  iCocosBaseSettingViewController.m
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "iCocosBaseSettingViewController.h"
#import "iCocosSettingCell.h"
#import "APService.h"
#import "PrefixHeader.pch"
@interface iCocosBaseSettingViewController ()

@end

@implementation iCocosBaseSettingViewController


- (void)loadView
{
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
//    UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  

    _allGroups = [NSMutableArray array];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    return group.items.count;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建一个iCocosSettingCell
    iCocosSettingCell *cell = [iCocosSettingCell settingCellWithTableView:tableView];
    
    // 2.取出这行对应的模型（iCocosSettingItem）
    iCocosSettingGroup *group = _allGroups[indexPath.section];
    cell.item = group.items[indexPath.row];
    if (cell.item.type==iCocosSettingItemTypeSwitch) {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
         NSUserDefaults* uu=[NSUserDefaults standardUserDefaults];
       NSString* isYES=[uu objectForKey:@"switch"];
        if (![isYES isEqualToString:@"SWITCH_NO"]) {
            switchview.on=YES;
        }
        else
        {
            switchview.on=NO;
        }
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
      
        cell.accessoryView = switchview;
    }
    
    
   
    return cell;
}

- (IBAction)updateSwitchAtIndexPath:(id)sender {
    
    
    UISwitch *switchView = (UISwitch *)sender;
    NSUserDefaults* uu=[NSUserDefaults standardUserDefaults];
    if ([switchView isOn])
    {
       
       
        [uu setObject:@"SWITCH_YES" forKey:@"switch"];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
    else
    {
        [uu setObject:@"SWITCH_NO" forKey:@"switch"];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];//关闭推送
        
        
    }
    
}
#pragma mark 点击了cell后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.取出这行对应的模型
    iCocosSettingGroup *group = _allGroups[indexPath.section];
    iCocosSettingItem *item = group.items[indexPath.row];

    // 1.取出这行对应模型中的block代码
    if (item.operation) {
        // 执行block
        item.operation();
    }
}

#pragma mark 返回每一组的header标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    
    return group.header;
}
#pragma mark 返回每一组的footer标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    
    return group.footer;
}

@end
