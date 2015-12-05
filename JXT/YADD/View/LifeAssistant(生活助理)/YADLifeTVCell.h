//
//  YADLifeTVCell.h
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADLifeTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**设置YADLifeTVCell 图片和标题*/
- (void)stCellImageTitle:(NSIndexPath *)indexPath;
@end
