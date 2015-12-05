//
//  JWhelpViewController.m
//  JXT
//
//  Created by 1039soft on 15/6/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWhelpViewController.h"

@interface JWhelpViewController ()

@end

@implementation JWhelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lab= [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width-5, self.view.bounds.size.height)];
//    _lab.lineBreakMode = NSLineBreakByWordWrapping;
//    _lab.numberOfLines = 0;
    _lab.editable=NO;
    _lab.font=[UIFont systemFontOfSize:16];
    _lab.text=_labtext;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_lab];
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
