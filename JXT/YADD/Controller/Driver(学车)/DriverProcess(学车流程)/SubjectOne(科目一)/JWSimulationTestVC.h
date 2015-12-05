//
//  JWSimulationTestVC.h
//  projectTemp
//
//  Created by JWX on 15/11/2.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWSimulationTestVCDelegate
/**
 *  模拟考试Button
 *
 *  @param btnTitle button标题
 */
- (void)btnSimClickTitle:(NSString *)btnTitle;
@end

@interface JWSimulationTestVC : UIViewController
/**button标题*/
@property (nonatomic, strong) NSString *strTitle;

/**JWSimulationTestVCDelegate*/
@property (weak, nonatomic) id<JWSimulationTestVCDelegate> delegate;
@end
