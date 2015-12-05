//
//  YADEnrollThreeImageCell.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADEnrollThreeImageCell.h"
@interface YADEnrollThreeImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation YADEnrollThreeImageCell

- (void)awakeFromNib {
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"YADEnrollThreeImageCell" owner:self options:nil];
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
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 10;
    return self;
}

@end
