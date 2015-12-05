//
//  YADHomeButtonCell.h
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YADHomeButtonCellDelegate
/**
 *  主页Button
 *
 *  @param btnTitle button标题
 */
- (void)btnClickTitle:(NSInteger)btnTag;
@end

@interface YADHomeButtonCell : UICollectionViewCell
- (void)stCellImageTitle:(NSIndexPath *)indexPath;

/**YADHomeButtonCellDelegate*/
@property (weak, nonatomic) id<YADHomeButtonCellDelegate> delegate;
@end
