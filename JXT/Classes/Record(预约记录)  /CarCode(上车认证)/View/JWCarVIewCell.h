//
//  JWCarVIewCell.h
//  JXT
//
//  Created by JWX on 15/7/2.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWRecordHeadModel;
@class JWRecordBodyModel;

@interface JWCarVIewCell : UITableViewCell

/**教练姓名*/
@property (weak, nonatomic) IBOutlet UILabel *lbName;
/**科目*/
@property (weak, nonatomic) IBOutlet UILabel *lbKM;
/**车号*/
@property (weak, nonatomic) IBOutlet UILabel *lbCH;
/**日期*/
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
/**时段*/
@property (weak, nonatomic) IBOutlet UILabel *lbHour;
/**学员id二维码*/
@property (weak, nonatomic) IBOutlet UILabel *lblCode;



/** 预约信息的数据模型 */
@property (nonatomic,strong)JWRecordHeadModel *bookRecord;
@property (nonatomic,strong)JWRecordBodyModel *stuBookRecordInfo;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
