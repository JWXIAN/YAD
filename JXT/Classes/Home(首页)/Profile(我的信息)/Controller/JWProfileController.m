//
//  JWProfileController.m
//  JXT
//
//  Created by JWX on 15/6/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWProfileController.h"
#import "PrefixHeader.pch"
#import "JiaxiaotongAPI.h"
#import "JWProfileModel.h"
#import "UIImageView+WebCache.h"
#import "JWExamScheduleInfo.h"
#import "MBProgressHUD+MJ.h"
#import "JWRecordVC.h"
#import "JWNoticeModel.h"
#import "ChangePhoneNum.h"
#import "JWmoneyViewController.h"
#import "AppDelegate.h"

#define NUMBERS @"0123456789\n"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
//#import "JWLoginModel.h"
@interface JWProfileController ()
@property (weak, nonatomic) IBOutlet UILabel *xingming;

@property (weak, nonatomic) IBOutlet UIButton *changeTEL;


@property (weak, nonatomic) IBOutlet UILabel *TEL;
@property (weak, nonatomic) IBOutlet UIImageView *headview;//头像
@property (weak, nonatomic) IBOutlet UILabel *namelabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *stuidlabel;//学号
@property (weak, nonatomic) IBOutlet UILabel *idcard;//身份证号
@property (weak, nonatomic) IBOutlet UILabel *begintime;//报名日期
@property (weak, nonatomic) IBOutlet UILabel *alltime;//总学时
@property (weak, nonatomic) IBOutlet UILabel *yettime;//已学学时
@property (weak, nonatomic) IBOutlet UILabel *havetime;//剩余学时
@property (weak, nonatomic) IBOutlet UILabel *exam;//考试进度



@property(strong,nonatomic) UIAlertView *alertView;
@property(strong,nonatomic)JWProfileModel* person;
@property(strong,nonatomic)JWExamScheduleInfo* p2;
@property(strong,nonatomic)NSString* perid;
@property(strong,nonatomic)NSString* gonggao;//公告
@property(strong,nonatomic) UITextField* textfild;
@property(strong,nonatomic)  UIView* telview,* viewall;
@property(strong,nonatomic) UIButton* yesbutton;
@end

@implementation JWProfileController



#pragma mark 修改手机号

- (IBAction)change:(UIButton *)sender {
    _viewall=[[UIView alloc]initWithFrame:self.view.frame];
    _viewall.backgroundColor=[UIColor blackColor];
    _viewall.alpha=0.5;
    sender.enabled=NO;
    
    
   _telview=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.center.y-100, self.view.frame.size.width-40, 150)];
// _telview animationDidStart:<#(CAAnimation *)#>
//colorWithRed:255.f/255.f green:250.f/255.f blue:250.f/255.f alpha:1//象牙白

    
    _telview.backgroundColor=[UIColor whiteColor];
    _telview.layer.cornerRadius=5;
    CGFloat gap=_telview.bounds.size.width;
    _textfild=[[UITextField alloc]initWithFrame:CGRectMake(_telview.bounds.origin.x+(gap*1/6), _telview.bounds.origin.y+35, _telview.bounds.size.width-(gap*1/3), 35)];
    _textfild.layer.borderWidth=1;
    _textfild.layer.borderColor=[UIColor orangeColor].CGColor;
    _textfild.font=[UIFont fontWithName:@"HelveticaNeue" size:_textfild.frame.size.height*0.6];
    _textfild.placeholder=@"请输入手机号";
    [_telview addSubview:_textfild];
    
    
    _yesbutton=[[UIButton alloc]initWithFrame:CGRectMake(_telview.bounds.origin.x+(gap*1/6), _textfild.bounds.size.height+55, CGRectGetWidth(_textfild.frame)/3, 30)];
    _yesbutton.titleLabel.font=_textfild.font;
  
    [_yesbutton setTitle:@"确定" forState:UIControlStateNormal];
    [_yesbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yesbutton.backgroundColor=[UIColor orangeColor];
    [_yesbutton addTarget:self action:@selector(changeok:) forControlEvents:UIControlEventTouchUpInside];
    [_telview addSubview:_yesbutton];
    
    
    CGRect frame=_yesbutton.frame;
    frame.origin.x=_textfild.bounds.size.width*2.75/3;
    UIButton* nobutton=[[UIButton alloc]initWithFrame:frame];
    nobutton.titleLabel.font=_textfild.font;
    [nobutton setTitle:@"取消" forState:UIControlStateNormal];
    [nobutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nobutton.backgroundColor=[UIColor orangeColor];
    [nobutton addTarget:self action:@selector(desmiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_viewall];
     [self.view addSubview:_telview];
    [_telview addSubview:nobutton];
   
    
}

//按钮事件
-(void)changeok:(UIButton*)sender
{
    _changeTEL.enabled=YES;
   
    [self changeTELURL];
}
-(IBAction)desmiss:(UIButton* )sender
{
     _changeTEL.enabled=YES;
     [_telview removeFromSuperview];
     [_viewall removeFromSuperview];
}

#pragma mark 修改电话号码
-(void)changeTELURL
{
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[_TEL.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [_TEL.text isEqualToString:filtered];
    if(!basicTest||_textfild.text.length!=11)
    {
        [MBProgressHUD showError:@"请输入正确手机号"];
    }
    else
    {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_textfild.text forKey:@"newmobile"];
    [ud synchronize];
        [JiaxiaotongAPI requsetChangedPhoneNumByChangedPhoneNum:_TEL.text andCallback:^(id obj) {
            NSString* isOK;
            ChangePhoneNum* chp=obj;
            isOK=chp.result;
            if ([isOK isEqualToString:@"1"]) {
                _TEL.text=_textfild.text;
               
                [MBProgressHUD showSuccess:@"修改成功"];
            }
            else
            {
                [MBProgressHUD showError:@"修改失败"];
            }
            
        }];
     [_telview removeFromSuperview];
     [_viewall removeFromSuperview];
    }
}



//#pragma mark 打开侧栏
//- (IBAction)placard:(UIBarButtonItem *)sender {
//    [self openOrCloseLeftList];
//}
#pragma makr 刷新
- (IBAction)repush:(UIBarButtonItem *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self shuaxin];
}
- (IBAction)peixun:(UIButton *)sender {
    JWRecordVC *jwr=[[JWRecordVC alloc]init];
    jwr.navigationItem.title=@"预约记录";
    [self.navigationController pushViewController:jwr animated:YES];
}
////打开左侧界面
//- (void) openOrCloseLeftList
//{
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (tempAppDelegate.LeftSlideVC.closed)
//    {
//        [tempAppDelegate.LeftSlideVC openLeftView];
//    }
//    else
//    {
//        [tempAppDelegate.LeftSlideVC closeLeftView];
//    }
//}

-(void)shuaxin
{
    [JiaxiaotongAPI requestUserInfoByUserID:nil view:self.view andCallback:^(id obj) {
        _person=obj;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

        [_headview sd_setImageWithURL:[NSURL URLWithString:_person.per_photo] placeholderImage:[UIImage imageNamed:@"zh"]];
        [ud setObject:_person.per_photo forKey:@"per_photo"];
        
        _namelabel.text=_person.per_name;
        _stuidlabel.text=_person.per_id;
        //存学号
        [ud setValue:_person.per_id forKey:@"person_id"];
        
        _idcard.text=_person.per_idcardno;
      
        NSRange range = [_person.part_registrationdate rangeOfString:@" "];//匹配得到的下标
        NSString* bes=_person.part_registrationdate;
        if (range.length!=0) {
             bes=[_person.part_registrationdate substringToIndex:range.location];//截取范围类的字符串
        }
        _begintime.text=bes;
        _TEL.text=_person.per_mobile;
        _alltime.text=_person.out_zongshi;
        _yettime.text=_person.yixueshi;
        _havetime.text=_person.out_shengyu;
        _perid=_person.per_id;
        [ud setObject:_person.per_id forKey:@"per_id"];
        [ud setObject:_person.per_idcardno forKey:@"accountID"];
        [ud setObject:_person.per_name forKey:@"per_name"];
//        [ud setObject:_person.train_learnid forKey:@"train_learnid"];
        [ud synchronize];
        [JiaxiaotongAPI requestStuExamScheduleByStuExamSchedule:_perid andCallback:^(id obj) {
            _p2=obj;
            _exam.text=_p2.tz_name;
        }];

        [MBProgressHUD hideHUDForView:self.view];
    }];
    
   }

-(void)nnn
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self nnn];
    //创建左侧公告
//    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
//
//    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//   [rightButton setImage:[UIImage imageNamed:@"gonggaobaise"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(placard) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gonggaobaise"] style:UIBarButtonItemStyleDone target:self action:@selector(placard)];
    self.title=@"我的信息";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置字体大小
    _xingming.font=[UIFont fontWithName:@"HelveticaNeue" size:_xingming.frame.size.height*0.8];
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label=obj;
            label.font=_xingming.font;
        }
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* button=obj;
            button.titleLabel.font=_xingming.font;
        }
    }
    
    _alertView = [[UIAlertView alloc]init];
    _alertView.delegate=self;
    _alertView.title=@"官方公告";
    [_alertView addButtonWithTitle:@"确定"];
    
    [self placard];
    [self shuaxin];

 
}
#pragma mark - 公告
-(void)placard
{
    __block JWProfileController* thisself=self;
    [JiaxiaotongAPI requestOfficialAnnounceByOfficialAnnounce:nil andCallback:^(id obj) {
        JWNoticeModel* jj=obj;
        thisself.gonggao=jj.result;
       
        thisself.gonggao =[thisself.gonggao stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        thisself.alertView.message=thisself.gonggao;
        [thisself.alertView show];

    }];
}

@end
