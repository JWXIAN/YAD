//
//  TePeriodListInfo.h
//  jiaxiaotong
//
//  Created by 1039soft on 15/5/21.
//  Copyright (c) 2015年 1039soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TePeriodListInfo : NSObject
@property (nonatomic,copy)NSString *teacherPeriodID;//教练时段列表标识
@property (nonatomic,copy)NSString *bookDate;       // 预约日期
@property (nonatomic,copy)NSString *period;         //时段
@property (nonatomic,copy)NSString *periodCode;     //时段编号
@property (nonatomic,copy)NSString *pxinfo;         //是否可预约
@property (nonatomic,copy)NSString *weekday;        //周几

@end
