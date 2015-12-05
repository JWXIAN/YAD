//
//  LightDetailCell.m
//  JXT
//
//  Created by 1039soft on 15/9/25.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "LightDetailCell.h"
#import "const.h"
#import "JJPhotoManeger.h"
#import "NSString+Extension.h"
@interface LightDetailCell()<JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headLabel;//标题
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_w;//由于打错字懒得改，这里其实是图片的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_h;//图片的宽
@property (weak, nonatomic) IBOutlet UILabel *answer;//答案
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1_left;//图片1左间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detail_top;


@property(strong,nonatomic) NSArray*  imageArr1,* imageArr2;
@end
@implementation LightDetailCell
-(void)updateConstraints
{
      [super updateConstraints];
    _image_h.constant=(self.frame.size.width-40)/2;
    if (_image1.hidden==true) {
        _image1.image=nil;
        
    }
    if (_image2.hidden==true) {
        _image2.image=nil;
    }
    
    if (_image1.hidden==true&&_image2.hidden==true) {
        _image_w.constant=0;
    }
    else
    {
        _image_w.constant=100;
    }
   

    
}
-(CGSize)textSize:(NSString*)text
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    return size;
}

-(void)setDetailCellWithIndexPathRow:(NSInteger)indexpathRow andData:(NSArray *)arr
{
    
    UIImageView* temp1 ,* temp2;
    _answer.hidden=false;
    switch (indexpathRow) {
        case 0:
         {
             _headLabel.text=[NSString stringWithFormat:@"1.%@",LightVoice1];
             _image1.image=[UIImage imageNamed:@"IMG_1"];
             _image2.image=[UIImage imageNamed:@"IMG_2"];
           
             _answer.text=@"答案: 示宽灯 近光灯";
             _detail.text=arr[indexpathRow];
             _image1.hidden=false;
             _image2.hidden=false;
             temp1=_image1;
             temp2=_image2;
            break;
         }
         case 1:
        {
            _headLabel.text=[NSString stringWithFormat:@"2.%@",LightVoice2];
            _answer.text=@"远光灯";
            _detail.text=arr[indexpathRow];
            _image1.image=[UIImage imageNamed:@"IMG_12"];
           
            _image1.hidden=false;
            _image2.hidden=true;
            temp1=_image1;
            temp2=_image2;
            break;
        }
         case 2:
        {
            _headLabel.text=[NSString stringWithFormat:@"3.%@",LightVoice3];
            _image1.image=[UIImage imageNamed:@"IMG_4"];
            temp1=_image1;
            temp2=_image2;
            _image1.hidden=false;
            _image2.hidden=true;
            _answer.text=@"开近光灯";
            _detail.text=arr[indexpathRow];
            break;
        }
      case 3:
        {
            _headLabel.text=[NSString stringWithFormat:@"4.%@",LightVoice4];
            _image1.hidden=false;
            _image2.hidden=true;
            _image1.image=[UIImage imageNamed:@"IMG_5"];
            _answer.text=@"开近光灯";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
        case 4:
        {
            _headLabel.text=[NSString stringWithFormat:@"5.%@",LightVoice5];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_6"];
            _image2.image=[UIImage imageNamed:@"IMG_7"];
            _answer.text=@"关大灯";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
        case 5:
        {
            _headLabel.text=[NSString stringWithFormat:@"6.%@",LightVoice5_2];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_9"];
            _image2.image=[UIImage imageNamed:@"IMG_7"];
            _answer.text=@"开前照灯 前后雾灯 警示灯";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
       case 6:
        {
            _headLabel.text=[NSString stringWithFormat:@"7.%@",LightVoice5_3];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_5"];
            _image2.image=[UIImage imageNamed:@"IMG_12"];
            _answer.text=@"开近光灯";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
       case 7:
        {
            _headLabel.text=[NSString stringWithFormat:@"8.%@",LightVoice5_4];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_5"];
            _image2.image=[UIImage imageNamed:@"IMG_12"];
            _answer.text=@"远近光灯交替闪灯两次";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
        
        case 8:
        {
            _headLabel.text=[NSString stringWithFormat:@"9.%@",LightVoice5_5];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_5"];
            _image2.image=[UIImage imageNamed:@"IMG_12"];
            _answer.text=@"远近光灯交替闪灯两次";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
            case 9:
        {
            _headLabel.text=[NSString stringWithFormat:@"10.%@",LightVoice5_6];
            _image1.hidden=false;
            _image2.hidden=false;
            _image1.image=[UIImage imageNamed:@"IMG_5"];
            _image2.image=[UIImage imageNamed:@"IMG_12"];
            _answer.text=@"左转向灯 远近光灯交替闪灯两次";
            _detail.text=arr[indexpathRow];
            temp1=_image1;
            temp2=_image2;
            break;
        }
            case 10:
        {
            
            _headLabel.text=[NSString stringWithFormat:@"11.%@",LightVoice6];
            _answer.hidden=true;
            _detail.text=arr[indexpathRow];
            _image1.hidden=true;
            _image2.hidden=true;
            temp1=_image1;
            temp2=_image2;
            
            break;
        }
        default:
            break;
    }
   
    
    if (temp1.image) {
        _imageArr1=[NSArray arrayWithObjects:temp1, nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [_image1 addGestureRecognizer:tap];
    }
    if (temp2.image) {
        _imageArr2=[NSArray arrayWithObjects:temp2, nil];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]init];
        [tap2 addTarget:self action:@selector(tap2:)];
        [_image2 addGestureRecognizer:tap2];
    }
   
    
}
//-(void)awakeFromNib
//{
//    
//}
-(void)tap:(UITapGestureRecognizer *)tap
{

    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showLocalPhotoViewer:_imageArr1 selecView:view];
    
}
-(void)tap2:(UITapGestureRecognizer *)tap
{
   
    UIImageView *view = (UIImageView *)tap.view;
   
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showLocalPhotoViewer:_imageArr2 selecView:view];
    
}

@end
