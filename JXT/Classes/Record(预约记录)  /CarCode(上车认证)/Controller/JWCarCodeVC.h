//
//  JWCarCodeVC.h
//  JXT
//
//  Created by JWX on 15/7/6.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCarCodeVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbJL;
@property (weak, nonatomic) IBOutlet UILabel *lbCH;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbHour;
@property (weak, nonatomic) IBOutlet UILabel *lbKM;
/**二维码*/
@property (weak, nonatomic) IBOutlet UIImageView *imageCode;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *km;
@property (nonatomic, strong) NSString *ch;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *code;

@end
