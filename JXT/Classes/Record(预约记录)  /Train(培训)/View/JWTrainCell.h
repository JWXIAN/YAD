//
//  JWTrainCell.h
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWTrainHeadModel;
@class JWTrainBodyModel;

@interface JWTrainCell : UITableViewCell

/**日期*/
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
/**时段*/
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
/**教练姓名*/
@property (weak, nonatomic) IBOutlet UILabel *lbJL;
/**车号*/
@property (weak, nonatomic) IBOutlet UILabel *lbCH;
/**科目*/
@property (weak, nonatomic) IBOutlet UILabel *lbKM;
/**我的评价*/
@property (weak, nonatomic) IBOutlet UILabel *lbPJ;
/**教练评语*/
@property (weak, nonatomic) IBOutlet UILabel *lbJLPY;

/**是否可评价*/
@property (weak, nonatomic) IBOutlet UIImageView *imagePJ;

/**培训id*/
@property (nonatomic, strong) NSString *pxid;
///** 预约信息的数据模型 */
//@property (nonatomic,strong)JWTrainHeadModel *bookRecord;
//@property (nonatomic,strong)JWTrainBodyModel *stuBookRecord;

/** 学员的数据模型 */
@property (nonatomic, strong) JWTrainBodyModel *stuBookRecord;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
