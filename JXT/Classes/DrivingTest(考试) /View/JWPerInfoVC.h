//
//  JWPerInfoVC.h
//  JXT
//
//  Created by JWX on 15/8/14.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWPerInfoVC : UIViewController
@property(strong,nonatomic)NSString *lblKSTM_name;
@property(strong,nonatomic)NSString *lblKSCX_name;
//全真模拟
@property (weak, nonatomic) IBOutlet UIButton *btnQZMN;
- (IBAction)btnSelectQZMN:(id)sender;

/**学员姓名*/
@property (weak, nonatomic) IBOutlet UILabel *lblName;
//未做题
@property (weak, nonatomic) IBOutlet UIButton *btnWZT;

//考试科目
@property (weak, nonatomic) IBOutlet UILabel *lblKSTM;
//考试标准
@property (weak, nonatomic) IBOutlet UILabel *lblKSBZ;
/**学员头像*/
@property (weak, nonatomic) IBOutlet UIImageView *imagePerson;

//考试车型
@property (weak, nonatomic) IBOutlet UILabel *lblKSCX;
- (IBAction)btnXKWZT:(id)sender;

@end
