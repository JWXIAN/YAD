//
//  JWTrainBodyModel.h
//  JXT
//
//  Created by JWX on 15/8/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWTrainBodyModel : NSObject

@property (nonatomic,copy)NSString *per_name;       //学员姓名
@property (nonatomic,copy)NSString *id;          //学员ID
@property (nonatomic,copy)NSString *ddate;          //预约日期
@property (nonatomic,copy)NSString *period;         //学时
@property (nonatomic,copy)NSString *t_info;         //预约时断
@property (nonatomic,copy)NSString *type;           //驾考类型
@property (nonatomic,copy)NSString *yyfs;           //预约方式
@property (nonatomic,copy)NSString *carcode;        //教练车编号
@property (nonatomic,copy)NSString *teacher;        //教练姓名
@property (nonatomic,copy)NSString *status;         //状态
@property (nonatomic,copy)NSString *tuiyuetime;     //退约时间
@property (nonatomic,copy)NSString *t_yn;           //是否可以退约
@property (nonatomic,copy)NSString *jspy;           //评价
@property (nonatomic,copy)NSString *pjzt;           //评价状态

//id = 30;
//period = E;
//ddate = 2015-07-11;
//t_yn = 0;
//jspy = 本节课学的还不错，就是上课不要再打瞌睡了，会影响到门口小卖部家的邻居，因为他们家好久没有上街买东西了！;
//tuiyuetime = 2000-01-01;
//type = 科二驾驶;
//pjzt = 未评价;
//per_name = 梁小浩;
//t_info = 08:00-08:50;
//carcode = 0181;
//teacher = 陈献文;
//yyfs = app预约;
//status = 培训;
@end
