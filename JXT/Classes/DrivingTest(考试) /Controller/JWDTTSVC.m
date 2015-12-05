//
//  JWDTTSVC.m
//  JXT
//
//  Created by JWX on 15/8/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWDTTSVC.h"
#import "JWDTTSCVCell.h"
#import "PrefixHeader.pch"
#import "UIView+MJExtension.h"
#import "exam.h"

@interface JWDTTSVC () <UICollectionViewDataSource, UICollectionViewDelegate>
///**滚动视图*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) exam *exam;


@end

static NSString *const CellIdentifier = @"JWDTTSCVCell";

@implementation JWDTTSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /**加载滚动视图*/
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    //翻页
//    _collectionView.pagingEnabled = YES;
//    滚动标签
//    _collectionView.showsHorizontalScrollIndicator = YES;
    _flowLayout.footerReferenceSize = CGSizeMake(self.view
                                                 .mj_w, 350);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    /**注册cell*/
    [_collectionView registerClass:[JWDTTSCVCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWDTTSCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.btnTS setTitle:[NSString stringWithFormat:@"%ld", (long)indexPath.row+1] forState:UIControlStateNormal];
    [cell.btnTS setBackgroundColor:JWColor(235, 235, 241)];
    [cell.btnTS setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置Cell对错题背景色
    for(int i=0; i<_cellDCTRow.count; i++){
        NSString *row = [[_cellDCTRow objectAtIndex:i] substringFromIndex:1];
        NSString *title = [[_cellDCTRow objectAtIndex:i] substringWithRange:NSMakeRange(0,1)];
        if(row.intValue == indexPath.row){
            if([title isEqualToString:@"对"]){
                [cell.btnTS setBackgroundColor:JWColor(83, 164, 43)];
                [cell.btnTS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if([title isEqualToString:@"错"]){
                [cell.btnTS setBackgroundColor:[UIColor redColor]];
                [cell.btnTS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    return cell;
}

//- (void)loadDTView{
//    JWDTTSCVCell *cell;
//    for(int i=0; i<_cellDCTRow.count; i++){
//        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//        cell = (JWDTTSCVCell *)[_collectionView cellForItemAtIndexPath:index];
//        NSString *row = [[_cellDCTRow objectAtIndex:i] substringFromIndex:1];
//        NSString *title = [[_cellDCTRow objectAtIndex:i] substringWithRange:NSMakeRange(0,1)];
//        if(row.intValue == index.row){
//            if([title isEqualToString:@"对"]){
//                [cell.btnTS setBackgroundColor:JWColor(83, 164, 43)];
//                [cell.btnTS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }else if([title isEqualToString:@"错"]){
//                [cell.btnTS setBackgroundColor:[UIColor redColor]];
//                [cell.btnTS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }
////        }else{
////            [cell.btnTS setBackgroundColor:JWColor(235, 235, 241)];
////            [cell.btnTS setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        }
//        }
//    }
//}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
////    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//}
@end
