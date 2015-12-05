//
//  YADSubjectFourVC.m
//  YAD
//
//  Created by JWX on 15/11/19.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADSubjectFourVC.h"
#import "UIView+MJExtension.h"
#import "JWSimulationTestCell.h"
#import "PrefixHeader.pch"

@interface YADSubjectFourVC ()<UICollectionViewDelegate, UICollectionViewDataSource, JWSimulationTestCellDelegate>
/**布局flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**个人信息View*/
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic ,strong) UILabel *lblTitle;

#pragma mark - 模拟考试
@property(strong,nonatomic) NSString*  className,* whichButton;//科目名称 , 车型
@property(strong,nonatomic) NSArray*  examInfoArr;//存放题目

@end

/**cell重用标识符*/
static NSString *const CellIdentifier = @"JWSimulationTestCell";
//头部
static NSString *const kheaderIdentifier = @"kheaderIdentifier";

@implementation YADSubjectFourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadVw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载Collection
- (void)loadVw{
    self.view.backgroundColor = [UIColor whiteColor];
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

//#pragma mark - 题库
//- (void)loadSimulationData{
//    NSString *select= @"carType not like '%%Z%%' and carType like '%%C%%'";
//
//    NSString* info = [NSString stringWithFormat:@"%@ and className='%@' and isExclude=0",select,_className];
//    if (!_className) {
//        info=[NSString stringWithFormat:@"%@ and isExclude=0",select];
//    }
//    //        NSString* info = @"carType='小车' and className='科目一'";//测试用例
//    _examInfoArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
//}
//
//cell buttonClick代理
- (void)btnClickTitle:(NSString *)btnTitle{
    //    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ////    NSString* select;
    ////    NSString* temp;
    ////    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    ////    _whichButton = [user objectForKey:@"whichButton"];
    ////
    ////    if (!([btnTitle isEqualToString:@"考试历史"]||[btnTitle isEqualToString:@"考试统计"]||[btnTitle isEqualToString:@"考试要点"]||[btnTitle isEqualToString:@"许愿墙"]))
    ////    {
    ////        if ([_whichButton hasPrefix:@"Z"]) {
    ////            temp=[_whichButton substringFromIndex:1];
    ////            select=[NSString stringWithFormat:@"carType like '%%Z%%' and carType like '%%%@%%'",temp];
    ////        }
    ////        else
    ////        {
    ////            select= [NSString stringWithFormat:@"carType not like '%%Z%%' and carType like '%%%@%%'",_whichButton];
    ////        }
    ////    }
    //if ([btnTitle isEqualToString:@"顺序练习"]) {
    //        ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
    //        shunxu.arr=_examInfoArr;
    //        shunxu.title=@"顺序练习";
    //        shunxu.isMove=1;
    //        [self.navigationController pushViewController:shunxu animated:YES];
    //    }else if ([btnTitle isEqualToString:@"章节练习"]){
    //        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
    //        chapters.title=@"章节练习";
    //        chapters.allArr=_examInfoArr;
    //        [self.navigationController pushViewController:chapters animated:YES];
    //    }else if ([btnTitle isEqualToString:@"专项练习"]){
    //        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
    //        chapters.title=@"专项练习";
    //        chapters.allArr=_examInfoArr;
    //        [self.navigationController pushViewController:chapters animated:YES];
    //    }else if ([btnTitle isEqualToString:@"随机练习"]){
    //        ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
    //        shunxu.arr=_examInfoArr;
    //        shunxu.title=@"随机练习";
    //        if (_examInfoArr.count>0) {
    //            shunxu.isMove= arc4random()%_examInfoArr.count ;
    //        }
    //        [self.navigationController pushViewController:shunxu animated:YES];
    //
    //    }else if ([btnTitle isEqualToString:@"模拟考试"]){
    //        JWPerInfoVC *dt = [[JWPerInfoVC alloc] init];
    //
    //        dt.title = btnTitle;
    //        //科目
    //        dt.lblKSTM_name=@"科目一";
    //        //车型
    //        dt.lblKSCX_name=@"C";
    //
    //        dt.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:dt animated:YES];
    //
    //    }else if ([btnTitle isEqualToString:@"考试统计"]){
    //        JWLXTJVC *lxtjVC = [[JWLXTJVC alloc] init];
    //        lxtjVC.title = btnTitle;
    //        lxtjVC.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:lxtjVC animated:YES];
    //    }else if ([btnTitle isEqualToString:@"排行榜"]){
    //
    //    }else if ([btnTitle isEqualToString:@"考试历史"]){
    //        JWWDCJVC *wdcgVC = [[JWWDCJVC alloc] init];
    //        wdcgVC.title = btnTitle;
    //        wdcgVC.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:wdcgVC animated:YES];
    //    }else if ([btnTitle isEqualToString:@"我的错题"]){
    //        NSString* info = [NSString stringWithFormat:@"answerWere='true'"];
    //        NSArray* tempArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
    //        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
    //        eliminate.title=@"我的错题";
    //        eliminate.examModelArr=tempArr;
    //        [self.navigationController pushViewController:eliminate animated:YES];
    //    }else if ([btnTitle isEqualToString:@"我的收藏"]){
    //        NSArray* tempArr = [exam selectWhere:@"isExclude=0 and isCollection=1" groupBy:nil orderBy:nil limit:nil];
    //        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
    //        eliminate.title=@"我的收藏";
    //        eliminate.examModelArr=tempArr;
    //        [self.navigationController pushViewController:eliminate animated:YES];
    //    }
    //
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
    
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
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
