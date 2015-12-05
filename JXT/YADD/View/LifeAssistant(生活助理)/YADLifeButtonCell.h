//
//  YADLifeButtonCell.h
//  projectTemp
//
//  Created by JWX on 15/11/17.
//  Copyright © 2015年 jiajiaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YADLifeButtonCellDelegate
/**
 *  生活助理Button
 *
 *  @param btnTag
 */
- (void)btnClickTitle:(NSInteger)btnTag;
@end

@interface YADLifeButtonCell : UICollectionViewCell
/**设置YADLifeButtonCell 图片和标题*/
- (void)stCellImageTitle:(NSIndexPath *)indexPath;

@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

/**YADLifeButtonCellDelegate*/
@property (weak, nonatomic) id<YADLifeButtonCellDelegate> delegate;
@end
