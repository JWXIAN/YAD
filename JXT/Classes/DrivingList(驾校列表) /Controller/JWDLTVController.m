//
//  JWDLTVController.m
//  JXT
//
//  Created by JWX on 15/6/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWDLTVController.h"
#import "JsonPaser.h"
#import "JiaxiaotongAPI.h"
#import "AFNetworking.h"
#import "JWDriveBodyModel.h"
#import "JWDriveHeadModel.h"
#import "JWDLTVCell.h"
#import "JWTarBarController.h"
#import "MBProgressHUD+MJ.h"
#import "JWLoginController.h"
#import "PrefixHeader.pch"
#import <CoreLocation/CoreLocation.h>
#import "tool.h"
#import "JWLoginController.h"
#import "JXT-swift.h"
#import "UIView+MJExtension.h"


@interface JWDLTVController ()  <UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
/**存放驾校数据*/
@property (nonatomic,strong)NSMutableArray * driveHeads,* tabarr,* province,* province_temp,* city;//保存获取到的驾校列表， 保存搜索完后的驾校列表,保存省,保存搜索时的省,保存每个省的市
@property(strong,nonatomic) NSArray* grouping;//分好组的对象
@property (nonatomic, strong) NSMutableArray *searchResultDataArray;            // 存放搜索出结果的数组
@property(strong,nonatomic) UITableView* tableView;
@property (nonatomic,retain) UISearchBar* searchBar;
@property(strong,nonatomic) UIButton* nowCity;//创建当前城市按钮
@property(strong,nonatomic) NSString* nowCityName,* provinceNow;//当前城市,省
@property(nonatomic,retain)CLLocationManager *locationManager;

@property(assign,nonatomic) NSInteger key,citykey;//是否显示定位
@property(strong,nonatomic) JWDriveBodyModel* drivemodel;//驾校模型
@property(strong,nonatomic) UILabel*  cityNowLabel;//显示城市的section
//@property(strong,nonatomic) NSMutableArray*  tempCityarrM;

@end

@implementation JWDLTVController

//-(void)refreshSegments:(UIBarButtonItem* )sender
//{
////    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.navigationController) {
//         [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//         [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
   
    
    
      [self locate];
//    UINavigationBar* naviga=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44)];
//        naviga.barTintColor=JWColor(67, 153, 213);
//    UINavigationItem* bartitem= [[UINavigationItem alloc]init];
//    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
//    title.text=@"选择驾校";
//    title.textColor=[UIColor whiteColor];
//    title.textAlignment=NSTextAlignmentCenter;
//    [naviga addSubview:title];
//   
////    bartitem.titleView=title;
//    bartitem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action: @selector(refreshSegments:)];
//        NSArray* arr=@[bartitem];
//        [naviga setItems:arr];
//       naviga.tintColor=[UIColor whiteColor];
//    
//        [self.view addSubview:naviga];
    self.view.backgroundColor=[UIColor whiteColor];

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _searchBar.placeholder = @"城市/编号/名称";   //设置占位符
    _searchBar.delegate = self;   //设置控件代理
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_searchBar];
    
    [self loadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
   
    // 1. 获取输入的值
    NSString *conditionStr =searchText;
    
    // 2. 创建谓词，准备进行判断的工具
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.phoneNumber CONTAINS [CD] %@ OR self.name CONTAINS [CD] %@ OR self.gender CONTAINS [CD] %@", conditionStr, conditionStr, conditionStr];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.qyname CONTAINS [CD] %@ OR self.qyid CONTAINS [CD] %@ OR self.shengfen CONTAINS [CD] %@ OR self.shiqu CONTAINS [CD] %@", conditionStr, conditionStr, conditionStr, conditionStr];
    
    // 3. 使用工具获取匹配出的结果
    self.searchResultDataArray = [NSMutableArray arrayWithArray:[_driveHeads filteredArrayUsingPredicate:predicate]];
    
    
    //如果搜索栏为空，代表我们没有在搜索，tableView需要显示原数据。如果不为空，代表我们在搜索，tableView要显示搜索结果
    if (searchBar.text == nil || [searchBar.text isEqualToString:@""]) {
        _tabarr=_driveHeads;
        _province_temp=_province;
         _key=1;
    }
    else
    {
        _tabarr=_searchResultDataArray;
        _province_temp=nil;
         _key=0;
    }
    
     _grouping=[tool requirementArray:_province targetArray:_tabarr  key:@"shengfen"];
    // 4. 刷新页面，将结果显示出来
    [self.tableView reloadData];
}
#pragma mark 将要开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    return YES;
}
#pragma mark 开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    for (id obj in [_searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    
    searchBar.text = @"";
    
}
#pragma mark 结束搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = NO;
    
}
#pragma mark 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.text = @"";
    
    [_searchBar resignFirstResponder];
     _tabarr=_driveHeads;
    _province_temp=_province;
    _key=1;
//    _grouping=[tool requirementArray:_province targetArray:_tabarr  key:@"shengfen"];
     _grouping=[Tool_swift requirementArray:_province array2:_tabarr key:@"shengfen"];
    
    [_tableView reloadData];
    
}





/**加载驾校数据*/
- (void)loadData
{
    _key=1;
    self.driveHeads = [NSMutableArray array];
    self.searchResultDataArray = [NSMutableArray array];
//    _tempCityarrM=[NSMutableArray array];
    _tabarr=[NSMutableArray array];
    _province=[NSMutableArray arrayWithObject:@"当前"];
    _city=[NSMutableArray array];
    [MBProgressHUD showMessage:nil];
    [JiaxiaotongAPI requestDriveByDriveID:nil andCallback:^(id obj) {
         [MBProgressHUD hideHUD];
        JWDriveHeadModel *drive =obj;
     
        _driveHeads=drive.driveHeads;
        _tabarr=_driveHeads;
        //取出省份并分组
        for (_drivemodel in _driveHeads)
        {
            [_province addObject:_drivemodel.shengfen];
           
        }
//        _province=(NSMutableArray*)[tool arrayWithMemberIsOnly:_province];
        _province=(NSMutableArray*)[Tool_swift arrayWithMemberIsOnly:_province];
        _province_temp=_province;
        _grouping=[tool requirementArray:_province targetArray:_tabarr  key:@"shengfen"];
        
        //取出每个省的市区并分组
        for (int i=0; i<_grouping.count; i++) {
            NSMutableArray* city_temp=[NSMutableArray array];
            for (_drivemodel in _grouping[i]) {
                [city_temp addObject:_drivemodel.shiqu];
            }
           
            city_temp=(NSMutableArray*)[self arrayWithMemberIsOnly:city_temp];

            [_city addObject:city_temp];
        }
         
        [_tableView reloadData];
        
       
      
        NSUInteger section= [tool isInArr:_province key:_provinceNow];

        if (section!=-1) {
            NSArray* arrTemp=_city[section];
            NSUInteger row=[tool isInArr:arrTemp key:_nowCityName];
            if (row!=-1) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            }
            
        }

       
    }];
    
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    else
    {
        return 130;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return _grouping.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (section==0)
    {
        return _key;
    }
  
    else
    {
        NSArray* temp=_grouping[section];
        return temp.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString* one=@"one";
        UITableViewCell* cellOne=[tableView dequeueReusableCellWithIdentifier:one];
  
        if (cellOne== nil) {
            cellOne = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:one];
            cellOne.textLabel.text=@"当前定位城市";
            _nowCity=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 10, 60, 40)];
           
           
        }
       
        [_nowCity setTitle:_nowCityName forState:UIControlStateNormal];
        
        if (_nowCityName) {
            NSUserDefaults* user =  [NSUserDefaults standardUserDefaults];
            [user setObject:_nowCityName forKey:@"nowCityName"];
            [user synchronize];
        }
        
        
        _nowCity.backgroundColor=[UIColor colorWithRed:0 green:245.f/255.f blue:164.f/255.f alpha:1];
        _nowCity.tintColor=[UIColor whiteColor];
        _nowCity.layer.cornerRadius=10;
        _nowCity.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:_nowCity.frame.size.height*0.5];
        [_nowCity addTarget:self action:@selector(nowCity:) forControlEvents:UIControlEventTouchUpInside];
        [cellOne addSubview:_nowCity];
        cellOne.selectionStyle=UITableViewCellSelectionStyleNone;
        return cellOne;
    }
    else
    {
        static NSString *ID = @"cell";
        JWDLTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell== nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JWDLTVCell" owner:self options:nil]lastObject];
           _cityNowLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width, 10)];
        }
   
           JWDriveBodyModel* body=_grouping[indexPath.section][indexPath.row];
        
       
        
        NSMutableArray* tempCity=[NSMutableArray array];
        [tempCity addObject:body.shiqu];
        if (![_city[indexPath.section][indexPath.row] isEqualToString:@"否"]) {
            _cityNowLabel.text=body.shiqu;
            _cityNowLabel.textColor=[UIColor lightGrayColor];
            _cityNowLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:_cityNowLabel.frame.size.height*1.2];
            [cell.contentView addSubview:_cityNowLabel];
            
        }
        cell.driveData=body;
        return cell;
        
    }
    
    
    

}
// 右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _province_temp;
}
//点击索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
   
        [MBProgressHUD showSuccess:_province_temp[index]];

    
    return index;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//     [MBProgressHUD showSuccess:_province_temp[section]];
    
    if (section==0)
    {
        if (_key) {
            return @"当前城市";
        }
        else
        {
            return nil;
        }
    }
   
    else
    {
        
        if (_province_temp.count>1)
        {
            return _province_temp[section];
        }
        else
        {
            return nil;
        }
        
    }
}


#pragma mark - 选择后跳转到登陆页面 将驾校名传到登陆页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {

        JWDriveBodyModel *driveData =_grouping[indexPath.section][indexPath.row];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:driveData.qyid forKey:@"drivecode"];
        [ud setObject:driveData.qyname forKey:@"drivename"];
        [ud synchronize];

        [self.delegate passValue:driveData];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma tableview按钮事件
- (void)nowCity:(UIButton* )sender
{
    [self locate];
    //tableview滚动到指定位置
    

  
    NSUInteger section= [tool isInArr:_province key:_provinceNow];
    if (section!=-1) {
        NSArray* arrTemp=_city[section];
        NSUInteger row=[tool isInArr:arrTemp key:_nowCityName];
        if (row!=-1) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    }
    else
    {
        [MBProgressHUD showError:@"当前城市未开通"];
    }
    
    
 
}



#pragma mark - 定位
- (void)locate

{
    
    // 判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
    }else {
        
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  
                                  @"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
    }
    
    // 开始定位
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];//     前台定位
        
     
    }
    [self.locationManager startUpdatingLocation];
    
}
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations

{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             
             //获取城市
             
             NSString *city = placemark.locality;
             _provinceNow=placemark.administrativeArea;
            
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 
             }
             
//             [[NSUserDefaults standardUserDefaults]setObject:city forKey:@"nowCityName"];
             _nowCityName=[city substringToIndex:2];
             
             [self.tableView reloadData];
           
             
         }
         
         else if (error == nil && [array count] == 0)
             
         {
             
             NSLog(@"No results were returned.");
             
         }
         
         else if (error != nil)
             
         {
             
             NSLog(@"An error occurred = %@", error);
             
         }
         
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
    
}

#pragma mark - tableview中每个省去除显示重复的市
- (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
        }
        else
        {
            [categoryArray addObject:@"否"];
            
        }
    }
    return categoryArray;
}

@end
