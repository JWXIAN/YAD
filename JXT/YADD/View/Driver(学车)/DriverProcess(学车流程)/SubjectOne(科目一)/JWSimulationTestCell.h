//
//  JWSimulationTestCell.h
//  projectTemp
//
//  Created by JWX on 15/11/2.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWSimulationTestCellDelegate
/**
 *  模拟考试Button
 *
 *  @param btnTitle button标题
 */
- (void)btnClickTitle:(NSString *)btnTitle;
@end

@interface JWSimulationTestCell : UICollectionViewCell
//设置button标题 图片
- (void)loadTitle:(NSIndexPath *)indexPath;

/**JWSimulationTestCellDelegate*/
@property (weak, nonatomic) id<JWSimulationTestCellDelegate> delegate;
@end
