//
//  ChangePassWordViewController.m
//  YiDeng
//
//  Created by 1039soft on 15/6/17.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "JiaxiaotongAPI.h"
#import "ChangePhoneNum.h"
#import "ChangePassword.h"

#define NUMBERS @"0123456789\n"
@interface ChangePassWordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repassword;

@property(strong,nonatomic)MBProgressHUD* ad;
@property (weak, nonatomic) IBOutlet UIButton *sendbutton;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *select;

@end

@implementation ChangePassWordViewController
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_repassword resignFirstResponder];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    _username.borderStyle=UITextBorderStyleNone;
    _password.borderStyle=UITextBorderStyleNone;
    _repassword.borderStyle=UITextBorderStyleNone;
    _username.delegate=self;
    _password.delegate=self;
    _repassword.delegate=self;
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"修改密码",@"更换手机",nil];
    
    //初始化UISegmentedControl
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(self.view.center.x-100, 90, 200, 35);
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:76.0/255.0 green:185.0/255.0 blue:245.0/255.0 alpha:1] ,UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor colorWithRed:76.0/255.0 green:185.0/255.0 blue:245.0/255.0 alpha:1];
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [self.view addSubview:segmentedControl];

}
-(void)segmentAction:(UISegmentedControl *)Seg{
    if (Seg.selectedSegmentIndex==0) {
        _username.placeholder=@"请输入原密码";
        _password.placeholder=@"请输入新密码";
        _repassword.placeholder=@"请确认密码";
    }
    else
    {
        _username.placeholder=@"请输入原手机号";
        _password.placeholder=@"请输入新手机号";
        _repassword.placeholder=@"请确认新手机号";
    }
}

- (IBAction)send:(UIButton *)sender {
    if ([_username.text isEqualToString:@""]||[_password.text isEqualToString:@""]||[_repassword.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请确认信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.frame = CGRectMake(50, 200, 200, 50);
        [alertView show];
        
    }
    else
    {
        if ([_username.placeholder isEqualToString:@"请输入原手机号"])
        {
         
                //修改手机号码
                [self changeTELURL];
                //        [self popoverPresentationController];
            
          
            
        }
        else
        {
    
            //修改密码
            [self changePassWordURL];
            //         [self popoverPresentationController];
            
        }
    }

}
#pragma mark 修改电话号码
-(void)changeTELURL
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_password.text forKey:@"newmobile"];
    [ud synchronize];
    if (_password.text != _repassword.text) {
        [MBProgressHUD showError:@"新手机号不一致"];
    }else{
        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[_password.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [_password.text isEqualToString:filtered];
        if(!basicTest||_password.text.length!=11)
        {
            [MBProgressHUD showError:@"请输入正确手机号"];
        }
        else
        {
        [JiaxiaotongAPI requsetChangedPhoneNumByChangedPhoneNum:_username.text andCallback:^(id obj) {
            NSString* isOK;
            ChangePhoneNum* chp=obj;
            isOK=chp.result;
            if ([isOK isEqualToString:@"1"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.frame = CGRectMake(50, 200, 200, 50);
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.frame = CGRectMake(50, 200, 200, 50);
                [alertView show];
            }
            
         }];
       }
    }
    
}
#pragma mark 修改密码
-(void)changePassWordURL
{
    NSDictionary* dic=@{@"old":_username.text,@"new":_password.text};
    if (_password.text != _repassword.text) {
        [MBProgressHUD showError:@"新密码不一致"];
    }else{
        [JiaxiaotongAPI requestChangedPasswordByChangedPassword:dic andCallback:^(id obj) {
            NSString* isOK;
            ChangePassword* chpaw=obj;
            isOK=chpaw.result;
            if ([isOK isEqualToString:@"1"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.frame = CGRectMake(50, 200, 200, 50);
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.frame = CGRectMake(50, 200, 200, 50);
                [alertView show];
            }
        }];

    }
}



@end
