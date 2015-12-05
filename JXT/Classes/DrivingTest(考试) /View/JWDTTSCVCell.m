//
//  JWDTTSCVCell.m
//  JXT
//
//  Created by JWX on 15/8/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWDTTSCVCell.h"
#import "JWDTTSVC.h"

@implementation JWDTTSCVCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JWDTTSCVCell" owner:self options:nil];
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
//- (void)cellWithIndexPath:(NSIndexPath *)indexPath{
//    _cellIndexPath = indexPath;
//}
- (void)awakeFromNib {
    self.btnTS.layer.cornerRadius = 20;
}

- (IBAction)btnTSSelect:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cvCellTSBtn" object:self.btnTS.titleLabel.text];
}
@end
