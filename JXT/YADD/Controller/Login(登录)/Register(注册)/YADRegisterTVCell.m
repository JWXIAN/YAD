//
//  YADRegisterTVCell.m
//  JXT
//
//  Created by JWX on 15/12/4.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "YADRegisterTVCell.h"
@interface YADRegisterTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation YADRegisterTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"YADRegisterTVCell";
    // 2. tableView查询可重用Cell
    YADRegisterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADRegisterTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellWithTitle:(NSIndexPath *)indexPath{
    NSArray *arrImage = @[@"zh", @"mima", @"zh", @"mima", @"mima"];
    NSArray *arrPlaceholder = @[@"请输入姓名", @"请输入手机号", @"请输入身份证号", @"报名来源", @"请选择车型"];
    if (indexPath.row == 0) {
        _imgView.image = [UIImage imageNamed:arrImage[0]];
        _textDetail.placeholder = arrPlaceholder[0];
    }else if(indexPath.row == 1){
        _imgView.image = [UIImage imageNamed:arrImage[1]];
        _textDetail.placeholder = arrPlaceholder[1];
        _textDetail.secureTextEntry = YES;
    }else if (indexPath.row == 2){
        _imgView.image = [UIImage imageNamed:arrImage[2]];
        _textDetail.placeholder = arrPlaceholder[2];
    }else if (indexPath.row == 3){
        _imgView.image = [UIImage imageNamed:arrImage[3]];
        _textDetail.placeholder = arrPlaceholder[3];
    }
}

@end
