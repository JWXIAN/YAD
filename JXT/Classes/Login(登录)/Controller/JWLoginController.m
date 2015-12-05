//
//  JWLoginController.m
//  JXT
//
//  Created by JWX on 15/6/24.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWLoginController.h"
#import "PrefixHeader.pch"
#import "JWDLTVController.h"
#import "MBProgressHUD+MJ.h"
#import "JWTarBarController.h"
#import "JWLoginModel.h"
#import "JiaxiaotongAPI.h"
#import "JWNoticeTVController.h"
#import "RegisterVC.h"
#import "APService.h"
#import "JXT-swift.h"
#import "AppDelegate.h"
#import "UserDefaultsKey.h"

@interface JWLoginController ()<UITextFieldDelegate,PassValueDelegate>


/**驾校列表*/
- (IBAction)btnDrivList:(id)sender;
/**忘记密码*/
- (IBAction)btnPW:(id)sender;
/**登录btn*/
- (IBAction)btnLogin:(id)sender;

/**身份证号*/
@property (weak, nonatomic) IBOutlet UITextField *tFNo;

/**密码*/
@property (weak, nonatomic) IBOutlet UITextField *tFPassword;
/**登录btn*/
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *drive_school_label;
/**学员数据模型*/
@property (nonatomic,strong)JWLoginModel *studentLogin;

@property(strong,nonatomic) UIView* backview,* schoolHereView;//选择驾校
@end


@implementation JWLoginController
//收键盘

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tFNo resignFirstResponder];
    [_tFPassword resignFirstResponder];

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
#pragma - mark 接收驾校返回数据
-(void)passValue:(id)value{
    self.driveData=value;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _drive_school_label.text=[ud objectForKey:@"drivename"];
    _tFNo.text=[ud objectForKey:@"dengluname"];
    _tFPassword.text=[ud objectForKey:@"RegisterPassWord"];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _drive_school_label.lineBreakMode=NSLineBreakByWordWrapping;
    _tFNo.delegate=self;
    _tFPassword.delegate=self;

    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RegisterInfo:) name:@"RegisterInfo" object:nil];
}
-(void)RegisterInfo:(NSNotification*)notification
{
    _tFNo.text=notification.userInfo[@"username"];
    _tFPassword.text=notification.userInfo[@"password"];
}
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_backview removeFromSuperview];
    [_schoolHereView removeFromSuperview];
}

//登录xib
- (id)init
{
    self = [super initWithNibName:@"JWLoginVC" bundle:nil];
    if (self) {
        // Something.
    }
    return self;
}


/**跳回选择驾校*/
- (IBAction)btnDrivList:(id)sender {
    _backview=[[UIView alloc]initWithFrame:self.view.frame];

    _backview.backgroundColor=[UIColor blackColor];
    _backview.alpha=0.5;
    
    _schoolHereView=[[UIView alloc]initWithFrame:CGRectMake(5, 64, self.view.frame.size.width-10, self.view.frame.size.height/2)];
    _schoolHereView.backgroundColor=[UIColor whiteColor];
    _schoolHereView.layer.cornerRadius=3;
    
    //初始化
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    

    CGRect frame=_schoolHereView.frame;
    frame.size.height*=5/6;

    JWDLTVController *tb = [[JWDLTVController alloc] init];
    tb.delegate=self;
    if (self.navigationController) {
         [self.navigationController pushViewController:tb animated:YES];
    }
   else
   {
       [self presentViewController:tb animated:YES completion:nil];
   }
//    [self presentViewController:tb animated:YES completion:nil];
}

//注册
- (IBAction)btnPW:(id)sender {
    UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    RegisterVC* student_register=[story instantiateViewControllerWithIdentifier:@"register"];
    [self presentViewController:student_register animated:YES completion:nil];
    
}
/**登录按钮*/
- (IBAction)btnLogin:(id)sender {
    if(self.tFNo.text.length !=0 && self.tFPassword.text.length !=0)
    {
        [self StLogin];
    }else if (self.tFNo.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入身份证号码"];
    }else if (self.tFPassword.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码"];
    }
    
}

/**登录响应*/
- (void)StLogin
{
    [MBProgressHUD showMessage:@"正在拼命登录中..."];
    NSString *accountID = self.tFNo.text;
    NSString *password = self.tFPassword.text;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:accountID forKey:@"accountID"];
    [ud setObject:password forKey:@"password"];
    
    [ud synchronize];
    [JiaxiaotongAPI requsetStuLoginByStuLogin:accountID andCallback:^(id obj) {
        self.studentLogin = (JWLoginModel *)obj;
        //保存身份证号
        NSString *IDCardNum = self.studentLogin.per_idcardno;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:IDCardNum forKey:@"per_idcardno"];
//        JWLog(@"%@",self.studentLogin.issuccess);
        if ([self.studentLogin.issuccess isEqualToString:@"true"]) {
            //隐藏蒙板
            [MBProgressHUD hideHUD];
//            [ud setObject:_studentLogin.per_id forKey:@"per_id"];
            [ud setObject:accountID forKey:@"dengluname"];
            [ud setObject:_studentLogin.per_name forKey:@"_studentLogin.per_name"];
            [ud setObject:_studentLogin.train_learnid forKey:@"train_learnid"];
            //存是否登录成功
            [ud setBool:YES forKey:UserIsaAlreadyLogin_Bool];
//            [ud setBool:YES forKey:@"issuccess"];
            [ud synchronize];
            NSString* tags=[ud objectForKey:@"drivecode"];
           
            
            NSSet *target =[[NSSet alloc]initWithObjects:tags,IDCardNum,nil];
//TODO:设置推送标签
            [APService setTags:target callbackSelector:nil object:nil];
            if ([ud boolForKey:@"shouci"]) {
                UIStoryboard* story=[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
                ChanegExam* ex=[story instantiateViewControllerWithIdentifier:@"changeexam"];
                [self presentViewController:ex animated:YES completion:nil];
             
//                [self.navigationController pushViewController:ex animated:YES];
            }
            else
            {

                JWTarBarController* jwtab=[[JWTarBarController alloc]init];
              
//                [self.navigationController pushViewController:jwtab animated:YES];
                [self presentViewController:jwtab animated:YES completion:nil];
            }
          
            
            [MBProgressHUD showSuccess:@"学员登录成功！祝您学车愉快！"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"学员信息错误！"];
            [ud setBool:NO forKey:@"issuccess"];
            [ud synchronize];
        }
        
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
