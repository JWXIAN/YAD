//
//  JWBJFYCell.h
//  JXT
//
//  Created by JWX on 15/10/12.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWBJFYCell : UITableViewCell

- (IBAction)btnLJBJ:(id)sender;
/**补缴按钮*/
@property (weak, nonatomic) IBOutlet UIButton *btnLJBJ;
/**补缴类型*/
@property (weak, nonatomic) IBOutlet UILabel *lblPXF;
/**补缴金额*/
@property (weak, nonatomic) IBOutlet UILabel *lblBJJE;
/**欠费时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
