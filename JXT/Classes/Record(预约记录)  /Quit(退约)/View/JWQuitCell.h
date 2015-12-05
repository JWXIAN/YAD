//
//  JWQuitCell.h
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWRecordBodyModel;
@class JWRecordHeadModel;

@interface JWQuitCell : UITableViewCell
/**日期*/
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
/**时段*/
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
/**教练*/
@property (weak, nonatomic) IBOutlet UILabel *lbJL;
/**车号*/
@property (weak, nonatomic) IBOutlet UILabel *lbCH;
/**科目*/
@property (weak, nonatomic) IBOutlet UILabel *lbKU;

/** 预约信息的数据模型 */
@property (nonatomic,strong)JWRecordBodyModel *stuBookRecord;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
