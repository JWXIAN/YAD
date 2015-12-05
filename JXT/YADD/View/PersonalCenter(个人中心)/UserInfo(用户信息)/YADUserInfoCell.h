//
//  YADUserInfoCell.h
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWProfileModel.h"

@interface YADUserInfoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**用户信息*/
- (void)stCellImageTitle:(NSIndexPath *)indexPath userInfo:(JWProfileModel *)userInfo testInfo:(NSString *)testInfo;
@end
