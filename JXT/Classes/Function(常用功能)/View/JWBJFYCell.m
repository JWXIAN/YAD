//
//  JWBJFYCell.m
//  JXT
//
//  Created by JWX on 15/10/12.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWBJFYCell.h"
#import "MBProgressHUD+MJ.h"
#import "JWBJFYTV.h"

@implementation JWBJFYCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    JWBJFYCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWBJFYCell" owner:nil options:nil] lastObject];
    }
    cell.btnLJBJ.layer.cornerRadius = 5;
    return cell;
}

- (IBAction)btnLJBJ:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"payBtnIndex" object:[NSString stringWithFormat:@"%ld", _btnLJBJ.tag]];
}
@end
