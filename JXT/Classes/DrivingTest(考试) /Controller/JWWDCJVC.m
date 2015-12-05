//
//  JWWDCJVC.m
//  JXT
//
//  Created by JWX on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWWDCJVC.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "JWWDCJCell.h"
#import "PNChart.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "JWWDCJStatBodyModel.h"
#import "JWWDCJStatModel.h"
#import "MJRefresh.h"

@interface JWWDCJVC () <UITableViewDelegate, UITableViewDataSource>
/**统计View*/
@property (nonatomic, strong) UIView *headStatView;
@property (nonatomic, strong) NSMutableArray *wdcjScoreArr;
@property (nonatomic, strong) NSMutableArray *wdcjTitleArr;
/**标题View*/
@property (nonatomic, strong) UIView *headTitleView;
/**标题ImageView*/
@property (nonatomic, strong) UIImageView *dateImageView;
@property (nonatomic, strong) UIImageView *scoreImageView;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UIImageView *pyImageView;
/**成绩信息*/
@property (nonatomic, strong) UITableView *footerTVView;

/**成绩信息数组*/
@property (nonatomic, strong) NSArray *wdcjStat;
@end

@implementation JWWDCJVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //View添加
    [self loadWDCJView:@"WDCJDateImage" scoreImage:@"WDCJScoreImage" pyImage:@"WDCJPYImage" timeImage:@"WDCJTimeImage"];
    //下拉刷新
    [self TBRefresh];
}

#pragma mark UITableView + 下拉刷新 默认
- (void)TBRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _footerTVView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _wdcjScoreArr = [NSMutableArray array];
        _wdcjTitleArr = [NSMutableArray array];
        [weakSelf loadDataView];
    }];
    // 马上进入刷新状态
    [_footerTVView.header beginRefreshing];
}

#pragma mark - View添加
- (void)loadWDCJView:(NSString *)dateImage scoreImage:(NSString *)scoreImage pyImage:(NSString *)pyImage timeImage:(NSString *)timeImage{
    //统计View
    _headStatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h/2.8)];
    _headStatView.backgroundColor = JWColor(122, 197, 39);
    [self.view addSubview:_headStatView];
    
    
    //标题图View
    _headTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headStatView.frame), self.view.mj_w, 44)];
     _headTitleView.backgroundColor = JWColor(249, 249, 249);
    [self.view addSubview:_headTitleView];
    
    //成绩信息View
    _footerTVView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headTitleView.frame), self.view.mj_w, self.view.mj_h-CGRectGetMaxY(_headTitleView.frame))];
    _footerTVView.separatorColor = [UIColor colorWithWhite:0.94 alpha:1];

    if ([[UIDevice currentDevice]systemVersion].floatValue>8.0) {
        _footerTVView.layoutMargins=UIEdgeInsetsZero;
    }
    _footerTVView.delegate = self;
    _footerTVView.dataSource = self;
    [self.view addSubview:_footerTVView];
    
    //创建ImageView
    _dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 12, 20, 20)];
    _dateImageView.image = [UIImage imageNamed:dateImage];
//    _dateImageView.backgroundColor = [UIColor redColor];
    
    _scoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateImageView.frame)+35, 12, 20, 20)];
    _scoreImageView.image = [UIImage imageNamed:scoreImage];
    
    _pyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headTitleView.frame)-90, 12, 20, 20)];
    _pyImageView.image = [UIImage imageNamed:pyImage];
    
    _timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_pyImageView.mj_x-58, 12, 20, 20)];
    _timeImageView.image = [UIImage imageNamed:timeImage];
    
    //循环添加ImageView
    NSArray *arrImageView = @[_dateImageView, _scoreImageView, _timeImageView, _pyImageView];
    for(int i=0; i<arrImageView.count; i++){
       [_headTitleView addSubview:[arrImageView objectAtIndex:i]];
    }
}

#pragma mark - 顶部统计图
- (void)loadChart{
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 15, _headStatView.mj_w, _headStatView.mj_h-10)];
    self.lineChart.yLabelFormat = @"%d";
    self.lineChart.backgroundColor = [UIColor clearColor];
    if(_wdcjScoreArr.count >10){
        for(int i=0; i<_wdcjScoreArr.count; i++){
            [_wdcjTitleArr addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        self.lineChart.xLabels = _wdcjTitleArr;
    }else{
       [self.lineChart setXLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7", @"8", @"9", @"10"]];
    }
    
//    _lineChart.xLabelColor = [UIColor whiteColor];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.axisColor = [UIColor whiteColor];
//    self.lineChart.sh
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 100;
    self.lineChart.yFixedValueMin = 0;
    
    [self.lineChart setYLabels:@[@"0",@"20",@"40",@"60",@"80",@"100",]];
//    [self.lineChart setXLabelColor:[UIColor whiteColor]];
    // Line Chart #1
    NSArray * data01Array = [NSArray array];
    
    data01Array = _wdcjScoreArr;
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = [UIColor whiteColor];
    data01.alpha = 0.8f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
//    self.lineChart.delegate = self;
    [_headStatView addSubview:_lineChart];
    
//    UIView *zView = [[UIView alloc] initWithFrame:_lineChart.frame];
//    zView.backgroundColor = [UIColor redColor];
//    [_lineChart addSubview:zView];
}
#pragma mark - 统计图点击代理事件 - 暂时不需要
//- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
//    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
//}
//
//- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
//    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
//}

#pragma mark - 加载底部成绩数据
- (void)loadDataView{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id = [ud objectForKey:@"drivecode"];
    NSString *cardNo = [ud objectForKey:@"per_idcardno"];
    NSString *km = [ud objectForKey:@"lblKSKM"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=mnks&prc=prc_app_getkslist&parms=schoolid=%@|userid=%@|km=%@", school_id, cardNo, km];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
        JWWDCJStatModel *wdcjStat = [JWWDCJStatModel objectWithKeyValues:dic];
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            self.wdcjStat = [JWWDCJStatBodyModel objectArrayWithKeyValuesArray:wdcjStat.body];
            for(int i=0; i<_wdcjStat.count; i++){
                [_wdcjScoreArr addObject:[[_wdcjStat objectAtIndex:i] valueForKeyPath:@"kaofenshu"]];
            }
            [MBProgressHUD hideHUD];
            [_footerTVView reloadData];
            [self loadChart];
            // 结束刷新状态
            [_footerTVView.header endRefreshing];
        }else{
            [MBProgressHUD hideHUD];
            // 结束刷新状态
            [_footerTVView.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        // 结束刷新状态
        [_footerTVView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _wdcjStat.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JWWDCJCell *cell = [JWWDCJCell cellWithTableView:tableView];
    if ([[UIDevice currentDevice]systemVersion].floatValue>8.0) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    [cell cellWithIndexPath:indexPath];
    cell.wdcjStat = _wdcjStat[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
@end
