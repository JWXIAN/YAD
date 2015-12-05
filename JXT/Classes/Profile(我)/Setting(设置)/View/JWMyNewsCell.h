//
//  JWMyNewsCell.h
//  JXT
//
//  Created by JWX on 15/9/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWMyNewsCell : UITableViewCell

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**题序*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/**正文*/
@property (weak, nonatomic) IBOutlet UILabel *lblText;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblBT;
@end
