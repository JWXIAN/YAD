//
//  JWWDCJCell.h
//  JXT
//
//  Created by JWX on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWWDCJStatBodyModel;

@interface JWWDCJCell : UITableViewCell

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**序号*/
@property (weak, nonatomic) IBOutlet UILabel *lblXH;
/**考试分数*/
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
/**考试时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
/**考试评语*/
@property (weak, nonatomic) IBOutlet UILabel *lblPY;
/**考试时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

- (void)cellWithIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) NSIndexPath *cellRowIndex;

/** 我的成绩的数据模型 */
@property (nonatomic, strong) JWWDCJStatBodyModel *wdcjStat;

@end
