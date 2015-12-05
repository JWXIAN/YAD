//
//  YADEnrollSDThreeCell.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADEnrollSDThreeCell.h"
#import "YADEnrollThreeImageCell.h"
#import "UIView+MJExtension.h"

@interface YADEnrollSDThreeCell() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/**详情*/
@property (weak, nonatomic) IBOutlet UITextView *textViewDetail;

@end
/**cell重用标识符*/
static NSString *const CellIdentifier = @"YADEnrollThreeImageCell";

@implementation YADEnrollSDThreeCell

- (void)awakeFromNib {
    // Initialization code
    [self loadCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"YADEnrollSDThreeCell";
    // 2. tableView查询可重用Cell
    YADEnrollSDThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADEnrollSDThreeCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - CollectionView
- (void)loadCollectionView{
    //collectionView背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    /**注册cell*/
    [_collectionView registerClass:[YADEnrollThreeImageCell class] forCellWithReuseIdentifier:CellIdentifier];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YADEnrollThreeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//// 单独定制每行item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 5;
//}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (IBAction)btnMoreClick:(id)sender {
    
}
@end
