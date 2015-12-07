//
//  JWWeChatPayAPI.m
//  JXT
//
//  Created by JWX on 15/10/13.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWWeChatPayAPI.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JWWeChatHeadModel.h"
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "XMLDictionary.h"
#import "WXApi.h"
#import "JWgetpay.h"

@implementation JWWeChatPayAPI

#pragma mark - 微信支付

+ (void)WeChatPayAPI:(NSString *)payInfo payMoney:(NSString *)payMoney{
    
    NSUserDefaults *drive=[NSUserDefaults standardUserDefaults];
    NSString *dr=[drive objectForKey:@"drivecode"];
    //取AppID、商户号、商户密钥
    [JWgetpay requestWeChatkey:dr andCallback:^(id obj) {
        JWWeChatHeadModel *jr=obj;
        NSDictionary *xctpay=jr.body[0];
        //                JWWeChatModel *weChat = [[JWWeChatModel alloc] init];
        //                //AppID
        //                weChat.username = xctpay[@"username"];
        //                //商户号
        //                weChat.userid = xctpay[@"userid"];
        //                //商户密钥
        //                weChat.encrypt = xctpay[@"encrypt"];
        NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
        //应用APPID
        appid = xctpay[@"username"];
        //微信支付商户号
        mch_id = xctpay[@"userid"];
        //商户密钥
        partner = xctpay[@"encrypt"];
        ///产生随机字符串，这里最好使用和安卓端一致的生成逻辑
        nonce_str =[self generateTradeNo];
        //商品详情
        body = payInfo;
        //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
        out_trade_no = [self getOrderNumber];
        
        //        _OrderNumber = out_trade_no;
        //交易价格1表示0.01元，10表示0.1元
        total_fee = payMoney;
        NSLog(@"total_fee----%@", total_fee);
        
        //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
        spbill_create_ip =[getIPhoneIP getIPAddress];
        //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
        notify_url =@"http://www.1039soft.com";
        //客户端
        trade_type =@"APP";
        //获取sign签名
        DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
        sign = [data getSignForMD5];
        //设置参数并转化成xml格式
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:appid forKey:@"appid"];//公众账号ID
        [dic setValue:mch_id forKey:@"mch_id"];//商户号
        [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
        [dic setValue:sign forKey:@"sign"];//签名
        [dic setValue:body forKey:@"body"];//商品描述
        [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
        [dic setValue:total_fee forKey:@"total_fee"];//金额
        [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
        [dic setValue:notify_url forKey:@"notify_url"];//通知地址
        [dic setValue:trade_type forKey:@"trade_type"];//交易类型
        NSLog(@"%@", dic);
        NSString *string = [dic XMLString];
        [self http:string];
    }];
}

+ (void)http:(NSString *)xml{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", manager);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            DataMD5 *md5 = [[DataMD5 alloc] init];
            request.sign=[md5 createMD5SingForPay:@"wx61acca87c7d8684c" partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            [MBProgressHUD hideHUD];
            //调用微信
            [WXApi sendReq:request];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"无法支付"];
            //            NSLog(@"参数不正确，请检查参数");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"无法支付"];

    }];
}


///产生随机字符串
+ (NSString *)generateTradeNo
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
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

//将订单号使用md5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//产生随机数
+ (NSString *)getOrderNumber{
    int random = arc4random()%10000;
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *tradeNO=[NSString stringWithFormat:@"%@%d",currentDateStr,random];
    return tradeNO;
}


//#pragma mark - 微信支付
//
//- (void)weChatPay{
//    [MBProgressHUD showMessage:@"正在支付..."];
//    NSUserDefaults *drive=[NSUserDefaults standardUserDefaults];
//    NSString *dr=[drive objectForKey:@"drivecode"];
//    //取AppID、商户号、商户密钥
//    [JWgetpay requestWeChatkey:dr andCallback:^(id obj) {
//        JWWeChatHeadModel *jr=obj;
//        NSDictionary *xctpay=jr.body[0];
//        //                JWWeChatModel *weChat = [[JWWeChatModel alloc] init];
//        //                //AppID
//        //                weChat.username = xctpay[@"username"];
//        //                //商户号
//        //                weChat.userid = xctpay[@"userid"];
//        //                //商户密钥
//        //                weChat.encrypt = xctpay[@"encrypt"];
//        NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
//        //应用APPID
//        appid = xctpay[@"username"];
//        //微信支付商户号
//        mch_id = xctpay[@"userid"];
//        //商户密钥
//        partner = xctpay[@"encrypt"];
//        ///产生随机字符串，这里最好使用和安卓端一致的生成逻辑
//        nonce_str =[self generateTradeNo];
//        //商品详情
//        body = [NSString stringWithFormat:@"补缴类型:%@  补缴金额:%@  欠费时间:%@",[drive objectForKey:@"lblPXF"], [drive objectForKey:@"lblBJJE"], [drive objectForKey:@"lblDate"]];
//        //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
//        out_trade_no = [self getOrderNumber];
//        
//        //        _OrderNumber = out_trade_no;
//        //交易价格1表示0.01元，10表示0.1元
//        //                NSLog(@"%@", [NSString stringWithFormat:@"%d00",[_jine.text intValue]]);
//        NSInteger money = [[drive objectForKey:@"lblBJJE"] floatValue]*100;
//        total_fee = [NSString stringWithFormat:@"%ld", money];
//        NSLog(@"total_fee----%@", total_fee);
//        //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
//        spbill_create_ip =[getIPhoneIP getIPAddress];
//        //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
//        notify_url =@"http://www.1039soft.com";
//        //客户端
//        trade_type =@"APP";
//        //获取sign签名
//        DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
//        sign = [data getSignForMD5];
//        //设置参数并转化成xml格式
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:appid forKey:@"appid"];//公众账号ID
//        [dic setValue:mch_id forKey:@"mch_id"];//商户号
//        [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
//        [dic setValue:sign forKey:@"sign"];//签名
//        [dic setValue:body forKey:@"body"];//商品描述
//        [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
//        [dic setValue:total_fee forKey:@"total_fee"];//金额
//        [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
//        [dic setValue:notify_url forKey:@"notify_url"];//通知地址
//        [dic setValue:trade_type forKey:@"trade_type"];//交易类型
//        NSLog(@"%@", dic);
//        NSString *string = [dic XMLString];
//        [self http:string];
//    }];
//    
//}
//- (void)http:(NSString *)xml{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        return xml;
//    }];
//    //发起请求
//    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", manager);
//        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
//        NSLog(@"responseString is %@",responseString);
//        //将微信返回的xml数据解析转义成字典
//        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
//        //判断返回的许可
//        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
//            
//            //发起微信支付，设置参数
//            PayReq *request = [[PayReq alloc] init];
//            request.partnerId = [dic objectForKey:@"mch_id"];
//            request.prepayId= [dic objectForKey:@"prepay_id"];
//            request.package = @"Sign=WXPay";
//            request.nonceStr= [dic objectForKey:@"nonce_str"];
//            //将当前事件转化成时间戳
//            NSDate *datenow = [NSDate date];
//            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//            UInt32 timeStamp =[timeSp intValue];
//            request.timeStamp= timeStamp;
//            DataMD5 *md5 = [[DataMD5 alloc] init];
//            request.sign=[md5 createMD5SingForPay:@"wxc1452ee4722071a5" partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
//            [MBProgressHUD hideHUD];
//            //调用微信
//            [WXApi sendReq:request];
//        }else{
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"无法支付"];
//            //            NSLog(@"参数不正确，请检查参数");
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error is %@",error);
//    }];
//}
//
//
/////产生随机字符串
//- (NSString *)generateTradeNo
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand(time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
//
//////将订单号使用md5加密
////-(NSString *)md5:(NSString *)str
////{
////    const char *cStr = [str UTF8String];
////    unsigned char result[16]= "0123456789abcdef";
////    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
////    return [NSString stringWithFormat:
////            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
////            result[0], result[1], result[2], result[3],
////            result[4], result[5], result[6], result[7],
////            result[8], result[9], result[10], result[11],
////            result[12], result[13], result[14], result[15]
////            ];
////}
//
////产生随机数
//- (NSString *)getOrderNumber{
//    int random = arc4random()%10000;
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *tradeNO=[NSString stringWithFormat:@"%@%d",currentDateStr,random];
//    return tradeNO;
//}

@end
