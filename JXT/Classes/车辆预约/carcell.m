//
//  carcell.m
//  JXT
//
//  Created by 1039soft on 15/7/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "carcell.h"
#import "UIImageView+WebCache.h"
#import "CatZanButton.h"
#import "JWgetcommend.h"
#import "MBProgressHUD+MJ.h"
@interface carcell()
//{
//   __weak UIImageView*  _head,* _nameimage,* _redu,* _tuijian,* _kemu,* _che,* _phone;
//   __weak UILabel * _namelabel,* _kemulabel,* _chelable,* _phonelabel,* _zanlabel;
//  __weak  UIButton* _map,* _star,* _attention;
//   __weak CatZanButton * _zanBtn;
//}
@property(strong,nonatomic) UIImageView* head,* nameimage,* redu,* tuijian,* kemu,* che,* phone;
@property(strong,nonatomic) UILabel *namelabel,* kemulabel,* chelable,* phonelabel,* zanlabel;
@property(assign,nonatomic) CGFloat hight,litleimage_height;
@property(strong,nonatomic) UIButton* map,* star,* attention;
@property(strong,nonatomic) CatZanButton *zanBtn;

@end

@implementation carcell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
      self.frame=frame;
        [self inin];
        [self getzan];

//        getcommend
           }
    return self;
}

-(void)inin
{
    _hight=self.frame.size.height*0.7;
    
    _head=[[UIImageView alloc]initWithFrame:CGRectMake(_hight*0.1, _hight*0.05, _hight*0.8, _hight)];
    
    _litleimage_height=CGRectGetWidth(_head.frame)*0.25;
    
    _nameimage=[[UIImageView alloc]initWithFrame: CGRectMake(CGRectGetMaxX(_head.frame)+_hight*0.1,_hight*0.05,_litleimage_height*0.75 ,_litleimage_height)];
    _namelabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameimage.frame)+_hight*0.05,_hight*0.05,0,0)];//这个frame是初设的，没关系，后面还会重新设置其size。
    
    _redu=[[UIImageView alloc]init];
    _tuijian=[[UIImageView alloc]init];
    
    _kemu=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_head.frame)+_hight*0.1, CGRectGetMaxY(_nameimage.frame)+_hight*0.075, _litleimage_height*0.8, _litleimage_height*0.8)];
    
    _kemulabel=[[UILabel alloc] initWithFrame:CGRectMake(_namelabel.frame.origin.x,_kemu.frame.origin.y,0,0)];
    _che=[[UIImageView alloc]init];
    
    _chelable=[[UILabel alloc]init];
    
    _map=[[UIButton alloc]init];
    
    _phone=[[UIImageView alloc]init];
    _phonelabel=[[UILabel alloc]init];
    
    _star=[[UIButton alloc]initWithFrame:CGRectMake(_hight*0.1, self.frame.size.height-_litleimage_height*0.8-_hight*0.05, CGRectGetWidth(_head.frame), _litleimage_height*0.8)];
    
    
    _zanBtn=[[CatZanButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_head.frame)+_hight*0.1, self.frame.size.height-CGRectGetHeight(_star.frame)*1.5, CGRectGetHeight(_star.frame)*1.5, CGRectGetHeight(_star.frame)*1.5) zanImage:[UIImage imageNamed:@"Zan"] unZanImage:[UIImage imageNamed:@"UnZan"]];
    _zanlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_zanBtn.frame)+_hight*0.05, _zanBtn.center.y-_zanBtn.frame.size.height/4, 0,0)];
    _attention=[[UIButton alloc]init];
    [self.contentView addSubview:_head];
    [self.contentView addSubview:_nameimage];
    [self.contentView addSubview:_namelabel];
    [self.contentView addSubview:_redu];
    [self.contentView addSubview:_tuijian];
    [self.contentView addSubview:_kemu];
    [self.contentView addSubview:_kemulabel];
    [self.contentView addSubview:_che];
    [self.contentView addSubview:_chelable];
    [self.contentView addSubview:_map];
    [self.contentView addSubview:_phone];
    [self.contentView addSubview:_phonelabel];
    [self.contentView addSubview:_zanlabel];
    [self.contentView addSubview:_attention];
    

   

}

-(void)drawview
{

    
   //头像
    [_head sd_setImageWithURL:[NSURL URLWithString:_driTeaListInfo.photo] placeholderImage:[UIImage imageNamed:@"touxiang"]];
   
    
    
   //名字图标
    _nameimage.image=[UIImage imageNamed:@"name"];
 
    
    //名字
    _namelabel.numberOfLines=0;
    _namelabel.text=_driTeaListInfo.name;
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:_nameimage.frame.size.height*0.7];
    _namelabel.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size = [_namelabel.text sizeWithFont:_namelabel.font constrainedToSize:CGSizeMake(140.f,MAXFLOAT)];
    CGRect frame=_namelabel.frame;

    frame.size=size;
    _namelabel.frame=frame;
   
    
    //热度
    if ([_driTeaListInfo.biaoqian isEqualToString:@"热"]) {
        _redu.frame=CGRectMake(CGRectGetMaxX(_namelabel.frame)+_hight*0.15, _hight*0.05, _namelabel.frame.size.height*0.75, _namelabel.frame.size.height);
        _redu.image=[UIImage imageNamed:@"re"];

  
  
    }
    if ([_driTeaListInfo.biaoqian isEqualToString:@"荐"]) {
        
          _tuijian.frame=CGRectMake(CGRectGetMaxX(_redu.frame)+_hight*0.1, _hight*0.05, _namelabel.frame.size.height*0.75,_namelabel.frame.size.height);
         _tuijian.image=[UIImage imageNamed:@"tuijian"];
        
    }
    
    //科目
    _kemu.image=[UIImage imageNamed:@"kemu"];
    
    
    _kemulabel.numberOfLines=3;
    _kemulabel.text=_driTeaListInfo.type_name;
//
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt2 = [UIFont fontWithName:@"HelveticaNeue" size:_kemu.frame.size.height*0.7];
    _kemulabel.font = fnt2;
    // 根据字体得到NSString的尺寸
    CGSize size2 = [_kemulabel.text sizeWithFont:_kemulabel.font constrainedToSize:CGSizeMake(self.frame.size.width/2.5,MAXFLOAT)];
    CGRect frame2=_kemulabel.frame;
    
    frame2.size=size2;
    _kemulabel.frame=frame2;

    
    //车号
    
    _che.frame=CGRectMake(CGRectGetMaxX(_head.frame)+_hight*0.1, CGRectGetMaxY(_kemulabel.frame)+_hight*0.075, _litleimage_height*0.8, _litleimage_height*0.8);
    
    _che.image=[UIImage imageNamed:@"chehao"];
  
 
    _chelable.frame=CGRectMake(_namelabel.frame.origin.x,_che.frame.origin.y,0,0);
   
    _chelable.text=_driTeaListInfo.carcode;
    
    // 设置Label的字体 HelveticaNeue  Courier
    _chelable.font = [UIFont fontWithName:@"HelveticaNeue" size:_che.frame.size.height*0.7];
    // 根据字体得到NSString的尺寸

    CGSize sizeche = [_chelable.text sizeWithFont:_chelable.font constrainedToSize:CGSizeMake(140.f,MAXFLOAT)];
    CGRect frameche=_chelable.frame;
    
    frameche.size=sizeche;
    _chelable.frame=frameche;
   
    
    //地图
    _map.frame=CGRectMake(self.frame.size.width-_hight*0.4, CGRectGetMinY(_che.frame)-CGRectGetHeight(_che.frame), CGRectGetWidth(_che.frame)*1.5, CGRectGetHeight(_che.frame)*2);
    [_map setImage:[UIImage imageNamed:@"anjuke_icon_itis_position"] forState:UIControlStateNormal];
    [_map addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
   
    
    //电话
    _phone.frame=CGRectMake(CGRectGetMaxX(_head.frame)+_hight*0.1, CGRectGetMaxY(_che.frame)+_hight*0.075, _litleimage_height*0.8, _litleimage_height*0.8);
    _phone.image=[UIImage imageNamed:@"tel"];

    
    _phonelabel.frame=CGRectMake(_namelabel.frame.origin.x,_phone.frame.origin.y,0,0);
   
    _phonelabel.text=_driTeaListInfo.mobile;
    
    // 设置Label的字体 HelveticaNeue  Courier
    _phonelabel.font = [UIFont fontWithName:@"HelveticaNeue" size:_phone.frame.size.height*0.7];
    // 根据字体得到NSString的尺寸

    CGSize size_phone = [_phonelabel.text sizeWithFont:_phonelabel.font constrainedToSize:CGSizeMake(140.f,MAXFLOAT)];
    CGRect frame_phone=_phonelabel.frame;
    
    frame_phone.size=size_phone;
    _phonelabel.frame=frame_phone;

    
    //设置星
    switch ([_driTeaListInfo.pingfen integerValue]) {
       
        case 4:
        {
            
            [_star setImage:[UIImage imageNamed:@"xing_four"] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
           
            [_star setImage:[UIImage imageNamed:@"xing_five"] forState:UIControlStateNormal];
        }
        default:
            [_star setImage:[UIImage imageNamed:@"xing_three"] forState:UIControlStateNormal];
            break;
    }
    [_star addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_star];
    
    //点赞
    __block typeof(self) thisself =self;
    [_zanBtn setClickHandler:^(CatZanButton *zanButton) {
       
        if (zanButton.isZan) {
            thisself->_zanlabel.text=[NSString stringWithFormat:@"%ld", [thisself->_zanlabel.text integerValue]+1];
        }else{
           thisself->_zanlabel.text=[NSString stringWithFormat:@"%ld", [thisself->_zanlabel.text integerValue]-1];
           
        }
       
    }];
    [self.contentView addSubview:_zanBtn];
    
    //赞数目
    _zanlabel.text=@"0";
    // 设置Label的字体 HelveticaNeue  Courier
    _zanlabel.font = [UIFont fontWithName:@"HelveticaNeue" size:_zanBtn.frame.size.height*0.5];
    // 根据字体得到NSString的尺寸
    
    CGSize size_zanlabel = [_zanlabel.text sizeWithFont:_zanlabel.font constrainedToSize:CGSizeMake(110,MAXFLOAT)];
    CGRect frame_zanlabel=_zanlabel.frame;
    
    frame_zanlabel.size=size_zanlabel;
    _zanlabel.frame=frame_zanlabel;
    _zanlabel.textColor=[UIColor redColor];
  
    //关注
    _attention.frame=CGRectMake(CGRectGetMinX(_map.frame)-_map.frame.size.width, CGRectGetMinY(_zanBtn.frame), _map.frame.size.width*2,_zanBtn.frame.size.height-_hight*0.025);
    [_attention setTitle:@"关注" forState:UIControlStateNormal];
    _attention.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:_attention.frame.size.height*0.4];
    _attention.tag=0;
    _attention.backgroundColor=[UIColor blueColor];
    _attention.layer.cornerRadius=10;
    [_attention addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
 
    
}
-(void)attention:(UIButton*)sender
{
    if (sender.tag==0) {
        
            [JWgetcommend attention:_driTeaListInfo.code andCallback:^(id obj) {
         
            if ([obj[@"head"][@"issuccess"] isEqualToString:@"true"]) {
                for (NSDictionary* dic in obj[@"body"]) {
                    [_attention setTitle:@"取消关注" forState:UIControlStateNormal];
                    _attention.backgroundColor=[UIColor lightGrayColor];
                    sender.tag=1;
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@将收到空余时段推送消息!",dic[@"result"]]];
                }
            }
            else
            {
                 [MBProgressHUD showError:@"关注失败"];
            }
        }];
    }
    else
    {
       
        [JWgetcommend unattention:_driTeaListInfo.code andCallback:^(id obj) {
            if ([obj[@"head"][@"issuccess"] isEqualToString:@"true"]) {
                    [_attention setTitle:@"关注" forState:UIControlStateNormal];
                    _attention.backgroundColor=[UIColor blueColor];
                    sender.tag=0;
                    [MBProgressHUD showSuccess:@"取消成功,将不再收到空余时段消息!"];
                
            }
            else
            {
                [MBProgressHUD showError:@"取消关注失败"];
            }
        }];

    }
   
    
}
//地图事件
-(IBAction)map:(UIButton*)sender
{
    NSString* ddd=_driTeaListInfo.jingdu;//经度
    NSString* bbb=_driTeaListInfo.weidu;//纬度
    if (ddd&&bbb) {
        NSDictionary* dic=@{@"longitude":ddd,@"latitude":bbb};
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"openmap" object:nil userInfo:dic];
    }
    else
    {
        [MBProgressHUD showError:@"该教练车/教练员未开放位置信息"];
    }
}

//评价事件
-(void)pingjia:(UIButton*)sender
{
    NSDictionary* dic=@{@"teachercode":_driTeaListInfo.code};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showappraise" object:nil userInfo:dic];
}
#pragma mark 获取赞信息
-(void)getzan
{
    [JWgetcommend getcommend:_driTeaListInfo.code andCallback:^(id obj) {
        if (![obj[@"head"][@"stateinfo"] isEqualToString:@"失败"]) {
            NSString* pro=obj[@"body"][0][@"geshu"];
            _zanlabel.text=pro;
        }
    }];
}

@end
