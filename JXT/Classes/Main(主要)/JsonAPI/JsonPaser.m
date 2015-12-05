//
//  JsonPaser.m
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/17.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "JsonPaser.h"
#import "JWDriveBodyModel.h"
#import "JWDriveHeadModel.h"
#import "MBProgressHUD+MJ.h"
#import "JWLoginModel.h"
#import "JWRecordHeadModel.h"
#import "JWRecordBodyModel.h"
#import "JWNoticeModel.h"
#import "JWProfileModel.h"
#import "JWExamScheduleInfo.h"
#import "StudentExamContent.h"
#import "StuExamInfo.h"
#import "AddComplaint.h"
#import "ChangePhoneNum.h"
#import "ChangePassword.h"
#import "Share.h"
#import "JWTYModel.h"
#import "JWEvaluateModel.h"
#import "JWVenicleHeadModel.h"
#import "JWVenicleBodyModel.h"
#import "TeacherTime.h"
#import "TePeriodListInfo.h"
#import "DynamicPeriodList.h"
#import "PeriodListContent.h"
@implementation JsonPaser
#pragma mark 学员信息
+(JWProfileModel *)parserUserInfoByDictionary:(NSDictionary *)dic{
   
    JWProfileModel *stu = [[JWProfileModel alloc]init];
    
    NSDictionary *head = [dic objectForKey:@"head"];

    stu.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    stu.statecode = [head objectForKey:@"statecode"];
    stu.stateinfo = [head objectForKey:@"stateinfo"];
    
    NSDictionary *body = [dic objectForKey:@"body"];
    NSDictionary *person = [body objectForKey:@"person"];
    stu.part_registrationdate = [person objectForKey:@"part_registrationdate"];
    stu.per_e_mail = [person objectForKey:@"per_e_mail"];
    stu.per_id = [person objectForKey:@"per_id"];
    stu.per_idcardno = [person objectForKey:@"per_idcardno"];
    stu.per_mobile = [person objectForKey:@"per_mobile"];
    stu.per_name = [person objectForKey:@"per_name"];
    stu.per_password = [person objectForKey:@"per_password"];
    stu.per_photo = [person objectForKey:@"per_photo"];
    stu.per_sex = [person objectForKey:@"per_sex"];
    
    NSDictionary *out_result = [body objectForKey:@"out_result"];
    stu.out_bushi = [out_result objectForKey:@"out_bushi"];
    stu.out_ddate = [out_result objectForKey:@"out_ddate"];
    stu.out_isweiyue = [[out_result objectForKey:@"out_isweiyue"] boolValue];
    stu.out_shengyu = [out_result objectForKey:@"out_shengyu"];
    stu.out_zongshi = [out_result objectForKey:@"out_zongshi"];
    stu.yixueshi = [out_result objectForKey:@"out_yixueshi"];
    return stu;
}
/**驾校列表*/
+(JWDriveHeadModel *)parserDriveInfoByDictionary:(NSDictionary *)dic{
    JWDriveHeadModel *drive = [[JWDriveHeadModel alloc]init];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    drive.issuccess = [head objectForKey:@"issuccess"];
    drive.statecode = [head objectForKey:@"statecode"];
    drive.stateinfo = [head objectForKey:@"stateinfo"];
    if ([drive.statecode isEqualToString:@"2000"]) {
        NSArray *dataArr = [dic objectForKey:@"body"];
        
        drive.driveHeads = [NSMutableArray array];
        for (NSDictionary *driveDic in dataArr) {
            JWDriveBodyModel *driveData = [[JWDriveBodyModel alloc]init];
            driveData.driveID = [driveDic objectForKey:@"id"];
            driveData.qyid = [driveDic objectForKey:@"qyid"];
            driveData.qyname = [driveDic objectForKey:@"qyname"];
            driveData.begindate = [driveDic objectForKey:@"begindate"];
            driveData.enddate = [driveDic objectForKey:@"enddate"];
            driveData.shengfen = [driveDic objectForKey:@"shengfen"];
            driveData.shiqu = [driveDic objectForKey:@"shiqu"];
            driveData.connstring = [driveDic objectForKey:@"connstring"];
            driveData.state = [driveDic objectForKey:@"state"];
            driveData.nid = [driveDic objectForKey:@"nid"];
            driveData.qytype = [driveDic objectForKey:@"qytype"];
            [drive.driveHeads addObject:driveData];
        }

    }
        return drive;
}
//+(DriTeacherInfo *)parserDriTeacherInfoByDictionary:(NSDictionary *)dic{
//    DriTeacherInfo *driTeacherInfo = [[DriTeacherInfo alloc]init];
//    NSDictionary *head = [dic objectForKey:@"head"];
//    driTeacherInfo.issuccess = [head objectForKey:@"issuccess"];
//    driTeacherInfo.statecode = [head objectForKey:@"statecode"];
//    driTeacherInfo.stateinfo = [head objectForKey:@"stateinfo"];
//    NSDictionary *body = [dic objectForKey:@"body"];
//    driTeacherInfo.teacherID = [body objectForKey:@"id"];
//    driTeacherInfo.code = [body objectForKey:@"code"];
//    driTeacherInfo.name = [body objectForKey:@"name"];
//    driTeacherInfo.sex = [body objectForKey:@"sex"];
//    driTeacherInfo.mobile = [body objectForKey:@"mobile"];
//    driTeacherInfo.type_name = [body objectForKey:@"type_name"];
//    driTeacherInfo.type = [body objectForKey:@"type"];
//    driTeacherInfo.carcode = [body objectForKey:@"carcode"];
//    driTeacherInfo.tcx = [body objectForKey:@"tcx"];
//    driTeacherInfo.photo = [body objectForKey:@"photo"];
//    return driTeacherInfo;
//}
/**退约*/
+(JWTYModel *)jsonTY:(NSDictionary *)dic{
    
    JWTYModel *ty = [[JWTYModel alloc]init];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    ty.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    ty.statecode = [head objectForKey:@"statecode"];
    ty.stateinfo = [head objectForKey:@"stateinfo"];
    
    NSDictionary *body = [dic objectForKey:@"body"];
    ty.result = [body objectForKey:@"result"];
    return ty;
}
/**评价*/
+(JWEvaluateModel *)jsonPJ:(NSDictionary *)dic{
    JWEvaluateModel *ev = [[JWEvaluateModel alloc]init];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    ev.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    ev.statecode = [head objectForKey:@"statecode"];
    ev.stateinfo = [head objectForKey:@"stateinfo"];
    
    NSDictionary *body = [dic objectForKey:@"body"];
    ev.result = [body objectForKey:@"result"];
    return ev;
}
//学员登陆
+(JWLoginModel *)parserStuLoginByDictionary:(NSDictionary *)dic{
    JWLoginModel *stuLogin = [[JWLoginModel alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];
        stuLogin.issuccess = [head objectForKey:@"issuccess"];
        stuLogin.statecode = [head objectForKey:@"statecode"];
        stuLogin.stateinfo = [head objectForKey:@"stateinfo"];
    NSDictionary *body = [dic objectForKey:@"body"];
        stuLogin.stuID = [body objectForKey:@"id"];
        stuLogin.per_id = [body objectForKey:@"per_id"];
        stuLogin.per_name = [body objectForKey:@"per_name"];
        stuLogin.per_sex = [body objectForKey:@"per_sex"];
        stuLogin.per_national = [body objectForKey:@"per_national"];
        stuLogin.per_remark = [body objectForKey:@"per_remark"];
        stuLogin.per_namecode = [body objectForKey:@"per_namecode"];
        stuLogin.per_birthday = [body objectForKey:@"per_birthday"];
        stuLogin.per_photopath = [body objectForKey:@"per_photopath"];
        stuLogin.per_postcode = [body objectForKey:@"per_postcode"];
        stuLogin.per_phone = [body objectForKey:@"per_phone"];
        stuLogin.per_mobile = [body objectForKey:@"per_mobile"];
        stuLogin.per_e_mail = [body objectForKey:@"per_e_mail"];
        stuLogin.per_receivedcard = [body objectForKey:@"per_receivedcard"];
        stuLogin.per_password = [body objectForKey:@"per_password"];
        stuLogin.per_idcard = [body objectForKey:@"per_idcard"];
        stuLogin.per_idcardno = [body objectForKey:@"per_idcardno"];
        stuLogin.per_nationality = [body objectForKey:@"per_nationality"];
        stuLogin.per_homeaddress = [body objectForKey:@"per_homeaddress"];
        stuLogin.per_address = [body objectForKey:@"per_address"];
        stuLogin.per_homeareaid = [body objectForKey:@"per_homeareaid"];
        stuLogin.per_addressareaid = [body objectForKey:@"per_addressareaid"];
        stuLogin.per_feptletelanleee = [body objectForKey:@"per_feptletelanleee"];
        stuLogin.per_firstcarddate = [body objectForKey:@"per_firstcarddate"];
        stuLogin.per_historydriverlicence = [body objectForKey:@"per_historydriverlicence"];
        stuLogin.per_recordcode = [body objectForKey:@"per_recordcode"];
        stuLogin.per_ic = [body objectForKey:@"per_ic"];
        stuLogin.price_id = [body objectForKey:@"price_id"];
        stuLogin.part_trainmodel = [body objectForKey:@"part_trainmodel"];
        stuLogin.part_licensetype = [body objectForKey:@"part_licensetype"];
        stuLogin.part_source = [body objectForKey:@"part_source"];
        stuLogin.part_waitaddress = [body objectForKey:@"part_waitaddress"];
        stuLogin.part_registrationdate = [body objectForKey:@"part_registrationdate"];
        stuLogin.part_archivedate = [body objectForKey:@"part_archivedate"];
        stuLogin.part_schoolareaid = [body objectForKey:@"part_schoolareaid"];
        stuLogin.train_yxdays = [body objectForKey:@"train_yxdays"];
        stuLogin.train_learnid = [body objectForKey:@"train_learnid"];
        stuLogin.train_traincode = [body objectForKey:@"train_traincode"];
        stuLogin.train_yuehours = [body objectForKey:@"train_yuehours"];
        stuLogin.train_learndhours = [body objectForKey:@"train_learndhours"];
        stuLogin.train_ledgervolume = [body objectForKey:@"train_ledgervolume"];
        stuLogin.train_totalhours = [body objectForKey:@"train_totalhours"];
        stuLogin.train_ledgeryear = [body objectForKey:@"train_ledgeryear"];
        stuLogin.train_losthours = [body objectForKey:@"train_losthours"];
        stuLogin.train_addedhours = [body objectForKey:@"train_addedhours"];
        stuLogin.train_learndhourstemp = [body objectForKey:@"train_learndhourstemp"];
        stuLogin.train_graduationdate = [body objectForKey:@"train_graduationdate"];
        stuLogin.train_model_id = [body objectForKey:@"train_model_id"];
        stuLogin.train_classno = [body objectForKey:@"train_classno"];
        stuLogin.state = [body objectForKey:@"state"];
        stuLogin.division_id = [body objectForKey:@"division_id"];
        stuLogin.per_photo = [body objectForKey:@"per_photo"];
        stuLogin.rein_id = [body objectForKey:@"rein_id"];
        stuLogin.per_job = [body objectForKey:@"per_job"];
        stuLogin.per_englishname = [body objectForKey:@"per_englishname"];
        stuLogin.self_c1 = [body objectForKey:@"self_c1"];
        stuLogin.self_c2 = [body objectForKey:@"self_c2"];
        stuLogin.self_c3 = [body objectForKey:@"self_c3"];
        stuLogin.self_c4 = [body objectForKey:@"self_c4"];
        stuLogin.self_c5 = [body objectForKey:@"self_c5"];
        stuLogin.self_d1 = [body objectForKey:@"self_d1"];
        stuLogin.self_d2 = [body objectForKey:@"self_d2"];
        stuLogin.self_d3 = [body objectForKey:@"self_d3"];
        stuLogin.jx_code = [body objectForKey:@"jx_code"];
        stuLogin.price_id2 = [body objectForKey:@"price_id2"];
        stuLogin.price_id3 = [body objectForKey:@"price_id3"];
        stuLogin.train_cpxs = [body objectForKey:@"train_cpxs"];
        stuLogin.per_finger = [body objectForKey:@"per_finger"];
        stuLogin.per_fingerimage = [body objectForKey:@"per_fingerimage"];
        stuLogin.part_source2 = [body objectForKey:@"part_source2"];
        stuLogin.part_source3 = [body objectForKey:@"part_source3"];
        stuLogin.per_tmcode = [body objectForKey:@"per_tmcode"];
        stuLogin.price_list = [body objectForKey:@"price_list"];
        stuLogin.price_listname = [body objectForKey:@"price_listname"];
        stuLogin.self_c6 = [body objectForKey:@"self_c6"];
        stuLogin.self_c7 = [body objectForKey:@"self_c7"];
        stuLogin.self_c8 = [body objectForKey:@"self_c8"];
        stuLogin.yingfu = [body objectForKey:@"yingfu"];
        stuLogin.koukuan = [body objectForKey:@"koukuan"];
        stuLogin.remark = [body objectForKey:@"remark"];
        stuLogin.km1pm = [body objectForKey:@"km1pm"];
        stuLogin.km2pm = [body objectForKey:@"km2pm"];
        stuLogin.km3pm = [body objectForKey:@"km3pm"];
        stuLogin.photoexportmark = [body objectForKey:@"photoexportmark"];
    
    
    return stuLogin;
}

/**考试进度*/
+(JWExamScheduleInfo *)parserExamScheduleByDictionary:(NSDictionary *)dic{
   
        JWExamScheduleInfo *examScheduleInfo = [[JWExamScheduleInfo alloc]init];
    if ([dic[@"head"][@"statecode"] isEqualToString:@"2000"]) {
        NSArray *examScheduleArr = [dic objectForKey:@"body"];
        for (NSDictionary *examDic in examScheduleArr) {
           
            examScheduleInfo.tz_id = [examDic objectForKey:@"tz_id"];
            examScheduleInfo.tz_name = [examDic objectForKey:@"tz_name"];
        }

    }
          return examScheduleInfo;
}
//预约记录
+(JWRecordHeadModel *)parserBookRecordByDictionary:(NSDictionary *)dic{
    JWRecordHeadModel *bookRecord = [[JWRecordHeadModel alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];
    bookRecord.issuccess = [head objectForKey:@"issuccess"];
    bookRecord.statecode = [head objectForKey:@"statecode"];
    bookRecord.stateinfo = [head objectForKey:@"stateinfo"];
    if (![bookRecord.issuccess isEqualToString:@"false"]) {
        NSArray *recordArr = [dic objectForKey:@"body"];
        bookRecord.recordHeads = [NSMutableArray array];
        for (NSDictionary *recordDic in recordArr) {
            JWRecordBodyModel *recordInfo = [[JWRecordBodyModel alloc]init];
            recordInfo.per_name = [recordDic objectForKey:@"per_name"];
            recordInfo.id = [recordDic objectForKey:@"id"];
            recordInfo.ddate = [recordDic objectForKey:@"ddate"];
            recordInfo.period = [recordDic objectForKey:@"period"];
            recordInfo.t_info = [recordDic objectForKey:@"t_info"];
            recordInfo.type = [recordDic objectForKey:@"type"];
            recordInfo.yyfs = [recordDic objectForKey:@"yyfs"];
            recordInfo.carcode = [recordDic objectForKey:@"carcode"];
            recordInfo.teacher = [recordDic objectForKey:@"teacher"];
            recordInfo.status = [recordDic objectForKey:@"status"];
            recordInfo.tuiyuetime = [recordDic objectForKey:@"tuiyuetime"];
            recordInfo.t_yn = [recordDic objectForKey:@"t_yn"];
            recordInfo.jspy = [recordDic objectForKey:@"jspy"];
            recordInfo.pjzt = [recordDic objectForKey:@"pjzt"];
            [bookRecord.recordHeads addObject:recordInfo];
    }
    }
    return bookRecord;
}
//分享
+(Share *)parserShareByDictionary:(NSDictionary *)dic{
    Share *share = [[Share alloc]init];

    NSDictionary *head = [dic objectForKey:@"head"];
    share.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    share.statecode = [head objectForKey:@"statecode"];
    share.stateinfo = [head objectForKey:@"stateinfo"];
    
    NSDictionary *body = [dic objectForKey:@"body"];
    share.result = [body objectForKey:@"result"];
    return share;
}
////保存预约信息
//+(SaveBookRecord *)parserSaveBookRecordByDictionary:(NSDictionary *)dic{
//    SaveBookRecord *saveBookRecord = [[SaveBookRecord alloc]init];
//    NSDictionary *head = [dic objectForKey:@"head"];
//    saveBookRecord.issuccess = [head objectForKey:@"issuccess"];
//    saveBookRecord.statecode = [head objectForKey:@"statecode"];
//    saveBookRecord.stateinfo = [head objectForKey:@"stateinfo"];
//    NSDictionary *body = [dic objectForKey:@"body"];
//    saveBookRecord.result = [body objectForKey:@"result"];
//    return saveBookRecord;
//}
//添加投诉
+(AddComplaint *)parserAddComplaintByDictionary:(NSDictionary *)dic{
    AddComplaint *complaint = [[AddComplaint alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];
    complaint.issuccess = [head objectForKey:@"issuccess"];
    complaint.stateinfo = [head objectForKey:@"stateinfo"];
    complaint.statecode = [head objectForKey:@"statecode"];
    NSDictionary *body = [dic objectForKey:@"body"];
    complaint.result = [body objectForKey:@"result"];
    return complaint;
}
////学员投诉列表
//+(StuComplaintList *)parserStuComplaintListByDictionary:(NSDictionary *)dic{
//    StuComplaintList *complaintList = [[StuComplaintList alloc]init];
//    NSDictionary *head = [dic objectForKey:@"head"];
//    complaintList.issuccess = [head objectForKey:@"issuccess"];
//    complaintList.statecode = [head objectForKey:@"statecode"];
//    complaintList.stateinfo = [head objectForKey:@"stateinfo"];
//    NSArray *dataArr = [dic objectForKey:@"body"];
//    complaintList.complaintLists = [NSMutableArray array];
//    for (NSDictionary *listDic in dataArr) {
//        ComplaintListInfo *complaintListInfo = [[ComplaintListInfo alloc]init];
//        complaintListInfo.complaintID = [listDic objectForKey:@"id"];
//        complaintListInfo.addDate = [listDic objectForKey:@"tjdate"];
//        complaintListInfo.addContent = [listDic objectForKey:@"tjcontent"];
//        complaintListInfo.title = [listDic objectForKey:@"zhuti"];
//        complaintListInfo.recoverContent = [listDic objectForKey:@"recoverContent"];
//        [complaintList.complaintLists addObject:complaintListInfo];
//    }
//    return complaintList;
//}
//修改密码
+(ChangePassword *)parserChangePasswordByDictionary:(NSDictionary *)dic{
    ChangePassword *changePassword = [[ChangePassword alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];
    changePassword.issuccess = [head objectForKey:@"issuccess"];
    changePassword.statecode = [head objectForKey:@"statecode"];
    changePassword.stateinfo = [head objectForKey:@"stateinfo"];
    NSDictionary *body = [dic objectForKey:@"body"];
    changePassword.result = [body objectForKey:@"result"];
    return changePassword;
}

//修改手机号
+(ChangePhoneNum *)parserChangePhoneNumByDictionary:(NSDictionary *)dic{
    
    ChangePhoneNum *changePhoneNum = [[ChangePhoneNum alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];
    changePhoneNum.issuccess = [head objectForKey:@"issuccess"];
    changePhoneNum.statecode = [head objectForKey:@"statecode"];
    changePhoneNum.stateinfo = [head objectForKey:@"stateinfo"];
    NSDictionary *body = [dic objectForKey:@"body"];
    changePhoneNum.result = [body objectForKey:@"result"];
    return changePhoneNum;
    
}


//学员考试明细
+(StudentExamContent *)parserStudentExamContentByDictionary:(NSDictionary *)dic{
    StudentExamContent *studentExamContent = [[StudentExamContent alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];

    studentExamContent.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    studentExamContent.statecode = [head objectForKey:@"statecode"];
    studentExamContent.stateinfo = [head objectForKey:@"stateinfo"];
    
    if ([studentExamContent.statecode isEqualToString:@"2000"]) {
        NSArray *bodyArr = [dic objectForKey:@"body"];
        studentExamContent.stuExamContents = [NSMutableArray array];
        
        for (NSDictionary *bodyDic in bodyArr) {
            StuExamInfo *stuExamInfo = [[StuExamInfo alloc]init];
            stuExamInfo.examID = [bodyDic objectForKey:@"tz_id"];
            stuExamInfo.examName = [bodyDic objectForKey:@"tz_name"];
            stuExamInfo.examResult = [bodyDic objectForKey:@"ks_result"];
            stuExamInfo.examDate = [bodyDic objectForKey:@"ks_date"];
            stuExamInfo.examAddress = [bodyDic objectForKey:@"examAddress"];
            [studentExamContent.stuExamContents addObject:stuExamInfo];
            
            
        }

    }
    
    return studentExamContent;
}
//官方公告
+(JWNoticeModel *)parserOfficialAnnounceByDictionary:(NSDictionary *)dic{
    JWNoticeModel *notice = [[JWNoticeModel alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];

    notice.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    notice.statecode = [head objectForKey:@"statecode"];
    notice.stateinfo = [head objectForKey:@"stateinfo"];
    NSDictionary *body = [dic objectForKey:@"body"];
    notice.result = [body objectForKey:@"result"];
    return notice;
}
//教练可约时段
+(TeacherTime *)parserTeacherTimeByDictionary:(NSDictionary *)dic{
    TeacherTime *teacherTime = [[TeacherTime alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];

    teacherTime.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    teacherTime.statecode = [head objectForKey:@"statecode"];
    teacherTime.stateinfo = [head objectForKey:@"stateinfo"];
    if ([teacherTime.statecode isEqualToString:@"2000"]) {
        NSDictionary *body = [dic objectForKey:@"body"];
        NSArray *dataArr = [body objectForKey:@"teacherPeriodList"];
        teacherTime.teacherPeriodLists = [NSMutableArray array];
        for (NSDictionary *periodDic in dataArr) {
            TePeriodListInfo *tePeriodListInfo = [[TePeriodListInfo alloc]init];
            tePeriodListInfo.teacherPeriodID = [periodDic objectForKey:@"id"];
            tePeriodListInfo.bookDate = [periodDic objectForKey:@"yue_date"];
            tePeriodListInfo.period = [periodDic objectForKey:@"shiduan"];
            tePeriodListInfo.periodCode = [periodDic objectForKey:@"sdcode"];
            tePeriodListInfo.pxinfo = [periodDic objectForKey:@"pxinfo"];
            tePeriodListInfo.weekday = [periodDic objectForKey:@"dw"];
            [teacherTime.teacherPeriodLists addObject:tePeriodListInfo];
            
        }

    }
        return teacherTime;
}

//教练列表
+(JWVenicleHeadModel *)parserDriTeaListByDictionary:(NSDictionary *)dic{
    JWVenicleHeadModel *driTeachersList = [[JWVenicleHeadModel alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];

    driTeachersList.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    driTeachersList.statecode = [head objectForKey:@"statecode"];
    driTeachersList.stateinfo = [head objectForKey:@"stateinfo"];
    if ([driTeachersList.stateinfo isEqualToString:@"有数据"] ) {
        NSArray *TeacherDataLists = [dic objectForKey:@"body"];
        
        driTeachersList.driTeachersList = [NSMutableArray array];
        for (NSDictionary *driveDic in TeacherDataLists) {
            JWVenicleBodyModel *driTeaListInfo = [[JWVenicleBodyModel alloc]init];
            driTeaListInfo.DriTeacherID = [driveDic objectForKey:@"id"];
            driTeaListInfo.code = [driveDic objectForKey:@"code"];
            driTeaListInfo.name = [driveDic objectForKey:@"name"];
            driTeaListInfo.sex = [driveDic objectForKey:@"sex"];
            driTeaListInfo.mobile = [driveDic objectForKey:@"mobile"];
            driTeaListInfo.type_name = [driveDic objectForKey:@"type_name"];
            driTeaListInfo.type = [driveDic objectForKey:@"type"];
            driTeaListInfo.carcode = [driveDic objectForKey:@"carcode"];
            driTeaListInfo.tcx = [driveDic objectForKey:@"tcx"];
            driTeaListInfo.photo = [driveDic objectForKey:@"photo"];
            driTeaListInfo.score = [driveDic objectForKey:@"score"];
            driTeaListInfo.orders = [driveDic objectForKey:@"orders"];
            driTeaListInfo.biaoqian = [driveDic objectForKey:@"biaoqian"];
            driTeaListInfo.pingfen = [driveDic objectForKey:@"pingfen"];
            driTeaListInfo.yyxs = [driveDic objectForKey:@"yyxs"];
            driTeaListInfo.zxs = [driveDic objectForKey:@"zxs"];
            
            driTeaListInfo.subaccountsid = [driveDic objectForKey:@"subaccountsid"];
            driTeaListInfo.subtoken = [driveDic objectForKey:@"subtoken"];
            driTeaListInfo.voipaccount = [driveDic objectForKey:@"voipaccount"];
            driTeaListInfo.voippwd = [driveDic objectForKey:@"voippwd"];
            [driTeachersList.driTeachersList addObject:driTeaListInfo];
            
            driTeaListInfo.jingdu=driveDic[@"jingdu"];
            driTeaListInfo.weidu=driveDic[@"weidu"];
        }
        
    }
    
    return driTeachersList;
}

//联动时段列表
+(DynamicPeriodList *)parserDynamicPeriodListByDictionary:(NSDictionary *)dic{
    DynamicPeriodList *dynamicPeriodList = [[DynamicPeriodList alloc]init];
    NSDictionary *head = [dic objectForKey:@"head"];

    dynamicPeriodList.issuccess = [[head objectForKey:@"issuccess"] boolValue];
    dynamicPeriodList.statecode = [head objectForKey:@"statecode"];
    dynamicPeriodList.stateinfo = [head objectForKey:@"stateinfo"];
    NSArray *bodyArr = [dic objectForKey:@"body"];
    dynamicPeriodList.dynPeriodListContents = [NSMutableArray array];
    if ([dynamicPeriodList.stateinfo isEqualToString:@"有数据"]) {
        for (NSDictionary *contentDic in bodyArr) {
            PeriodListContent *periodListContent = [[PeriodListContent alloc]init];
            periodListContent.code = [contentDic objectForKey:@"code"];
            periodListContent.period = [contentDic objectForKey:@"t_info"];
            [dynamicPeriodList.dynPeriodListContents addObject:periodListContent];
        }
        
    }
    return dynamicPeriodList;
}








@end
