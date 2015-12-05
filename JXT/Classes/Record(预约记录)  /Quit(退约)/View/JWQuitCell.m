//
//  JWQuitCell.m
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWQuitCell.h"
#import "JWRecordHeadModel.h"
#import "JWRecordBodyModel.h"

@implementation JWQuitCell

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
    JWQuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWQuitCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setStuBookRecord:(JWRecordBodyModel *)stuBookRecord{
    _stuBookRecord = stuBookRecord;
    //预约日期
    self.lbDate.text = self.stuBookRecord.ddate;
    //预约时段
    self.lbHour.text = self.stuBookRecord.t_info;
    //预约类型
    self.lbKU.text = self.stuBookRecord.type;
    //预约车号
    self.lbCH.text = self.stuBookRecord.carcode;
    //教练姓名
    self.lbJL.text = self.stuBookRecord.teacher;
}

@end
