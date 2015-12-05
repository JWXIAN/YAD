//
//  YADPickUpTV.m
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADPickUpTV.h"
#import "YADPickUpTVCell.h"
#import "UIView+MJExtension.h"
#import "UILabel+JWContentSize.h"
#import "PrefixHeader.pch"
//定位
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "SVProgressHUD.h"
#import "JJPickUpInfoAPI.h"


@interface YADPickUpTV () <CLLocationManagerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
/**定位当前位置*/
@property (nonatomic, strong) UIButton *btnPosition;
@end

@implementation YADPickUpTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
//    //隐藏多余行
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
    //底部View
    self.tableView.tableFooterView = [self tableViewFooterView];
    [self loadUserLocation];
}
- (void)loadUserLocation{
    //请求定位服务
//    _locationManager=[[CLLocationManager alloc]init];
//    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
//        [_locationManager requestWhenInUseAuthorization];
//    }
    //位置反编码
    _geocoder=[[CLGeocoder alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 10; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        //在ios 8.0下要授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [_locationManager requestWhenInUseAuthorization]; //使用程序时获取位置
            // - (void)requestAlwaysAuthorization;  //始终允许访问位置获取
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currLocation = [locations lastObject];
    [self getAddressByLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
}

//定位失败，回调此方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        [SVProgressHUD showErrorWithStatus:@"请开启应用定位权限"];
    }
    if ([error code]==kCLErrorLocationUnknown) {
        [SVProgressHUD showErrorWithStatus:@"无法获取当前位置"];
    }
}
#pragma mark 根据坐标取得地址
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        if (placemark.name == nil) {
            [_btnPosition setTitle:@"点击重新获取位置" forState:UIControlStateNormal];
        }else{
            [_btnPosition setTitle:placemark.name forState:UIControlStateNormal];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
            YADPickUpTVCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.textDetail.text.length == 0) {
                cell.textDetail.text = [placemark.name substringFromIndex:2];
            }
        }
    }];
}
#pragma mark - 加载底部View
- (UIView *)tableViewFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 135)];
    
    //定位当前位置
    _btnPosition = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, self.view.mj_w-100, 30)];
    [_btnPosition setTitle:@"点击获取当前位置" forState:UIControlStateNormal];
    [_btnPosition setImage:[UIImage imageNamed:@"tabbar_home"] forState:UIControlStateNormal];
    [_btnPosition setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnPosition.titleLabel.font = [UIFont systemFontOfSize:14];
    _btnPosition.layer.borderWidth = 0.5;
    _btnPosition.layer.borderColor = [JWColor(188, 187, 192) CGColor];
    _btnPosition.layer.cornerRadius = 5;
    [_btnPosition addTarget:self action:@selector(btnPositionClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnPosition];
    
    //提交预约
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(50, 35, self.view.mj_w-100, 44)];
    [btnSubmit setTitle:@"提交预约" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSubmit setBackgroundColor:JWColor(232, 94, 84)];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit addTarget:self action:@selector(btnSubmitPickUpClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSubmit];
    
    NSString *strText = @"*注意事项 \n*须提前24小时预约VIP接送车，否则预约无效，司机会在指定预约时间前5分钟联系预约学员，请学员注意时间，按时到达预约地点，以免耽误学车时间。";
    UILabel *lblPrompt = [[UILabel alloc] init];
    lblPrompt.text = strText;
    lblPrompt.textAlignment = NSTextAlignmentLeft;
    lblPrompt.textColor = [UIColor grayColor];
    lblPrompt.font = [UIFont systemFontOfSize:14];
    lblPrompt.numberOfLines = 0;
    NSInteger w = [lblPrompt JWContentSize].width;
//    NSInteger h = [lblPrompt JWContentSize].height;
    if (w > self.view.mj_w-20) {
        w /= self.view.mj_w;
    }
    lblPrompt.frame = CGRectMake(10, CGRectGetMaxY(btnSubmit.frame)+20, self.view.mj_w-20, w*44+20);
    [view addSubview:lblPrompt];
    return view;
}
#pragma mark - 重新定位
- (void)btnPositionClick{
    [_locationManager startUpdatingLocation];
    [_btnPosition setTitle:@"正在获取当前位置..." forState:UIControlStateNormal];
}

#pragma mark - 提交预约
- (void)btnSubmitPickUpClick{
    [SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    YADPickUpTVCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textDetail.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空", cell.lblTitle.text]];
    }else{
        //预约手机号
        [dic setObject:cell.textDetail.text forKey:@"pickUpPhone"];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.textDetail.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空", cell.lblTitle.text]];
            dic = [NSMutableDictionary dictionary];
        }else{
            //预约地址
            [dic setObject:cell.textDetail.text forKey:@"pickUpAdd"];
            //预约接送时间
            indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            //格式化时间
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *date = [formatter stringFromDate:cell.datePicker.date];
            [dic setObject:date forKey:@"pickUpDate"];
            //预约时间
            [dic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"pickUpMakeTime"];
            
            //保存预约
            [JJPickUpInfoAPI savePickUpInfo:dic callback:^(NSDictionary *result) {
                [SVProgressHUD dismiss];
            }];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADPickUpTVCell *cell = [YADPickUpTVCell cellWithTableView:tableView];
    [cell cellWithTitleDetail:indexPath];
    if (indexPath.section == 1) {
        cell.textDetail.text = _studentLogin.per_name;
    }else if (indexPath.section == 2){
        cell.textDetail.text = _studentLogin.per_mobile;
    }
    cell.textDetail.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 50;
    }else{
       return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
