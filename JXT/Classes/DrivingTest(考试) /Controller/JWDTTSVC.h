//
//  JWDTTSVC.h
//  JXT
//
//  Created by JWX on 15/8/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWDTTSVC : UIViewController
/**题数统计*/
@property (nonatomic, assign) NSInteger tsCount;
/**对错题数组*/
@property (nonatomic, strong) NSArray *cellDCTRow;

/**设置Cell*/
//- (void)setDCTCell:(NSArray *)dctArr cellCount:(int)cellCount;
@end
