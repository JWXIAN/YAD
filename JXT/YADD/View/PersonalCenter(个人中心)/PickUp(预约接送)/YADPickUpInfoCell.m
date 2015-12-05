//
//  YADPickUpInfoCell.m
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADPickUpInfoCell.h"
#import "PrefixHeader.pch"

@interface YADPickUpInfoCell()<UIAlertViewDelegate>
/**预约时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
/**预约地点*/
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
/**预约状态*/
@property (weak, nonatomic) IBOutlet UILabel *lblState;
/**预约取消*/
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
@implementation YADPickUpInfoCell

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
    static NSString *ID = @"YADPickUpInfoCell";
    // 2. tableView查询可重用Cell
    YADPickUpInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADPickUpInfoCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)btnCancelClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"预约接送" message:@"确定取消预约接送?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)cellWithIndexPath:(NSIndexPath *)indexPath{
    _btnCancel.tag = indexPath.row;
}

- (void)setPickUpInfoModel:(YADPickUpInfoModel *)pickUpInfoModel{
    _pickUpInfoModel = pickUpInfoModel;
    _btnCancel.layer.cornerRadius = 5;
    _btnCancel.hidden = NO;
    [_btnCancel setBackgroundColor:JWColor(232, 94, 84)];
    
    _lblDate.text = _pickUpInfoModel.jstime;
    _lblLocation.text= _pickUpInfoModel.jsadd;
    _lblState.text = _pickUpInfoModel.status;
    _lblID.text = _pickUpInfoModel.id;
    
    if ([_pickUpInfoModel.status isEqualToString:@"完成"]) {
        _btnCancel.hidden = YES;
        _lblState.textColor = [UIColor orangeColor];
    }else if([_pickUpInfoModel.status isEqualToString:@"取消"]){
        _btnCancel.hidden = YES;
        _lblState.textColor = [UIColor grayColor];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.delegate btnCancelPickUpClick:_btnCancel.tag];
    }
}
@end
