//
//  JWQuitTV.m
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWQuitTV.h"
#import "JsonPaser.h"
#import "JiaxiaotongAPI.h"
#import "MBProgressHUD+MJ.h"
#import "JWRecordHeadModel.h"
#import "JWRecordBodyModel.h"
#import "JWQuitCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"


@interface JWQuitTV ()
/**预约记录数据模型*/
@property (nonatomic,strong) NSMutableArray *recordHeads;

/**预约数组*/
@property (nonatomic, strong) NSMutableArray *quitarr;
@property (nonatomic, strong) NSArray *yearArr;
@property (nonatomic, strong) NSMutableArray *quitmarr;

@end

@implementation JWQuitTV

#pragma mark UITableView + 下拉刷新 默认
- (void)TBRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
        //        [self loadData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    //添加底部,防止cell最后一行数据无法拉出
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    self.tableView.tableFooterView = view;
    [self TBRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**加载退约信息*/
- (void)loadData
{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><learnID>%@</learnID><status>取消</status><methodName>queryYuyue</methodName></MAP_TO_XML>",school_id, per_id];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWRecordHeadModel *quithead = [JWRecordHeadModel objectWithKeyValues:dic];
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            self.quitarr = quithead.body;
            [self arrGroup];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"无退约记录"];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙"];
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    }];

//    self.recordHeads = [NSMutableArray array];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *stuid = [ud objectForKey:@"stuID"];
//    [JiaxiaotongAPI requestBookRecordByBookRecordTY:stuid andCallback:^(id obj) {
//        JWRecordHeadModel *record = (JWRecordHeadModel *)obj;
//        if (record != nil) {
//            self.recordHeads = record.recordHeads;
//            [self.tableView reloadData];
//        }
//    }];
//    // 结束刷新状态
//    [self.tableView.header endRefreshing];
}

- (void)arrGroup{
    /**按年排序*/
    NSMutableDictionary *tmpDict=[NSMutableDictionary dictionary];
    for(NSDictionary *dict in _quitarr)
    {
        NSString *key = dict[@"ddate"];
        if(tmpDict[key] == nil)
        {
            tmpDict[key]=[[NSMutableArray alloc] init];
        }
        [tmpDict[key] addObject:dict];
    }
    
    NSMutableArray *result=[NSMutableArray array];
    NSMutableArray *chartarr=[NSMutableArray array];
    NSArray *sortkeys= [tmpDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *reSortArray= [NSMutableArray array];
    for (id _obj in [sortkeys reverseObjectEnumerator]) {
        [reSortArray addObject:_obj];
    }
    for (NSString *key in reSortArray)
    {
        NSDictionary *dict=@{key:tmpDict[key]};
        [result addObject:dict];
        NSMutableArray *arr=[NSMutableArray array];
        for (int i=0; i<dict.allKeys.count; i++) {
            NSString *s=dict.allKeys[i];
            for (NSDictionary* abc in dict[s]) {
                NSString *ab=abc[@"id"];
                [arr addObject:ab];
            }
            [chartarr addObject:arr];
        }
    }
    self.quitmarr = chartarr;
    self.yearArr = reSortArray;
    self.quitarr = result;
}


/**返回cell数据行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_quitmarr[section] count];
    //    return self.recordHeads.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _quitarr.count;
}
// 返回分组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.yearArr[section];
}

#pragma mark - 数据源代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID = @"Cell";
//    JWQuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"JWQuitCell" owner:self options:nil]lastObject];
//        //       cell.textLabel.textColor = JWColor(67, 153, 213);
//    }
//    cell.stuBookRecord = self.recordHeads[indexPath.row];
//    return cell;
    JWQuitCell *cell = [JWQuitCell cellWithTableView:tableView];
    //获取分组
    NSMutableArray *arr = [[_quitarr objectAtIndex:indexPath.section] objectForKey:_yearArr[indexPath.section]];
    NSMutableArray *marr = [JWRecordBodyModel objectArrayWithKeyValuesArray:arr];
    cell.stuBookRecord = marr[indexPath.row];
    return cell;
}
@end
