//
//  const.h
//  JXT
//
//  Created by 1039soft on 15/9/25.
//  Copyright (c) 2015年 JW. All rights reserved.
//
#pragma mark 灯光
/**打开灯光通知 */
static NSString* const OpenLightNotification = @"OpenLightNotification";

/**播放声音要说的话 */

//灯光操作
static NSString* const LightTitle  = @"下面将进行模拟夜间行驶场景灯光使用的考试，请按语音指令在5秒内做出相应的灯光操作。";
static NSString* const LightVoice1 = @"夜间在没有路灯、照明不良条件下行驶。";
static NSString* const LightVoice2 = @"请将前照灯变换成远光";
static NSString* const LightVoice3 = @"夜间在窄路与非机动车会车";
static NSString* const LightVoice4 = @"夜间同方向近距离跟车行驶";
static NSString* const LightVoice5 = @"夜间在道路上发生故障妨碍交通又难以移动";
static NSString* const LightVoice5_2= @"雾天行驶";
static NSString* const LightVoice5_3= @"夜间通过拱桥、人行横道";
static NSString* const LightVoice5_4= @"夜间经过急弯、坡路";
static NSString* const LightVoice5_5= @"夜间通过没有交通信号灯控制的路口";
static NSString* const LightVoice5_6= @"夜间超越前方车辆";
static NSString* const LightVoice6 = @"模拟夜间考试完成，请关闭所有灯光";
#pragma  mark  语音模拟
//语音模拟
static NSString* const Sound1 = @"绕车一周检查车辆外观及安全状况，打开车门前观察后方交通情况，上车后请系好安全带，调整座位、次镜、后视镜，打开聚光灯，并关闭警示灯。";
static NSString* const Sound2 = @"请起步继续完成考试";
static NSString* const Sound3 = @"前方路口直行";
static NSString* const Sound4 = @"前方请变更车道";
static NSString* const Sound5 = @"通过公共汽车站";
static NSString* const Sound6 = @"通过学校区域";
/**需要间隔10秒(请结束直线行驶)*/
static NSString* const Sound7 = @"前方进入直线行驶路段，请保持时速在35公里左右";
static NSString* const Sound7_2 =@"请结束直线行驶。";
static NSString* const Sound8 = @"前方路口左转";
static NSString* const Sound9 = @"前方路口右转";
static NSString* const Sound10 = @"请进行加减挡位操作";
static NSString* const Sound11 = @"与机动车会车";
static NSString* const Sound12 = @"请超越前方车辆";
static NSString* const Sound13 = @"请减速慢行";
/**需要间隔10秒(离开最低限速路段)*/
static NSString* const Sound14 = @"前方路段最低限速40公里每小时";
static NSString* const Sound14_2 = @"离开最低限速路段。";
static NSString* const Sound15 = @"前方人行横道";
/**需要间隔10秒(行人已通过)*/
static NSString* const Sound16 = @"前方人行横道有行人通过";
static NSString* const Sound16_2 =@"行人已通过。";
static NSString* const Sound17 = @"前方隧道";
static NSString* const Sound18 = @"前方请选择合适地点掉头";
static NSString* const Sound19 = @"请靠边停车";
