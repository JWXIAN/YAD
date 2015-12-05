//
//  JWOrderTY.h
//  JXT
//
//  Created by JWX on 15/7/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWTYModel.h"

@interface JWOrderTY : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbJL;
@property (weak, nonatomic) IBOutlet UILabel *lbCH;
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
@property (weak, nonatomic) IBOutlet UILabel *lbKM;
@property (weak, nonatomic) IBOutlet UILabel *lbId;
@property (weak, nonatomic) IBOutlet UILabel *lbSchoolId;


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *jl;
@property (nonatomic, strong) NSString *ch;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *km;
@property (nonatomic, strong) NSString *lbid;
@property (nonatomic, strong) NSString *scid;

/**退约*/
+(JWTYModel *)jsonTY:(NSDictionary *)dic;
@end
