//
//  JWOrderTV.m
//  JXT
//
//  Created by JWX on 15/7/1.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWOrderTV.h"
#import "JWRecordTVCell.h"
#import "JWRecordBodyModel.h"
#import "JWRecordHeadModel.h"
#import "MBProgressHUD+MJ.h"
#import "JiaxiaotongAPI.h"
#import "JsonPaser.h"
#import "JWOrderTY.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"




@interface JWOrderTV ()
/**预约记录数据模型*/
@property (nonatomic, strong)NSMutableArray *recordHeads;
/**学校id*/
@property (nonatomic, strong) NSString *schoolID;

/**预约数组*/
@property (nonatomic, strong) NSMutableArray *orderarr;
@property (nonatomic, strong) NSArray *yearArr;
@property (nonatomic, strong) NSMutableArray *ordermarr;
@property (nonatomic, strong) NSMutableDictionary *orderdic;
@end


@implementation JWOrderTV

#pragma mark UITableView + 下拉刷新 默认
- (void)TBRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
//        [self loadData];
    }];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   

    //添加底部,防止cell最后一行数据无法拉出
    self.tableView.rowHeight = 130;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    self.tableView.tableFooterView = view;
    [self TBRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self loadData];
//}
/**加载预约信息*/
- (void)loadData
{
   
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><learnID>%@</learnID><status>预约</status><methodName>queryYuyue</methodName></MAP_TO_XML>",school_id, per_id];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
//    NSLog(@"%@",path);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWRecordHeadModel *trainhead = [JWRecordHeadModel objectWithKeyValues:dic];
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
//            self.recordHeads = [JWRecordBodyModel objectArrayWithKeyValuesArray:trainhead.body];
            self.orderarr = trainhead.body;
            
            [self arrGroup];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"无预约记录"];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙"];
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    }];

//
////    self.recordHeads = [NSMutableArray array];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *stuid = [ud objectForKey:@"stuID"];
////    NSString *stuid = [ud objectForKey:@"stuID"];
//    NSString *scid=[ud objectForKey:@"drivecode"];
////    NSString *schoolID = [ud objectForKey:@"drivecode"];
//    self.schoolID = scid;
//    [JiaxiaotongAPI requestBookRecordByBookRecord:stuid andCallback:^(id obj) {
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
    for(NSDictionary *dict in _orderarr)
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
    self.ordermarr = chartarr;
    self.yearArr = reSortArray;
    self.orderarr = result;
}

#pragma mark - Table view data source

/**返回cell数据行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_ordermarr[section] count];
//    return self.recordHeads.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderarr.count;
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
//    JWRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"JWRecordTVCell" owner:self options:nil]lastObject];
//        //       cell.textLabel.textColor = JWColor(67, 153, 213);
//    }
//    cell.stuBookRecordInfo = self.recordHeads[indexPath.row];
    JWRecordTVCell *cell = [JWRecordTVCell cellWithTableView:tableView];
    //获取分组
    NSMutableArray *arr = [[_orderarr objectAtIndex:indexPath.section] objectForKey:_yearArr[indexPath.section]];
    NSMutableArray *marr = [JWRecordBodyModel objectArrayWithKeyValuesArray:arr];
    cell.stuBookRecordInfo = marr[indexPath.row];
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWOrderTY *ty = [[JWOrderTY alloc] initWithNibName:@"JWOrderTY" bundle:nil];
    JWRecordTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    if([cell.t_yn.text isEqual:@"0"]){
        return;
    }else{
        ty.jl = cell.lbName.text;
        ty.km = cell.lbType.text;
        ty.ch = cell.lbCarNo.text;
        ty.date = cell.lbData.text;
        ty.hour = cell.lbHour.text;
        ty.lbid = cell.lbYYID.text;
        ty.scid = self.schoolID;
        ty.title = @"预约详情";
        [self.navigationController pushViewController:ty animated:YES];
    }
}


@end
