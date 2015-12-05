//
//  JWLXTJVC.m
//  JXT
//
//  Created by JWX on 15/8/31.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWLXTJVC.h"
#import "PNChart.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "JWLXTJView.h"
#import "exam.h"


@interface JWLXTJVC ()
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic, strong) NSArray *statArr;
@property (nonatomic, strong) NSArray *titleValueArr;
@property (nonatomic, assign) int arrCTCount;
@property (nonatomic, assign) NSInteger arrCount;
@property (nonatomic, assign) int arrDTCount;
@end

@implementation JWLXTJVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JWColor(241, 241, 241);
    [self selectDCT];
    [self loadStatView];
    [self loadStatDetail];
}
- (void)selectDCT{
    _arrCTCount = 0;
    _arrDTCount = 0;
    NSArray *topic = [exam selectWhere:nil groupBy:nil orderBy:nil limit:nil];
    _arrCount = topic.count;
    for(int i=0; i<topic.count; i++){
        if([[[topic objectAtIndex:i] valueForKeyPath:@"answerWere"] isEqualToString:@"true"]){
            _arrCTCount +=1;
        }else{
            _arrDTCount +=1;
        }
    }
}
//加载统计View
- (void)loadStatView{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *dt = [ud objectForKey:@"dtCountArr"];
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:_arrCount-_arrCTCount color:PNTitleColor description:@"未做题"],
                       [PNPieChartDataItem dataItemWithValue:dt.intValue color:PNBlue description:@"答对题"],
                       [PNPieChartDataItem dataItemWithValue:_arrCTCount color:PNTwitterColor description:@"答错题"],
                       ];
    
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.mj_w/2-(self.view.mj_w/2+100)/2+30, 70, self.view.mj_h/2-60, self.view.mj_h/2-60) items:items];
    //统计值数组
    _statArr = _pieChart.valueArr;
    //值数组
    _titleValueArr = _pieChart.titleValueArr;
  
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];

    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:14.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(0, self.pieChart.mj_y+50, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    [self.view addSubview:self.pieChart];
    
}
//加载统计详情
- (void)loadStatDetail{
    // 1.主View
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(8, self.view.mj_h/2+40, self.view.mj_w-16, 190)];
    detailView.layer.cornerRadius = 5;
    detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailView];
    
    // 2.Title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, detailView.mj_w, 30)];
    lblTitle.text = @"练习统计";
    lblTitle.textColor = JWColor(124, 124, 124);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [detailView addSubview:lblTitle];
    // 3.下划线
    UIView *xhxView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lblTitle.frame)+8, detailView.mj_w - 10, 1)];
    xhxView.backgroundColor = JWColor(241, 241, 241);
    [detailView addSubview:xhxView];
    // 4.统计明细
    JWLXTJView *lxtjView = [[JWLXTJView alloc] init];
    lxtjView.frame = CGRectMake(5, CGRectGetMaxY(xhxView.frame)+5, detailView.mj_w-10, 120);
    // 5.拿出数组%
    lxtjView.lblWZTL.text = [_statArr objectAtIndex:0];
    lxtjView.lblDDTL.text = [_statArr objectAtIndex:1];
    lxtjView.lblDCTL.text = [_statArr objectAtIndex:2];
    //拿出值
    lxtjView.lblWZT.text = [_titleValueArr objectAtIndex:0];
    lxtjView.lblDDT.text = [_titleValueArr objectAtIndex:1];
    lxtjView.lblDCT.text = [_titleValueArr objectAtIndex:2];
    
    [detailView addSubview:lxtjView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
