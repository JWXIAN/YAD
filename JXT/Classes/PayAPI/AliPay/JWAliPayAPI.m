//
//  JWAliPayAPI.m
//  JXT
//
//  Created by JWX on 15/10/13.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWAliPayAPI.h"
#import <AlipaySDK/AlipaySDK.h>

#import "DataSigner.h"
#import "JWgetpay.h"
#import "JWpriceModel.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

@implementation JWAliPayAPI

#pragma mark   ==============产生随机订单号==============


+ (NSString *)generateTradeNO
{
    static int kNumber = 8;
    
    NSString *sourceStr = @"0123456789";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (void)AliPayAPI:(NSString *)payTitle payDescribe:(NSString *)payDescribe payMoney:(NSString *)payMoney{
    NSUserDefaults* drive=[NSUserDefaults standardUserDefaults];
    NSString *dr=[drive objectForKey:@"drivecode"];
    
    [JWgetpay requestpaykey:dr andCallback:^(id obj) {
        JWpriceModel *jr=obj;
        NSDictionary* xctpay=jr.body[0];
        Order *order = [[Order alloc] init];
        order.partner = xctpay[@"pariner"];//商户PID
        order.seller =xctpay[@"seller"];//商户收款账号
#warning 订单编号年月日时分秒+随机8位数
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSString* tradeNO=[NSString stringWithFormat:@"%@%@",currentDateStr,[self generateTradeNO]];
        order.tradeNO = tradeNO; //订单ID（由商家自行制定）
        order.productName = payTitle; //商品标题
        order.productDescription = payDescribe; //商品描述
        order.amount = payMoney; //商品价格
#warning 服务器路径获取接口？
        order.notifyURL = @"http://www.1039soft.com";   // 服务器异步通知页面路径   回调URL
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        //                NSLog(@"orderSpec = %@",orderSpec);
        
        NSString* privateKey=xctpay[@"pirvate"];
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            [MBProgressHUD hideHUD];
            //支付并返回结果
         
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSString* result=resultDic[@"result"];
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]&& [result rangeOfString:@"success=\"true\""].location !=NSNotFound ) {
                    
                    
                    if([[drive objectForKey:@"wzPayType"] isEqualToString:@"payBJFY"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayBJFYSuccess" object:@"支付成功"];
                    }else if ([[drive objectForKey:@"wzPayType"] isEqualToString:@"payGMXS"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayGMXSSuccess" object:order];
                    }
                }
                else
                {
                    [MBProgressHUD showError:@"支付失败"];
                }
            }];
        }
    }];
}


//[JWgetpay requestpaykey:dr andCallback:^(id obj) {
//    JWpriceModel *jr=obj;
//    NSDictionary* xctpay=jr.body[0];
//    Order *order = [[Order alloc] init];
//    order.partner = xctpay[@"pariner"];//商户PID
//    order.seller =xctpay[@"seller"];//商户收款账号
//#warning 订单编号年月日时分秒+随机8位数
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSString* tradeNO=[NSString stringWithFormat:@"%@%@",currentDateStr,[self generateTradeNO]];
//    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
//    order.productName = _biaoti_one; //商品标题
//    order.productDescription = [NSString stringWithFormat:@"%@ 课时",_biaoti_two]; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",[_jine.text floatValue]]; //商品价格
//#warning 服务器路径获取接口？
//    order.notifyURL = @"http://www.1039soft.com";   // 服务器异步通知页面路径   回调URL
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    //                NSLog(@"orderSpec = %@",orderSpec);
//    
//    NSString* privateKey=xctpay[@"pirvate"];
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        //                    NSLog(@"orderString==%@",orderString);
//        [MBProgressHUD hideHUD];
//        //支付并返回结果
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSString* result=resultDic[@"result"];
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]&& [result rangeOfString:@"success=\"true\""].location !=NSNotFound ) {
//                NSDateFormatter *dateFo = [[NSDateFormatter alloc] init];
//                //设定时间格式,这里可以设置成自己需要的格式
//                [dateFo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                //用[NSDate date]可以获取系统当前时间
//                NSString *currentDateS = [dateFo stringFromDate:[NSDate date]];
//                _jilu.text=[NSString stringWithFormat:@"日期：%@\n科目:  %@\n课时：%@\n金额：%@\n",currentDateS,_biaoti_one,_biaoti_two,order.amount];
//                _jilu.font=[UIFont systemFontOfSize:15];
//                NSUserDefaults* jilu=[NSUserDefaults standardUserDefaults];
//                [jilu setObject:_jilu.text forKey:@"jilu"];
//                [jilu synchronize];
//                NSDictionary* info=@{@"danjia":_dan1_jia4,@"keshi":_biaoti_two,@"zongjia":order.amount,@"kemu":_biaoti_one,@"dingdanhao":tradeNO};
//#warning 此接口目前没有任何含义
//                [JWgetpay postpayinfo:dr info:info andCallback:^(id obj) {
//                    JWpriceModel* ja=obj;
//                    if ([ja.body[0][@"result"] isEqualToString:@"ok"]) {
//                        //                                    NSLog(@"")
//                    }
//                }];
//            }
//            else
//            {
//                [MBProgressHUD showError:@"支付失败"];
//            }
//            //                        NSLog(@"reslut = %@",resultDic);
//        }];
//    }
//}];

@end
