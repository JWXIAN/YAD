//
//  RegisterVC.m
//  JXT
//
//  Created by 1039soft on 15/8/4.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "RegisterVC.h"
#import "MBProgressHUD+MJ.h"
#import "PopoverView.h"
#import "RegisterAbout.h"
#import "DGActivityIndicatorView.h"
#define NUMBERS @"0123456789\n"

@interface RegisterVC ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TEL;
@property (weak, nonatomic) IBOutlet UITextField *IDcard;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *SelectCar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
@property (weak, nonatomic) IBOutlet UINavigationItem *item;
@property (weak, nonatomic) IBOutlet UIButton *zhuce;

@property(strong,nonatomic) NSMutableArray* SelectTitles;
@property(strong,nonatomic) NSString*  CarCategory;
@property(strong,nonatomic) DGActivityIndicatorView *activityIndicatorView ;

/**报名来源*/
@property (weak, nonatomic) IBOutlet UITextField *txtBMLY;

@end

@implementation RegisterVC

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark textfild代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_name resignFirstResponder];
    [_TEL resignFirstResponder];
    [_IDcard resignFirstResponder];
    [_txtBMLY resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //如果键盘盖过输入框上移界面
    CGFloat offset=self.view.frame.size.height-(textField.frame.origin.y+textField.frame.size.height+300);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.view.frame;
            frame.origin.y=offset;
            self.view.frame=frame;
        }];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=0;
        self.view.frame=frame;
    }];
    
}
- (IBAction)Select:(UIButton *)sender {

    CGPoint point = CGPointMake(sender.center.x , sender.center.y);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles: _SelectTitles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        
        if ([_SelectTitles[index] isEqualToString:@"没有数据"]) {
            [MBProgressHUD showError:@"没有车辆信息"];
        }
        else
        {
            [sender setTitle:_SelectTitles[index] forState:UIControlStateNormal];
            _CarCategory=_SelectTitles[index];
        }
        
    };
    [pop show];
    

}

- (IBAction)send:(UIButton *)sender {
   
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[_TEL.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [_TEL.text isEqualToString:filtered];
    if (_name.hasText&&_TEL.hasText&&_IDcard.hasText&&![_SelectCar.titleLabel.text isEqualToString:@"点击选择"]) {
      
         if(!basicTest||_TEL.text.length!=11)
        {
            [MBProgressHUD showError:@"请输入正确手机号"];
        }
        else if (![self checkUserIdCard:_IDcard.text]) {
            [MBProgressHUD showError:@"正输入正确身份证格式"];
        }else if (_txtBMLY.text.length == 0){
            [MBProgressHUD showError:@"请输入报名来源"];
        }else{
            
           //发送注册信息
           [self drawWaitAnimation:YES];
           NSDictionary *Registerinfo=@{@"name":_name.text,@"mobile":_TEL.text,@"IDcard":_IDcard.text,@"category":_CarCategory,@"bmly":_txtBMLY.text};
           [RegisterAbout PostRegisterInfo:Registerinfo view:self.view Callback:^(id obj) {
               NSDictionary* success=obj;
              [self drawWaitAnimation:NO];
               if ([success[@"head"][@"statecode"] isEqualToString:@"2000"]) {
                   for (NSDictionary* dic in success[@"body"]) {
                       if ([dic[@"column1"] isEqualToString:@"ok"]) {
                        
                           NSString* password=[_IDcard.text substringWithRange:NSMakeRange(9, 6)];
                           NSString* info=[NSString stringWithFormat:@"姓名:%@\n电话:%@\n车型:%@\n身份证号:%@\n密码:%@\n报名来源:%@",_name.text,_TEL.text,_CarCategory,_IDcard.text,password, _txtBMLY.text];
//                           NSDictionary* RegisterInfo=@{@"username":_IDcard.text,@"password":password};
//                           [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterInfo" object:nil userInfo:RegisterInfo];
                           NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                           [user setObject:_TEL.text forKey:@"dengluname"];
                           [user setObject:@"0" forKey:@"RegisterPassWord"];
                           [user synchronize];
                           UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"注册成功" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          
                           [alert show];
                           
                       }
                       else
                       {
                           [MBProgressHUD showSuccess:dic[@"column1"]];
                       }
                   }
               }
               else
               {
                    [MBProgressHUD showSuccess:@"注册失败"];
               }
           }];
       }
        
    }
    else if([_SelectCar.titleLabel.text isEqualToString:@"点击选择"])
    {
        [MBProgressHUD showError:@"请选择车型"];
    }
    else
    {
        [MBProgressHUD showError:@"请填写完整信息"];
    }
}

#pragma mark 动画方法
-(void)drawWaitAnimation:(BOOL)isshow
{
  
    if (isshow) {
        _activityIndicatorView.frame=CGRectMake(0,self.view.center.y, self.view.frame.size.width, CGRectGetMinY(_zhuce.frame)-self.view.center.y);
        [self.view addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
        self.view.userInteractionEnabled=NO;
    }
    else
    {
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView removeFromSuperview];
        self.view.userInteractionEnabled=YES;
        
    }
    
}

#pragma  mark alertview 代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard: (NSString *) idCard
{
    
    if (idCard.length <= 0) {
        
        return NO;
    }
    
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    _name.delegate=self;
    _TEL.delegate=self;
    _IDcard.delegate=self;
    _txtBMLY.delegate=self;
    //初始化对象
    _SelectTitles=[NSMutableArray array];
   _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTwoDots tintColor:[UIColor colorWithRed:67.f/255.f green:153.f/255.f blue:213.f/255.f alpha:1] size:20.f];
    
    [RegisterAbout GetCarCallback:^(id obj) {
        NSDictionary* dic=obj;
        if ([dic[@"head"][@"statecode"] isEqualToString:@"2000"]) {
            for (NSDictionary* type in dic[@"body"]) {
                [_SelectTitles addObject:type[@"typename"]];
            }
        }
        else
        {
            [_SelectTitles addObject:@"没有数据"];
        }
    }];
    
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField* textfild=obj;
            textfild.borderStyle=UITextBorderStyleNone;
            textfild.font=[UIFont fontWithName:@"HelveticaNeue" size:textfild.frame.size.height*0.5];
        }
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label=obj;
            label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.7];
        }
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* button=obj;
            button.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:button.frame.size.height*0.5];
        }
    }
//    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
//    title.text=@"新学员注册";
//    title.textColor=[UIColor whiteColor];
//    title.textAlignment=NSTextAlignmentCenter;
//    [_navigationbar addSubview:title];
//    _navigationbar.barTintColor=[UIColor colorWithRed:67.f/255.f green:153.f/255.f blue:213.f/255.f alpha:1];
//    _navigationbar.tintColor=[UIColor whiteColor];
//    _item.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action: @selector(back:)];
}
-(void)back:(UIBarButtonItem* )sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
