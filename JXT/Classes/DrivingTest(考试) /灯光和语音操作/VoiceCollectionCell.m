//
//  VoiceCollectionCell.m
//  JXT
//
//  Created by 1039soft on 15/9/24.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "VoiceCollectionCell.h"
#import "const.h"
@interface VoiceCollectionCell()
@property (weak, nonatomic) IBOutlet ExamButton *VoiceButton;
@property (weak, nonatomic) IBOutlet ExamButton *infoButton;
@end
@implementation VoiceCollectionCell

-(void)setButtonWithCellNum:(NSNumber *)num
{
    NSInteger tempnum =  num.integerValue+1;
    NSNumber* num2 = [NSNumber numberWithInteger:tempnum];
    NSString* temp = [NSString stringWithFormat:@"灯光%@",num2];
   
    [_infoButton setTitle:temp forState:UIControlStateNormal];
    [_infoButton setImage:[UIImage imageNamed:@"灯光"] forState:UIControlStateNormal];
    [_infoButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)VoiceSetButtonWithCellNum:(NSNumber *)num
{
    switch (num.intValue) {
        case 0:
        {
            [_VoiceButton setTitle:@"考前准备" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"考前准备"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case 1:
        {
            [_VoiceButton setTitle:@"起步" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"起步"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
       case 2:
        {
            [_VoiceButton setTitle:@"路口直行" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"路口直行"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case 3:
        {
            [_VoiceButton setTitle:@"变更车道" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"变更车道"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 4:
        {
            [_VoiceButton setTitle:@"公共汽车站" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"公共汽车站"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 5:
        {
            [_VoiceButton setTitle:@"学校" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"学校"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 6:
        {
            [_VoiceButton setTitle:@"直线行驶" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"直线行驶"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 7:
        {
            [_VoiceButton setTitle:@"左转" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"左转"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 8:
        {
            [_VoiceButton setTitle:@"右转" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"右转"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 9:
        {
            [_VoiceButton setTitle:@"加减档" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"加减档"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 10:
        {
            [_VoiceButton setTitle:@"会车" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"会车"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 11:
        {
            [_VoiceButton setTitle:@"超车" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"超车"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 12:
        {
            [_VoiceButton setTitle:@"减速" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"减速"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 13:
        {
            [_VoiceButton setTitle:@"限速" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"限速"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 14:
        {
            [_VoiceButton setTitle:@"人行横道" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"人行横道"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 15:
        {
            [_VoiceButton setTitle:@"有行人通过" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"有行人通过"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 16:
        {
            [_VoiceButton setTitle:@"隧道" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"隧道"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 17:
        {
            [_VoiceButton setTitle:@"掉头" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"掉头"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
            case 18:
        {
            [_VoiceButton setTitle:@"靠边停车" forState:UIControlStateNormal];
            [_VoiceButton setImage:[UIImage imageNamed:@"靠边停车"] forState:UIControlStateNormal];
            [_VoiceButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            break;
    }
}
-(void)openLight:(UIButton*)sender
{
    [sender setImage:[UIImage imageNamed:@"播放声音"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:OpenLightNotification object:sender.titleLabel.text userInfo:@{@"imageName":@"播放声音"}];
}
@end
