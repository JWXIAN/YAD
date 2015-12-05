//
//  YADLoginTVCell.m
//  YAD
//
//  Created by JWX on 15/11/27.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADLoginTVCell.h"

@interface YADLoginTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end
@implementation YADLoginTVCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"YADLoginTVCell";
    // 2. tableView查询可重用Cell
    YADLoginTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADLoginTVCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellWithTitle:(NSIndexPath *)indexPath{
    NSArray *arrImage = @[@"zh", @"mima"];
    NSArray *arrPlaceholder = @[@"请输入身份证号码/手机号/学员编号", @"请输入密码"];
    if (indexPath.row == 0) {
        _imgView.image = [UIImage imageNamed:arrImage[0]];
        _textDetail.placeholder = arrPlaceholder[0];
    }else{
        _imgView.image = [UIImage imageNamed:arrImage[1]];
        _textDetail.placeholder = arrPlaceholder[1];
        _textDetail.secureTextEntry = YES;
    }
}
@end
