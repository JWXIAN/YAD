//
//  YADEnrollSDTV.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADEnrollSDTV.h"
#import "YADEnrollSDOneCell.h"
#import "YADEnrollSDTwoCell.h"
#import "YADEnrollSDThreeCell.h"
#import "UIView+MJExtension.h"
#import "YADEnrollEvaluationCell.h"
#import "PrefixHeader.pch"
#import "UILabel+JWContentSize.h"

@interface YADEnrollSDTV ()<UICollectionViewDataSource, UICollectionViewDelegate, YADEnrollSDOneCellDelegate>
/**布局flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**CollectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**评价文本长度*/
@property (nonatomic, assign) CGSize evaluationTextSize;

/**评论数组*/
@property (nonatomic, strong) NSArray *arrEva;
/**TV Cell高度*/
@property (nonatomic, assign) NSInteger cellHeight;
@end
/**cell重用标识符*/
static NSString *const CellIdentifier = @"YADEnrollEvaluationCell";

@implementation YADEnrollSDTV

- (void)viewDidLoad {
    [super viewDidLoad];
    [self itView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 立即报名
- (void)btnSignUpImmClick{
    
}

- (void)itView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    //隐藏多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 1)];
    //计算Cell高度
    [self CalculateCellHeight];
}

#pragma mark - 计算Cell高度
- (void)CalculateCellHeight{
    _arrEva = @[@"服务好 45454", @"态度好 4545", @"非常非的好 4543", @"好 344", @"哈哈哈 644", @"不知道么 543", @"非常非的好 4543", @"手活非常 344", @"哈哈哈 644", @"知道说什么 543"];
    int lblH = 0;
    int lblW = 0;
    for (int i=0; i<_arrEva.count; i++) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = _arrEva[i];
        lblW += [lbl JWContentSize].width;
        
        if (lblW>self.view.mj_w-25) {
            lblH+=20;
        }
    }
    _cellHeight = lblH;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YADEnrollSDOneCell *oneCell = [YADEnrollSDOneCell cellWithTableView:tableView];
        return oneCell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            YADEnrollSDTwoCell *twoCell = [YADEnrollSDTwoCell cellWithTableView:tableView];
            return twoCell;
        }else{
            static NSString *ID = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            [cell.contentView addSubview:[self evaluationCell:CGRectMake(0, 0, self.view.mj_w, _cellHeight)]];
            return cell;
        }
    }else{
        YADEnrollSDThreeCell *threeCell = [YADEnrollSDThreeCell cellWithTableView:tableView];
        return threeCell;
    }
}
#pragma mark - CollectionView
#pragma mark - 评价Cell
- (UIView *)evaluationCell:(CGRect)rectFrame{
    //加载滚动视图
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //垂直布局
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView  =[[UICollectionView alloc]initWithFrame:rectFrame collectionViewLayout:_flowLayout];
    //collectionView背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    /**注册cell*/
    [_collectionView registerClass:[YADEnrollEvaluationCell class] forCellWithReuseIdentifier:CellIdentifier];
    return _collectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 101;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 47;
        }else{
            return _cellHeight;
        }
    }else{
        return 425;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && indexPath.row == 0) {
        
    }
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrEva.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YADEnrollEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.lblEvaluation.text = _arrEva[indexPath.row];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = _arrEva[indexPath.row];
    //计算长度
    _evaluationTextSize = [lbl JWContentSize];
    return CGSizeMake(_evaluationTextSize.width, _evaluationTextSize.height);
}
// 单独定制每行item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
