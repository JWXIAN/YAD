//
//  YADEnrollDriverTVCell.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADEnrollDriverTVCell.h"
@interface YADEnrollDriverTVCell()

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDetail;
@end
@implementation YADEnrollDriverTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    YADEnrollDriverTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADEnrollDriverTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    NSString *strDetail;
    switch (indexPath.row) {
        case 0:
            strTitle = @"C1 普通班";
            strImage = @"";
            strDetail = @"收费3970，含考试费，有三种培训模式。";
            break;
        case 1:
            strTitle = @"C2 普通班";
            strImage = @"";
            strDetail = @"收费3970，含考试费，有三种培训模式。";
            break;
        case 2:
            strTitle = @"VIP 星级班";
            strImage = @"";
            strDetail = @"收费6700，含考试费，提供免费午餐、饮料，并有小车门对门接送。";
            break;
        case 3:
            strTitle = @"C1 自学直考班";
            strImage = @"";
            strDetail = @"报名收费970(含考试费)，每个学时按照80元收费。";
            break;
        case 4:
            strTitle = @"C1 早班及晚班";
            strImage = @"";
            strDetail = @"在普通班基础上收1500元，早班7点到9点，晚班18:00-22:00。";
            break;
    }
    _cellTitle.text = strTitle;
    _cellDetail.text = strDetail;
    _cellImage.image = [UIImage imageNamed:@"tabbar_home"];
}

@end
