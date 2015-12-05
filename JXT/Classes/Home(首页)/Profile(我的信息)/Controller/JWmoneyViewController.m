//
//  JWmoneyViewController.m
//  JXT
//
//  Created by 1039soft on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWmoneyViewController.h"
#import "PopoverView.h"
#import "JWgetpay.h"
#import "JWpriceModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

//微信支付
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "JWWeChatModel.h"
#import "JWWeChatHeadModel.h"
#import "MBProgressHUD+MJ.h"
#import "PrefixHeader.pch"

#import "JWWeChatPayAPI.h"
#import "JWAliPayAPI.h"

@interface JWmoneyViewController ()<UITextViewDelegate, NSXMLParserDelegate>


/**微信支付*/
@property (weak, nonatomic) IBOutlet UIButton *btnWeChatPay;
/**支付宝*/
@property (weak, nonatomic) IBOutlet UIButton *ali; 
@property (weak, nonatomic) IBOutlet UIButton *kclass;//科目
@property (weak, nonatomic) IBOutlet UILabel *danjia;//单价
@property (weak, nonatomic) IBOutlet UILabel *jine;//金额
@property (weak, nonatomic) IBOutlet UITextView *jilu;//充值记录
@property(assign,nonatomic)BOOL showZhou;
@property(assign,nonatomic)float keshi;
@property(strong,nonatomic) NSMutableArray* ptitle;
@property(strong,nonatomic) JWpriceModel* jwp;
@property(strong,nonatomic) NSString* biaoti_one;
@property(strong,nonatomic) NSString* biaoti_two;
@property(strong,nonatomic) NSString* dan1_jia4;
@property(assign,nonatomic)NSInteger dj;

/**微信支付*/
@property (nonatomic, strong) NSString *OrderNumber;

@end

@implementation JWmoneyViewController

#warning 充值记录接口获取？
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    NSUserDefaults* jj=[NSUserDefaults standardUserDefaults];
    _jilu.text=[jj objectForKey:@"jilu"];
    _jilu.font=[UIFont systemFontOfSize:15];
    //支付宝
    [_ali setEnabled:NO];
    _ali.layer.cornerRadius = 6;
    //微信支付按钮
    [_btnWeChatPay setEnabled:NO];
    _btnWeChatPay.layer.cornerRadius = 6;
    
    self.navigationItem.title=@"账户充值";
    _ptitle=[NSMutableArray array];
    [self getinfo];
    int k=0;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView* view=obj;
            for (id obj in view.subviews) {
                if ([obj isKindOfClass:[UILabel class]]) {
                    UILabel* label=obj;
                    label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.7];
                    
                }
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton* button=obj;
                    button.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:button.frame.size.height*0.4];
                }
            }
        }
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label=obj;
            label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.5];
            k++;
        }
    }
    
    /**微信支付结果通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeChatPayMsg:) name:@"WeChatPayMsg" object:nil];
    
    /**支付宝结果通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nilAliPaySuccess:) name:@"AliPaySuccess" object:nil];
    /**支付类型*/
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"payGMXS" forKey:@"wzPayType"];
}

- (IBAction)keshi:(UIButton *)sender {
        CGPoint point = CGPointMake(sender.center.x + sender.center.y, sender.frame.origin.y+120 + sender.frame.size.height);
    NSMutableArray *titles =[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [titles addObject:[NSString stringWithFormat:@"%d",i]];
    }
        PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
//            NSLog(@"select index:%ld", (long)index);
            _biaoti_two=titles[index];
//            sender.titleLabel.text=titles[index];
            [sender setTitle:titles[index] forState:UIControlStateNormal];
            sender.titleLabel.textAlignment=NSTextAlignmentCenter;
            _keshi=[titles[index] intValue];
            _jine.text=[NSString stringWithFormat:@"%.2f",_keshi*_dj];
            if (![_jine.text isEqualToString:@"0.00"]) {
                [_ali setEnabled:YES];
                [_ali setBackgroundColor:JWColor(0, 170, 238)];
                [_btnWeChatPay setEnabled:YES];
                [_btnWeChatPay setBackgroundColor:JWColor(0, 194, 61)];
            }
        };
        
        [pop show];
}

- (IBAction)xiala:(UIButton *)sender {
    CGPoint point = CGPointMake(sender.center.x + sender.center.y, sender.frame.origin.y+70 + sender.frame.size.height);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:_ptitle images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
       
//        NSLog(@"select index:%ld", (long)index);
        if (_jwp.body!=nil) {
            _biaoti_one=_jwp.body[index][@"科目"];
            _danjia.text=_jwp.body[index][@"单价"];
//            sender.titleLabel.text=_jwp.body[index][@"科目"];
            [sender setTitle:_jwp.body[index][@"科目"] forState:UIControlStateNormal];
            sender.titleLabel.textAlignment=NSTextAlignmentCenter;//设置文字居中
            _dan1_jia4=_jwp.body[index][@"单价"];
            _dj=[_dan1_jia4 floatValue];
            _jine.text=[NSString stringWithFormat:@"%.2f",_keshi*_dj];
            if (![_jine.text isEqualToString:@"0.00"]) {
                [_ali setEnabled:YES];
                [_ali setBackgroundColor:JWColor(81, 151, 78)];
                [_btnWeChatPay setEnabled:YES];
                [_btnWeChatPay setBackgroundColor:JWColor(81, 151, 78)];
            }
         }
    
    };
    [pop show];
   
  }




#pragma  mark - 支付宝
/**支付成功通知*/
- (void)nilAliPaySuccess:(NSNotification *)nc{
    [MBProgressHUD showSuccess:@"支付成功"];
    NSUserDefaults* drive=[NSUserDefaults standardUserDefaults];
    NSString* dr=[drive objectForKey:@"drivecode"];
    Order *order = nc.object;
    
    NSDateFormatter *dateFo = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateS = [dateFo stringFromDate:[NSDate date]];
    _jilu.text=[NSString stringWithFormat:@"日期：%@\n科目:  %@\n课时：%@\n金额：%@\n",currentDateS,_biaoti_one,_biaoti_two,order.amount];
    _jilu.font=[UIFont systemFontOfSize:15];
    NSUserDefaults* jilu=[NSUserDefaults standardUserDefaults];
    [jilu setObject:_jilu.text forKey:@"jilu"];
    [jilu synchronize];
    
    NSDictionary* info=@{@"danjia":_dan1_jia4,@"keshi":_biaoti_two,@"zongjia":order.amount,@"kemu":_biaoti_one,@"dingdanhao":order.tradeNO};
    
#warning 此接口目前没有任何含义
    [JWgetpay postpayinfo:dr info:info andCallback:^(id obj) {
        JWpriceModel* ja=obj;
        if ([ja.body[0][@"result"] isEqualToString:@"ok"]) {
        }
    }];
}
- (IBAction)alipay:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在支付..."];
    NSUserDefaults* drive=[NSUserDefaults standardUserDefaults];
    NSString* dr=[drive objectForKey:@"drivecode"];
    [JWgetpay requestpayissuccess:dr andCallback:^(id obj) {
        JWpriceModel* jj=obj;
#warning 返回body是数组以后可能会增加账号，目前为写死第一个账号
       NSString* result=jj.body[0][@"result"];
        if ([result isEqualToString:@"ok"]) {
#pragma mark - 支付宝API
            [JWAliPayAPI AliPayAPI:_biaoti_one payDescribe:[NSString stringWithFormat:@"%@ 课时",_biaoti_two] payMoney:[NSString stringWithFormat:@"%.2f",[_jine.text floatValue]]];
            
         
       
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"支付失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.frame = CGRectMake(50, 200, 200, 50);
            [alertView show];
        }
    }];
    
   }


#pragma mark - 微信支付

//微信支付成功通知
- (void)WeChatPayMsg:(NSNotification *)nc{
    if([nc.object isEqualToString:@"支付成功"]){
        NSUserDefaults *drive=[NSUserDefaults standardUserDefaults];
        NSString *dr=[drive objectForKey:@"drivecode"];
        
        NSDateFormatter *dateFo = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateS = [dateFo stringFromDate:[NSDate date]];
        _jilu.text=[NSString stringWithFormat:@"日期：%@\n科目:  %@\n课时：%@\n金额：%@\n",currentDateS,_biaoti_one,_biaoti_two,_jine.text];
        _jilu.font=[UIFont systemFontOfSize:15];
        NSUserDefaults *jilu=[NSUserDefaults standardUserDefaults];
        [jilu setObject:_jilu.text forKey:@"jilu"];
        [jilu synchronize];
        NSDictionary *info=@{@"danjia":_dan1_jia4,@"keshi":_biaoti_two,@"zongjia":_jine.text,@"kemu":_biaoti_one,@"dingdanhao":_OrderNumber};
        
#warning 此接口目前没有任何含义
        [JWgetpay postpayinfo:dr info:info andCallback:^(id obj) {
            JWpriceModel *ja=obj;
            if ([ja.body[0][@"result"] isEqualToString:@"ok"]) {
                NSLog(@"传回服务器支付信息成功");
            }
        }];
    }
}

//微信支付Btn事件
- (IBAction)btnWeChat:(id)sender {
    [MBProgressHUD showMessage:@"正在支付..."];
    NSUserDefaults *drive=[NSUserDefaults standardUserDefaults];
    NSString *dr=[drive objectForKey:@"drivecode"];
    [JWgetpay requestpayissuccess:dr andCallback:^(id obj) {
        JWpriceModel *jj=obj;
#warning 返回body是数组以后可能会增加账号，目前为写死第一个账号
        NSString *result=jj.body[0][@"result"];
        if ([result isEqualToString:@"ok"]) {
            //交易价格1表示0.01元，10表示0.1元
            NSInteger money = [_jine.text floatValue]*100;
#pragma mark - 微信支付API
            [JWWeChatPayAPI WeChatPayAPI:[NSString stringWithFormat:@"%@ - 购买课时: %@ ",_biaoti_one , _biaoti_two] payMoney:[NSString stringWithFormat:@"%ld",money]];
            
        }else{
            [MBProgressHUD showError:@"无法购买学时"];
        }
    }];
}
-(void)getinfo
{
    NSUserDefaults* drive=[NSUserDefaults standardUserDefaults];
   NSString* dr=[drive objectForKey:@"drivecode"];
   [JWgetpay requestClassandPrice:dr andCallback:^(id obj) {
       _jwp=obj;
       if (_jwp.body!=nil) {
       for (int i=0; i<_jwp.body.count; i++) {
           
           {
                [_ptitle addObject:_jwp.body[i][@"科目"]];
           
           }
           
       }
           
       }
     
   }];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
