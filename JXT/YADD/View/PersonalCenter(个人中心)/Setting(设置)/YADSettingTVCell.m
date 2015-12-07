//
//  YADSettingTVCell.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADSettingTVCell.h"
@interface YADSettingTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;


@end
@implementation YADSettingTVCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    YADSettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADSettingTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    if (indexPath.section == 0) {
        strTitle = @"修改密码";
        strImage = @"设置-修改密码";
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                strTitle = @"接受推送";
                strImage = @"设置-接受推送";
                break;
            case 1:
                strTitle = @"分享给朋友";
                strImage = @"设置-分享给朋友";
                break;
            case 2:
                strTitle = @"意见反馈";
                strImage = @"设置-意见反馈";
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                strTitle = @"使用帮助";
                strImage = @"设置-使用帮助";
                break;
            case 1:
                strTitle = @"联系客服";
                strImage = @"设置-联系客服";
                break;
            case 2:
                strTitle = @"关于";
                strImage = @"个人中心-我的消息";
                break;
        }
    }
    _cellTitle.text = strTitle;
    _cellImage.image = [UIImage imageNamed:strImage];
}
@end
