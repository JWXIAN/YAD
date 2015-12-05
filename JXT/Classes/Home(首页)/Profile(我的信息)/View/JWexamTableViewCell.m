//
//  JWexamTableView_m
//  JXT
//
//  Created by 1039soft on 15/6/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWexamTableViewCell.h"

@implementation JWexamTableViewCell

- (void)awakeFromNib {
    
    
}
-(void) cellInfo:(StuExamInfo* )exam
{
    _kemu.text=exam.examName;
    _didian.text=exam.examAddress;
    _shijian.text=exam.examDate;
    if ([exam.examResult isEqualToString:@"1"]) {
        _jieguo.text=@"通过";
        //        _jieguo.tintColor=[UIColor blueColor];
    }
    else
    {
        _jieguo.text=@"未通过";
        _jieguo.textColor=[UIColor redColor];
        
    }
    for (id obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label=obj;
            label.font=[UIFont fontWithName:@"HelveticaNeue" size:label.frame.size.height*0.7];
        }
        
    }
}

@end
