//
//  JWCarVIewCell.m
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWCarVIewCell.h"
#import "JWRecordBodyModel.h"
#import "JWRecordHeadModel.h"
#import "MBProgressHUD+MJ.h"


@implementation JWCarVIewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - cell只处理自己内部的，不让控制器关注cell的实现
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    JWCarVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWCarView" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setStuBookRecordInfo:(JWRecordBodyModel *)stuBookRecordInfo{
    _stuBookRecordInfo = stuBookRecordInfo;
    //教师名字
    self.lbName.text = self.stuBookRecordInfo.teacher;
    /**科目*/
    self.lbKM.text = self.stuBookRecordInfo.type;
    /**教练车号*/
    self.lbCH.text = self.stuBookRecordInfo.carcode;
    /**时段*/
    self.lbHour.text = self.stuBookRecordInfo.t_info;
    /**学员id二维码*/
    self.lblCode.text = self.stuBookRecordInfo.id;
    /**日期*/
    if(self.stuBookRecordInfo.ddate.length > 7){
        self.lbDate.text = [self.stuBookRecordInfo.ddate substringToIndex:10];
    }else{
        self.lbDate.text =  [self.stuBookRecordInfo.ddate stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"日期为空"];
    }
}

@end
