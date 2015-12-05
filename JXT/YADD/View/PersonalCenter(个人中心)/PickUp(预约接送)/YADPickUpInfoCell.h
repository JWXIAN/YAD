//
//  YADPickUpInfoCell.h
//  YAD
//
//  Created by JWX on 15/11/24.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YADPickUpInfoModel.h"
@protocol YADPickUpInfoCellDelegate

- (void)btnCancelPickUpClick:(NSInteger)btnTag;
@end

@interface YADPickUpInfoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)cellWithIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) YADPickUpInfoModel *pickUpInfoModel;

/**YADPickUpInfoCellDelegate*/
@property (weak, nonatomic) id<YADPickUpInfoCellDelegate> delegate;

/**预约id*/
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@end
