//
//  YADSubjectFootCell.m
//  YAD
//
//  Created by JWX on 15/11/19.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADSubjectFootCell.h"

@implementation YADSubjectFootCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"YADSubjectFootCell";
    // 2. tableView查询可重用Cell
    YADSubjectFootCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADSubjectFootCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
