//
//  YADUserInfoCell.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADUserInfoCell.h"
#import "JiaxiaotongAPI.h"
#import "JWExamScheduleInfo.h"

@interface YADUserInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellDetial;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;



@end
@implementation YADUserInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"YADUserInfoCell";
    // 2. tableView查询可重用Cell
    YADUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADUserInfoCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath userInfo:(JWProfileModel *)userInfo testInfo:(NSString *)testInfo{
    NSArray *arrTitle = @[@"身份证号:", @"总学时:", @"已学学时:", @"剩余学时:", @"考试进度:"];
    NSArray *arrImage = @[@"用户信息-身份证号", @"用户信息-总学时", @"用户信息-已学学时", @"用户信息-剩余学时", @"用户信息-考试进度"];
    _cellTitle.text = arrTitle[indexPath.row];
    _cellImage.image = [UIImage imageNamed:arrImage[indexPath.row]];
    NSString *strDetail;
    switch (indexPath.row) {
        case 0:
            strDetail = userInfo.per_idcardno;
            break;
        case 1:
            strDetail = userInfo.out_zongshi;
            break;
        case 2:
            strDetail = userInfo.yixueshi;
            break;
        case 3:
            strDetail = userInfo.out_shengyu;
            break;
        case 4:
            strDetail = testInfo;
            break;
    }
    _cellDetial.text = strDetail;
}
@end
