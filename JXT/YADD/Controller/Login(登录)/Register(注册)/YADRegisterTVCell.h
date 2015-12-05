//
//  YADRegisterTVCell.h
//  JXT
//
//  Created by JWX on 15/12/4.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADRegisterTVCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)cellWithTitle:(NSIndexPath *)indexPath;

@property (weak, nonatomic) IBOutlet UITextField *textDetail;
@end
