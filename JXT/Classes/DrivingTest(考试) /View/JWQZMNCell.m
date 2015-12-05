//
//  JWQZMNCell.m
//  JXT
//
//  Created by JWX on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWQZMNCell.h"
#import "NSLayoutConstraint+ClassMethodPriority.h"
#import "exam.h"

@interface JWQZMNCell()
@end

@implementation JWQZMNCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"JWQZMNCell";
    // 2. tableView查询可重用Cell
    JWQZMNCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWQZMNCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cell;
}

@end
