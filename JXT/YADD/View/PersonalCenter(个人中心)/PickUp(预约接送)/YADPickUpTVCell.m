//
//  YADPickUpTVCell.m
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADPickUpTVCell.h"
@interface YADPickUpTVCell()
@end

@implementation YADPickUpTVCell

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
    static NSString *ID = @"YADPickUpTVCell";
    // 2. tableView查询可重用Cell
    YADPickUpTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADPickUpTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)cellWithTitleDetail:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strPlac;
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:1*24*60*60];
    switch (indexPath.section) {
        case 0:
            strTitle = @"请填写您的预约信息";
            _lblTitle.textColor = [UIColor grayColor];
            _textDetail.hidden = YES;
            break;
        case 1:
            strTitle = @"您的姓名";
            strPlac = @"请输入姓名";
            [_textDetail setEnabled:NO];
            break;
        case 2:
            strTitle = @"您的手机";
            strPlac = @"请输入手机号码";
            _textDetail.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 3:
            strTitle = @"接送时间";
            _textDetail.hidden = YES;
            _datePicker.hidden = NO;
            break;
        case 4:
            strTitle = @"接送地点";
            strPlac = @"请输入详细接送地点";
            break;
    }
    _lblTitle.text = strTitle;
    _textDetail.placeholder = strPlac;
}
@end
