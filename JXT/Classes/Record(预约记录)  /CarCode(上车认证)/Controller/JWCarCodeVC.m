//
//  JWCarCodeVC.m
//  JXT
//
//  Created by JWX on 15/7/6.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWCarCodeVC.h"
#import "MBProgressHUD+MJ.h"
#import "QRCodeGenerator.h"
#import <ShareSDK/ShareSDK.h>

@interface JWCarCodeVC ()
@property(strong,nonatomic)UIImage* anewImage;
@end

@implementation JWCarCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDate];
//    self.btnSave.layer.cornerRadius = 10;
//    self.btnAchieve.layer.cornerRadius = 10;
}

- (void)loadDate
{
    self.lbJL.text = self.name;
    self.lbCH.text = self.km;
    self.lbDate.text = self.date;
    self.lbHour.text = self.hour;
    self.lbKM.text = self.km;
    self.imageCode.image = [QRCodeGenerator qrImageForString:self.code imageSize:self.imageCode.bounds.size.width];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnJT:(id)sender {
    [self saveimage];
     UIImageWriteToSavedPhotosAlbum(_anewImage,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  }
- (void)saveimage
{
    //延迟一秒保存
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //获取图形上下文
        //    UIGraphicsBeginImageContext(self.view.frame.size);
        UIGraphicsBeginImageContext(self.view.frame.size);
        //将view绘制到图形上下文中
        //    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        _anewImage=UIGraphicsGetImageFromCurrentImageContext();
       
    });

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败，请检查是否拥有相关的权限"];
    }else
    {
        [MBProgressHUD showSuccess:@"保存截图成功"];
    }
}



@end
