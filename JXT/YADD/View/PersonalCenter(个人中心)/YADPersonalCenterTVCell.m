//
//  YADPersonalCenterTVCell.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADPersonalCenterTVCell.h"
@interface YADPersonalCenterTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@end

@implementation YADPersonalCenterTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    YADPersonalCenterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADPersonalCenterTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    switch (indexPath.row) {
        case 0:
            strTitle = @"学车流程";
            strImage = @"个人中心-学车流程";
            break;
        case 1:
            strTitle = @"练车预约";
            strImage = @"个人中心-练车预约";
            break;
        case 2:
            strTitle = @"预约记录";
            strImage = @"个人中心-预约记录";
            break;
        case 3:
            strTitle = @"考试预约";
            strImage = @"个人中心-考试预约";
            break;
        case 4:
            strTitle = @"预约接送(VIP学员)";
            strImage = @"个人中心-预约vip";
            break;
        case 5:
            strTitle = @"我的成绩";
            strImage = @"个人中心-我的成绩";
            break;
        case 6:
            strTitle = @"我的消息";
            strImage = @"个人中心-我的消息";
            break;
        case 7:
            strTitle = @"选择题库";
            strImage = @"个人中心-选择题库";
            break;
        case 8:
            strTitle = @"我的评价";
            strImage = @"个人中心-我的评价";
            break;
        case 9:
            strTitle = @"在线客服";
            strImage = @"个人中心-在线客服";
            break;
        case 10:
            strTitle = @"设置";
            strImage = @"个人中心-设置";
            break;
    }
    _cellTitle.text = strTitle;
    _cellImage.image = [UIImage imageNamed:strImage];
}
@end
