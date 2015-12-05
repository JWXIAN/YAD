//
//  LightDetailCell.h
//  JXT
//
//  Created by 1039soft on 15/9/25.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightDetailCell : UITableViewCell
-(void)setDetailCellWithIndexPathRow:(NSInteger)indexpathRow andData:(NSArray* )arr;
@property (weak, nonatomic) IBOutlet UILabel *detail;//详解
@end
