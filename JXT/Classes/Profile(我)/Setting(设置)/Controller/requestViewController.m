//
//  requestViewController.m
//  YiDeng
//
//  Created by 1039soft on 15/6/17.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "requestViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "JiaxiaotongAPI.h"
#import "AddComplaint.h"
@interface requestViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titlefiled;
@property(strong,nonatomic)MBProgressHUD* loadingView;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UIButton *sendbutton;
@property(strong,nonatomic)NSString* isOK;
@end

@implementation requestViewController

#warning 使用添加投诉接口，可能接口不对

- (IBAction)send:(UIButton *)sender {
    
    

    
      [self hud];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_titlefiled.text forKey:@"t_title"];
    [ud setObject:_body.text forKey:@"t_body"];
    
    
    [JiaxiaotongAPI requestAddComplaintByAddComplaint:nil andCallback:^(id obj) {
        AddComplaint* ad=obj;
        _isOK=ad.result;
        if ([_isOK isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"反馈成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.frame = CGRectMake(50, 200, 200, 50);
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"反馈失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.frame = CGRectMake(50, 200, 200, 50);
            [alertView show];
        }
        
        [_loadingView show:NO];   //取消显示
        [_loadingView removeFromSuperview];
    }];
}
-(void)hud
{
    _loadingView= [[MBProgressHUD alloc]initWithView:self.view];
    _loadingView.labelText = @"正在反馈...";
    [self.view addSubview:_loadingView];
    
    _loadingView.taskInProgress = YES;
    [_loadingView show:YES];   //显示
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"意见反馈";
    _body.layer.borderWidth=1;
    _body.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _titlefiled.delegate=self;
    _body.delegate=self;
   }
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_titlefiled resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([_body hasText]&&[_titlefiled hasText]) {
         [_sendbutton setEnabled:YES];
         [_sendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder]; //移除键盘
        
        return NO;
        
    }
    
    return YES;
    
}

@end
