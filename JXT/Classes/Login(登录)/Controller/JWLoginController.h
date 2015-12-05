//
//  JWLoginController.h
//  JXT
//
//  Created by JWX on 15/6/24.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWDriveBodyModel;
@class JWLoginModel;

@interface JWLoginController : UIViewController
/**驾校数据模型*/
@property (nonatomic,strong)JWDriveBodyModel *driveData;
/**登录学员数据模型*/
@property (nonatomic,strong)JWLoginModel *stuLogin;

@property (weak, nonatomic) IBOutlet UIButton *remove;


@end
