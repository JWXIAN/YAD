//
//  JWKMTestVC.m
//  JXT
//
//  Created by JWX on 15/8/11.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWKMTestVC.h"
#import "JWTestCell.h"
#import "UIView+MJExtension.h"
#import "JWTestFooterCell.h"
#import "PrefixHeader.pch"
#import "WMPageConst.h"
#import "exam.h"
#import "JWPerInfoVC.h"
#import "JWWDCJVC.h"
#import "JWLXTJVC.h"
#import "JXT-swift.h"
@interface JWKMTestVC () <UICollectionViewDelegate, UICollectionViewDataSource,UIAlertViewDelegate>
@property (nonatomic, readonly) UICollectionView *collectionView;
@property(strong,nonatomic) NSString*  className,* whichButton;//科目名称 , 车型
@property(strong,nonatomic) NSArray*  examInfoArr;//存放题目

@end

static NSString *const CellIdentifier = @"JWTestCell";
static NSString *const HeaderIdentifier = @"HeaderIdentifier";
static NSString *const FooterIdentifier = @"FooterIdentifier";

@implementation JWKMTestVC
#pragma - mark 通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)pushview:(NSNotification* )sender
{
    NSString* select;
    NSString* temp;
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    _whichButton = [user objectForKey:@"whichButton"];
    
    if (!([sender.object isEqualToString:@"我的成绩"]||[sender.object isEqualToString:@"练习统计"]||[sender.object isEqualToString:@"考试要点"]||[sender.object isEqualToString:@"许愿墙"]))
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
    
    
    if ([sender.object isEqualToString:@"考试要点"]) {
        ExamTechniqueTableViewController* technique = [story instantiateViewControllerWithIdentifier:@"technique"];
        technique.className=_className;
        [self.navigationController pushViewController:technique animated:YES];
    }
    else if (![sender.object isEqualToString:@"排除的题"]) {
        NSString* info = [NSString stringWithFormat:@"%@ and className='%@' and isExclude=0",select,_className];
        if (!_className) {
            info=[NSString stringWithFormat:@"%@ and isExclude=0",select];
        }
         
        //        NSString* info = @"carType='小车' and className='科目一'";//测试用例
        _examInfoArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
      
    }
    if ([sender.object isEqualToString:@"顺序练习"]) {
       

            ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
            shunxu.arr=_examInfoArr;
            shunxu.title=@"顺序练习";
            shunxu.isMove=1;
            [self.navigationController pushViewController:shunxu animated:YES];
        
        
    }
    if ([sender.object isEqualToString:@"章节练习"]) {
        
        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
        chapters.title=@"章节练习";
        chapters.allArr=_examInfoArr;
        [self.navigationController pushViewController:chapters animated:YES];
    }
    if ([sender.object isEqualToString:@"随机练习"]) {
        ExamTopBodyView* shunxu=[story instantiateViewControllerWithIdentifier:@"shunxu"];
        shunxu.arr=_examInfoArr;
        shunxu.title=@"随机练习";
        if (_examInfoArr.count>0) {
            shunxu.isMove= arc4random()%_examInfoArr.count ;
        }
        [self.navigationController pushViewController:shunxu animated:YES];
    
    }
    if ([sender.object isEqualToString:@"专项练习"]) {
        
        ChaptersTable* chapters = [story instantiateViewControllerWithIdentifier:@"Chapters"];
        chapters.title=@"专项练习";
        chapters.allArr=_examInfoArr;
        [self.navigationController pushViewController:chapters animated:YES];
    }
    if ([sender.object isEqualToString:@"排除的题"]) {
        
        NSString* info = [NSString stringWithFormat:@"%@  and className='%@' and isExclude=1",select,_className];
        if (!_className) {
            info=[NSString stringWithFormat:@"%@  and isExclude=1",select];
        }
        
        //        NSString* info = @"carType='小车' and className='科目一'";//测试用例
        NSArray* tempArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
        eliminate.title=@"排除的题";
        eliminate.examModelArr=tempArr;
        [self.navigationController pushViewController:eliminate animated:YES];
        
        }
    if ([sender.object isEqualToString:@"我的收藏"]) {
        
//        NSString* info = [NSString stringWithFormat:@"%@  and className='%@' and isExclude=0 and isCollection=1",select,_className];
//      
//        if (!_className) {
//            info=[NSString stringWithFormat:@"%@  and isExclude=0 and isCollection=1",select];
//        }
        //        NSString* info = @"carType='小车' and className='科目一'";//测试用例
        NSArray* tempArr = [exam selectWhere:@"isExclude=0 and isCollection=1" groupBy:nil orderBy:nil limit:nil];
        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
        eliminate.title=@"我的收藏";
        eliminate.examModelArr=tempArr;
        [self.navigationController pushViewController:eliminate animated:YES];
    }

    if ([sender.object isEqualToString:@"我的错题"]) {
        NSString* info = [NSString stringWithFormat:@"answerWere='true'"];
        NSArray* tempArr = [exam selectWhere:info groupBy:nil orderBy:nil limit:nil];
        EliminateViewController* eliminate = [story instantiateViewControllerWithIdentifier:@"eliminate"];
        eliminate.title=@"我的错题";
        eliminate.examModelArr=tempArr;
        [self.navigationController pushViewController:eliminate animated:YES];
    }
    if ([sender.object isEqualToString:@"模拟考试"]){
        JWPerInfoVC *dt = [[JWPerInfoVC alloc] init];
    
        dt.title = sender.object;
        if (_className) {
             dt.lblKSTM_name=_className;
        }
       else
       {
           dt.lblKSTM_name=[NSString stringWithFormat:@"%@考试",_whichButton];
       }
        dt.lblKSCX_name=_whichButton;
        dt.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dt animated:YES];
    }
    
    if([sender.object isEqualToString:@"我的成绩"]){
        JWWDCJVC *wdcgVC = [[JWWDCJVC alloc] init];
        wdcgVC.title = sender.object;
        wdcgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wdcgVC animated:YES];
    }
    
    if([sender.object isEqualToString:@"练习统计"]){
        JWLXTJVC *lxtjVC = [[JWLXTJVC alloc] init];
        lxtjVC.title = sender.object;
        lxtjVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lxtjVC animated:YES];
    }
    if ([sender.object isEqualToString:@"许愿墙"]) {
        StudentWish* wish = [story instantiateViewControllerWithIdentifier:@"StudentWish"];
        [self.navigationController pushViewController:wish animated:YES];
    }
    

    
}

- (void)titleget:(NSNotification* )sender//接收科目改变
{
    NSDictionary* dic =  sender.object;
    _className=dic[@"title"];
    [[NSUserDefaults standardUserDefaults]setObject:_className forKey:@"xuanzekemuzhihou"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   //错题
       NSArray* arr = [exam selectWhere:@"answerWere='true'" groupBy:nil orderBy:nil limit:nil];
      [[NSNotificationCenter defaultCenter]postNotificationName:@"MyMistake" object:arr];
}

#pragma - mark 界面加载

- (void)viewDidLoad {
    [super viewDidLoad];

  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushview:) name:@"pushview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleget:) name:WMControllerDidFullyDisplayedNotification object:nil];//监听选择科目
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    CGRect frame = self.view.frame;
    
   _collectionView  =[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = JWColor(245.0, 245.0, 245.0);
    _collectionView.bounces=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator=NO;
    
    flowLayout.minimumLineSpacing =0;
    /**注册cell*/
    [_collectionView registerClass:[JWTestCell class] forCellWithReuseIdentifier:CellIdentifier];
    /**注册底部*/
    [_collectionView registerClass:[JWTestFooterCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
    //代码控制header和footer的显示
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    collectionViewLayout.footerReferenceSize = CGSizeMake(self.view
                                                          .mj_w, 220);
    
    [self.view addSubview:_collectionView];
}



#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell= (JWTestCell *)[[[NSBundle mainBundle] loadNibNamed:@"JWTestCell" owner:self options:nil] lastObject];
    }
  
   
     [cell cellWithIndexPath:indexPath];
  
 
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *titleView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    } else if (kind == UICollectionElementKindSectionFooter) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
    }
    return titleView;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.view.frame.size.width<=320) {
        return CGSizeMake(self.view.mj_w, ([UIScreen mainScreen].bounds.size.height-120-15)/2);
    }
    else
    {
        return CGSizeMake(self.view.mj_w, ([UIScreen mainScreen].bounds.size.height-150-15 - 44)/2);
    }
    
}

//- (UICollectionViewFlowLayout *) flowLayout{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 50.0f);  //设置head大小
//    flowLayout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
//    return flowLayout;
//}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 0, 5);
//}
//#pragma mark --UICollectionViewDelegate
////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
////    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
////    cell.backgroundColor = [UIColor whiteColor];
//}
////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

@end
