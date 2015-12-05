//
//  YADPersonalCenterTVCell.h
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADPersonalCenterTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)stCellImageTitle:(NSIndexPath *)indexPath;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@end
