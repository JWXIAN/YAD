//
//  JWSimulationTestVC.m
//  projectTemp
//
//  Created by JWX on 15/11/2.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "JWSimulationTestVC.h"
#import "UIView+MJExtension.h"
#import "JWSimulationTestCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "JXT-swift.h"
#import "JWPerInfoVC.h"
#import "JWLXTJVC.h"
#import "JWWDCJVC.h"
#import "exam.h"
#import "UserDefaultsKey.h"

@interface JWSimulationTestVC () <UICollectionViewDelegate, UICollectionViewDataSource, JWSimulationTestCellDelegate>
/**布局flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**个人信息View*/
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic ,strong) UILabel *lblTitle;

@end

/**cell重用标识符*/
static NSString *const CellIdentifier = @"JWSimulationTestCell";
//头部
static NSString *const kheaderIdentifier = @"kheaderIdentifier";



@implementation JWSimulationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
//    [self loadHeadImgView];
    [self loadVw];
    //加载题库
//    [self loadSimulationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//加载Collection
- (void)loadVw{
    /**加载滚动视图*/
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //垂直布局
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h-110) collectionViewLayout:_flowLayout];
    //_collectionView背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    /**注册cell*/
    [_collectionView registerClass:[JWSimulationTestCell class] forCellWithReuseIdentifier:CellIdentifier];
    //头部
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    [self.view addSubview:_collectionView];
}
////加载头部图片View
//- (void)loadHeadImgView{
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 135)];
//    img.image = [UIImage imageNamed:@"account_bg"];
//    [self.view addSubview:img];
//    UILabel *lblPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, self.view.mj_w, 25)];
//    lblPrompt.text = @"    😊目测您是一个新手，您应该先进行题库练习~";
//    lblPrompt.font = [UIFont systemFontOfSize:14];
//    lblPrompt.textColor = [UIColor grayColor];
//    lblPrompt.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lblPrompt];
//}

#pragma mark - 题库
- (void)loadSimulationData{
}
//
//cell buttonClick代理
- (void)btnClickTitle:(NSString *)btnTitle{
    [self.delegate btnSimClickTitle:btnTitle];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }else if (section ==1){
        return 3;
    }else{
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWSimulationTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell loadTitle:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.mj_w/4-10, self.view.mj_w/4-10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *titleView;
    if (kind == UICollectionElementKindSectionHeader) {
         titleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
    }
    titleView.layer.borderColor = [JWColor(188, 187, 192) CGColor];
    titleView.layer.borderWidth = 0.5;
    //添加头部View
    [titleView addSubview:[self loadHeadView:indexPath]];
    return titleView;
}

- (UIView *)loadHeadView:(NSIndexPath *)indexPath{
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 29)];
    if (indexPath.section == 0) {
        _lblTitle.text = @"    出入江湖";
    }else if (indexPath.section == 1){
        _lblTitle.text = @"    小试牛刀";
    }else{
        _lblTitle.text = @"    温故知新";
    }
    _lblTitle.font = [UIFont systemFontOfSize:14];
    _lblTitle.textColor = [UIColor grayColor];
    _lblTitle.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return _lblTitle;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.mj_w ,29};
    return size;
}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(1, 8, 1, 8);
//}
@end
