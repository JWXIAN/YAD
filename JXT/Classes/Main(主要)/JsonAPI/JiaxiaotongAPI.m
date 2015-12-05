
//
//  JiaxiaotongAPI.m
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/17.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import "JiaxiaotongAPI.h"
#import "AFNetworking.h"
#import "JsonPaser.h"
#import "JWDriveBodyModel.h"
#import "MBProgressHUD+MJ.h"
#import "JWLoginModel.h"
#import "JWDriveHeadModel.h"
#import "JWRecordHeadModel.h"
#import "PrefixHeader.pch"
#import "JWExamScheduleInfo.h"
#import "StudentExamContent.h"
#import "AddComplaint.h"
#import "ChangePassword.h"
#import "ChangePhoneNum.h"
#import "Share.h"
#import "MJRefresh.h"
#import "UserDefaultsKey.h"

@implementation JiaxiaotongAPI


//+(NSString *)getToken{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//}

#pragma mark 学员信息
+(void)requestUserInfoByUserID:(NSString *)userID view:(id)view andCallback:(MyCallback)callback{
//    
//    NSString *str = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx";
   
//    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryStudentInfo&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>00012</schoolId><accountId>130104198810121215</accountId><methodName>queryStudentInfo</methodName></MAP_TO_XML>";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString* uid=[ud objectForKey:@"per_idcardno"];//accountID
    NSString* drid=[ud objectForKey:@"drivecode"];//驾校id

    NSString *path =[NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryStudentInfo&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><accountId>%@</accountId><methodName>queryStudentInfo</methodName></MAP_TO_XML>",drid,uid];
   
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
//    NSLog(@"%@",path);
//    NSArray *fristArray =[path componentsSeparatedByString:@"methodName="];
//    NSString *secondStr = (NSString *)fristArray[0];
//    NSArray *secondArray = [secondStr componentsSeparatedByString:@"&"];
//    NSString *name = (NSString *)secondArray[0];
    
   // NSString *path =  @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryStudentInfo&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CschoolId%3E12345%3C/schoolId%3E%3CaccountId%3E130104198810121215%3C/accountId%3E%3CmethodName%3EqueryStudentInfo%3C/methodName%3E%3C/MAP_TO_XML%3E";
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manger GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        JWProfileModel *userInfo = [JsonPaser parserUserInfoByDictionary:dic];
        //保存用户信息模型
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserLoginSuccessInfo];
        
        callback(userInfo);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
}

//教练列表
+(void)requestDriTeacherListByDriTeacherList:(NSString *)driTeacherList view:(id)view  andCallback:(MyCallback)callback{
    // NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherList&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CpageN%3E0%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CschoolId%3E12345%3C/schoolId%3E%3CaccountId%3E0114080078%3C/accountId%3E%3CJLname%3E%E6%88%91%E7%9A%84%E6%95%99%E7%BB%83%3C/JLname%3E%3CmethodName%3EqueryTeacherList%3C/methodName%3E%3C/MAP_TO_XML%3E";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accountID =[ud objectForKey:@"accountID"];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
#warning 从哪取的？
//    NSString *teacherName = [ud objectForKey:@"teacherName"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherList&xmlStr=<\?xml version=\"1.0\" encoding=\"utf-8\"\?><MAP_TO_XML><pageN>0</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><accountId>%@</accountId><JLname>%@</JLname><methodName>queryTeacherList</methodName></MAP_TO_XML>",schoolID,accountID,driTeacherList];
    
    
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];

//    NSLog(@"%@",path);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [MBProgressHUD showError:@"加载数据失败"];
        UITableView* tab = view;
        [tab.header endRefreshing];

      
    }];
}
//驾校列表
+(void)requestDriveByDriveID:(NSString *)driveID andCallback:(MyCallback)callback{
    //NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=getSchoolList&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CpageN%3E11%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CjxName%3E%3C/jxName%3E%3Csheng%3E%3C/sheng%3E%3Cshiqu%3E%3C/shiqu%3E%3C/MAP_TO_XML%3E%27%20";
  
    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=getSchoolList&xmlStr=<\?xml version=\"1.0\" encoding=\"utf-8\"\?><MAP_TO_XML><pageN>11</pageN><pageNum>0</pageNum><jxName></jxName><sheng></sheng><shiqu></shiqu></MAP_TO_XML>";
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (dic != nil) {
            JWDriveHeadModel *drive = [JsonPaser parserDriveInfoByDictionary:dic];
            callback(drive);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
}
//学员登陆
+(void)requsetStuLoginByStuLogin:(NSString *)stuLogin andCallback:(MyCallback)callback{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *password = [ud objectForKey:@"password"];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=studentLogin&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><accountId>%@</accountId><passWord>%@</passWord><methodName>studentLogin</methodName></MAP_TO_XML>",schoolID,stuLogin,password];

    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
   
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWLoginModel *stuLogin = [JsonPaser parserStuLoginByDictionary:dic];
        callback(stuLogin);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
}

#pragma mark 考试进度
+(void)requestStuExamScheduleByStuExamSchedule:(NSString *)stuExamSchedule andCallback:(MyCallback)callback{

    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* schid=[user objectForKey:@"drivecode"];
   
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryExa_KaoShi_JinDu&SCHOOL_ID=%@&stu_id=%@",schid,stuExamSchedule];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWExamScheduleInfo *examSchedule = [JsonPaser parserExamScheduleByDictionary:dic];
        callback(examSchedule);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
}
//查询预约记录
+(void)requestBookRecordByBookRecord:(NSString *)bookRecord andCallback:(MyCallback)callback{
    // NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CpageN%3E3%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CschoolId%3E49267%3C/schoolId%3E%3ClearnID%3E0114040503%3C/learnID%3E%3Cstatus%3E%E9%A2%84%E7%BA%A6%3C/status%3E%3CmethodName%3EqueryYuyue%3C/methodName%3E%3C/MAP_TO_XML%3E";
    
    //    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>49264</schoolId><learnID>0114080078</learnID><status>预约</status><methodName>queryYuyue</methodName></MAP_TO_XML>";
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><learnID>%@</learnID><status>预约</status><methodName>queryYuyue</methodName></MAP_TO_XML>",school_id, per_id];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
        JWRecordHeadModel *bookRecord = [JsonPaser parserBookRecordByDictionary:dic];
        callback(bookRecord);
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
    
}

//查询退约记录
+(void)requestBookRecordByBookRecordTY:(NSString *)bookRecord andCallback:(MyCallback)callback{
    // NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CpageN%3E3%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CschoolId%3E49267%3C/schoolId%3E%3ClearnID%3E0114040503%3C/learnID%3E%3Cstatus%3E%E9%A2%84%E7%BA%A6%3C/status%3E%3CmethodName%3EqueryYuyue%3C/methodName%3E%3C/MAP_TO_XML%3E";
    
    //    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>49264</schoolId><learnID>0114080078</learnID><status>预约</status><methodName>queryYuyue</methodName></MAP_TO_XML>";
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><learnID>%@</learnID><status>取消</status><methodName>queryYuyue</methodName></MAP_TO_XML>",school_id, per_id];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

        JWRecordHeadModel *bookRecord = [JsonPaser parserBookRecordByDictionary:dic];
        callback(bookRecord);
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
    
}

//查询培训记录
+(void)requestBookRecordByBookRecordPX:(NSString *)bookRecord andCallback:(MyCallback)callback{
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryYuyue&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>3</pageN><pageNum>0</pageNum><schoolId>%@</schoolId><learnID>%@</learnID><status>培训</status><methodName>queryYuyue</methodName></MAP_TO_XML>",school_id, per_id];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//                JWLog(@"%@",dic);
        JWRecordHeadModel *bookRecord = [JsonPaser parserBookRecordByDictionary:dic];
        callback(bookRecord);
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
    
}

//查询上车认证记录
+(void)requestBookRecordByBookRecordRZ:(NSString *)bookRecord andCallback:(MyCallback)callback{
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString *school_id=[ud objectForKey:@"drivecode"];
    NSString *per_id=[ud objectForKey:@"train_learnid"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=shangcherenzheng&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><learnID>%@</learnID><methodName>shangcherenzheng</methodName></MAP_TO_XML>",school_id, per_id];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        JWLog(@"%@",dic);
        JWRecordHeadModel *bookRecord = [JsonPaser parserBookRecordByDictionary:dic];
        callback(bookRecord);
        [MBProgressHUD hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载数据失败"];
    }];
    
}
//分享
+(void)requestShareByShare:(NSString *)share andCallback:(MyCallback)callback{
    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=querySharecontent";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        Share *share = [JsonPaser parserShareByDictionary:dic];
        callback(share);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [MBProgressHUD showError:@"发送分享请求失败"];
    }];
}
//添加投诉
+(void)requestAddComplaintByAddComplaint:(NSString *)addComplaint andCallback:(MyCallback)callback{
  //  NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=insertTousu&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CschoolId%3E12345%3C/schoolId%3E%3Copername%3E%E5%BC%A0%E4%B8%89%3C/opername%3E%3Coperid%3E0107030001%3C/operid%3E%3Ctjtype%3E%E6%8A%95%E8%AF%89%3C/tjtype%3E%3Czhuti%3E%E6%95%99%E7%BB%83%E6%94%B6%E7%BA%A2%E5%8C%85%3C/zhuti%3E%3Ctjcontent%3E%E6%94%B6%E7%BA%A2%E5%8C%85%E7%9A%84%E6%95%99%E7%BB%83%E6%98%AF%E6%9D%8E%E5%9B%9B%EF%BC%8C%E6%80%81%E5%BA%A6%E8%9B%AE%E6%A8%AA%3C/tjcontent%3E%3CmethodName%3EinsertTousu%3C/methodName%3E%3C/MAP_TO_XML%3E";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *stuID = [ud objectForKey:@"per_id"];
    NSString *name = [ud objectForKey:@"per_name"];
    NSString* title=[ud objectForKey:@"t_title"];
    NSString* body=[ud objectForKey:@"t_body"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=insertTousu&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>12345</schoolId><opername>%@</opername><operid>%@</operid><tjtype>投诉</tjtype><zhuti>%@</zhuti><tjcontent>%@</tjcontent><methodName>insertTousu</methodName></MAP_TO_XML>",name,stuID,title,body];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        AddComplaint *complaint = [JsonPaser parserAddComplaintByDictionary:dic];
        callback(complaint);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"");
        [MBProgressHUD showError:@"发送添加投诉失败!"];
    }];
}
////投诉列表
//+(void)requestComplaintListByComplaintList:(NSString *)complaintlist andCallback:(MyCallback)callback{
// //   NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTousu&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CpageN%3E4%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CschoolId%3E12345%3C/schoolId%3E%3Cstuid%3E0107030001%3C/stuid%3E%3CmethodName%3EqueryTousu%3C/methodName%3E%3C/MAP_TO_XML%3E";
//    
//    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTousu&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><pageN>4</pageN><pageNum>0</pageNum><schoolId>12345</schoolId><stuid>0107030001</stuid><methodName>queryTousu</methodName></MAP_TO_XML>";
//    
//    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
//    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
//    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        StuComplaintList *complaintList = [JsonPaser parserStuComplaintListByDictionary:dic];
//        callback(complaintList);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//          NSLog(@"发送投诉列表失败!");
//    }];
//}
//教练可约时段
+(void)requestTeacherTimeByTeacherTime:(NSString *)carid view:(id)view andCallback:(MyCallback)callback{
   // NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherPeriodList&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CschoolId%3E12345%3C/schoolId%3E%3Ccarid%3E1111%3C/carid%3E%3Cstuid%3E123456%3C/stuid%3E%3CpageN%3E0%3C/pageN%3E%3CpageNum%3E0%3C/pageNum%3E%3CsqlWhere%3E%3C/sqlWhere%3E%3CmethodName%3EQueryYueCarList%3C/methodName%3E%3C/MAP_TO_XML%3E";
    NSUserDefaults* us=[NSUserDefaults standardUserDefaults];
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherPeriodList&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\"?><MAP_TO_XML><schoolId>%@</schoolId><carid>%@</carid><stuid>%@</stuid><pageN>0</pageN><pageNum>0</pageNum><sqlWhere></sqlWhere><methodName>QueryYueCarList</methodName></MAP_TO_XML>",[us objectForKey:@"drivecode"],carid,[us objectForKey:@"train_learnid"]];
   
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       
        TeacherTime *teacherTime = [JsonPaser parserTeacherTimeByDictionary:dic];
       
        callback(teacherTime);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view];
        [MBProgressHUD showError:@"发送请求教练可约时段失败!"];
    }];
    }
//
////教练可约日期
//+(void)requestTeacherPeriodDateByComplaintList:(NSDictionary *)teacherPeriodDate andCallback:(MyCallback)callback{
//    //NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherDateList&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CschoolId%3E12345%3C/schoolId%3E%3Ccarid%3E1111%3C/carid%3E%3Cstuid%3E123456%3C/stuid%3E%3CmethodName%3EqueryTeacherDateList%3C/methodName%3E%3C/MAP_TO_XML%3E";
//    
//    NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryTeacherDateList&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>12345</schoolId><carid>1111</carid><stuid>123456</stuid><methodName>queryTeacherDateList</methodName></MAP_TO_XML>";
//    
//    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
//    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
//    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        TeacherPeriodDate *teacherPeriodDate = [JsonPaser parserTeacherPeriodDateByDictionary:dic];
//        callback(teacherPeriodDate);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         [MBProgressHUD showError:@"发送请求教练可约日期失败!"];
//    }];
//}

//学员考试明细
+(void)requsetStudentExamContentByStudentExamContent:(NSString *)studentExamContent andCallback:(MyCallback)callback{
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    NSString* school_id=[ud objectForKey:@"drivecode"];
    NSString* per_id=[ud objectForKey:@"per_id"];
    NSString *path =[NSString stringWithFormat: @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryExa_RecordList&SCHOOL_ID=%@&stu_id=%@",school_id,per_id];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        StudentExamContent *studentExamContent = [JsonPaser parserStudentExamContentByDictionary:dic];
        callback(studentExamContent);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送请求学员考试明细失败!"];
    }];
}

//官方公告
+(void)requestOfficialAnnounceByOfficialAnnounce:(NSString *)officialAnnounce andCallback:(MyCallback)callback{
   // NSString *path = @"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryAttention&xmlStr=%3C?xml%20version=%221.0%22%20encoding=%22utf-8%22%20?%3E%3CMAP_TO_XML%3E%3CschoolId%3E49267%3C/schoolId%3E%3CmethodName%3EqueryAttention%3C/methodName%3E%3C/MAP_TO_XML%3E";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    
    /**url拼接驾校id*/
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryAttention&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><methodName>queryAttention</methodName></MAP_TO_XML>", schoolID];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        JWNoticeModel *officialAnnounce = [JsonPaser parserOfficialAnnounceByDictionary:dic];
        callback(officialAnnounce);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JWLog(@"获取公告数据失败");
    }];
}

//修改密码
+(void)requestChangedPasswordByChangedPassword:(NSDictionary *)changedEPassword andCallback:(MyCallback)callback{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accountID =[ud objectForKey:@"accountID"];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
//    NSString *newPassword = [ud objectForKey:@"currentPassword"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=updateMima&xmlStr=<?xml version=\"1.0\" encoding=\"utf-8\" ?><MAP_TO_XML><schoolId>%@</schoolId><accountId>%@</accountId><oldpassWord>%@</oldpassWord><newpassWord>%@</newpassWord><methodName>updateMima</methodName></MAP_TO_XML>",schoolID,accountID,changedEPassword[@"old"],changedEPassword[@"new"]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    path =[path stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    path =[path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path =[path stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    path =[path stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        ChangePassword *changePassword = [JsonPaser parserChangePasswordByDictionary:dic];
        callback(changePassword);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [MBProgressHUD showError:@"请求修改密码失败!"];
        
    }];
}
//修改手机号码
+(void)requsetChangedPhoneNumByChangedPhoneNum:(NSString *)changePhoneNum andCallback:(MyCallback)callback{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accountID =[ud objectForKey:@"accountID"];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    
//    NSString *oldmobile = [ud objectForKey:@"oldmobile"];
    NSString *newmobile = [ud objectForKey:@"newmobile"];
    
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=updateMobile&schoolId=%@&accountId=%@&oldmobile=%@&newmobile=%@",schoolID,accountID,changePhoneNum,newmobile];
    

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        ChangePhoneNum *changePhoneNum = [JsonPaser parserChangePhoneNumByDictionary:dic];
        callback(changePhoneNum);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求修改手机号码失败!"];
    }];
    

}
//获取联动时段列表
+(void)requestDynamicPeriodListByDynamicPeriodList:(NSString *)dynamicPeriodList view:(id)view andCallback:(MyCallback)callback{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *schoolID = [ud objectForKey:@"drivecode"];
    NSString *path = [NSString stringWithFormat:@"http://xy.1039.net:12345/drivingServcie/rest/driving_json/Default.ashx?methodName=queryLianDongList&SCHOOL_ID=%@&shiduan=%@",schoolID,dynamicPeriodList];
     path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        DynamicPeriodList * dynamicPeriodList = [JsonPaser parserDynamicPeriodListByDictionary:dic];
        callback(dynamicPeriodList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:view];
        [MBProgressHUD showError:@"请求联动时段列表失败!"];
    }];
    
}






@end
