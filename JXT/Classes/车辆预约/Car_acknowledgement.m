//
//  Car_acknowledgement.m
//  JXT
//
//  Created by 1039soft on 15/7/30.
//  Copyright (c) 2015年 JW. All rights reserved.


//预约

#import "Car_acknowledgement.h"
#import "BespokeCell.h"
#import "Bespoke_verify.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "TePeriodListInfo.h"
#import "JiaxiaotongAPI.h"
#import "TeacherTime.h"
#import "PopoverView.h"
#import "JWgetappointment.h"
#import "WeatherModel.h"
#import "MJExtension.h"

@interface Car_acknowledgement ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectday_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enableday_w;
@property (weak, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UITableView *timetab;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *carcode;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIButton *canselectday;

@property(strong,nonatomic)NSMutableArray* muarr;//教练可约时段数组
@property(strong,nonatomic)NSMutableArray* muarr2;//保存预约日期  日期+时间
@property(strong,nonatomic)NSMutableArray* muarr3;//保存预约日期  日期
@property(strong,nonatomic)NSMutableArray* muarr4;//选择日期后的数组内容;  控制选择后的cell日期
@property(strong,nonatomic)NSMutableArray* muarr5;//存放改变日期后的内容 控制按钮图片
@property(strong,nonatomic)  NSArray* QAQ ;
@property(strong,nonatomic) WeatherModel* weather;//天气模型
@property(strong,nonatomic) NSArray*  weatherArr;//未来7天和当前天天气
@end



@implementation Car_acknowledgement
#pragma mark - 打电话
- (IBAction)call:(UIButton *)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_tel.text]]];
}
#pragma mark - 发短信
- (IBAction)meesage:(UIButton *)sender {
       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_tel.text]]];
}
- (IBAction)canse:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"可约时段"]) {
        
        [sender setTitle:@"全部时段" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"可约时段" forState:UIControlStateNormal];
    }

    [_muarr4 removeAllObjects];
    [_muarr5 removeAllObjects];
    for (int i=0; i<_muarr.count; i++) {
        TePeriodListInfo* mur55=_muarr[i];
        if ([sender.titleLabel.text isEqualToString:@"全部时段"]) {
            [_muarr4 addObject:_muarr2[i]];
            [_muarr5 addObject:_muarr[i]];
              [_timetab reloadData];
            
        }
        if ([sender.titleLabel.text isEqualToString:@"可约时段"]) {
            if ([mur55.pxinfo isEqualToString:@"Y"]) {
                [_muarr4 addObject:_muarr2[i]];
                [_muarr5 addObject:_muarr[i]];
                  [_timetab reloadData];
            }
        }
    }
  
}
- (IBAction)selectday:(UIButton *)sender {
    CGPoint point = CGPointMake(sender.center.x , sender.frame.origin.y+60 + sender.frame.size.height);
    
    NSArray* titles=_QAQ;
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        [sender setTitle:titles[index] forState:UIControlStateNormal];
        [_muarr4 removeAllObjects];
        [_muarr5 removeAllObjects];
        for (int i=0; i<_muarr.count; i++) {
            if ([titles[index] isEqualToString:_muarr3[i]]) {
                [_muarr4 addObject:_muarr2[i]];
                [_muarr5 addObject:_muarr[i]];
            }
        }
          [_canselectday setTitle:@"可约时段" forState:UIControlStateNormal];
        [_timetab reloadData];
        
    };
    
    [pop show];
}

-(void)updateViewConstraints
{
     [super updateViewConstraints];
    _selectday_w.constant=self.view.frame.size.width/2-22;
    _enableday_w.constant=self.view.frame.size.width/2-22;
}
-(void)viewWillAppear:(BOOL)animated
{  [super viewWillAppear:animated];
//    [MBProgressHUD hideHUDForView:self.view];
    [self geturl];
 
}
-(void)refreshSegment:(UIBarButtonItem*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self geturl];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _muarr=[NSMutableArray array];
    _muarr2=[NSMutableArray array];
    _muarr3=[NSMutableArray array];
    _muarr4=[NSMutableArray array];
    _muarr5=[NSMutableArray array];
    _weather=[[WeatherModel alloc]init];
    self.title=@"预约";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action: @selector(refreshSegment:)];
    _timetab.delegate=self;
    _timetab.dataSource=self;
    
    _timetab.tableFooterView=[[UIView alloc]init];
    for (id obj in _headview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* button=obj;
            button.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:button.frame.size.height*0.5];
        
        }
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label=obj;
            label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.65];
        }
        
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verify:) name:@"verify" object:nil];
    _name.text=_driTeaListInfo.name;
    _type.text=_driTeaListInfo.type_name;
    _carcode.text=_driTeaListInfo.carcode;
    _tel.text=_driTeaListInfo.mobile;
    [_head sd_setImageWithURL:[NSURL URLWithString:_driTeaListInfo.photo] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    [self getWeather];
}
-(void)verify:(NSNotification*)sender
{
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    Bespoke_verify* verify=[story instantiateViewControllerWithIdentifier:@"verify"];
    
    
    verify.nowtime=_muarr4[[sender.userInfo[@"tag"] integerValue]];
    verify.driTeaListInfo=_driTeaListInfo;
    TePeriodListInfo* tepl=_muarr5[[sender.userInfo[@"tag"] integerValue]];
    verify.periodCode=tepl.periodCode;
    NSArray *array = [_muarr4[[sender.userInfo[@"tag"] integerValue]] componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString* sss=array[3];
    verify.shiduan=sss;
    [self.navigationController pushViewController:verify animated:YES];
}
#pragma mark - 获取数据
-(void)geturl
{
    
    //    [MBProgressHUD showMessage:@"获取数据"];
    [JiaxiaotongAPI requestTeacherTimeByTeacherTime:_driTeaListInfo.code view:self.view andCallback:^(id obj) {
        TeacherTime* teach=obj;
        _muarr=teach.teacherPeriodLists;
        for (int i=0; i<_muarr.count; i++) {
            TePeriodListInfo* teper= _muarr[i];
            NSString* daystring=[NSString stringWithFormat:@"%@ %@",teper.bookDate,teper.period];
            [_muarr2 addObject:daystring];
            [_muarr3 addObject:teper.bookDate];
        }
        _muarr4=[NSMutableArray arrayWithArray:_muarr2] ;
        _muarr5=[NSMutableArray arrayWithArray:_muarr];
       _QAQ=[self arrayWithMemberIsOnly:_muarr3];
        [_timetab reloadData];
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
    
}
#pragma mark - 获取天气信息
-(void)getWeather
{

    [JWgetappointment getWeatherInfoAndCallBack:^(id obj) {
        NSDictionary* dicTemp = obj;
        
        NSArray* arrTemp = dicTemp[@"HeWeather data service 3.0"];
        _weather.HeWeather_data_service_3=arrTemp.firstObject;
        _weather.status=_weather.HeWeather_data_service_3[@"status"];
        
        if ([_weather.status isEqualToString:@"ok"]) {
            _weather.daily_forecast=_weather.HeWeather_data_service_3[@"daily_forecast"];
            _weatherArr=_weather.daily_forecast;
            [_timetab reloadData];
        }
        else//获取天气失败
        {
            _weather=nil;
        }
        
        
        
        
    }];

}
#pragma mark -  去除数组中相同对象
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


#pragma mark tableview代理事件
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _muarr5.count;;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"bespoke";
    //从重用对象池中找不用的cell对象
    BespokeCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    //未找到创建
    if (cell==nil) {
        cell=[[BespokeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
//    cell.font= [UIFont fontWithName:@"HelveticaNeue" size:cell.textLabel.frame.size.height*0.2];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
        NSString* tempS = _muarr4[indexPath.row];
        NSArray* tempArr= [tempS componentsSeparatedByString:@"  "];
     [cell setCellWithTimeInfo:tempArr andWeather:_weatherArr];
//    cell.textLabel.text=_muarr4[indexPath.row];
    cell.bespoke.tag=indexPath.row;
    TePeriodListInfo* mur5=_muarr5[indexPath.row];
    if ([mur5.pxinfo isEqualToString:@"Y"]) {
        [cell.bespoke setBackgroundImage:[UIImage imageNamed:@"lijiyuyue"] forState:UIControlStateNormal];
        [cell.bespoke setEnabled:YES];
        cell.userInteractionEnabled=YES;
    }
    else if([mur5.pxinfo isEqualToString:@"p"])
    {
        [cell.bespoke setBackgroundImage:[UIImage imageNamed:@"yibeiyue"] forState:UIControlStateNormal];
        [cell.bespoke setEnabled:NO];
        cell.userInteractionEnabled=NO;
    }
    else
    {
        [cell.bespoke setBackgroundImage:[UIImage imageNamed:@"yitingyong"] forState:UIControlStateNormal];
        [cell.bespoke setEnabled:NO];
        cell.userInteractionEnabled=NO;
    }

   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    Bespoke_verify* verify=[story instantiateViewControllerWithIdentifier:@"verify"];
    verify.nowtime=_muarr4[indexPath.row];
    verify.driTeaListInfo=_driTeaListInfo;
    TePeriodListInfo* tepl=_muarr5[indexPath.row];
    verify.periodCode=tepl.periodCode;
    NSArray *array = [_muarr4[indexPath.row] componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString* sss=array[3];
    verify.shiduan=sss;
    [self.navigationController pushViewController:verify animated:YES];
    
 

    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
