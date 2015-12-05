//
//  JWWDCJCell.m
//  JXT
//
//  Created by JWX on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWWDCJCell.h"
#import "PrefixHeader.pch"
#import "JWWDCJStatBodyModel.h"
@interface JWWDCJCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mid_left;//中间分割线距离左侧距离

@end

@implementation JWWDCJCell
-(void)updateConstraints
{
    [super updateConstraints];
    _mid_left.constant=(self.frame.size.width-0.5)/2;
    
}
#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"JWWDCJCell";
    // 2. tableView查询可重用Cell
    JWWDCJCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWWDCJCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cell;
}

- (void)cellWithIndexPath:(NSIndexPath *)indexPath{
    _cellRowIndex = indexPath;
}

- (void)awakeFromNib {
}

- (void)setWdcjStat:(JWWDCJStatBodyModel *)wdcjStat{
    _wdcjStat = wdcjStat;
    //序号
    _lblXH.text = [NSString stringWithFormat:@"%ld", _cellRowIndex.row+1];
    //分数
    _lblScore.text = _wdcjStat.kaofenshu;
    //日期
    _lblDate.text = [_wdcjStat.starttime substringWithRange:NSMakeRange(5,5)];
    //用时
    _lblTime.text = _wdcjStat.kaotime;
    //评语
    if([_wdcjStat.kaofenshu integerValue]>=90){
       _lblPY.text = @"驾驾车神";
    }else{
       _lblPY.text = @"马路杀手";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
