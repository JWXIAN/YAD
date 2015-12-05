//
//  LeisureModel.h
//  JXT
//
//  Created by 1039soft on 15/10/10.
//  Copyright © 2015年 JW. All rights reserved.
////{"head":{"issuccess":"true","statecode":"2000","stateinfo":"有数据"},"body":[{"photo":"http://img5.duitang.com/uploads/item/201503/26/20150326161657_aL8FW.jpeg","teachername":"张教练","teacherid":"0001","typename":"科目二","typecode":"PXLX001","carcode":"京A0001","pxdate":"2015-09-30","tinfo":"11:00-12:00","period":"A"}]}

#import <Foundation/Foundation.h>
/**
 *  空段查询模型
 *
 *  @since 2.0.2
 */
@interface LeisureModel : NSObject
@property(strong,nonatomic) NSDictionary* head;
@property(strong,nonatomic) NSString* issuccess;
@property(strong,nonatomic) NSString* statecode;
@property(strong,nonatomic) NSString* stateinfo;

@property(strong,nonatomic) NSArray* body;
@property(strong,nonatomic) NSString* photo;//照片
@property(strong,nonatomic) NSString* teachername;//教师名称
@property(strong,nonatomic) NSString* teacherid;//教师编号
@property(strong,nonatomic) NSString* typename;//科目名  ->typename  
@property(strong,nonatomic) NSString* typecode;//科目编号
@property(strong,nonatomic) NSString* carcode;//车号
@property(strong,nonatomic) NSString* pxdate;//培训日期
@property(strong,nonatomic) NSString* tinfo;//培训时间
@property(strong,nonatomic) NSString* period;//时段代码
@end
