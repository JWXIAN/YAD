//
//  JWTestScoreVC.m
//  JXT
//
//  Created by JWX on 15/10/15.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "JWTestScoreVC.h"
#import "JWTarBarController.h"
#import "UIView+MJExtension.h"
#import "UIImageView+WebCache.h"

@interface JWTestScoreVC ()

@end

@implementation JWTestScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePs.layer.masksToBounds = YES;
    _imagePs.layer.cornerRadius = _imagePs.mj_h/2.0;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //学员头像
    [_imagePs sd_setImageWithURL:[ud objectForKey:@"per_photo"] placeholderImage:[UIImage imageNamed:@"PersonImage"]];
    if ([[ud objectForKey:@"dtCountArr"] intValue] >= 90) {
        [_imageBGView setImage:[UIImage imageNamed:@"jjcs"]];
    }
    //学员姓名
    _lblName.text = [ud objectForKey:@"per_name"];
    //分数
    _lblScore.text = [NSString stringWithFormat:@"%@分", [ud objectForKey:@"dtCountArr"]];
    //用时
    _lblTime.text = [ud objectForKey:@"strTime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)btnQuit:(id)sender {
    JWTarBarController *tb = [[JWTarBarController alloc] init];
    tb.selectedIndex = 1;
    [self presentViewController:tb animated:YES completion:nil];
}

- (IBAction)btnCXKS:(id)sender {
    JWTarBarController *tb = [[JWTarBarController alloc] init];
    tb.selectedIndex = 1;
    [self presentViewController:tb animated:YES completion:nil];
}
@end
