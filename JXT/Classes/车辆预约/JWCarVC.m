//
//  JWCarVC.m
//  JXT
//
//  Created by 1039soft on 15/7/27.
//  Copyright (c) 2015年 JW. All rights reserved.



/**
 *  练车预约
 *
 *  @return 老板托喜欢拖工资，请各为同行注意
 *
 *  @since 2.0.2
 */
#import <MapKit/MapKit.h>

#import "JWCarVC.h"
#import "carcell.h"


#import "JiaxiaotongAPI.h"
#import "JWVenicleHeadModel.h"
#import "JWVenicleBodyModel.h"
#import "MapViewController.h"
#import "JWappraiseTVC.h"
#import "JsonPaser.h"
#import "JWRecordVC.h"
#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "Car_acknowledgement.h"

#warning 这个加载界面效果不好
#import "MBProgressHUD+MJ.h"

#import "jxt-swift.h"
#import "JWStudentDriverTV.h"
#import "JWgetappointment.h"
#import "LeisureModel.h"
#import "MJExtension.h"
#import "LeisureSelectCell.h"
#import "Bespoke_verify.h"
#define _allowAppearance    NO
#define _bakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define _tintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define _hairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]


@interface JWCarVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray* arr,* arr2;
    NSArray* acan,* acan2;
    JWVenicleBodyModel* veh,* veh2;
    NSString* a,* a2;
}



@property(strong,nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *menuItems;//顶部选项卡内容
//教练列表
@property(strong,nonatomic) UITableView* tabview1, * tabview2;

@property(strong,nonatomic) UITableView* selectTable;//空段查询列表

/**教练信息数据模型*/
@property (nonatomic,strong)NSMutableArray *vehicleHeads,* vehicleHeads2;
@property (nonatomic,strong)NSString * teachinfo;

//section标题
@property(strong,nonatomic)NSMutableArray* headsection,* headsection2;
@property(strong,nonatomic)NSMutableDictionary* dic,* dic2;

//更新地址

@property(strong,nonatomic)  NSArray* ccc;
//选择上面哪个按钮
@property(assign,nonatomic) NSInteger whichButton;

@property(strong,nonatomic) NSString *beginTime, *endTime;//记录开始时间和结束时间

@property(strong,nonatomic) NSMutableArray* teacherInfoArr;
@property(strong,nonatomic)  NSDate* beginDate,* endDate;//开始时间结束时间
@end


@implementation JWCarVC

#pragma mark - 通知
#pragma  mark 地图通知
-(void)openmap:(NSNotification*)sender
{
    NSString* a=sender.userInfo[@"longitude"];//经度
    NSString* b=sender.userInfo[@"latitude"];//纬度
    
    //根据经纬度解析成位置
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocationDegrees la=[b doubleValue],lb=[a doubleValue];
    CLLocation* location=[[CLLocation alloc]initWithLatitude:la longitude:lb];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark=[placemark objectAtIndex:0];
         
         NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     mark.name,@"address",//详细地址
                                     mark.subLocality,@"city",//区县
                                     @"google",@"from_map_type",
                                     b,@"google_lat",
                                     a,@"google_lng",
                                     [NSString stringWithFormat:@"%@%@",mark.administrativeArea,mark.locality],@"region",//省，市
                                     nil];
         
         
         MapViewController *mv = [[MapViewController alloc] init];
         mv.navDic = dic;
         mv.mapType = RegionNavi;
         [self.navigationController pushViewController:mv animated:YES];
         
         
     } ];
    
}
#pragma  mark 评价列表通知
-(void)showappraise:(NSNotification*)sender
{
    JWappraiseTVC* atv=[[JWappraiseTVC alloc]init];
    atv.teachercode=sender.userInfo[@"teachercode"];
    [self.navigationController pushViewController:atv animated:YES];
}
#pragma mark 空段查询通知
-(void)LeisureSelect:(NSNotification *)sender
{
    [self setBespokeViewWithIndexPathRow:NULL OrModel:sender.object];
}

#pragma mark 预约完成
-(void)yuyuechenggong:(NSNotification *)sender
{
    [self dateBegain:nil];
    
}
#pragma mark - 预约记录
- (void)CARLog
{
    JWRecordVC *discover = [[JWRecordVC alloc] init];
    discover.title = @"预约记录";
    [self.navigationController pushViewController:discover animated:YES];
}

#pragma mark - 上面按钮的事件
-(void)button1:(UIButton*)sender//我的教练
{
    _scrollView.contentOffset=CGPointMake(0, 0);
    _whichButton=0;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[ExamButton class]]) {
            ExamButton* button = obj;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if ([button.titleLabel.text isEqualToString:@"全部教练"]) {
                [button setImage:[UIImage imageNamed:@"qbjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"预约记录"]) {
                [button setImage:[UIImage imageNamed:@"yyjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"空段查询"]) {
                [button setImage:[UIImage imageNamed:@"kysd (1)"] forState:UIControlStateNormal];
            }
        }
        
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"wdjl_1"] forState:UIControlStateNormal];
}
-(void)button2:(UIButton*)sender//全部教练
{
    _whichButton=1;
    _scrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[ExamButton class]]) {
            ExamButton* button = obj;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if ([button.titleLabel.text isEqualToString:@"我的教练"]) {
                [button setImage:[UIImage imageNamed:@"wdjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"预约记录"]) {
                [button setImage:[UIImage imageNamed:@"yyjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"空段查询"]) {
                [button setImage:[UIImage imageNamed:@"kysd (1)"] forState:UIControlStateNormal];
            }
        }
        
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"qbjl_1"] forState:UIControlStateNormal];

}
/**
 *  空段查询
 *
 *  @param sender 空段查询
 *
 *  @since 2.0.2
 */
-(void)button2New:(UIButton*)sender
{
    _whichButton=2;
    _scrollView.contentOffset=CGPointMake(self.view.frame.size.width*2, 0);
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[ExamButton class]]) {
            ExamButton* button = obj;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if ([button.titleLabel.text isEqualToString:@"全部教练"]) {
                [button setImage:[UIImage imageNamed:@"qbjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"我的教练"]) {
                [button setImage:[UIImage imageNamed:@"wdjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"预约记录"]) {
                [button setImage:[UIImage imageNamed:@"yyjl"] forState:UIControlStateNormal];
            }
        }
        
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"kysd_1 (1)"] forState:UIControlStateNormal];
}
-(void)button3:(UIButton*)sender
{
    JWRecordVC *discover = [[JWRecordVC alloc] init];
    discover.title=@"预约记录";
    [self.navigationController pushViewController:discover animated:YES];
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[ExamButton class]]) {
            ExamButton* button = obj;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if ([button.titleLabel.text isEqualToString:@"全部教练"]) {
                [button setImage:[UIImage imageNamed:@"qbjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"我的教练"]) {
                [button setImage:[UIImage imageNamed:@"wdjl"] forState:UIControlStateNormal];
            }
            if ([button.titleLabel.text isEqualToString:@"空段查询"]) {
                [button setImage:[UIImage imageNamed:@"kysd (1)"] forState:UIControlStateNormal];
            }
        }
        
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"yyjl_1"] forState:UIControlStateNormal];
}

#pragma mark - 时间选择事件
-(void)dateBegain:(UIDatePicker *)sender
{
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    if (sender) {
        if (sender.tag==1) {
            _beginTime=dateAndTime;
            _beginDate=select;
        }
        else
        {
            _endTime=dateAndTime;
            _endDate=select;
        }
    }
    
   
    if (_beginTime==nil) {
        _beginTime=[selectDateFormatter stringFromDate:[NSDate date]];
        _beginDate=[NSDate date];
    }
    if (_endTime!=nil) {
        NSArray* temp1 = [_beginTime componentsSeparatedByString:@" "];
        NSArray* temp2 = [_endTime componentsSeparatedByString:@" "];
        NSString* day = [NSString stringWithFormat:@"%@-%@",temp1[0],temp2[0]];
        NSString* time = [NSString stringWithFormat:@"%@-%@",temp1[1],temp2[1]];
        if (_endDate<_beginDate) {
           
            
            [MBProgressHUD showError:@"错误日期"];
        }
      
        else
        {
           
        
       
        [JWgetappointment getLeisureWithDay:day time:time Callback:^(id obj) {
          
         LeisureModel* leisure = [LeisureModel objectWithKeyValues:obj];
         LeisureModel* leisure2 = [LeisureModel objectWithKeyValues:leisure.head];
        if ([leisure2.statecode isEqualToString:@"2000"]) {
                _teacherInfoArr= [LeisureModel objectArrayWithKeyValuesArray:leisure.body];
        
            [_selectTable reloadData];
            
          }
         
            
        
        }];
      }
    }
    
  
}

#pragma mark - viewdidload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationController.navigationBar.alpha = 1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LeisureSelect:) name:@"LeisureSelect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yuyuechenggong:) name:@"yuyuechenggong" object:nil];
    _whichButton=0;
    NSInteger height = 0;
    if (self.navigationController.childViewControllers.count>=2) {
        if ([self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-2] isKindOfClass:[JWStudentDriverTV class]]) {
            height=self.navigationController.navigationBar.frame.size.height+20;
        }

    }
   //创建最上面的button
    ExamButton* button1 = [[ExamButton alloc]initWithFrame:CGRectMake(0, height, self.view.frame.size.width/4, 44)];
    [button1 setImage:[UIImage imageNamed:@"wdjl_1"] forState:UIControlStateNormal];
    [button1 setTitle:@"我的教练" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  

    
    [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ExamButton* button2 = [[ExamButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, height, self.view.frame.size.width/4, 44)];
    [button2 setImage:[UIImage imageNamed:@"qbjl"] forState:UIControlStateNormal];
    [button2 setTitle:@"全部教练" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ExamButton* button2New = [[ExamButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2/4, height, self.view.frame.size.width/4, 44)];
    [button2New setImage:[UIImage imageNamed:@"kysd (1)"] forState:UIControlStateNormal];
    [button2New setTitle:@"空段查询" forState:UIControlStateNormal];
    [button2New setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [button2New addTarget:self action:@selector(button2New:) forControlEvents:UIControlEventTouchUpInside];
    
    ExamButton* button3 = [[ExamButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*3/4,height , self.view.frame.size.width/4, 44)];
    [button3 setImage:[UIImage imageNamed:@"yyjl"] forState:UIControlStateNormal];
    [button3 setTitle:@"预约记录" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
    [button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button2New];
    [self.view addSubview:button3];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //初始化数据
    _dic=[NSMutableDictionary dictionary];
    _dic2=[NSMutableDictionary dictionary];
    arr =[NSMutableArray array];
    arr2=[NSMutableArray array];
    _teacherInfoArr=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openmap:) name:@"openmap" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showappraise:) name:@"showappraise" object:nil];
    _menuItems =@[@"我的教练",@"全部教练"];
    
    _headsection=[NSMutableArray array];
    _headsection2=[NSMutableArray array];
    //   _vehicleHeads
    if (height==0) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height+44, self.view.frame.size.width, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-68)];
    }
    else
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height+44, self.view.frame.size.width, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-68)];
    }
    
    CGSize size=CGSizeMake(self.view.frame.size.width*3, 0);
    _scrollView.contentSize=size;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled=YES;
    //隐藏滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.bounces=NO;//去除弹簧效果
    
    //我的教练列表
    _tabview1=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _scrollView.frame.size.height)];
    
    _tabview1.tag=0;
   
    //全部教练列表
    _tabview2=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, _scrollView.frame.size.height)];
    
    _tabview2.tag=1;
    
    
   //空段查询界面
    UIView* leisureView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, _scrollView.frame.size.height)];
    UILabel* beginDate = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width, 15)];
    beginDate.text=@"开始时间";
    beginDate.font=[UIFont systemFontOfSize:12];
    beginDate.textColor=[UIColor lightGrayColor];
    UIDatePicker* dateBeginSelect = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 17, self.view.frame.size.width, 45+35)];
    dateBeginSelect.tag=1;
    
    [dateBeginSelect addTarget:self action:@selector(dateBegain:) forControlEvents:UIControlEventValueChanged];
   
    UILabel* endDate = [[UILabel alloc]initWithFrame:CGRectMake(5, 65+35, self.view.frame.size.width, 15)];
    endDate.text=@"结束时间";
    endDate.font=[UIFont systemFontOfSize:12];
    endDate.textColor=[UIColor lightGrayColor];
    UIDatePicker* dateEndSelect = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 80+35, self.view.frame.size.width, 45+35)];
    dateEndSelect.tag=2;
     [dateEndSelect addTarget:self action:@selector(dateBegain:) forControlEvents:UIControlEventValueChanged];
    
    _selectTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 127+70, self.view.frame.size.width, self.view.frame.size.height-127-self.tabBarController.tabBar.frame.size.height-70)];
    _selectTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _selectTable.tag=2;
   
    _selectTable.delegate=self;
    _selectTable.dataSource=self;
    
    [leisureView addSubview:_selectTable];
    [leisureView addSubview:beginDate];
    [leisureView addSubview:endDate];
    [leisureView addSubview:dateBeginSelect];
    [leisureView addSubview:dateEndSelect];
    
    _tabview1.delegate=self;
    _tabview1.dataSource=self;
    _tabview2.delegate=self;
    _tabview2.dataSource=self;
    
    _tabview1.tableFooterView=[[UIView alloc]init];
    _tabview2.tableFooterView=[[UIView alloc]init];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:leisureView];
    [_scrollView addSubview:_tabview1];
    [_scrollView addSubview:_tabview2];
   
//    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    
//    [self loadData:_menuItems[0]];
//    
//    [self loadDataAllTeacher:_menuItems[1]];
    
    //预约记录
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(CARLog)];
    
   
    self.tabview1.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:@"我的教练"];
    }];
    
    self.tabview2.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataAllTeacher:@"全部教练"];
    }];
    [self.tabview1.mj_header beginRefreshing];
    [self.tabview2.mj_header beginRefreshing];
    
}




#warning 姓名字母传值已经按照顺序排序，如果传值没有排序，需要更改算法
#pragma mark - 获取数据
- (void)loadData:(NSString*)name
{
    [_headsection removeAllObjects];
  
    [_dic removeAllObjects];
    
    [_vehicleHeads removeAllObjects];
    [arr removeAllObjects];
      __weak typeof(self) thisself =self;
    
    [JiaxiaotongAPI requestDriTeacherListByDriTeacherList:name view:self.tabview1 andCallback:^(id obj) {
        JWVenicleHeadModel *driTeacher = [JsonPaser parserDriTeaListByDictionary:obj];
        thisself.vehicleHeads = driTeacher.driTeachersList;
        JWVenicleBodyModel* jwb;
        
        
        for (int i=0; i<thisself.vehicleHeads.count; i++) {
            jwb=thisself.vehicleHeads[i];
            
            [thisself.headsection addObject:jwb.orders];
        }
        thisself.headsection=[thisself arrayWithMemberIsOnly:thisself.headsection];
#warning 将教练信息分组，如果没有更好的算法请勿更改此处
        //为不同section设置不同数据源
        
        
        
        int info=0;
        for (int i=0; i<thisself.vehicleHeads.count; i++) {
            
            veh=thisself.vehicleHeads[i];
            
            if ([veh.orders isEqualToString:a])
            {
                [arr addObject:thisself.vehicleHeads[i]];
                NSArray* QAQ=[NSArray arrayWithArray:arr];
                [thisself.dic setObject:QAQ forKey:[NSString stringWithFormat:@"%d",info]];
                
            }
            else
            {
                acan=[NSArray arrayWithArray:arr];
                [thisself.dic setObject:acan forKey:[NSString stringWithFormat:@"%d",info-1]];
                [arr removeAllObjects];
                [arr addObject:thisself.vehicleHeads[i]];
                
                [thisself.dic setObject:arr forKey:[NSString stringWithFormat:@"%d",info]];
                info++;
                
            }
            a=veh.orders;
            
        }
        
        
        [thisself.tabview1 reloadData];
        
        //            }
 
        [thisself.tabview1.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:thisself.view];
//        [MBProgressHUD hideHUD];
        
    }];
    
}
/** 加载全部教练*/
- (void)loadDataAllTeacher:(NSString*)name
{
    
    [_headsection2 removeAllObjects];
    [_dic2 removeAllObjects];
    [_vehicleHeads2 removeAllObjects];
    [arr2 removeAllObjects];
    
    __weak typeof(self) thisself =self;
    [JiaxiaotongAPI requestDriTeacherListByDriTeacherList:name view:self.tabview2 andCallback:^(id obj) {
        JWVenicleHeadModel *driTeacher = [JsonPaser parserDriTeaListByDictionary:obj];
        thisself.vehicleHeads2 = driTeacher.driTeachersList;
        JWVenicleBodyModel* jwb;
        
        for (int i=0; i<thisself.vehicleHeads2.count; i++) {
            jwb=thisself.vehicleHeads2[i];
            
            [thisself.headsection2 addObject:jwb.orders];
        }
        thisself.headsection2=[thisself arrayWithMemberIsOnly:thisself.headsection2];
#warning 将教练信息分组，如果没有更好的算法请勿更改此处
        //为不同section设置不同数据源
        
        
        
        int info=0;
        
        
        for (int i=0; i<thisself.vehicleHeads2.count; i++) {
            
            veh2=thisself.vehicleHeads2[i];
            
            if ([veh2.orders isEqualToString:a2])
            {
                [arr2 addObject:thisself.vehicleHeads2[i]];
                NSArray* QAQ=[NSArray arrayWithArray:arr2];
                [thisself.dic2 setObject:QAQ forKey:[NSString stringWithFormat:@"%d",info]];
                
            }
            else
            {
                acan2=[NSArray arrayWithArray:arr2];
                [thisself.dic2 setObject:acan2 forKey:[NSString stringWithFormat:@"%d",info-1]];
                [arr2 removeAllObjects];
                
                [arr2 addObject:thisself.vehicleHeads2[i]];
                [thisself.dic2 setObject:arr2 forKey:[NSString stringWithFormat:@"%d",info]];
                info++;
                
            }
            a2=veh2.orders;
            
        }
        
        
        
        [thisself.tabview2 reloadData];
        [thisself.tabview2.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:thisself.view];
//        [MBProgressHUD hideHUD];
        
    }];
    
    
    
}
#pragma mark 去除数组中相同对象
-(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}


#pragma mark - uiscrollview代理方法
//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView//减速结束调用
{
    // 不可以用self.scrollView.contentOffset.x/pageWidth直接计算
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* button = obj;
            if (page==0)
            {
                if ([button.titleLabel.text isEqualToString:@"我的教练"])
                {
                    [self button1:button];
                }
                
            }
            else if(page == 1)
            {
                if ([button.titleLabel.text isEqualToString:@"全部教练"])
                {
                    [self button2:button];
                }
            }
            else if(page==2)
            {
                if ([button.titleLabel.text isEqualToString:@"空段查询"]) {
                    [self button2New:button];
                }
            }

        }
    }
}


#pragma mark tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    if (tableView.tag==2)
    {
        
        return 0;
    }
    else
    {
       return tableView.frame.size.width*0.05+0.4;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==2) {
        
        return 63;
    }
    else
    {
        UITableViewCell*   cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        
        return cell.frame.size.height;
    }
  
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag!=2) {
        
        UIView* vi=[[UIView alloc]initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, tableView.frame.size.width*0.2+0.4)];
        
        UIView* gay=[[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 0.4)];
        gay.backgroundColor=[UIColor lightGrayColor];
        gay.alpha=0.5;
        
        UIImageView* secb=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 50, tableView.frame.size.width*0.05)];
        secb.image=[UIImage imageNamed:@"dh"];
        
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, tableView.frame.size.width*0.05)];
        lab.tintColor=[UIColor clearColor];
        if (tableView.tag==0) {
            lab.text=self.headsection[section];
            
        }
        else
        {
            lab.text=_headsection2[section];
            
        }
        
        lab.textColor=[UIColor whiteColor];
        [vi addSubview:gay];
        [vi addSubview:secb];
        [vi addSubview:lab];
        return vi;
    }
  else
  {
      
      return nil;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if (tableView.tag==0) {
        
        return self.headsection.count;
        
    }
   else if(tableView.tag==1)
    {
        
        return self.headsection2.count;
       
    }
    else
    {
       
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* count;
    if (tableView.tag==0) {
        count=_dic[[NSString stringWithFormat:@"%ld",(long)section]];
        
    }
   else if (tableView.tag==1)
    {
         count=_dic2[[NSString stringWithFormat:@"%ld",(long)section]];
    }
    else
    {
  
        count=_teacherInfoArr;
    }
    
    return count.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //空段查询
    if (tableView.tag==2) {
        static NSString* cellID=@"mycell";
        //从重用对象池中找不用的cell对象
        LeisureSelectCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        //未找到创建
        if (cell==nil) {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"LeisureSelectCell" owner:nil options:nil] lastObject];
        }
        
        [cell setCellWithModel:_teacherInfoArr[indexPath.row]];
        
        return cell;
        
    }
    else
    {
        static NSString* cellID=@"keepcell";
        //从重用对象池中找不用的cell对象
        carcell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
        //未找到创建
        if (cell==nil) {
            CGFloat h=_scrollView.frame.size.height/3;
            if (self.view.frame.size.width<=320) {
                h=_scrollView.frame.size.height/2;
            }
            cell.frame=CGRectMake(0, 0, self.view.frame.size.width, h);
            cell=[[carcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID frame:CGRectMake(0, 0, self.view.frame.size.width, h)];
            
        }
        
        if (tableView.tag==0) {
            _ccc=_dic[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            
        }
        else
        {
            _ccc=_dic2[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        }
        cell.driTeaListInfo = _ccc[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell drawview];
        
        return cell;
    }
   
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (_whichButton==2) {
        
        [self setBespokeViewWithIndexPathRow:indexPath.row OrModel:nil];
    }
    else
    {
        NSArray* ccc2;
        if (_whichButton==0) {
            ccc2=_dic[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        }
        if (_whichButton==1) {
            ccc2=_dic2[[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        }
        
        
        
        UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        Car_acknowledgement* acknowledgement=[story instantiateViewControllerWithIdentifier:@"acknowledgement"];
        acknowledgement.driTeaListInfo=ccc2[indexPath.row];
        [self.navigationController pushViewController:acknowledgement animated:YES];
    }
    
    
}
// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //    return [self.vehicleHeads valueForKeyPath:@"orders"];
    if (tableView.tag==0) {
        return _headsection;
    }
    else if (tableView.tag==1) {
         return _headsection2;
    }
    else
    {
        
        return nil;
    }
    
}
//预约确认
- (void)setBespokeViewWithIndexPathRow:(NSInteger)row OrModel:(LeisureModel* )model
{
   
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    Bespoke_verify* acknowledgement=[story instantiateViewControllerWithIdentifier:@"verify"];
    LeisureModel* leisure;
    if (model==nil) {
       
        leisure=_teacherInfoArr[row];
     
    }
    else
    {
        leisure=model;
        
        
    }
    acknowledgement.shiduan=leisure.tinfo;
    acknowledgement.periodCode=leisure.period;
    acknowledgement.nowtime=leisure.pxdate;
    JWVenicleBodyModel* jwVenCle = [[JWVenicleBodyModel alloc]init];
    jwVenCle.photo=leisure.photo;
    jwVenCle.name=leisure.teachername;
    jwVenCle.code=leisure.teacherid;
    jwVenCle.type_name=leisure.typename;
    jwVenCle.type=leisure.typecode;
    jwVenCle.carcode=leisure.carcode;
    acknowledgement.driTeaListInfo=jwVenCle;
    [self.navigationController pushViewController:acknowledgement animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
////点击索引
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (tableView.tag==0) {
//        [MBProgressHUD showSuccess:_headsection[index]];
//
//    }
//    else
//    {
//          [MBProgressHUD showSuccess:_headsection2[index]];
//    }
//    return index;
//}

@end
