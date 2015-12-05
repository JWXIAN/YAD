//
//  JWAliPayAPI.h
//  JXT
//
//  Created by JWX on 15/10/13.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface JWAliPayAPI : NSObject



/**随机生成订单*/
+ (NSString *)generateTradeNO;
/**支付宝API*/
+ (void)AliPayAPI:(NSString *)payTitle payDescribe:(NSString *)payDescribe payMoney:(NSString *)payMoney;
@end
