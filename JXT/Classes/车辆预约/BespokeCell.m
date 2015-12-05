//
//  BespokeCell.m
//  JXT
//
//  Created by 1039soft on 15/7/30.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "BespokeCell.h"
@interface BespokeCell()
@property (weak, nonatomic) IBOutlet UILabel *theDay;//日期
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;//天气图标
@property (weak, nonatomic) IBOutlet UILabel *theTime;

@end
@implementation BespokeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

- (void)awakeFromNib {


}
-(void)setCellWithTimeInfo:(NSArray* )timeS andWeather:(NSArray *)weatherArr
{
  
    _theDay.text=timeS[0];
    _theTime.text=timeS[1];
    NSInteger okDay=0;
    if (weatherArr==nil) {
        _weatherImage.image=[UIImage imageNamed:@"999"];
        
    }
    else
    {
        for (NSDictionary* weDic in weatherArr) {
            NSDictionary* cond= weDic[@"cond"];
            NSString* date = weDic[@"date"];
            NSArray* stArr = [_theDay.text componentsSeparatedByString:@"-"];
            NSString* st;
            if ([stArr[2] integerValue]>=10) {
                st=timeS[0];
            }
          else
          {
              st= [NSString stringWithFormat:@"%@-%@-0%@",stArr[0],stArr[1],stArr[2]];
          }
           
            if ([date isEqualToString:st])
            {
                 _weatherImage.image=[UIImage imageNamed:cond[@"code_d"]];
                okDay=1;
            }
        }
        if (okDay==0) {
            _weatherImage.image=[UIImage imageNamed:@"999"];
        }
       
    }
   
    
}
- (IBAction)verify:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"verify" object:nil userInfo:@{@"tag":[NSString stringWithFormat:@"%ld",(long)sender.tag]}];
}



@end
