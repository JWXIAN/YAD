//
//  JWAboutViewController.m
//  JXT
//
//  Created by 1039soft on 15/7/8.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWAboutViewController.h"

@interface JWAboutViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *banbenhao;//版本号


@end

@implementation JWAboutViewController

- (IBAction)tel:(UIButton *)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.1039.cn"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    _banbenhao.text = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//获取版本号
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
