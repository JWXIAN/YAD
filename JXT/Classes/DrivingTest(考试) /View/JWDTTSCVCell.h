//
//  JWDTTSCVCell.h
//  JXT
//
//  Created by JWX on 15/8/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWDTTSCVCell : UICollectionViewCell
- (IBAction)btnTSSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTS;
//获取cell indexPath
//- (void)cellWithIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) NSMutableArray *tsArr;

//@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@end
