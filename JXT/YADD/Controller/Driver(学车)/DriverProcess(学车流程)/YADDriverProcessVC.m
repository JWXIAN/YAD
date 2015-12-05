//
//  YADDriverProcessVC.m
//  YAD
//
//  Created by JWX on 15/11/19.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADDriverProcessVC.h"
#import "HMSegmentedControl.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"

#import "YADDriverTwo.h"
#import "YADSubjectThreeTV.h"
#import "YADSubjectFourVC.h"
#import "UserDefaultsKey.h"

@interface YADDriverProcessVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) HMSegmentedControl *segment;
@property (nonatomic, strong) UIScrollView *scroll;

//科目二
@property (nonatomic, strong) YADDriverTwo *driverTwo;
//科目三
@property (nonatomic, strong) YADSubjectThreeTV *driverThree;
@property (nonatomic, strong) YADSubjectFourVC *subjectFour;
@end

@implementation YADDriverProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadHeadSegmentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SegmentView
- (void)loadHeadSegmentView{
    //     Segmented control with more customization and indexChangeBlock
    _segment = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 44)];
    _segment.sectionTitles = @[@"科目一", @"科目二", @"科目三", @"科目四"];
    //切换对应ScrollView
    __weak typeof(self) weakSelf = self;
    [_segment setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scroll setContentOffset:CGPointMake(weakSelf.view.mj_w*index, 0) animated:YES];
    }];
    _segment.selectionIndicatorHeight = 4.0f;
    _segment.backgroundColor = [UIColor whiteColor];
    _segment.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]};
//    _segment.selectionIndicatorColor = [UIColor whiteColor];
    //分割线
    _segment.verticalDividerEnabled = YES;
    _segment.verticalDividerColor = JWColor(188, 187, 192);
    _segment.verticalDividerWidth = 0.5f;
    _segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :[UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
    _segment.selectedSegmentIndex = 0;
    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
//    _segment.shouldAnimateUserSelection = NO;
    [self.view addSubview:_segment];
    //加载ScrollView
    [self loadScrollView];
}

- (void)btnRegisterClick{
}
#pragma mark - ScrollView
- (void)loadScrollView{
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.mj_w, self.view.mj_h-88-22)];
    self.scroll.backgroundColor = JWColor(188, 187, 192);
    self.scroll.pagingEnabled = YES;
    self.scroll.showsHorizontalScrollIndicator = NO;
    _scroll.bounces = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.contentSize = CGSizeMake(self.view.mj_w * 4, 0);
    self.scroll.delegate = self;
    [self.scroll scrollRectToVisible:CGRectMake(0, 44, self.view.mj_w, self.scroll.mj_h-88-22) animated:NO];
    [self.view addSubview:self.scroll];
    
    //科一
    _simlationTestVC = [[JWSimulationTestVC alloc] init];
    _simlationTestVC.view.frame = CGRectMake(0, 0, self.view.mj_w, self.scroll.mj_h);
    [self.scroll addSubview:_simlationTestVC.view];
    
    //科二
    _driverTwo = [[YADDriverTwo alloc] initWithStyle:UITableViewStyleGrouped];
    _driverTwo.view.frame = CGRectMake(self.view.mj_w, 0, self.view.mj_w, self.scroll.mj_h);
    [self.scroll addSubview:_driverTwo.view];
    
    //科三
    _driverThree = [[YADSubjectThreeTV alloc] initWithStyle:UITableViewStyleGrouped];
    _driverThree.view.frame = CGRectMake(self.view.mj_w * 2, 0, self.view.mj_w, self.scroll.mj_h);
    [self.scroll addSubview:_driverThree.view];

    //科四
    _subjectFour = [[YADSubjectFourVC alloc] init];
    _subjectFour.view.frame = CGRectMake(self.view.mj_w * 3, 0, self.view.mj_w, self.view.mj_h);
    [self.scroll addSubview:_subjectFour.view];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    //保存科目
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", page] forKey:SimulationSubjectIndex];
    [_segment setSelectedSegmentIndex:page animated:YES];
}

@end
