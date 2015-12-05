//
//  JWRecordTVCell.m
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWRecordTVCell.h"
#import "JWRecordHeadModel.h"
#import "JWRecordBodyModel.h"
#import "MBProgressHUD+MJ.h"



@implementation JWRecordTVCell

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
    JWRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JWRecordTVCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setStuBookRecordInfo:(JWRecordBodyModel *)stuBookRecordInfo{
    _stuBookRecordInfo = stuBookRecordInfo;
    //预约日期
    self.lbData.text = self.stuBookRecordInfo.ddate;
    //教师姓名
    self.lbName.text = self.stuBookRecordInfo.teacher;
    //预约时段
    self.lbHour.text = self.stuBookRecordInfo.t_info;
    //预约方式
    self.lbMode.text = self.stuBookRecordInfo.yyfs;
    //预约状态
    self.lbState.text = self.stuBookRecordInfo.status;
    //预约类型
    self.lbType.text = self.stuBookRecordInfo.type;
    //预约车号
    self.lbCarNo.text = self.stuBookRecordInfo.carcode;
   
    //预约id
    self.lbYYID.text = self.stuBookRecordInfo.id;
    
    /**是否可退约*/
  
    self.t_yn.text = self.stuBookRecordInfo.t_yn;
    if([self.t_yn.text isEqual:@"0"]){
        self.imageTY.hidden = YES;
        self.tylbl.hidden = YES;
    }else{
        self.imageTY.hidden = NO;
    }
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    //预约日期
//    self.lbData.text = self.stuBookRecordInfo.ddate;
//    //预约者
//    self.lbName.text = self.stuBookRecordInfo.per_name;
//    //预约时段
//    self.lbHour.text = self.stuBookRecordInfo.t_info;
//    //预约方式
//    self.lbMode.text = self.stuBookRecordInfo.yyfs;
//    //预约状态
//    self.lbState.text = self.stuBookRecordInfo.status;
//    //预约类型
//    self.lbType.text = self.stuBookRecordInfo.type;
//    //预约车号
//    self.lbCarNo.text = self.stuBookRecordInfo.carcode;
//    //预约id
//    self.lbYYID.text = self.stuBookRecordInfo.stuID;
//    
//    /**是否可退约*/
//    self.t_yn.text = self.stuBookRecordInfo.t_yn;
//    if([self.t_yn.text isEqual:@"0"]){
//        self.imageTY.hidden = YES;
//    }else{
//        self.imageTY.hidden = NO;
//    }
//    
//}



@end
