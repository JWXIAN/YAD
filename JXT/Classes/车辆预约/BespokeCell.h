//
//  BespokeCell.h
//  JXT
//
//  Created by 1039soft on 15/7/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BespokeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bespoke;
-(void)setCellWithTimeInfo:(NSArray* )timeS andWeather:(NSArray* )weatherArr;
@end
