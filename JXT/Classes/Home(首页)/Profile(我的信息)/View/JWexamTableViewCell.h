//
//  JWexamTableViewCell.h
//  JXT
//
//  Created by 1039soft on 15/6/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuExamInfo.h"
@interface JWexamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kemu;
@property (weak, nonatomic) IBOutlet UILabel *didian;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
@property (weak, nonatomic) IBOutlet UILabel *jieguo;
-(void) cellInfo:(StuExamInfo* )exam;
@end
