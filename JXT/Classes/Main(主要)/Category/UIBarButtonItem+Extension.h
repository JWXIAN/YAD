//
//  UIBarButtonItem+Extension.h
//  JXT
//
//  Created by JWX on 15/6/19.
//  Copyright (c) 2015年 JW. All rights reserved.

//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
