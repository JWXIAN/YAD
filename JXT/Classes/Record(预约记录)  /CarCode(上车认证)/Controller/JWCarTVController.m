//
//  JWCarTVController.m
//  JXT
//
//  Created by JWX on 15/6/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWCarTVController.h"
#import "JWRecordTVCell.h"
#import "JWCarVIewCell.h"
#import "JWRecordBodyModel.h"
#import "JsonPaser.h"
#import "JiaxiaotongAPI.h"
#import "JWRecordHeadModel.h"
#import "MBProgressHUD+MJ.h"
#import "JWCarCell.h"
#import "JWCarCodeVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"


@interface JWCarTVController ()
/**预约记录数据模型*/
@property (nonatomic ,strong)NSMutableArray *recordHeads;
/**培训数组*/
@property (nonatomic, strong) NSMutableArray *carcodearr;
@property (nonatomic, strong) NSArray *yearArr;
@property (nonatomic, strong) NSMutableArray *carcodemarr;
@property (nonatomic, strong) NSMutableDictionary *carcodedic;

@end

@implementation JWCarTVController

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
    self.tableView.rowHeight = 165;
    //添加底部,防止cell最后一行数据无法拉出
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    self.tableView.tableFooterView = view;
    [self TBRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**加载上车信息*/
- (void)loadData
{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=shangcherenzheng&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><learnID>%@</learnID><methodName>shangcherenzheng</methodName></MAP_TO_XML>",school_id, per_id];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWRecordHeadModel *carcode = [JWRecordHeadModel objectWithKeyValues:dic];
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            self.carcodearr = carcode.body;
            [self arrGroup];
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"无记录"];
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
//    [JiaxiaotongAPI requestBookRecordByBookRecordRZ:stuid andCallback:^(id obj) {
//        JWRecordHeadModel *record = (JWRecordHeadModel *)obj;
//        if (record != nil) {
//            self.recordHeads = record.recordHeads;
//            [self.tableView reloadData];
//        }
//    }];
//    // 结束刷新状态
//    [self.tableView.header endRefreshing];
}

/**数据按时间分组*/
- (void)arrGroup{
    /**按年排序*/
    NSMutableDictionary *tmpDict=[NSMutableDictionary dictionary];
    for(NSDictionary *dict in _carcodearr)
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
    NSArray *sortkeys=[tmpDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
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
                NSString *ab=abc[@"period"];
                [arr addObject:ab];
            }
            [chartarr addObject:arr];
        }
    }
    self.carcodemarr = chartarr;
    self.yearArr = reSortArray;
    self.carcodearr = result;
}


/**返回cell数据行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_carcodemarr[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carcodearr.count;
}
// 返回分组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* temp = self.yearArr[section];
    NSArray* titleArr = [temp componentsSeparatedByString:@" "];
//    NSString *yeaar = [self.yearArr[section] substringToIndex:10];
    return titleArr[0];
}

#pragma mark - 数据源代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID = @"Cell";
//    JWCarVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"JWCarView" owner:self options:nil]lastObject];
//        //       cell.textLabel.textColor = JWColor(67, 153, 213);
//    }
//    cell.stuBookRecordInfo = self.recordHeads[indexPath.row];
//    return cell;
//    
    JWCarCell *cell = [JWCarCell cellWithTableView:tableView];
    //获取分组
    NSMutableArray *arr = [[_carcodearr objectAtIndex:indexPath.section] objectForKey:_yearArr[indexPath.section]];
    NSMutableArray *marr = [JWRecordBodyModel objectArrayWithKeyValuesArray:arr];
    
    cell.stuBookRecordInfo = marr[indexPath.row];
  
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JWCarCodeVC *car = [[JWCarCodeVC alloc] initWithNibName:@"JWCarCodeVC" bundle:nil];
    JWCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    car.name = cell.lbName.text;
    car.km = cell.lbKM.text;
    car.ch = cell.lbCH.text;
    car.date = cell.lbDate.text;
    car.hour = cell.lbHour.text;
    car.code = cell.lblCode.text;
//    self.stCode = car.code;
    car.title = @"教练扫描";
    [self.navigationController pushViewController:car animated:YES];

}



@end
