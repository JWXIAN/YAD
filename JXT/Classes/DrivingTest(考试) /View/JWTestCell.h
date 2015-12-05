//
//  JWTestCell.h
//  JXT
//
//  Created by JWX on 15/8/12.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTestCell : UICollectionViewCell

- (void)cellWithIndexPath:(NSIndexPath *)indexPath;

@property(strong,nonatomic) NSString* str;

@end
