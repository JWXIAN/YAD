//
//  JWMyNewsTV.m
//  JXT
//
//  Created by JWX on 15/9/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWMyNewsTV.h"
#import "JWMyNewsCell.h"
#import "MJExtension.h"
#import "UIView+MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "PrefixHeader.pch"
#import "SVProgressHUD.h"

@interface JWMyNewsTV ()
/**推送存放字典*/
@property (nonatomic, strong) NSMutableArray *newsArr;
/**plist路径*/
@property (nonatomic, strong) NSString *plistPath;

/**行高度*/
@property (nonatomic, assign) CGFloat rowH;

//字典数组
@property (nonatomic, strong) NSMutableArray *usersArray;
@end

@implementation JWMyNewsTV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    _plistPath = [documentsPath stringByAppendingPathComponent:@"MyNews.plist"];
    _newsArr = [[NSMutableArray alloc] init];
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:_plistPath])
    {
        //加载plist文件
        _newsArr = [NSMutableArray arrayWithContentsOfFile:_plistPath];
        if(_newsArr.count ==0){
            [SVProgressHUD showErrorWithStatus:@"没有推送信息"];
        }
        //测试数据
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:@"aaaaa" forKey:@"newMsg"];
//        [dic setObject:@"cccc" forKey:@"newDate"];
//        [_newsArr addObject:dic];
    }else{
        [SVProgressHUD showErrorWithStatus:@"没有推送信息"];
//        NSMutableDictionary *newsDic2 = [[NSMutableDictionary alloc] init];
//        
//        [newsDic2 setObject:@"测试3" forKey:@"newMsg"];
//        [newsDic2 setObject:@"2015-09-24 17:01:53" forKey:@"newDate"];
//        [newsDic2 setObject:@"推送消息" forKey:@"newType"];
        
//        //添加字典
//        NSMutableDictionary *newsDic = [[NSMutableDictionary alloc] init];
//        //当前时间
//        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *date = [formatter stringFromDate:[NSDate date]];
//        
//        [newsDic setObject:@"推送消息" forKey:@"newMsg"];
//        [newsDic setObject:date forKey:@"newDate"];
//        [newsDic setObject:@"顶部消息" forKey:@"newType"];
//
//        [_newsArr addObject:newsDic];
//        //写入文件
//        [_newsArr writeToFile:_plistPath atomically:YES];
    }
    
//    if(_newsArr.count > 0){
//        self.tableView.backgroundColor = JWColor(244, 244, 244);
//    }else{
//        self.tableView.backgroundColor = [UIColor redColor];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWMyNewsCell *cell = [JWMyNewsCell cellWithTableView:tableView];
    cell.lblText.text = [[_newsArr valueForKeyPath:@"newMsg"] objectAtIndex:indexPath.row];
    cell.lblDate.text = [[_newsArr valueForKeyPath:@"newDate"] objectAtIndex:indexPath.row];
    cell.lblTitle.text = [[_newsArr valueForKeyPath:@"newType"] objectAtIndex:indexPath.row];
    
#pragma mark - 计算lab行数
    //设置字体
    UIFont *ft = [UIFont systemFontOfSize:14];
    cell.lblText.font = ft;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:ft, NSFontAttributeName,nil];
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize =[cell.lblText.text boundingRectWithSize:CGSizeMake(263, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    cell.lblText.text = cell.lblText.text;
    cell.lblText.frame = CGRectMake(16, 41, labelsize.width, labelsize.height);
    //计算行高
    _rowH = CGRectGetMaxY(cell.lblText.frame);
    
    return cell;
}

+ (NSMutableArray *)setNews:(NSString *)newsMsg newsDate:(NSString *)newsDate newsType:(NSString *)newsType{
    //获取完整路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"MyNews.plist"];
    
    //创建plist文件数组
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *newsDic = [[NSMutableDictionary alloc] init];
    
    //判断是否已创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        //添加数据
        usersArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
        [newsDic setObject:newsMsg forKey:@"newMsg"];
        [newsDic setObject:newsDate forKey:@"newDate"];
        [newsDic setObject:newsType forKey:@"newType"];
        [usersArray addObject:newsDic];
        //写入plist
        [usersArray writeToFile:plistPath atomically:YES];
    }else{
        [newsDic setObject:newsMsg forKey:@"newMsg"];
        [newsDic setObject:newsDate forKey:@"newDate"];
        [newsDic setObject:newsType forKey:@"newType"];
        
        //添加数组元素
        [usersArray addObject:newsDic];
        //写入文件
        [usersArray writeToFile:plistPath atomically:YES];
    }

    return usersArray;
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [_newsArr removeAllObjects];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowH+10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_newsArr removeObjectAtIndex:indexPath.row];
        //写入文件
        [_newsArr writeToFile:_plistPath atomically:YES];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除信息";
}

@end
