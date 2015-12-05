//
//  JWLoginModel.h
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWLoginModel : NSObject
@property (nonatomic,copy)NSString *issuccess;                         //是否成功
@property (nonatomic,copy)NSString *statecode;                      //状态识别码
@property (nonatomic,copy)NSString *stateinfo;                      //状态信息
@property (nonatomic,copy)NSString *stuID;                          //学员ID
@property (nonatomic,copy)NSString *per_id;                         // 学员编号
@property (nonatomic,copy)NSString *per_name;                       // 学员姓名
@property (nonatomic,copy)NSString *per_sex;                        // 学员性别
@property (nonatomic,copy)NSString *per_national;                   //民族
@property (nonatomic,copy)NSString *per_remark;                     // 评论???
@property (nonatomic,copy)NSString *per_namecode;                   //姓名编码
@property (nonatomic,copy)NSString *per_birthday;                   // 学员生日
@property (nonatomic,copy)NSString *per_photopath;                  //照片路径
@property (nonatomic,copy)NSString *per_postcode;                   //邮编
@property (nonatomic,copy)NSString *per_phone;                      //学员电话
@property (nonatomic,copy)NSString *per_mobile;                     //学员手机
@property (nonatomic,copy)NSString *per_e_mail;                     //电子邮箱
@property (nonatomic,copy)NSString *per_receivedcard;               //学员卡
@property (nonatomic,copy)NSString *per_password;                   //密码
@property (nonatomic,copy)NSString *per_idcard;                     //居民身份证
@property (nonatomic,copy)NSString *per_idcardno;                   //身份证号
@property (nonatomic,copy)NSString *per_nationality;                // 国家
@property (nonatomic,copy)NSString *per_homeaddress;                //家庭地址
@property (nonatomic,copy)NSString *per_address;                    //地址
@property (nonatomic,copy)NSString *per_homeareaid;                 //家庭区域
@property (nonatomic,copy)NSString *per_addressareaid;              //地址区域
@property (nonatomic,copy)NSString *per_feptletelanleee;            // ???
@property (nonatomic,copy)NSString *per_firstcarddate;              //办卡日期
@property (nonatomic,copy)NSString *per_historydriverlicence;       // 已有驾照
@property (nonatomic,copy)NSString *per_recordcode;                 //
@property (nonatomic,copy)NSString *per_ic;                         //
@property (nonatomic,copy)NSString *price_id;                       //
@property (nonatomic,copy)NSString *part_trainmodel;                // 训练模型 ???
@property (nonatomic,copy)NSString *part_licensetype;               // 驾照类型
@property (nonatomic,copy)NSString *part_source;                    // 班级类别
@property (nonatomic,copy)NSString *part_waitaddress;               // 等待地址
@property (nonatomic,copy)NSString *part_registrationdate;          // 注册日期
@property (nonatomic,copy)NSString *part_archivedate;               //  存档日期
@property (nonatomic,copy)NSString *part_schoolareaid;              // 学校区域ID

@property (nonatomic,copy)NSString *train_yxdays;                   // 已学天数
@property (nonatomic,copy)NSString *train_learnid;                  // 训练学号
@property (nonatomic,copy)NSString *train_traincode;                //训练编号
@property (nonatomic,copy)NSString *train_yuehours;                 //预约时长
@property (nonatomic,copy)NSString *train_learndhours;              //训练时长
@property (nonatomic,copy)NSString *train_ledgervolume;             // 分类科目
@property (nonatomic,copy)NSString *train_totalhours;               //总时长
@property (nonatomic,copy)NSString *train_ledgeryear;               //
@property (nonatomic,copy)NSString *train_losthours;                //失去时长 ？？？
@property (nonatomic,copy)NSString *train_addedhours;               // 添加时长
@property (nonatomic,copy)NSString *train_learndhourstemp;          // 已学时长
@property (nonatomic,copy)NSString *train_graduationdate;           // 毕业日期
@property (nonatomic,copy)NSString *train_model_id;                 //
@property (nonatomic,copy)NSString *train_classno;                  // 班级编号
@property (nonatomic,copy)NSString *state;                          // 状态
@property (nonatomic,copy)NSString *division_id;//
@property (nonatomic,copy)NSString *per_photo;//
@property (nonatomic,copy)NSString *rein_id;//
@property (nonatomic,copy)NSString *per_job;//
@property (nonatomic,copy)NSString *per_englishname;//
@property (nonatomic,copy)NSString *self_c1;//
@property (nonatomic,copy)NSString *self_c2;//
@property (nonatomic,copy)NSString *self_c3;//
@property (nonatomic,copy)NSString *self_c4;//
@property (nonatomic,copy)NSString *self_c5;//
@property (nonatomic,copy)NSString *self_d1;//
@property (nonatomic,copy)NSString *self_d2;//
@property (nonatomic,copy)NSString *self_d3;//
@property (nonatomic,copy)NSString *jx_code;//
@property (nonatomic,copy)NSString *price_id2;//
@property (nonatomic,copy)NSString *price_id3;//
@property (nonatomic,copy)NSString *train_cpxs;//
@property (nonatomic,copy)NSString *per_finger;//
@property (nonatomic,copy)NSString *per_fingerimage;//
@property (nonatomic,copy)NSString *part_source2;//
@property (nonatomic,copy)NSString *part_source3;//
@property (nonatomic,copy)NSString *per_tmcode;//
@property (nonatomic,copy)NSString *price_list;//
@property (nonatomic,copy)NSString *price_listname;//
@property (nonatomic,copy)NSString *self_c6;//
@property (nonatomic,copy)NSString *self_c7;//
@property (nonatomic,copy)NSString *self_c8;//
@property (nonatomic,copy)NSString *yingfu;//
@property (nonatomic,copy)NSString *koukuan;//
@property (nonatomic,copy)NSString *remark;//
@property (nonatomic,copy)NSString *km1pm;//
@property (nonatomic,copy)NSString *km2pm;//
@property (nonatomic,copy)NSString *km3pm;//
@property (nonatomic,copy)NSString *photoexportmark;//
@end
