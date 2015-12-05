//
//  JWexamTableViewController.m
//  JXT
//
//  Created by 1039soft on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWexamTableViewController.h"
#import "JiaxiaotongAPI.h"
#import "StudentExamContent.h"
#import "StuExamInfo.h"
#import "JWexamTableViewCell.h"
@interface JWexamTableViewController ()<UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *examtabel;
@property(strong,nonatomic)NSMutableArray* mu;
@end

@implementation JWexamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mu=[NSMutableArray array];
    self.navigationItem.title=@"考试进度详情";
    _examtabel.delegate=self;
    _examtabel.dataSource=self;
    _examtabel.estimatedRowHeight=300;
    _examtabel.rowHeight=UITableViewAutomaticDimension;
    [JiaxiaotongAPI requsetStudentExamContentByStudentExamContent:nil andCallback:^(id obj) {
        StudentExamContent* ste=obj;
        _mu=ste.stuExamContents;
        [self.tableView reloadData];
        self.tableView.tableFooterView=[[UIView alloc]init];
//        NSLog(@"%@",_mu);
    }];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _mu.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"examcell";
    //从重用对象池中找不用的cell对象
    JWexamTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    //未找到创建
    if (cell==nil) {
        cell=[[JWexamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    StuExamInfo* stuinfo=_mu[indexPath.row];
//
    [cell cellInfo:stuinfo];

   
    return cell;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWexamTableViewCell* cell =(JWexamTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.shijian.frame.origin.y + cell.shijian.frame.size.height + 10;
}


@end
