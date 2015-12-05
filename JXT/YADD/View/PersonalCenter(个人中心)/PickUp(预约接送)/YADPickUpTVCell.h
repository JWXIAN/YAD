//
//  YADPickUpTVCell.h
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADPickUpTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)cellWithTitleDetail:(NSIndexPath *)indexPath;

/**信息*/
@property (weak, nonatomic) IBOutlet UITextField *textDetail;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/**时间选择器*/
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end
