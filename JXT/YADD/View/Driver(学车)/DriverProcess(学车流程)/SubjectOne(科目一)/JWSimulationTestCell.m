//
//  JWSimulationTestCell.m
//  projectTemp
//
//  Created by JWX on 15/11/2.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "JWSimulationTestCell.h"
@interface JWSimulationTestCell()
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@end
@implementation JWSimulationTestCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JWSimulationTestCell" owner:self options:nil];
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)loadTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    if (indexPath.section == 0) {
        _btnTitle.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
                strTitle = @"顺序练习";
                strImage = @"111";
                break;
            case 1:
                strTitle = @"章节练习";
                strImage = @"222";
                break;
            case 2:
                strTitle = @"专项练习";
                strImage = @"333";
                break;
            case 3:
                strTitle = @"随机练习";
                strImage = @"444";
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                strTitle = @"模拟考试";
                strImage = @"555";
                _btnTitle.tag = 4;
                break;
            case 1:
                strTitle = @"考试统计";
                strImage = @"666";
                _btnTitle.tag = 5;
                break;
            case 2:
                strTitle = @"排行榜";
                strImage = @"777";
                _btnTitle.tag = 6;
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                strTitle = @"考试历史";
                strImage = @"888";
                break;
            case 1:
                strTitle = @"我的错题";
                strImage = @"999";
                break;
            case 2:
                strTitle = @"我的收藏";
                strImage = @"101010";
                break;
        }
    }
    [_btnTitle setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [_btnTitle setTitle:strTitle forState:UIControlStateNormal];
}

- (IBAction)btnClick:(id)sender {
    [self.delegate btnClickTitle:_btnTitle.titleLabel.text];
}
@end
