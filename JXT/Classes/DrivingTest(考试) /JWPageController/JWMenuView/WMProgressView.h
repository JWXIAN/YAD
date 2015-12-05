//
//  WMProgressView.h
//  WMPageController
//
//  Created by JWXian.com on 15/8/11.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMProgressView : UIView
@property (nonatomic, strong) NSArray *itemFrames;
@property (nonatomic, assign) CGColorRef color;
@property (nonatomic, assign) CGFloat progress;
- (void)setProgressWithOutAnimate:(CGFloat)progress;
@end
