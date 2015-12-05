//
//  YADLifeTV.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADLifeTV.h"
#import "YADLifeTVCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "YADLifeButtonCell.h"
#import "JWMapLBSVC.h"
#import "YADWebViewVC.h"

@interface YADLifeTV ()<UICollectionViewDelegate, UICollectionViewDataSource, YADLifeButtonCellDelegate>
/**布局flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**CollectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;
@end

/**cell重用标识符*/
static NSString *const CellIdentifier = @"YADLifeButtonCell";
static NSString *const kheaderIdentifier = @"kheaderIdentifier";

@implementation YADLifeTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)itView{
    self.tableView.tableHeaderView = [self loadHeaderView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
//    //创建左侧barButtonItem
//    UIBarButtonItem *left =   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(barButtonLeftClick)];
//    self.navigationItem.leftBarButtonItem=left;
//    UIBarButtonSystemItemCompose//编辑
    //创建右侧barButtonItem
    UIBarButtonItem *right= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonRightClick)];
    self.navigationItem.rightBarButtonItem=right;
}
#pragma mark - 导航左边按钮
- (void)barButtonLeftClick{
    
}
#pragma mark - 导航右边按钮
- (void)barButtonRightClick{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮Click
- (void)btnClickTitle:(NSInteger)btnTag{
    NSArray *arrTitle = @[@"超市", @"加油站", @"银行", @"停车场", @"餐馆", @"班车接送", @"代驾服务", @"扣分查询", @"违章查询"];
    NSLog(@"%ld", btnTag);
    if (btnTag <5) {
        JWMapLBSVC *map = [[JWMapLBSVC alloc] init];
        map.title = @"我的地图";
        map.poiSearchTitle = arrTitle[btnTag];
        [self.navigationController pushViewController:map animated:YES];
    }else if(btnTag == 5){
        [self itWebView:@"http://182.92.70.91:22223/yianda/bccx.html" strTitle:@"班车查询"];
    }else if(btnTag == 6){
        
    }else if(btnTag == 7){
        [self itWebView:@"m.weizhangwang.com/jiashizheng/" strTitle:arrTitle[btnTag]];
    }else if(btnTag == 8){
        [self itWebView:@"m.weizhangwang.com" strTitle:arrTitle[btnTag]];
    }
}

- (void)itWebView:(NSString *)url strTitle:(NSString *)strTitle{
    YADWebViewVC *web = [[YADWebViewVC alloc] init];
    web.title = strTitle;
    web.strURL = url;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark -顶部View
- (UIView *)loadHeaderView{
    //1、底层View
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 310)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //搜索
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 50)];
//    searchBar.searchBarStyle = UISearchBarStyleDefault;
//    searchBar.placeholder = @"搜索一下下";
//    [headerView addSubview:searchBar];
    //2、CollectionView
    //加载滚动视图
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //垂直布局
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 8, self.view.mj_w, 300) collectionViewLayout:_flowLayout];
    //collectionView背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    /**注册cell*/
    [_collectionView registerClass:[YADLifeButtonCell class] forCellWithReuseIdentifier:CellIdentifier];
    //头部
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    
    [headerView addSubview:_collectionView];
    
    return headerView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YADLifeTVCell *cell = [YADLifeTVCell cellWithTableView:tableView];
    [cell stCellImageTitle:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
#pragma mark - 分组HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 44)];
    View.backgroundColor = JWColor(188, 187, 192);
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.mj_w, 43.5)];
    headView.backgroundColor = [UIColor whiteColor];
    [View addSubview:headView];
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, headView.mj_h/2-14, 100, 27)];
    imageView.image = [UIImage imageNamed:@"消息推送"];
    [headView addSubview:imageView];
    //更多>>
    UIButton *buttonMore = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w-70, 0, 70, 44)];
    [buttonMore setTitle:@"更多>>" forState:UIControlStateNormal];
    buttonMore.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonMore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonMore.tag = section+10;
    [headView addSubview:buttonMore];
    return View;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0){
        return 5;
    }else{
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YADLifeButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell stCellImageTitle:indexPath];
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.mj_w/5-5, self.view.mj_w/4);
    }else{
       return CGSizeMake(self.view.mj_w/4-10, self.view.mj_w/4);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *titleView;
    if (kind == UICollectionElementKindSectionHeader) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
    }
    titleView.backgroundColor = JWColor(188, 187, 192);
    //底部View
    UIView *Headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.mj_w, 41)];
    Headview.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:Headview];
    //图片
    NSString *strImage;
    if (indexPath.section == 0) {
        strImage = @"定位查询";
    }else if (indexPath.section == 1){
        strImage = @"便捷服务";
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, Headview.mj_h/2-14, 100, 27)];
    imageView.image = [UIImage imageNamed:strImage];
    [Headview addSubview:imageView];
    //更多>>
    UIButton *buttonMore = [[UIButton alloc] initWithFrame:CGRectMake(self.view.mj_w-70, 0, 70, 44)];
    [buttonMore setTitle:@"更多>>" forState:UIControlStateNormal];
    buttonMore.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonMore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonMore.tag = indexPath.section;
    [Headview addSubview:buttonMore];
    
    return titleView;
}
#pragma mark - 更多Button
- (void)buttonMoreClick:(UIButton *)sender{
    //定位查询 - 更多
    if (sender.tag == 0) {
        
    }else{//便捷服务 - 更多
        
    }
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.mj_w ,42};
    return size;
}
// 单独定制每行item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

@end
