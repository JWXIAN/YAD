//
//  YADHomeTV.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADHomeTV.h"
#import "YADHomeTVCell.h"
#import "UIView+MJExtension.h"
#import "YADHomeButtonCell.h"
#import "YADUserInfoTV.h"
#import "PrefixHeader.pch"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "UserDefaultsKey.h"
#import "JWLoginController.h"
#import "JWCarVC.h"
#import "JWMapLBSVC.h"
#import "YADWebViewVC.h"
#import "YADLoginTV.h"

//ShareSDK
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "SVProgressHUD.h"

@interface YADHomeTV ()<UICollectionViewDataSource, UICollectionViewDelegate, YADHomeButtonCellDelegate, SDCycleScrollViewDelegate, UIWebViewDelegate>
/**布局flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**CollectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *headerView;
@end

/**cell重用标识符*/
static NSString *const CellIdentifier = @"YADHomeButtonCell";

@implementation YADHomeTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
    [self TBRefresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableView + 下拉刷新 默认
- (void)TBRefresh
{
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.tableView.tableHeaderView = [weakSelf loadHeaderView];
        [weakSelf.tableView reloadData];
        // 结束刷新状态
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 50)];
    //创建左侧barButtonItem - 个人信息
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(barButtonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=left;
    
    //创建右侧barButtonItem - 分享
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonRightClick)];
    self.navigationItem.rightBarButtonItem=right;
    
    //导航透明
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明图"] forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.alpha = 0.1;
}

#pragma mark - 导航左边按钮
- (void)barButtonLeftClick{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        YADUserInfoTV *userInfo = [[YADUserInfoTV alloc] initWithStyle:UITableViewStyleGrouped];
        userInfo.title = @"个人中心";
        userInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfo animated:YES];
    }else{
        YADLoginTV *login = [[YADLoginTV alloc] initWithStyle:UITableViewStyleGrouped];
        login.title = @"用户登录";
        [self.navigationController pushViewController:login animated:YES];
    }
}
#pragma mark - 导航右边分享按钮
- (void)barButtonRightClick{
//    [self shareWithView:nil];
}

#pragma mark - 主页Button跳转
- (void)btnClickTitle:(NSInteger)btnTag{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UserIsaAlreadyLogin_Bool] == YES) {
        if (btnTag == 0) { //报名须知
            [self itWebView:@"103.39.110.136:92/bmxz/index.html " strTitle:@"报名须知"];
        }else if (btnTag == 1){  //在线报名
            
        }else if (btnTag == 2){  //预约练车
            JWCarVC *car = [[JWCarVC alloc] init];
            car.title = @"预约练车";
            [self.navigationController pushViewController:car animated:YES];
        }else if (btnTag == 3){  //考试预约
            
        }else if (btnTag == 4){  //校园地图
            [self itWebView:@"http://182.92.70.91:22223/yianda/xydt.html" strTitle:@"校园地图"];
        }else if (btnTag == 5){  //班车查询
            [self itWebView:@"http://182.92.70.91:22223/yianda/bccx.html" strTitle:@"班车查询"];
        }else if (btnTag == 6){  //便捷服务
            self.tabBarController.selectedIndex = 2;
        }else if (btnTag == 7){  //定位查询"
            [self itMapView];
        }
    }else{
        if (btnTag == 4 || btnTag == 7) {
            [self itWebView:@"http://182.92.70.91:22223/yianda/xydt.html" strTitle:@"校园地图"];
        }else if (btnTag == 5){
            [self itWebView:@"http://182.92.70.91:22223/yianda/bccx.html" strTitle:@"班车查询"];
        }else if (btnTag == 6){
            self.tabBarController.selectedIndex = 2;
        }else{
            YADLoginTV *login = [[YADLoginTV alloc] initWithStyle:UITableViewStyleGrouped];
            login.title = @"用户登录";
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}
#pragma mark - 网页
- (void)itWebView:(NSString *)url strTitle:(NSString *)strTitle{
    YADWebViewVC *web = [[YADWebViewVC alloc] init];
    web.strURL = url;
    web.title = strTitle;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - 地图
- (void)itMapView{
    JWMapLBSVC *map = [[JWMapLBSVC alloc] init];
    map.title = @"在线地图";
    [self.navigationController pushViewController:map animated:YES];
}
#pragma mark -顶部View
- (UIView *)loadHeaderView{
    //1、底层View
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h-20)];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //2、滚动广告图
    [self scrollPageImage:nil titles:nil];
    //3、CollectionView
    [_headerView addSubview:[self loadCollectionView]];
    
    return _headerView;
}
#pragma mark - CollectionView
- (UIView *)loadCollectionView{
    //加载滚动视图
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //垂直布局
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, _headerView.mj_h/2+85, self.view.mj_w, _headerView.mj_h/2-90) collectionViewLayout:_flowLayout];
    //collectionView背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.layer.borderColor = [JWColor(188, 187, 192) CGColor];
    _collectionView.layer.borderWidth = 0.5;
    /**注册cell*/
    [_collectionView registerClass:[YADHomeButtonCell class] forCellWithReuseIdentifier:CellIdentifier];
    return _collectionView;
}
#pragma mark - 滚动图
- (void)scrollPageImage:(NSArray *)arrImagesURL titles:(NSArray *)arrTitles{
    // 情景一：采用本地图片实现
    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
                        [UIImage imageNamed:@"h2.jpg"],
                        [UIImage imageNamed:@"h3.jpg"],
                        [UIImage imageNamed:@"h4.jpg"]
                        ];
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.mj_w, self.headerView.mj_h/2+80) imagesGroup:images];
    
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [_headerView addSubview:cycleScrollView];
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;
//    //采用网络图片实现
//    NSArray *imagesURLStrings = @[@"www.baidu.com/img/bd_logo1.png",
//                                  @"www.baidu.com/img/bd_logo1.png",
//                                  @"www.baidu.com/img/bd_logo1.png"];
//    CGFloat w = self.view.bounds.size.width;
//    //网络加载 --- 创建带标题的图片轮播器
//    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, self.headerView.mj_h/2+80) imageURLStringsGroup:imagesURLStrings]; // 模拟网络延时情景
//    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    cycleScrollView2.delegate = self;
//    cycleScrollView2.dotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
//    cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
//    [self.view addSubview:cycleScrollView2];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADHomeTVCell *cell = [YADHomeTVCell cellWithTableView:tableView];
    return cell;
}
#pragma mark - 分组顶部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}
#pragma mark - 分组View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //头部View
//    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 44)];
//    sectionHeadView.backgroundColor = [UIColor whiteColor];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 0.5)];
//    lineView.backgroundColor= JWColor(188, 187, 192);
//    [sectionHeadView addSubview:lineView];
//    
//    
//    //新闻资讯 - 图片
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, sectionHeadView.mj_h/2-12, 120, 25)];
//    imageView.image = [UIImage imageNamed:@"新闻资讯01"];
//    [sectionHeadView addSubview:imageView];
//    
////    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, sectionHeadView.mj_h/2-10, 80, 20)];
////    lblTitle.text = @"活动资讯";
////    lblTitle.font = [UIFont systemFontOfSize:16];
////    lblTitle.textColor = JWColor(20, 196, 178);
////    [sectionHeadView addSubview:lblTitle];
//    
//    //更多资讯Button
//    UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w-88, 2, 80, 40)];
//    [headButton setTitle:@"更多资讯>>" forState:UIControlStateNormal];
//    headButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [headButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [headButton addTarget:self action:@selector(sectionHeadButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [sectionHeadView addSubview:headButton];
//    
//    //分割线
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.mj_w, 0.5)];
//    view.backgroundColor = JWColor(188, 187, 192);
//    [sectionHeadView addSubview:view];
//    
//    return sectionHeadView;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 200)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://103.39.110.136:92/index.html"]];
    [web loadRequest:request];
    web.delegate = self;
    return web;
}

#pragma mark - 拦截URL
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strXXX = request.URL.resourceSpecifier;
    //如果URL包含 News 拦截
    NSRange range = [strXXX rangeOfString:@"news"];
    if( range.location != NSNotFound )
    {
        [self itWebView:strXXX strTitle:@"新闻列表"];
        return NO;//返回NO，表示取消对本次请求的导航
    }
    return YES;
}

//#pragma mark - 分组更多资讯Button事件
//- (void)sectionHeadButtonClick{
//    
//}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YADHomeButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell stCellImageTitle:indexPath];
    
    cell.delegate = self;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.mj_w/4-15, self.view.mj_w/4);
}
// 单独定制每行item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

//#pragma mark 显示分享菜单
//
///**
// *  显示分享菜单
// *
// *  @param view 容器视图
// */
////TODO: 修改分享内容
//- (void)shareWithView:(UIView* )sView
//{
//    //创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"h1"]];
//    //    （注意：图片必须有且名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@""]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:sView //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               [SVProgressHUD showErrorWithStatus:@"分享成功"];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                       
//                   }];
//    }
//}
@end
