//
//  YADLifeButtonCell.m
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import "YADLifeButtonCell.h"
@interface YADLifeButtonCell()

@end
@implementation YADLifeButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YADLifeButtonCell" owner:self options:nil];
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
- (IBAction)btnClick:(id)sender {
    [self.delegate btnClickTitle:_btnImage.tag];
}

- (void)stCellImageTitle:(NSIndexPath *)indexPath{
    NSString *strTitle;
    NSString *strImage;
    if (indexPath.section == 0) {
        _btnImage.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
                strTitle = @"超市";
                strImage = @"生活助理-超市";
                break;
            case 1:
                strTitle = @"加油站";
                strImage = @"生活助理-加油站";
                break;
            case 2:
                strTitle = @"银行";
                strImage = @"生活助理-银行";
                break;
            case 3:
                strTitle = @"停车场";
                strImage = @"生活助理-停车场";
                break;
            case 4:
                strTitle = @"餐馆";
                strImage = @"生活助理-餐馆";
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                _btnImage.tag = 5;
                strTitle = @"班车接送";
                strImage = @"生活助理-班车接送";
                break;
            case 1:
                _btnImage.tag = 6;
                strTitle = @"代驾服务";
                strImage = @"生活助理-代驾服务";
                break;
            case 2:
                _btnImage.tag = 7;
                strTitle = @"扣分查询";
                strImage = @"生活助理-扣分查询";
                break;
            case 3:
                _btnImage.tag = 8;
                strTitle = @"违章查询";
                strImage = @"生活助理-违章查询";
                break;
        }
    }
    [_btnImage setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    _lblTitle.text = strTitle;
}
@end
