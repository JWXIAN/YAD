//
//  YADPickUpInfoModel.h
//  JXT
//
//  Created by JWX on 15/12/3.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YADPickUpInfoModel : NSObject
//{
//    "head":{
//        "issuccess":"true",
//        "statecode":"2000",
//        "stateinfo":"有数据"
//    },
//    "body":[
//            {
//                "id":"1",
//                "stuid":"123456789",
//                "mobile":"13412341234",
//                "jstime":"2015-12-10 16:53:00",
//                "jsadd":"北京",
//                "status":"预约",
//                "czdate":"2015-12-3 10:15:19",
//                "remark":"app预约"
//            }
//            ]
//}
/**id*/
@property (nonatomic, strong) NSString *id;
/**学员id*/
@property (nonatomic, strong) NSString *stuid;
/**手机号*/
@property (nonatomic, strong) NSString *mobile;
/**接送时间*/
@property (nonatomic, strong) NSString *jstime;
/**接送地址*/
@property (nonatomic, strong) NSString *jsadd;
/**接送状态*/
@property (nonatomic, strong) NSString *status;
/**操作时间*/
@property (nonatomic, strong) NSString *czdate;
/**标示*/
@property (nonatomic, strong) NSString *remark;

@end
