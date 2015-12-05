//
//  JWTrainCell.m
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWTrainCell.h"
#import "JWTrainHeadModel.h"
#import "JWTrainBodyModel.h"

@implementation JWTrainCell

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
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    JWTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWTrainCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setStuBookRecord:(JWTrainBodyModel *)stuBookRecord
{
    // setter方法中，第一句要赋值，否则要在其他方法中使用模型，将无法访问到
    //预约日期
    _stuBookRecord = stuBookRecord;
    self.lbDate.text = self.stuBookRecord.ddate;
    //预约时段
    self.lbHour.text = self.stuBookRecord.t_info;
    //预约类型
    self.lbKM.text = self.stuBookRecord.type;
    //预约车号
    self.lbCH.text = self.stuBookRecord.carcode;
    //评价状态
    self.lbPJ.text = self.stuBookRecord.pjzt;
    //教练评语
    self.lbJLPY.text = self.stuBookRecord.jspy;
    //教练姓名
    self.lbJL.text = self.stuBookRecord.teacher;
    /**培训id*/
    self.pxid = self.stuBookRecord.id;
    if ([self.lbPJ.text isEqual: @"未评价"]) {
        self.lbPJ.hidden = YES;
        self.imagePJ.hidden = NO;
    }else{
        self.imagePJ.hidden = YES;
        self.lbPJ.hidden = NO;
    }
}
@end
