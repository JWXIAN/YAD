//
//  YADLifeTVCell.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADLifeTVCell.h"
@interface YADLifeTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end

@implementation YADLifeTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    YADLifeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADLifeTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    switch (indexPath.row) {
        case 0:
            strTitle = @"优惠信息";
            strImage = @"生活助理-优惠信息";
            break;
        case 1:
            strTitle = @"新出交通法规";
            strImage = @"生活助理-新出交通法规";
            break;
        case 2:
            strTitle = @"新出车型";
            strImage = @"生活助理-新出车型";
            break;
    }
    _cellImage.image = [UIImage imageNamed:strImage];
    _cellTitle.text = strTitle;
}
@end
