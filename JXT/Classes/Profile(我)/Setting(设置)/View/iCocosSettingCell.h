//
//  iCocosSettingCell.h
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iCocosSettingItem;
@interface iCocosSettingCell : UITableViewCell
{
    UISwitch *_switch;
}
@property (nonatomic, strong) iCocosSettingItem *item;

+ (id)settingCellWithTableView:(UITableView *)tableView;
@end
