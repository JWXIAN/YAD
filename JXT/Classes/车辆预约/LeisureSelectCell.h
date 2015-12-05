//
//  LeisureSelectCell.h
//  JXT
//
//  Created by 1039soft on 15/10/10.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeisureModel.h"
@interface LeisureSelectCell : UITableViewCell
/**
 *  设置cell
 *
 *  @param arr 模型
 *
 *  @since 2.0.2
 */
- (void)setCellWithModel:(LeisureModel*)model;
@end
