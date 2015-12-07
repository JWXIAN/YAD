//
//  JWMyNewsCell.m
//  JXT
//
//  Created by JWX on 15/9/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWMyNewsCell.h"

@implementation JWMyNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"JWMyNewsCell";
    // 2. tableView查询可重用Cell
    JWMyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWMyNewsCell" owner:nil options:nil] lastObject];
    }
    cell.lblBT.layer.masksToBounds = YES;
    cell.lblBT.layer.cornerRadius = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    //设置自动行数与字符换行
    cell.lblText.numberOfLines = 0;
    cell.lblText.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    return cell;
}
@end
