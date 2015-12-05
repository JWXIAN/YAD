//
//  JWVenicleBodyModel.h
//  JXT
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWVenicleBodyModel : NSObject

@property (nonatomic,copy)NSString *DriTeacherID;       //???
@property (nonatomic,copy)NSString *code;               // 教师编号
@property (nonatomic,copy)NSString *name;               //教练姓名
@property (nonatomic,copy)NSString *sex;                //教练性别
@property (nonatomic,copy)NSString *mobile;             //教练手机号码
@property (nonatomic,copy)NSString *type_name;          //课程名称
@property (nonatomic,copy)NSString *type;               //课程代码
@property (nonatomic,copy)NSString *carcode;            //车号
@property (nonatomic,copy)NSString *tcx;                // 驾照类型
@property (nonatomic,copy)NSString *photo;              //照片
@property (nonatomic,copy)NSString *score;              //得分
@property (nonatomic,copy)NSString *orders;             //???
@property (nonatomic,copy)NSString *biaoqian;           //标签
@property (nonatomic,copy)NSString *pingfen;            // 学生评分
@property (nonatomic,copy)NSString *yyxs;               //???
@property (nonatomic,copy)NSString *zxs;                //???
@property (nonatomic,copy)NSString *subaccountsid;      //账号???
@property (nonatomic,copy)NSString *subtoken;           //token
@property (nonatomic,copy)NSString *voipaccount;        //IP网络传送话音账号
@property (nonatomic,copy)NSString *voippwd;            //IP网络传送话音密码
@property (nonatomic,copy)NSString *period;            //索引

@property(strong,nonatomic) NSString*  jingdu;//经度
@property(strong,nonatomic) NSString* weidu;//纬度

@end
