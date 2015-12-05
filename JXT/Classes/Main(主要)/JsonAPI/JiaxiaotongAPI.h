//
//  JiaxiaotongAPI.h
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/17.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void  (^MyCallback)(id obj);

@interface JiaxiaotongAPI : NSObject
//获取用户信息
+(void)requestUserInfoByUserID:(NSString *)userID view:(id)view andCallback:(MyCallback)callback;
//驾校列表
+(void)requestDriveByDriveID:(NSString *)driveID andCallback:(MyCallback)callback;
////教练信息
//+(void)requsetDriTeacherInfoByDriTeaInfo:(NSString *)driTeacherInfo andCallback:(MyCallback)callback;
//教练列表
+(void)requestDriTeacherListByDriTeacherList:(NSString *)driTeacherList view:(id)view andCallback:(MyCallback)callback;
//学员登陆
+(void)requsetStuLoginByStuLogin:(NSString *)stuLogin andCallback:(MyCallback)callback;
//学生考试进度
+(void)requestStuExamScheduleByStuExamSchedule:(NSString *)stuExamSchedule andCallback:(MyCallback)callback;
//查询上车认证记录
+(void)requestBookRecordByBookRecordRZ:(NSString *)bookRecord andCallback:(MyCallback)callback;
//查询预约记录
+(void)requestBookRecordByBookRecord:(NSString *)bookRecord andCallback:(MyCallback)callback;
//查询退约记录
+(void)requestBookRecordByBookRecordTY:(NSString *)bookRecord andCallback:(MyCallback)callback;
//查询培训记录
+(void)requestBookRecordByBookRecordPX:(NSString *)bookRecord andCallback:(MyCallback)callback;
//分享
+(void)requestShareByShare:(NSString *)share andCallback:(MyCallback)callback;
////保存预约信息
//+(void)requestSaveBookRecordBySaveBookRecord:(NSString *)saveBookRecord andCallback:(MyCallback)callback;
//添加投诉
+(void)requestAddComplaintByAddComplaint:(NSString *)addComplaint andCallback:(MyCallback)callback;
////投诉列表
//+(void)requestComplaintListByComplaintList:(NSString *)complaintlist andCallback:(MyCallback)callback;
//教练可约时段
+(void)requestTeacherTimeByTeacherTime:(NSString *)teacherTime view:(id)view andCallback:(MyCallback)callback;
//教练可约日期
//+(void)requestTeacherPeriodDateByComplaintList:(NSDictionary *)teacherPeriodDate andCallback:(MyCallback)callback;
//学员考试明细
+(void)requsetStudentExamContentByStudentExamContent:(NSString *)studentExamContent andCallback:(MyCallback)callback;
//官方公告
+(void)requestOfficialAnnounceByOfficialAnnounce:(NSString *)officialAnnounce andCallback:(MyCallback)callback;
//修改密码
+(void)requestChangedPasswordByChangedPassword:(NSDictionary *)changedEPassword andCallback:(MyCallback)callback;
//修改手机号码
+(void)requsetChangedPhoneNumByChangedPhoneNum:(NSString *)changePhoneNum andCallback:(MyCallback)callback;
////获取联动时段列表
+(void)requestDynamicPeriodListByDynamicPeriodList:(NSString *)dynamicPeriodList view:(id)view andCallback:(MyCallback)callback;


@end
