//
//  JWNewfeatureVC.m
//  JXT
//
//  Created by JWX on 15/7/10.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWNewfeatureVC.h"
#import "JWLoginController.h"
#import "PrefixHeader.pch"
#import "UIView+Extension.h"
#import "AppDelegate.h"
#import "JWTarBarController.h"

/**图片数量，显示page*/
#define JWNewfeatureCount 3

@interface JWNewfeatureVC () <UIScrollViewDelegate>
/**page控制器*/
@property (nonatomic, weak) UIPageControl *pageControl;
/**scroll视图*/
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation JWNewfeatureVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGRect frame= self.view.frame;
    frame.origin.y-=20;
    frame.size.height+=20;
    scrollView.frame = frame;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < JWNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == JWNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(JWNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = JWNewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = JWColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = JWColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    // 计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能,button可以添加到视图上
    imageView.userInteractionEnabled = YES;
    
    // 1.开启应用
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    startBtn.height = 40;
    startBtn.width = 200;
    startBtn.layer.cornerRadius = 10;
    startBtn.centerX = imageView.width * 0.5;
    startBtn.centerY = imageView.height * 0.85;
    [startBtn setTitle:@"开启学车通" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:JWColor(71, 173, 220)];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

- (void)shareClick:(UIButton *)shareBtn
{
    // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

/**加载登陆视图*/
- (void)startClick
{

    JWTarBarController* lo=[[JWTarBarController alloc]init];

    [lo setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];//设置页面跳转动画
//    [self.navigationController pushViewController:lo animated:YES];
    [self presentViewController:lo animated:YES completion:nil];

}

@end
