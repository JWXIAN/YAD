//
//  YADEnrollSDOneCell.h
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YADEnrollSDOneCellDelegate
/**
 *  立即报名
 *
 */
- (void)btnSignUpImmClick;
@end

@interface YADEnrollSDOneCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**YADEnrollSDOneCellDelegate*/
@property (weak, nonatomic) id<YADEnrollSDOneCellDelegate> delegate;
@end
