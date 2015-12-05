//
//  JWCarCell.m
//  JXT
//
//  Created by JWX on 15/8/6.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWCarCell.h"
#import "JWRecordBodyModel.h"

@implementation JWCarCell

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
    JWCarCell *cell= [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWCarCell" owner:nil options:nil] lastObject];
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
//        self.lbDate.text = [self.stuBookRecordInfo.ddate substringToIndex:10];
        NSArray* tempArr = [self.stuBookRecordInfo.ddate componentsSeparatedByString:@" "];
        self.lbDate.text = tempArr[0];
    }else{
        self.lbDate.text =  [self.stuBookRecordInfo.ddate stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"日期为空"];
    }
}
@end
