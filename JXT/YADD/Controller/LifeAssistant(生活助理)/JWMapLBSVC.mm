//
//  JWMapLBSVC.m
//  
//
//  Created by JWX on 15/9/28.
//
//

#import "JWMapLBSVC.h"
#import "SVProgressHUD.h"
#import "UIView+MJExtension.h"
//百度地图SDK
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface JWMapLBSVC ()<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UITextFieldDelegate>
/**地图View*/
//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

/**搜索的对象*/
@property (weak, nonatomic) IBOutlet UITextField *txtObject;

/**地图搜索*/
@property (nonatomic, strong) BMKPoiSearch *poisearch;

@property (nonatomic, assign) int curPage;

/**地图*/
@property (nonatomic, strong) BMKMapView *bmMapView;
/**定位*/
@property (nonatomic, strong) BMKLocationService *locService;

/**经纬度*/
@property (nonatomic, assign) CLLocationCoordinate2D *cllocation;
/**周边搜索区域名*/
@property (nonatomic, strong) NSString *strRegion;

/**搜索关键字*/
@property (nonatomic, strong) NSString *strKeyword;
/**搜索*/
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@end

@implementation JWMapLBSVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self loadMap];
}

- (void)loadMap{
    //poi附近搜索
    _poisearch = [[BMKPoiSearch alloc]init];
    //地图View
    _bmMapView = [[BMKMapView alloc]initWithFrame:_mapView.bounds];
    // 设置地图级别
    [_bmMapView setZoomLevel:19];
    _bmMapView.isSelectedAnnotationViewFront = YES;
    _locService = [[BMKLocationService alloc] init];
    
    _bmMapView.zoomEnabled = YES;   //设定地图View能否支持用户多点缩放(双指)
    _bmMapView.scrollEnabled = YES; //设定地图View能否支持用户移动地图
    
    //定位
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _bmMapView.showsUserLocation = NO;  //先关闭显示的定位图层
    _bmMapView.userTrackingMode = BMKUserTrackingModeFollow;    //设置定位的状态
    _bmMapView.showsUserLocation = YES; //显示定位图层
    [_mapView addSubview:_bmMapView];
    
    //textField[textField resignFirstResponder];
    _txtObject.delegate = self;
    //圆角
    _btnSearch.layer.cornerRadius = 5;
}
-(void)viewWillAppear:(BOOL)animated {
    [_bmMapView viewWillAppear];
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    _bmMapView.delegate = self;
    _poisearch.delegate = self;
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_bmMapView viewWillDisappear];
    // 不用时，置nil
    _bmMapView.delegate = nil;
    _poisearch.delegate = nil;
    _locService.delegate = nil;
}
- (void)viewDidAppear:(BOOL)animated{
    //周边搜索
    [self poiSearch:_poiSearchTitle];
}
#pragma mark - 搜索周边
- (IBAction)btnPoiSearchClick:(id)sender{
    if (_txtObject.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
    }else{
        [_txtObject resignFirstResponder];
        [self poiSearch:_txtObject.text];
    }
}

/**附近检索*/
- (void)poiSearch:(NSString *)strType{
    _strKeyword  = strType;
    //反地理编码
    //初始化地理编码类
    //注意：必须初始化地理编码类
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = _locService.userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txtObject resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_bmMapView) {
        _bmMapView = nil;
    }
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_bmMapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_bmMapView updateLocationData:userLocation];
//    NSLog(@"location-----", userLocation.location.coordinate);
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 *BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    _strRegion = result.addressDetail.district;

    //搜索周边
    _curPage = 0;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= result.addressDetail.city;
    citySearchOption.keyword = _strKeyword;

    NSLog(@"地区%@", citySearchOption.city);
    //        BMKNearbySearchOption *searchCity = [[BMKNearbySearchOption alloc] init];
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
}

#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_bmMapView.annotations];
    [_bmMapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_bmMapView addAnnotations:annotations];
        [_bmMapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_txtObject.text.length > 0) {
        [self poiSearch:_txtObject.text];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
