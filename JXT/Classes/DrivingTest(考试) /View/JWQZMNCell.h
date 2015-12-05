//
//  JWQZMNCell.h
//  JXT
//
//  Created by JWX on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class exam;
@interface JWQZMNCell : UITableViewCell

//题标
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//答案
@property (weak, nonatomic) IBOutlet UILabel *lblText;
//对错
@property (weak, nonatomic) IBOutlet UIImageView *imgaeDC;

////获取cell indexPath
//- (void)cellWithIndexPath:(NSIndexPath *)indexPath;
//
////答题数据模型
//@property (nonatomic, strong)exam *daInfo;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
