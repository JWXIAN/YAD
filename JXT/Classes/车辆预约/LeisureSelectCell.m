//
//  LeisureSelectCell.m
//  JXT
//
//  Created by 1039soft on 15/10/10.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "LeisureSelectCell.h"
#import "Bespoke_verify.h"
@interface LeisureSelectCell()
@property (weak, nonatomic) IBOutlet UILabel *teacherName;//教师姓名
@property (weak, nonatomic) IBOutlet UILabel *carCode;//车牌号
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property(strong,nonatomic) LeisureModel* leisure;//模型数组

@end
@implementation LeisureSelectCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setCellWithModel:(LeisureModel*)model
{
    if (model!=nil) {
        _teacherName.text=model.teachername;
        _carCode.text=model.carcode;
        _time.text=[NSString stringWithFormat:@"%@ %@",model.pxdate,model.tinfo];
        _leisure=model;
    }
    
}
- (IBAction)bespeakButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeisureSelect" object:_leisure];
}


@end
