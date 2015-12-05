//
//  YADSettingTVCell.h
//  YAD
//
//  Created by JWX on 15/11/18.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADSettingTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)stCellImageTitle:(NSIndexPath *)indexPath;
//标题
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@end
