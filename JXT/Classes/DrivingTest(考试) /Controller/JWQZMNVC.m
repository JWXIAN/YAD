//
//  JWQZMNVC.m
//  JXT
//
//  Created by JWX on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWQZMNVC.h"
#import "RKTabView.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "RJBlurAlertView.h"
#import "exam.h"
#import "JWQZMNCell.h"
#import "MBProgressHUD+MJ.h"
#import "JWQZMNCVCell.h"
#import "JWTestFooterCell.h"
#import "JWDTTSVC.h"
#import "AFNetworking.h"
#import "JWWDCJVC.h"
#import "JWWDCJVC.h"
#import "JWNavController.h"
#import "JWTestScoreVC.h"
#import "UIImageView+WebCache.h"

@interface JWQZMNVC () <RKTabViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
//@property (nonatomic ,strong) SwipeView *swipeView;
//@property (strong,nonatomic) NSMutableArray *dtViewArray;

/**底部菜单View*/
@property (nonatomic, strong) RKTabView *tabView;
///**答题TV*/
//@property (nonatomic, strong) JWQZMNTV *qzmnTV;
@property (nonatomic, strong) JWQZMNCell *qzmnCell;

///**滚动视图*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

/**自定义底部菜单弹出View*/
@property (nonatomic, strong) UIView *btnViewOne;
@property (nonatomic, strong) UIView *btnViewTwo;
/**弹出View*/
@property (nonatomic, strong) RJBlurAlertView *alertView;
/**collection cell行*/
@property (nonatomic, assign) NSInteger cellRow;
/**错题数组*/
@property (nonatomic, strong) NSMutableArray *ctCountArr;
/**对题数组*/
@property (nonatomic, strong) NSMutableArray *dtCountArr;
/**点击TV Cell记录*/
@property (nonatomic, assign) NSInteger selectTVCellCount;
/**统计TV对错题*/
@property (nonatomic, strong) NSMutableArray *tvDTDCCount;
/**底部菜单弹出View*/
@property (nonatomic, strong) JWDTTSVC *dttsVC;
///**收藏*/
@property (nonatomic, strong) NSString *strSC;
/**exam模型*/
@property (nonatomic, strong) exam *exam;
/**考试用时*/
@property (nonatomic, strong) UILabel *lblTime;

/**对错题行数数组*/
@property (nonatomic, strong) NSMutableArray *cellDCTRow;

/**错题统计*/
@property (nonatomic, assign) int mnksCTCount;
@end

//static NSString *reuseColorViewCellId = @"JWTestCell";
static NSString *const CellIdentifier = @"JWQZMNCVCell";
static NSString *const HeaderIdentifier = @"HeaderIdentifier";
static NSString *const FooterIdentifier = @"FooterIdentifier";

@implementation JWQZMNVC

- (void)viewDidLoad {
    
//    /**取消侧滑返回*/
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    _qzmnTV = [[JWQZMNTV alloc] init];
    [super viewDidLoad];
    //对错题统计
    _tvDTDCCount = [NSMutableArray array];
    _ctCountArr = [NSMutableArray array];
    _dtCountArr = [NSMutableArray array];
    _dtDic = [NSMutableDictionary dictionary];
    _selectTVCellCount = 0;
    _cellDCTRow = [NSMutableArray array];
    _mnksCTCount = 0;
    //底部菜单
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        self.ctPD = @"初始化";
//    });
    /**加载滚动视图*/
    _flowLayout =[[UICollectionViewFlowLayout alloc]init];
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h - 108) collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = JWColor(235.0, 235.0, 241.0);
    self.view.backgroundColor = JWColor(235.0, 235.0, 241.0);
    //翻页
    _collectionView.pagingEnabled = YES;
    //滚动标签
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    /**注册cell*/
    [_collectionView registerClass:[JWQZMNCVCell class] forCellWithReuseIdentifier:CellIdentifier];
//    /**注册底部*/
//    [_collectionView registerClass:[JWTestFooterCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
    //代码控制header和footer的显示
//    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    collectionViewLayout.footerReferenceSize = CGSizeMake(self.view
//                                                          .mj_w, self.view.mj_h -106);
    //    collectionViewLayout.minimumLineSpacing = 50;
    //    collectionViewLayout.minimumInteritemSpacing = 30;
    /**答题点击Cell*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dtTVCellselectRow:) name:@"dtTVCellselectRow" object:nil];
    /**答题错题统计*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dtCTvCellCount:) name:@"dtCTvCellCount" object:nil];
    /**答题对题统计*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dtDTvCellCount:) name:@"dtDTvCellCount" object:nil];
    /**底部弹出View点击题序*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cvCellTSBtn:) name:@"cvCellTSBtn" object:nil];
    
    /**答题字典通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dtDic:) name:@"dtDic" object:nil];
    //加载题库
//    [self loadData];
    //加载倒计时
    [self loadTime];
    //加载底部菜单
    [self loadDBCD];

    [self.view addSubview:_collectionView];
//    [self.btnViewTwo addSubview:_collectionView];
    //初始化弹窗
    _alertView = [[RJBlurAlertView alloc] init];
    _alertView.backgroundColor = [UIColor whiteColor];
    
    /**对题行数通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dtCellRow:) name:@"dtCellRow" object:nil];
    /**错题行数通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ctCellRow:) name:@"ctCellRow" object:nil];
}

/**对题行数通知*/
- (void)dtCellRow:(NSNotification *)nc{
    [_cellDCTRow addObject:nc.object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dtCellRow" object:nc];
}
/**错题行数通知*/
- (void)ctCellRow:(NSNotification *)nc{
    [_cellDCTRow addObject:nc.object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ctCellRow" object:nc];
}

/**答题字典通知*/
- (void)dtDic:(NSNotification *)nc{
//    NSLog(@"%@---------%d", nc.object, (int)[_cellRow row]);
//    NSLog(@"aaaaaa%ld", (long)_cellRow);
    [_dtDic setValue:nc.object forKey:[NSString stringWithFormat:@"%d", (int)_cellRow-1]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dtDic" object:nc];
}
//题数跳转
- (void)cvCellTSBtn:(NSNotification *)nc{
    [_btnViewOne removeFromSuperview];
    [_btnViewTwo removeFromSuperview];
    //32位转int
    NSString *str = nc.object;
    int va = str.intValue-1;
    //跳转制定题目
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:va inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cvCellTSBtn" object:nc];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_dtDic removeAllObjects];
    _mnksCTCount = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//点击cell接受通知
- (void)dtTVCellselectRow:(NSNotification *)nc{
//    NSString *str = [NSString stringWithFormat:@"%d", (int)_cellRow.row];
//    int row = str.intValue;
    if(_cellRow == _cellCount){
        [MBProgressHUD showError:@"已经是最后一题了"];
    }else{
        if(_mnksCTCount > 10){
            [self loadTJSJ];
        }else{
            //        NSString *str = [NSString stringWithFormat:@"%d", _cellRow];
            //        int row = str.intValue;
            //延时0.5秒执行下一题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_cellRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            });
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dtTVCellselectRow" object:nc];
}

//答题错题超过10道提示试卷
- (void)loadTJSJ{
    _alertView = [[RJBlurAlertView alloc] initWithTitle:nil text:@"\n错题超过十分，自动提交试卷" cancelButton:NO];
    [_alertView.okButton setTitle:@"提交试卷" forState:UIControlStateNormal];
    __weak JWQZMNVC *weakSelf = self;
    [_alertView setCompletionBlock:^(RJBlurAlertView *alert, UIButton *button) {
        if (button == alert.okButton) {
            [weakSelf setCDTCount];
            [weakSelf loadPapers];
        }
    }];
    [_alertView show];
}

//答题TV对题通知
- (void)dtDTvCellCount:(NSNotification *)nc{
//    [_tvDTDCCount addObject:_cellRow];
    _selectTVCellCount +=1;
    [_dtCountArr addObject:nc.object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dtDTvCellCount" object:nc];
//    [self loadDBCD];
}
//答题TV错题通知
- (void)dtCTvCellCount:(NSNotification *)nc{
    _selectTVCellCount +=1;
    _mnksCTCount++;
//    [_ctCountArr addObject:nc.object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dtCTvCellCount" object:nc];
//    [self loadDBCD];
}

#pragma mark - 加载底部菜单
- (void)loadDBCD{
    
    //存考试开始时间
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [ud setObject:date forKey:@"dtStartDate"];
    
    RKTabItem *mastercardTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"ts"] imageDisabled:[UIImage imageNamed:@"ts"]];
    mastercardTabItem.titleString = [NSString stringWithFormat:@"%ld/%ld", (long)_cellRow, (unsigned long)_cellDataArr.count];
    
    RKTabItem *paypalTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"cuo"] imageDisabled:[UIImage imageNamed:@"cuo"]];
    paypalTabItem.titleString = [NSString stringWithFormat:@"已错%d题", _mnksCTCount];
    
    RKTabItem *visaTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"sc"] imageDisabled:[UIImage imageNamed:@"sc1"]];

    if(_exam.isCollection == true){
        visaTabItem.titleFontColor = JWColor(82, 167, 85);
        visaTabItem.titleString = @"取消收藏";
        visaTabItem.tabState = TabStateDisabled;
    }else{
        visaTabItem.titleString = @"收藏本题";
        visaTabItem.titleFontColor = [UIColor grayColor];
        visaTabItem.tabState = TabStateEnabled;
    }
    
    RKTabItem *wuTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"chengji"] imageDisabled:[UIImage imageNamed:@"chengji"]];
    wuTabItem.titleString = @"交卷";
    //mastercardTabItem.tabState = TabStateEnabled;
    _tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-44, self.view.mj_w, 44)];
    _tabView.tabItems = @[mastercardTabItem, paypalTabItem, visaTabItem, wuTabItem];
    _tabView.backgroundColor = [UIColor whiteColor];
    //    _tabView.darkensBackgroundForEnabledTabs = YES;
    _tabView.lowerSeparatorLineColor = JWColor(232, 233, 232);
    //    tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    _tabView.titlesFontColor = [UIColor grayColor];
    _tabView.titlesFont = [UIFont systemFontOfSize:14];
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
}
#pragma mark - 底部菜单 - RKTabViewDelegate
- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem{
    if(index ==0){
        [self loadTX];
    }else if (index ==1){
        [self loadTX];
    }else if (index ==2){
        if([tabItem.titleString isEqualToString:@"收藏本题"]){
            [MBProgressHUD showSuccess:@"本题收藏成功"];
            tabItem.titleFontColor = JWColor(82, 167, 85);
            tabItem.tabState = TabStateDisabled;
            tabItem.titleString = @"取消收藏";
            _exam.isCollection = true;
            [exam update:_exam];
        }else{
            tabItem.titleString = @"收藏本题";
            tabItem.titleFontColor = [UIColor grayColor];
            tabItem.tabState = TabStateEnabled;
            _exam.isCollection = false;
            [exam update:_exam];
        }
    }else if (index ==3){
        if(_selectTVCellCount == _cellCount){
            _alertView = [[RJBlurAlertView alloc] initWithTitle:nil text:@"确定交卷？" cancelButton:YES];
        }else{
            _alertView = [[RJBlurAlertView alloc] initWithTitle:nil text:[NSString stringWithFormat:@"还有%ld道题没做，确定交卷？", _cellCount - _selectTVCellCount] cancelButton:YES];
        }
    __weak JWQZMNVC *weakSelf = self;
    [_alertView setCompletionBlock:^(RJBlurAlertView *alert, UIButton *button) {
        if (button == alert.okButton) {
            [weakSelf setCDTCount];
            [MBProgressHUD showMessage:@"正在交卷..."];
            [weakSelf loadPapers];
        }else{
            [MBProgressHUD showError:@"取消提交"];
        }
    }];
        [_alertView show];
    }
}
//底部菜单点击后的事件
- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    if(index ==0){
        [self loadTX];
    }else if (index ==1){
        [self loadTX];
    }else if (index ==2){
        if([tabItem.titleString isEqualToString:@"收藏本题"]){
            [MBProgressHUD showSuccess:@"本题收藏成功"];
            tabItem.titleFontColor = JWColor(82, 167, 85);
            tabItem.titleString = @"取消收藏";
            tabItem.tabState = TabStateDisabled;
            _exam.isCollection = true;
            [exam update:_exam];
        }else{
            tabItem.titleString = @"收藏本题";
            tabItem.titleFontColor = [UIColor grayColor];
            tabItem.tabState = TabStateEnabled;
            _exam.isCollection = false;
            [exam update:_exam];
        }
    }else if (index ==3){
        if(_selectTVCellCount == _cellCount){
            _alertView = [[RJBlurAlertView alloc] initWithTitle:nil text:@"确定交卷？" cancelButton:YES];
        }else{
            _alertView = [[RJBlurAlertView alloc] initWithTitle:nil text:[NSString stringWithFormat:@"还有%ld道题没做，确定交卷？", (long)_cellCount-_selectTVCellCount] cancelButton:YES];
        }
       __weak JWQZMNVC *weakSelf = self;
        [_alertView setCompletionBlock:^(RJBlurAlertView *alert, UIButton *button) {
            if (button == alert.okButton) {
                [weakSelf setCDTCount];
                [MBProgressHUD showMessage:@"正在交卷..."];
                [weakSelf loadPapers];
            }else{
            }
        }];
        [_alertView show];
    }
}

#pragma mark - 存考试交卷信息
- (void)setCDTCount{
    //存考试分数
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *strDT = [NSString stringWithFormat:@"%ld", (unsigned long)_dtCountArr.count];
    [ud setObject:strDT forKey:@"dtCountArr"];
    
    //存考试结束时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [ud setObject:date forKey:@"dtEndDate"];
    
    //需要转换的字符串
    NSString *dateString= _lblTime.text;
    //设置转换格式
    NSDateFormatter *formatterr=[[NSDateFormatter alloc]init];
    [formatterr setDateFormat:@"mm:ss"];
    //NSString转NSDate
    NSDate *timeDate=[formatterr dateFromString:dateString];
    NSDate *timeD;
    if([[ud objectForKey:@"lblTime"] isEqualToString:@"30分钟"]){
        timeD =[formatterr dateFromString:@"30:00"];
    }else{
        timeD =[formatterr dateFromString:@"45:00"];
    }
    //计算时间差
    NSTimeInterval secondsInterval= [timeD timeIntervalSinceDate:timeDate];
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:secondsInterval];
    NSString *strTime = [formatterr stringFromDate:dd];
    [ud setObject:strTime forKey:@"strTime"];
}

#pragma mark - 交卷
- (void)loadPapers{
    
    JWTestScoreVC *test = [[JWTestScoreVC alloc] init];
    [self presentViewController:test animated:YES completion:nil];
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id = [ud objectForKey:@"drivecode"];
    NSString *cardNo = [ud objectForKey:@"per_idcardno"];
    NSString *score = [ud objectForKey:@"dtCountArr"];
    NSString *bt = [ud objectForKey:@"dtStartDate"];
    NSString *et = [ud objectForKey:@"dtEndDate"];
    NSString *km = [ud objectForKey:@"lblKSKM"];
//    2015-08-31%%2015:35:12
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=jiaojuan&SCHOOL_ID=%@&cardno=%@&score=%@&bt=%@&et=%@&km=%@&way=app", school_id, cardNo, score, bt, et, km];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic valueForKeyPath:@"head.issuccess"] isEqualToString:@"true"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"交卷成功"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"交卷失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
//加载顶部倒计时
- (void)loadTime{
    //自定义View
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    _lblTime = [[UILabel alloc] initWithFrame:timeView.frame];
    [timeView addSubview:_lblTime];
    _lblTime.textColor = [UIColor whiteColor];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:timeView];
    self.navigationItem.rightBarButtonItem = bar;
    
    __block int timeout=0; //倒计时时间
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([[ud objectForKey:@"lblTime"] isEqualToString:@"30分钟"]){
      timeout=1800; //倒计时时间
    }else{
      timeout=2700; //倒计时时间
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"考试结束"];
            });
        }else{
            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d:%.2d",minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _lblTime.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 底部菜单点击View
- (void)loadTX{
    //遮盖View
    _btnViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h/2)];
    _btnViewOne.backgroundColor = [UIColor blackColor];
    _btnViewOne.alpha = 0.7;
    [self.view addSubview:_btnViewOne];
    
    //白色View
    _btnViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-self.view.mj_h/2-50, self.view.mj_w, self.view.mj_h/2+50)];
    _btnViewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_btnViewTwo];
    
    //添加关闭View按钮
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnViewTwo.frame)-50, 5, 41, 41)];
    [exitBtn setImage:[UIImage imageNamed:@"DTExitBtn"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.showsTouchWhenHighlighted = YES;
    [_btnViewTwo addSubview:exitBtn];
   
    //正确错误题
    UILabel *labZQ = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 41, 41)];
    UILabel *labZQS = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labZQ.frame)+3, 5, 41, 41)];
    UILabel *labCW = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labZQS.frame)+5, 5, 41, 41)];
    UILabel *labCWS = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labCW.frame)+3, 5, 41, 41)];
    labZQ.text = @"正确";
    labZQS.text = [NSString stringWithFormat:@"%ld", (unsigned long)_dtCountArr.count];
    labZQS.textColor = JWColor(83, 164, 43);
    labCW.text = @"错误";
    labCWS.text = [NSString stringWithFormat:@"%d", _mnksCTCount];
    labCWS.textColor = [UIColor redColor];
    NSArray *lblArr = @[labZQ, labZQS, labCW, labCWS];
    for(int i=0;i<lblArr.count;i++){
        [_btnViewTwo addSubview:[lblArr objectAtIndex:i]];
    }
    
    //下划线
    UIView *xhxView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(exitBtn.frame)+5, self.view.mj_w, 1)];
    xhxView.backgroundColor = JWColor(244, 244, 244);
    [_btnViewTwo addSubview:xhxView];
   
    
    //题数
    _dttsVC = [[JWDTTSVC alloc] init];
    _dttsVC.view.frame = CGRectMake(0, CGRectGetMaxY(xhxView.frame), self.view.mj_w, _btnViewTwo.mj_h-CGRectGetMaxY(xhxView.frame));
    //cell对错题
    _dttsVC.cellDCTRow = _cellDCTRow;
    //cell题数
    _dttsVC.tsCount = _cellDataArr.count;
    //重新设置Cell
//    [_dttsVC setDCTCell:_cellDCTRow cellCount:_cellCount];
    [_btnViewTwo addSubview:_dttsVC.view];
}
//底部视图关闭
- (void)btnClick{
    [_btnViewOne removeFromSuperview];
    [_btnViewTwo removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    if([[ud objectForKey:@"lblKSKM"] isEqualToString:@"科目一理论考试"]){
//        _cellCount = 100;
//    }else{
//        _cellCount = 50;
//    }
//    return _cellCount;
    return _cellDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    _qzmnTV.cvRowIndexPath = indexPath;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cvCellRowPath" object:rowIndex];
    
    JWQZMNCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.dtdic = _dtDic;
    _exam = _cellDataArr[indexPath.row];
    [cell setTVCell:_exam cellNum:indexPath];
    
    
    if (cell == nil) {
        cell= (JWQZMNCVCell *)[[[NSBundle mainBundle] loadNibNamed:@"JWQZMNCVCell" owner:self options:nil] lastObject];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //题目
    [ud setObject:_exam.questionBody forKey:@"headTM"];
    //题目类型
    [ud setObject:_exam.questionType forKey:@"headTMType"];
    //题目图片
    [ud setObject:_exam.questionPicture forKey:@"headTMImage"];
    //正确答案
    [ud setObject:_exam.rightAnswer forKey:@"tmZQDA"];
//    //是否收藏
//    [ud setObject:examModel.isCollection forKey:@"tmSFSC"];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    _cellRow = path.row;
    [self loadDBCD];
    
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionView.mj_w, _collectionView.mj_h);
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
//{
//    UICollectionReusableView *titleView;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
//    } else if (kind == UICollectionElementKindSectionFooter) {
//        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
//    }
//    return titleView;
//}




//- (UICollectionViewFlowLayout *) flowLayout{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 50.0f);  //设置head大小
//    flowLayout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
//    return flowLayout;
//}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
////    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
////    cell.backgroundColor = [UIColor whiteColor];
//    NSLog(@"select====%ld",indexPath.row);
//}
////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

@end
