//
//  JWProfileModel.h
//  JXT
//
//  Created by 1039soft on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
// 学员信息类

#import <Foundation/Foundation.h>

@interface JWProfileModel : NSObject
@property (nonatomic,assign)BOOL issuccess;                     //是否成功
@property (nonatomic,copy)NSString *statecode;                  // 状态码 ???
@property (nonatomic,copy)NSString *stateinfo;                  //  状态信息 ???
//person
@property (nonatomic,copy)NSString *per_id;                     //用户ID
@property (nonatomic,copy)NSString *per_idcardno;               //用户身份证号
@property (nonatomic,copy)NSString *per_name;                   //用户名
@property (nonatomic,copy)NSString *per_password;               //用户密码
@property (nonatomic,copy)NSString *productname;                //驾照类别名称
@property (nonatomic,copy)NSString *train_learnid;              //培训学号  ???
@property (nonatomic,copy)NSString *part_registrationdate;      //注册日期
@property (nonatomic,copy)NSString *per_mobile;                 //用户手机号码
@property (nonatomic,copy)NSString *per_e_mail;                 //用户邮箱地址
@property (nonatomic,copy)NSString *train_totalhours;           //培训的总时长
@property (nonatomic,copy)NSString *per_sex;                    //学员性别
@property (nonatomic,copy)NSString *per_photo;                  //学员照片
//out_result
@property (nonatomic,assign)BOOL out_isweiyue;                  //是否为weiyue   ???
@property (nonatomic,copy)NSString *out_ddate;                  // ???
@property (nonatomic,copy)NSString *out_bushi;                  // ???
@property (nonatomic,copy)NSString *out_shengyu;                //剩余学时
@property (nonatomic,copy)NSString *out_zongshi;                //学时总时长
@property (nonatomic,copy)NSString *yixueshi;                   //   ???

@end
