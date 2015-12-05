//
//  JWNoticeTVController.m
//  JXT
//
//  Created by JWX on 15/6/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWNoticeTVController.h"
#import "JiaxiaotongAPI.h"
#import "JWNoticeModel.h"
#import "MBProgressHUD+MJ.h"

@interface JWNoticeTVController ()
///**存放notice数据*/
//@property (nonatomic,strong)NSMutableArray *notices;
/**驾校公告数据模型*/
//@property (nonatomic,strong)JWNoticeModel *notices;
@end

@implementation JWNoticeTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 110;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self loadNotice];
}

/**加载公告信息*/
- (void)loadNotice
{
//    [JiaxiaotongAPI requsetStuLoginByStuLogin:nil andCallback:^(id obj) {
//        self.notices = (JWNoticeModel *)obj;
////        //保存身份证号
////        NSString *IDCardNum = self.studentLogin.per_idcardno;
////        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
////        [ud setObject:IDCardNum forKey:@"per_idcardno"];
////        [ud synchronize];
////        JWLog(@"%@",self.studentLogin.issuccess);
//        
//        if (self.notices.issuccess) {
//            //隐藏蒙板
//            [MBProgressHUD hideHUD];
//            
//        }else if([self.studentLogin.issuccess isEqualToString:@"false"]) {
//            [MBProgressHUD showError:@"学员信息错误！"];
//        }
//    }];

    
}

#pragma mark - tableview代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.notices.count;
    return 0;
}
/**cell数据源*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell== nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    cell.textLabel.text = self.notices[indexPath.row];
    return cell;
}
@end
