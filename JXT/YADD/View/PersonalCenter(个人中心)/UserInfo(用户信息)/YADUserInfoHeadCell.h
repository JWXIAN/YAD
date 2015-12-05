//
//  YADUserInfoHeadCell.h
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWProfileModel.h"

@interface YADUserInfoHeadCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(strong, nonatomic) JWProfileModel *person;
@end
