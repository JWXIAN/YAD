//
//  YADHomeButtonCell.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADHomeButtonCell.h"
@interface YADHomeButtonCell()
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation YADHomeButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YADHomeButtonCell" owner:self options:nil];
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
    _btnImage.clipsToBounds = YES;
    _btnImage.layer.cornerRadius = 10;
    return self;
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    _btnImage.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
            strTitle = @"报名须知";
            strImage = @"1";
            break;
        case 1:
            strTitle = @"在线报名";
            strImage = @"2";
            break;
        case 2:
            strTitle = @"预约练车";
            strImage = @"3";
            break;
        case 3:
            strTitle = @"考试预约";
            strImage = @"4";
            break;
        case 4:
            strTitle = @"校园地图";
            strImage = @"5";
            break;
        case 5:
            strTitle = @"班车查询";
            strImage = @"6";
            break;
        case 6:
            strTitle = @"便捷服务";
            strImage = @"7";
            break;
        case 7:
            strTitle = @"定位查询";
            strImage = @"8";
            break;
    }
    _lblTitle.text = strTitle;
    [_btnImage setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
}

- (IBAction)btnClick:(id)sender {
    [self.delegate btnClickTitle:_btnImage.tag];
}
@end
