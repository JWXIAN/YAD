//
//  JWEvaluateVIew.h
//  JXT
//
//  Created by JWX on 15/7/6.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWEvaluateVIew : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbKM;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbHour;

@property (weak, nonatomic) IBOutlet UITextView *PJText;

@property (weak, nonatomic) IBOutlet UILabel *lbOne;
@property (weak, nonatomic) IBOutlet UILabel *lbTwo;
@property (weak, nonatomic) IBOutlet UILabel *lbThree;
@property (weak, nonatomic) IBOutlet UILabel *lbFour;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *km;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *pxid;
@end
