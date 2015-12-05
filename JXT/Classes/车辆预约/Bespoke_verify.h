//
//  Bespoke_verify.h
//  JXT
//
//  Created by 1039soft on 15/7/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWVenicleBodyModel.h"
@interface Bespoke_verify : UIViewController
@property(strong,nonatomic) NSString*  nowtime;//日期 e.g. 2015年10月12日
@property (nonatomic,strong)JWVenicleBodyModel *driTeaListInfo;
@property(strong,nonatomic) NSString*  periodCode;//时间段代码
@property(strong,nonatomic) NSString* shiduan;//预约时间 e.g. 12:00-13:00

@end
