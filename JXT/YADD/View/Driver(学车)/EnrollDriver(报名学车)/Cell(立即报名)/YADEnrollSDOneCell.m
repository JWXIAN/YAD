//
//  YADEnrollSDOneCell.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADEnrollSDOneCell.h"
@interface YADEnrollSDOneCell()
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end
@implementation YADEnrollSDOneCell

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
    static NSString *ID = @"YADEnrollSDOneCell";
    // 2. tableView查询可重用Cell
    YADEnrollSDOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADEnrollSDOneCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnSignUp.layer.cornerRadius = 5;
    return cell;
}
//立即报名
- (IBAction)btnClick:(id)sender {
    [self.delegate btnSignUpImmClick];
}
@end
