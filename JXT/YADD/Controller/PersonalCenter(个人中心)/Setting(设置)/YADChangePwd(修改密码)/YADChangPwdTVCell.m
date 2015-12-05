//
//  YADChangPwdTVCell.m
//  JXT
//
//  Created by JWX on 15/12/5.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADChangPwdTVCell.h"
#import "PrefixHeader.pch"

@interface YADChangPwdTVCell()


@end

@implementation YADChangPwdTVCell

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
    static NSString *ID = @"YADChangPwdTVCell";
    // 2. tableView查询可重用Cell
    YADChangPwdTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADChangPwdTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellWithTitle:(NSIndexPath *)indexPath{
//    _textDetail.tintColor = JWColor(232, 94, 84);
    NSArray *arrTitle = @[@"原密码", @"新密码", @"新密码"];
    NSArray *arrPlaceholder = @[@"请输入密码", @"请输入新密码", @"再次输入新的密码"];
    if (indexPath.row == 0) {
        _lblTItle.text = arrTitle[0];
        _textDetail.placeholder = arrPlaceholder[0];
    }else if(indexPath.row == 1){
        _lblTItle.text = arrTitle[1];
        _textDetail.placeholder = arrPlaceholder[1];
    }else{
        _lblTItle.text = arrTitle[2];
        _textDetail.placeholder = arrPlaceholder[2];
    }
}
@end
