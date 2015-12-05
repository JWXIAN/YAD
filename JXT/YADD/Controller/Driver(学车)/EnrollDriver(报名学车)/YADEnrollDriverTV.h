//
//  YADEnrollDriverTV.h
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YADEnrollDriverTVDelegate
/**
 *  跳转报名学车页
 *
 *  @param dicCellInfo Cell信息
 */
- (void)btnClickTitle:(NSDictionary *)dicCellInfo;
@end

@interface YADEnrollDriverTV : UITableViewController
/**YADEnrollDriverTVDelegate*/
@property (weak, nonatomic) id<YADEnrollDriverTVDelegate> delegate;
@end
