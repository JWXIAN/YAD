//
//  YADLoginTVCell.h
//  YAD
//
//  Created by JWX on 15/11/27.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADLoginTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**账号密码框*/
@property (weak, nonatomic) IBOutlet UITextField *textDetail;

- (void)cellWithTitle:(NSIndexPath *)indexPath;
@end
