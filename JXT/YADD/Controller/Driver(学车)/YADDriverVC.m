//
//  YADDriverVC.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADDriverVC.h"
#import "HMSegmentedControl.h"
#import "UIView+MJExtension.h"
#import "PrefixHeader.pch"
#import "JWSimulationTestVC.h"
#import "YADEnrollDriverTV.h"
#import "YADDriverProcessVC.h"
#import "YADEnrollSDTV.h"
#import "UserDefaultsKey.h"
#import "JWSimulationTestCell.h"
#import "PrefixHeader.pch"
#import "JXT-swift.h"
#import "JWPerInfoVC.h"
#import "JWLXTJVC.h"
#import "JWWDCJVC.h"
#import "exam.h"
#import "YADWebViewVC.h"

@interface YADDriverVC ()<UIScrollViewDelegate, JWSimulationTestVCDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
/**模拟考试*/
//@property (nonatomic, strong) JWSimulationTestVC *simulation;
/**报名学车*/
//@property (nonatomic, strong) YADEnrollDriverTV *enrollDriver;
/**学车流程*/
@property (nonatomic, strong) YADDriverProcessVC *driveProcessVC;
/**报名学车Web*/
@property (nonatomic, strong) YADWebViewVC *webView;

#pragma mark - 模拟考试
@property(strong,nonatomic) NSString*  className,* whichButton;//科目名称 , 车型
@property(strong,nonatomic) NSArray*  examInfoArr;//存放题目
@end

@implementation YADDriverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self loadHeadSegmentView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 模拟考试跳转
- (void)btnSimClickTitle:(NSString *)btnTitle{
    NSString *strClassName = [[NSUserDefaults standardUserDefaults] objectForKey:SimulationSubjectIndex];
    if ([strClassName  isEqualToString:@"SimulationSubjectIndex"]) {
        _className = @"科目一";
    }else if([strClassName  isEqualToString:@"0"]){
        _className = @"科目一";
    }else if ([strClassName  isEqualToString:@"3"]){
        _className = @"科目四";
    }
    
    NSString* select;
    NSString* temp;
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    _whichButton = [user objectForKey:@"whichButton"];
    
    if (!([btnTitle isEqualToString:@"考试历史"]||[btnTitle isEqualToString:@"考试统计"]||[btnTitle isEqualToString:@"考试要点"]||[btnTitle isEqualToString:@"许愿墙"]))
    {
        if ([_whichButton hasPrefix:@"Z"]) {
            temp=[_whichButton substringFromIndex:1];
            select=[NSString stringWithFormat:@"carType like '%%Z%%' and carType like '%%%@%%'",temp];
        }
        else
        {
            select= [NSString stringWithFormat:@"carType not like '%%Z%%' and carType like '%%%@%%'",_whichButton];
        }
    }
    
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    
    if ([btnTitle isEqualToString:@"考试要点"]) {
        ExamTechniqueTableViewController* technique = [story instantiateViewControllerWithIdentifier:@"technique"];
        technique.className=_className;
        [self.navigationController pushViewController:technique animated:YES];
    }
    else if (![btnTitle isEqualToString:@"排除的题"]) {
        NSString* info = [NSString stringWithFormat:@"%@ and className='%@' and isExclude=0",select,_className];
        if (!_className) {
            info=[NSString stringWithFormat:@"%@ and isExclude=0",select];
        }
        
        //        NSString* info = @"carType='小车' and className='科目一'";//测试用例
        _examInfoArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
        
    }
    
    if ([btnTitle isEqualToString:@"顺序练习"]) {
        ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
        shunxu.arr=_examInfoArr;
        shunxu.title=@"顺序练习";
        shunxu.isMove=1;
        [self.navigationController pushViewController:shunxu animated:YES];
    }else if ([btnTitle isEqualToString:@"章节练习"]){
        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
        chapters.title=@"章节练习";
        chapters.allArr=_examInfoArr;
        [self.navigationController pushViewController:chapters animated:YES];
    }else if ([btnTitle isEqualToString:@"专项练习"]){
        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
        chapters.title=@"专项练习";
        chapters.allArr=_examInfoArr;
        [self.navigationController pushViewController:chapters animated:YES];
    }else if ([btnTitle isEqualToString:@"随机练习"]){
        ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
        shunxu.arr=_examInfoArr;
        shunxu.title=@"随机练习";
        if (_examInfoArr.count>0) {
            shunxu.isMove= arc4random()%_examInfoArr.count ;
        }
        [self.navigationController pushViewController:shunxu animated:YES];
        
    }else if ([btnTitle isEqualToString:@"模拟考试"]){
        JWPerInfoVC *dt = [[JWPerInfoVC alloc] init];
        dt.title = btnTitle;
        //科目
        dt.lblKSTM_name= _className;
        //车型
        dt.lblKSCX_name= _whichButton;
        
        dt.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dt animated:YES];
        
    }else if ([btnTitle isEqualToString:@"考试统计"]){
        JWLXTJVC *lxtjVC = [[JWLXTJVC alloc] init];
        lxtjVC.title = btnTitle;
        lxtjVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lxtjVC animated:YES];
    }else if ([btnTitle isEqualToString:@"排行榜"]){
        
    }else if ([btnTitle isEqualToString:@"考试历史"]){
        JWWDCJVC *wdcgVC = [[JWWDCJVC alloc] init];
        wdcgVC.title = btnTitle;
        wdcgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wdcgVC animated:YES];
    }else if ([btnTitle isEqualToString:@"我的错题"]){
        NSString* info = [NSString stringWithFormat:@"answerWere='true'"];
        NSArray* tempArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
        eliminate.title=@"我的错题";
        eliminate.examModelArr=tempArr;
        [self.navigationController pushViewController:eliminate animated:YES];
    }else if ([btnTitle isEqualToString:@"我的收藏"]){
        NSArray* tempArr = [exam selectWhere:@"isExclude=0 and isCollection=1" groupBy:nil orderBy:nil limit:nil];
        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
        eliminate.title=@"我的收藏";
        eliminate.examModelArr=tempArr;
        [self.navigationController pushViewController:eliminate animated:YES];
    }
    
}

//#pragma mark - 报名学车跳转
//- (void)btnClickTitle:(NSDictionary *)dicCellInfo{
//    YADEnrollSDTV *enrollSD = [[YADEnrollSDTV alloc] initWithStyle:UITableViewStyleGrouped];
//    enrollSD.title = @"报名学车";
//    enrollSD.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:enrollSD animated:YES];
//}

#pragma mark - SegmentView
- (void)loadHeadSegmentView{
    //     Segmented control with more customization and indexChangeBlock
    _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(50, 0, self.view.mj_w-200, 44)];
    _segmentControl.sectionTitles = @[@"报名学车", @"学车流程"];
    //切换对应ScrollView
    __weak typeof(self) weakSelf = self;
    [_segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.mj_w * index, 0, weakSelf.view.mj_w, weakSelf.view.mj_h-110) animated:YES];
    }];
    _segmentControl.selectionIndicatorHeight = 4.0f;
    _segmentControl.backgroundColor = [UIColor clearColor];
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    _segmentControl.selectionIndicatorColor = [UIColor clearColor];
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]};
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segmentControl.shouldAnimateUserSelection = NO;
    self.navigationItem.titleView = _segmentControl;
    [self loadScrollView];
    
    //创建右侧barButtonItem
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(btnRegisterClick) forControlEvents:UIControlEventTouchDragInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRegister];
    self.navigationItem.rightBarButtonItem=right;
}

- (void)btnRegisterClick{
    
}
#pragma mark - ScrollView
- (void)loadScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h-110)];
    self.scrollView.backgroundColor = JWColor(188, 187, 192);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.mj_w * 2, 0);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.mj_w, self.scrollView.mj_h) animated:YES];
    [self.view addSubview:self.scrollView];
    
    //报名学车
//    _enrollDriver = [[YADEnrollDriverTV alloc] initWithStyle:UITableViewStyleGrouped];
//    _enrollDriver.delegate = self;
//    _enrollDriver.view.frame = CGRectMake(0, 0, self.view.mj_w, self.scrollView.mj_h);
//    [self.scrollView addSubview:_enrollDriver.view];
    _webView = [[YADWebViewVC alloc] init];
    _webView.strURL = @"http://182.92.70.91:22223/yianda/bmxc_list.html";
    [self.scrollView addSubview:_webView.view];
    
//
    //学车流程
    _driveProcessVC = [[YADDriverProcessVC alloc] init];
    _driveProcessVC.view.frame = CGRectMake(self.view.mj_w, 0, self.view.mj_w, self.scrollView.mj_h);
    _driveProcessVC.simlationTestVC.delegate = self;
    [self.scrollView addSubview:_driveProcessVC.view];
    
    //模拟考试Delegate
//
//    //圈子
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.mj_w * 2, 0, self.view.mj_w, 210)];
//    [self setApperanceForLabel:label3];
//    label3.text = @"Headlines";
//    [self.scrollView addSubview:label3];
//    
//    //活动推荐
//    _cta = [[JWCTActivityVC alloc] init];
//    _cta.view.frame = CGRectMake(self.view.mj_w * 3, 0, self.view.mj_w, self.view.mj_h);
//    [self.scrollView addSubview:_cta.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [_segmentControl setSelectedSegmentIndex:page animated:YES];
}
@end
