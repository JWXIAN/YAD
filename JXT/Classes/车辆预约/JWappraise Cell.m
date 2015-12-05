//
//  JWappraise Cell.m
//  JXT
//
//  Created by 1039soft on 15/7/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWappraise Cell.h"
@interface JWappraise_Cell()
@property(strong,nonatomic) UILabel*  body,* body2,* time;
@property(strong,nonatomic) UIImageView* star;
@property(assign,nonatomic) CGFloat hight;
@end
@implementation JWappraise_Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame=frame;
        _hight=frame.size.height*0.25;
        _body=[[UILabel alloc]initWithFrame:CGRectMake(_hight/2, _hight/2, 0, 0)];
        _body2=[[UILabel alloc]init];
        _star=[[UIImageView alloc]init];
        _time=[[UILabel alloc]init];
    }
    return self;
}

-(void)drawview
{
    if (_info) {
        //评价内容
        _body.numberOfLines=0;
        _body.text=_info[@"pingjiacontent"];
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:_hight*0.7];
        _body.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize size_body = [_body.text sizeWithFont:_body.font constrainedToSize:CGSizeMake(self.frame.size.width,MAXFLOAT)];
        CGRect frame_body=_body.frame;
        
        frame_body.size=size_body;
        _body.frame=frame_body;
        [self addSubview:_body];
        
        //评价人
        _body2.frame=CGRectMake(_hight/1.5, CGRectGetMinY(_body.frame)+_hight, 0, 0);
        _body2.numberOfLines=0;
        _body2.text=[NSString stringWithFormat:@"%@ %@",_info[@"per_name"],_info[@"px_type"]];
        // 设置Label的字体 HelveticaNeue  Courier
        UIFont *fnt2 = [UIFont fontWithName:@"HelveticaNeue" size:_hight*0.6];
        _body2.font = fnt2;
        // 根据字体得到NSString的尺寸
        CGSize size_body2 = [_body2.text sizeWithFont:_body2.font constrainedToSize:CGSizeMake(self.frame.size.width*2/3,MAXFLOAT)];
        CGRect frame_body2=_body2.frame;
        
        frame_body2.size=size_body2;
        _body2.frame=frame_body2;
        _body2.textColor=[UIColor lightGrayColor];
        [self addSubview:_body2];
        
        //星
        _star.frame=CGRectMake(self.frame.size.width*2.2f/3.f, CGRectGetMinY(_body2.frame), self.frame.size.width*1/3-_hight*2,_hight*0.6);
        switch ([_info[@"score"] intValue]) {
            case 1:
            {
                _star.image=[UIImage imageNamed:@"xing_one"];
            }
                break;
            case 2:
            {
                _star.image=[UIImage imageNamed:@"xing_two"];
            }
                break;
            case 3:
            {
                _star.image=[UIImage imageNamed:@"xing_three"];
            }
                break;
            case 4:
            {
                _star.image=[UIImage imageNamed:@"xing_four"];
            }
                break;
            case 5:
            {
                _star.image=[UIImage imageNamed:@"xing_five"];
            }
            default:
                break;
        }
        [self addSubview:_star];
        
        _time.frame=CGRectMake(self.frame.size.width*1.9/3, self.frame.size.height-_hight, 0,0);
        _time.textColor=[UIColor lightGrayColor];
        _time.text=_info[@"pingjiatime"];
        UIFont *fnt3 = [UIFont fontWithName:@"HelveticaNeue" size:_hight*0.5];
        _time.font = fnt3;
        // 根据字体得到NSString的尺寸
        CGSize size_time = [_time.text sizeWithFont:_time.font constrainedToSize:CGSizeMake(self.frame.size.width-_hight,MAXFLOAT)];
        CGRect frame_time=_time.frame;
        
        frame_time.size=size_time;
        _time.frame=frame_time;
        _time.textColor=[UIColor lightGrayColor];
        
        [self addSubview:_time];
    }
}
@end
