//
//  JWTestCell.m
//  JXT
//
//  Created by JWX on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWTestCell.h"
#import "PrefixHeader.pch"
#import "JWDTTV.h"
#import "JXT-swift.h"
#import "exam.h"
@interface JWTestCell()
@property (weak, nonatomic) IBOutlet UIButton *fir;
@property (weak, nonatomic) IBOutlet UIButton *other;
@property (weak, nonatomic) IBOutlet UIButton *stochastic;
@property (weak, nonatomic) IBOutlet UIButton *Special;
@property (weak, nonatomic) IBOutlet UIButton *clean;
#pragma - mark 宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w5;

#pragma - mark 高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h5;


@end
@implementation JWTestCell
-(void)updateConstraints
{
    [super updateConstraints];

    _w1.constant=(self.frame.size.width-50)/2;
    _w2.constant=_w1.constant;
    _w3.constant=_w1.constant;
    _w4.constant=_w1.constant;
    _w5.constant=_w1.constant;
    
    _h1.constant=(self.frame.size.height-40)/2;
    _h2.constant=_h1.constant;
    _h3.constant=_h1.constant;
    _h4.constant=_h1.constant;
    _h5.constant=_h1.constant;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JWTestCell" owner:self options:nil];
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

-(void)awakeFromNib
{

    _fir.titleLabel.font=_other.titleLabel.font;
    for (id obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* button=obj;
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)cellWithIndexPath:(NSIndexPath *)indexPath
{
  

    if (indexPath.row==1) {
        [_fir setTitle:@"模拟考试" forState:UIControlStateNormal];
        [_fir setImage:[UIImage imageNamed:@"mnks"] forState:UIControlStateNormal];
       
        [_other setTitle:@"我的成绩" forState:UIControlStateNormal];
        [_other setImage:[UIImage imageNamed:@"wdcj"] forState:UIControlStateNormal];
        
        [_stochastic setTitle:@"练习统计" forState:UIControlStateNormal];
        [_stochastic setImage:[UIImage imageNamed:@"lxtj"] forState:UIControlStateNormal];
        
        [_Special setTitle:@"考试要点" forState:UIControlStateNormal];
        [_Special setImage:[UIImage imageNamed:@"ksyd"] forState:UIControlStateNormal];
    
        [_clean setTitle:@"许愿墙" forState:UIControlStateNormal];
        [_clean setImage:[UIImage imageNamed:@"xyq"] forState:UIControlStateNormal];
    }
    
}
- (void)click:(UIButton* )sender
{
 
     [[NSNotificationCenter defaultCenter]postNotificationName:@"pushview" object:sender.titleLabel.text];
}

@end
