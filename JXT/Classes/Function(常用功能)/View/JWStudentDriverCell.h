//
//  JWStudentDriverCell.h
//  JXT
//
//  Created by JWX on 15/9/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWStudentDriverCell : UITableViewCell
/**图标*/
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *lblText;


/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTV:(UITableView *)tableView indexPathRow:(NSIndexPath *)index;
@end
