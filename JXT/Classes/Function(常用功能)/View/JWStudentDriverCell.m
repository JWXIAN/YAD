//
//  JWStudentDriverCell.m
//  JXT
//
//  Created by JWX on 15/9/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWStudentDriverCell.h"

@implementation JWStudentDriverCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTV:(UITableView *)tableView indexPathRow:(NSIndexPath *)index
{
   
    NSString *imageIcon;
    NSString *lblTitle;
    // 1. 可重用标示符
    static NSString *ID = @"JWStudentDriverCell";
    // 2. tableView查询可重用Cell
    JWStudentDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWStudentDriverCell" owner:nil options:nil] firstObject];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    switch(index.section){
        case 0:
        {
            imageIcon = @"练车";
            lblTitle = @"预约练车";
            break;
        }
        case 1:
        {
            imageIcon = @"预约记录";
            lblTitle = @"预约记录";
            break;
        }
        case 2:
        {
            imageIcon = @"购买";
            lblTitle = @"购买学时";
            break;
        }
        case 3:
        {
            imageIcon=@"zb";
            lblTitle=@"补缴费用";
            break;
        }
        case 4:
        {
            imageIcon = @"进度";
            lblTitle = @"考试记录";
            break;
        }
        case 5:
        {
            imageIcon=@"dg";
            lblTitle=@"灯光和语音模拟";
            break;
        }
        case 6:
        {
            imageIcon=@"zb";
            lblTitle=@"周边";
            break;
        }
        case 7:
        {
            imageIcon = @"模拟";
            lblTitle = @"模拟考试";
            break;
        }
     
    }
    
    cell.imageIcon.image = [UIImage imageNamed:imageIcon];
    cell.lblText.text = lblTitle;
    return cell;
}

@end
