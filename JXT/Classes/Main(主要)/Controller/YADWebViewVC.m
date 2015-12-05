//
//  YADWebViewVC.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "YADWebViewVC.h"
#import "UIView+MJExtension.h"
#import "SVProgressHUD.h"

@interface YADWebViewVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation YADWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeAll;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self loadV];
}

- (void)loadV{
    [SVProgressHUD show];
    //加载科一科二知识
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, self.view.mj_h)];
    [_webView setUserInteractionEnabled:YES];             //是否支持交互
    [_webView setOpaque:YES];                              //Opaque为不透明的意思
    [_webView setScalesPageToFit:YES];                    //自动缩放以适应屏幕
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSURL *url;
    if ([_strURL rangeOfString:@"http://"].location !=NSNotFound){
        url = [NSURL URLWithString:_strURL];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", _strURL]];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

@end
