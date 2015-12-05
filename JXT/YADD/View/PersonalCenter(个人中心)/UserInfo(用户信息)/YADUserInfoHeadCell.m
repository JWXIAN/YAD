//
//  YADUserInfoHeadCell.m
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADUserInfoHeadCell.h"
#import "UIImageView+WebCache.h"

@interface YADUserInfoHeadCell()
//照片
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
//名字
@property (weak, nonatomic) IBOutlet UILabel *cellDetailName;
//学号
@property (weak, nonatomic) IBOutlet UILabel *cellDetailNo;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *cellDetailPhone;
//报名日期
@property (weak, nonatomic) IBOutlet UILabel *cellDetailDate;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation YADUserInfoHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"YADUserInfoHeadCell";
    // 2. tableView查询可重用Cell
    YADUserInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3. 如果没有可重用cell
    if (cell == nil) {
        //4. 从XIB加载自定义视图
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YADUserInfoHeadCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setPerson:(JWProfileModel *)person{
    _person = person;
    [_cellImage sd_setImageWithURL:[NSURL URLWithString:_person.per_photo] placeholderImage:[UIImage imageNamed:@"zh"]];
    _cellDetailName.text=_person.per_name;
    _cellDetailNo.text = _person.per_id;
    _cellDetailPhone.text= _person.per_mobile;
    
    NSRange range = [_person.part_registrationdate rangeOfString:@" "];//匹配得到的下标
    NSString* bes=_person.part_registrationdate;
    if (range.length!=0) {
        bes=[_person.part_registrationdate substringToIndex:range.location];//截取范围类的字符串
    }
    _cellDetailDate.text=bes;
}
@end
