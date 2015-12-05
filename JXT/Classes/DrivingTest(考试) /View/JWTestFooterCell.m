//
//  JWTestFooterCell.m
//  JXT
//
//  Created by JWX on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWTestFooterCell.h"
#import "XMBadgeView.h"
#import "JXT-swift.h"
#import "exam.h"
@interface JWTestFooterCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w;
@property (weak, nonatomic) IBOutlet ExamButton *MyMistake;
@property(strong,nonatomic) XMBadgeView *greenBadgeView;
@property(strong,nonatomic) UIView *greenView;



@end
@implementation JWTestFooterCell


-(void)updateConstraints
{
    [super updateConstraints];
 
    
    _w.constant=self.frame.size.width /2-0.5;
     _greenView= [[UIView alloc] initWithFrame:CGRectMake(_w.constant-_w.constant/8, _MyMistake.frame.origin.y+_MyMistake.frame.size.height/5, 10, 10)];
    _greenBadgeView = [[XMBadgeView alloc] initWithFrame:CGRectZero];
    _greenBadgeView.badgeTextFont=[UIFont systemFontOfSize:12];
    NSArray* arr = [exam selectWhere:@"answerWere='true'" groupBy:nil orderBy:nil limit:nil];
    if (arr.count>0) {
        
        
        [_MyMistake addSubview:_greenView];
        [_greenBadgeView setPanable:NO];
        [_greenBadgeView setBadgeText:@"99+"];
        [_greenBadgeView setBadgeViewAlignment:XMBadgeViewAlignmentTopLeft];
        [_greenView addSubview:_greenBadgeView];
        
        //        _greenBadgeView.hidden=NO;
        if (arr.count>99) {
            [_greenBadgeView setBadgeText:@"99+"];
        }
        else
        {
            [_greenBadgeView setBadgeText:[NSString stringWithFormat:@"%d",arr.count]];
        }
        
    }
    else
    {
        
        [_greenBadgeView removeFromSuperview];
        [_greenView removeFromSuperview];
        
        
    }
}

- (void)awakeFromNib {
    // Initialization code
    for (id obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[ExamButton class]]) {
            ExamButton* button = obj;
            if ([button.titleLabel.text isEqualToString:@"我的错题"]) {
            }
            [button addTarget:self action:@selector(sendeView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [[ NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ceshi:) name:@"MyMistake" object:nil];
   
}
-(void)ceshi:(NSNotification* )sender
{
    NSDictionary* arr = sender.object;
  
   
    
    if (arr.count>0) {
        
       
        [_MyMistake addSubview:_greenView];
        [_greenBadgeView setPanable:NO];
        [_greenBadgeView setBadgeText:@"99+"];
        [_greenBadgeView setBadgeViewAlignment:XMBadgeViewAlignmentTopLeft];
        [_greenView addSubview:_greenBadgeView];
    
        //        _greenBadgeView.hidden=NO;
        if (arr.count>99) {
            [_greenBadgeView setBadgeText:@"99+"];
        }
        else
        {
            [_greenBadgeView setBadgeText:[NSString stringWithFormat:@"%d",arr.count]];
        }
        
    }
    else
    {
        
        [_greenBadgeView removeFromSuperview];
        [_greenView removeFromSuperview];

        
    }

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JWTestFooterCell" owner:self options:nil];
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
        self = [arrayOfViews objectAtIndex:0];    }
    
    return self;
}

-(void)sendeView:(UIButton* )sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushview" object:sender.titleLabel.text];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
