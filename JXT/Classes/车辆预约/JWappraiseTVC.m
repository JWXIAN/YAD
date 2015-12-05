//
//  JWappraiseTVC.m
//  JXT
//
//  Created by 1039soft on 15/7/28.
//  Copyright (c) 2015年 JW. All rights reserved.


//评价

#import "JWappraiseTVC.h"
#import "JWgetcommend.h"
#import "MBProgressHUD+MJ.h"
#import "JWappraise Cell.h"
@interface JWappraiseTVC ()
@property(strong,nonatomic)NSArray* body;//保存评价列表内容
@end

@implementation JWappraiseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"评价详情";
    self.tableView.tableFooterView=[[UIView alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [JWgetcommend showappraise:_teachercode view:self.view andCallback:^(id obj) {
        if ([obj[@"head"][@"issuccess"] isEqualToString:@"true"]) {
                 _body=obj[@"body"];
                [self.tableView reloadData];
                        
//            NSArray* obejct =[];//目标数组
//            for (id obj in obejct) {
//                if (obj isk) {
//                    <#statements#>
//                }
//            }
        }
         [MBProgressHUD hideHUDForView:self.view];
    }];
  
}



#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _body.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"mycell";
    //从重用对象池中找不用的cell对象
    JWappraise_Cell* cell=[self.tableView dequeueReusableCellWithIdentifier:cellID];
    //未找到创建
    if (cell==nil) {
        cell=[[JWappraise_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/6)];
    }
    cell.info=_body[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell drawview];
    return cell;
}



@end
