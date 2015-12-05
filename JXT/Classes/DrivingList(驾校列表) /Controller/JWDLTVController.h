//
//  JWDLTVController.h
//  JXT
//
//  Created by JWX on 15/6/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassValueDelegate <NSObject>

-(void)passValue:(id)value;

@end


@interface JWDLTVController : UIViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;  
@end
