//
//  JWRecordVC.m
//  JXT
//
//  Created by JWX on 15/6/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWRecordVC.h"

#import "JWCarTVController.h"
#import "JWOrderTV.h"
#import "MBProgressHUD+MJ.h"
#import "JWTrainTV.h"
#import "JWQuitTV.h"
#import "PrefixHeader.pch"
#import "AppDelegate.h"
/**Segment define*/
#define _allowAppearance    NO
#define _bakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define _tintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define _hairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]

@interface JWRecordVC () <DZNSegmentedControlDelegate>
/**Segment*/

@property (nonatomic, strong) NSArray *menuItems;
/**上车认证view*/
@property (nonatomic, strong) JWCarTVController *carCode;
/**预约view*/
@property (nonatomic, strong) JWOrderTV *order;
/**培训*/
@property (nonatomic, strong) JWTrainTV *train;

/**退约*/
@property (nonatomic, strong) JWQuitTV *quit;
/**分段下划线*/
@property (nonatomic, strong) UIView *segmentLine;
@end

@implementation JWRecordVC

/**上车认证*/
- (JWCarTVController *)carCode
{
    if (!_carCode) {
        self.carCode = [[JWCarTVController alloc] init];
        self.carCode.view.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _carCode;
}

/**预约信息*/
- (JWOrderTV *)order
{
    if (!_order) {
        self.order = [[JWOrderTV alloc] init];
        self.order.view.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _order;
}
/**培训信息*/
- (JWTrainTV *)train
{
    if (!_train) {
        self.train = [[JWTrainTV alloc] init];
        self.train.view.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _train;
}

/**退约信息*/
- (JWQuitTV *)quit
{
    if (!_quit) {
        self.quit = [[JWQuitTV alloc] init];
        self.quit.view.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _quit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //预约信息分组
    _menuItems = @[[@"上车认证" uppercaseString],
                   [@"预约" uppercaseString],
                   [@"培训" uppercaseString],
                   [@"退约" uppercaseString]];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
//    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
//    [self.view addSubview:self.control];
//    self.segment = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
//    self.segment.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.segment];
    
    [self.view addSubview:self.control];
    self.control.frame = CGRectMake(0, 0, viewWidth, 40);
//    self.control.backgroundColor = [UIColor greenColor];
//    JWCarTVController *carCode = [[JWCarTVController alloc] init];
//    carCode.view.frame = CGRectMake(0, 40, viewWidth, viewHeight);
//    [self.control addSubview:carCode.view];
//    self.carCode = carCode;
//    self.tableView.tableFooterView = [UIView new];
    
    /**加载上车认证view*/
    [self addChildViewController:self.train];
    [self.view addSubview:self.train.view];
    
    self.segmentLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, 0.5)];
    self.segmentLine.backgroundColor = JWColor(202, 202, 202);
    [self.view addSubview:self.segmentLine];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment分组实现
/**顶部Segment*/
+ (void)load
{
    if (!_allowAppearance) {
        return;
    }
    
    [[DZNSegmentedControl appearance] setBackgroundColor:_bakgroundColor];
    [[DZNSegmentedControl appearance] setTintColor:_tintColor];
    [[DZNSegmentedControl appearance] setHairlineColor:_hairlineColor];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont fontWithName:@"EuphemiaUCAS" size:15.0]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
    
}
////打开左侧界面
//- (void) openOrCloseLeftList
//{
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (tempAppDelegate.LeftSlideVC.closed)
//    {
//        [tempAppDelegate.LeftSlideVC openLeftView];
//    }
//    else
//    {
//        [tempAppDelegate.LeftSlideVC closeLeftView];
//    }
//}
/**加载左右侧bar*/
- (void)loadView
{
    [super loadView];
// self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(openOrCloseLeftList)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action: @selector(refreshSegments:)];
}

/**右侧刷新cell*/
- (void)refreshSegments:(id)sender
{
    [MBProgressHUD showMessage:@"正在刷新"];
    [self.control removeAllSegments];
    [self.control setItems:self.menuItems];
    [self updateControlCounts];
    [self.order.tableView reloadData];
    [MBProgressHUD hideHUD];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateControlCounts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 2;
        _control.bouncySelectionIndicator = YES;
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

#pragma mark - ViewController Methods

///**右侧添加cell*/
//- (void)addSegment:(id)sender
//{
//    NSUInteger newSegment = self.control.numberOfSegments;
//
//    [self.control setTitle:[@"Favorites" uppercaseString] forSegmentAtIndex:self.control.numberOfSegments];
//    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:newSegment];
//}

/**顶部控制器统计*/
- (void)updateControlCounts
{
        [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:0];
        [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:1];
        [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:2];
        [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:3];
//    [self.control setCount:@(self.recordHeads.count) forSegmentAtIndex:0];
//    [self.control setCount:@(self.recordHeads.count) forSegmentAtIndex:1];
//    [self.control setCount:@(self.recordHeads.count) forSegmentAtIndex:2];
//    [self.control setCount:@(self.recordHeads.count) forSegmentAtIndex:3];
    if (_allowAppearance) {
        [self.control setTitleColor:_hairlineColor forState:UIControlStateNormal];
    }
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    if (self.control.selectedSegmentIndex == 0) {
        [self.train.view removeFromSuperview];
        [self.order.view removeFromSuperview];
        [self.quit.view removeFromSuperview];
        
        [self addChildViewController:self.carCode];
        [self.view addSubview:self.carCode.view];
    }else if(self.control.selectedSegmentIndex == 1)
    {
        [self.train.view removeFromSuperview];
        [self.carCode.view removeFromSuperview];
        [self.quit.view removeFromSuperview];
        
        [self addChildViewController:self.order];
        [self.view addSubview:self.order.view];
    }else if (self.control.selectedSegmentIndex == 2)
    {
        [self.order.view removeFromSuperview];
        [self.carCode.view removeFromSuperview];
        [self.quit.view removeFromSuperview];
        /**加载培训view*/
        [self.view addSubview:self.train.view];
    }else if(self.control.selectedSegmentIndex == 3){
        [self.carCode.view removeFromSuperview];
        [self.train.view removeFromSuperview];
        [self.order.view removeFromSuperview];
        [self.view addSubview:self.quit.view];
    }
}


#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}
@end
