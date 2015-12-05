//
//  tool.h
//  JXT
//
//  Created by 1039soft on 15/8/5.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface tool : NSObject
//去除数组中重复对象
/**
 @param array 要去重的数组
 @return 处理好的数组
 **/
+ (NSArray *)arrayWithMemberIsOnly:(NSMutableArray *)array;


//根据所给内容对数组进行分组
/**

 @param array  分组根据
 @param array2  要分组的数组
 @param key 根据数组中对象的哪一个值进行分组
 @return 分好组的数组
 **/
+ (NSArray *)requirementArray:(NSArray *)array targetArray:(NSArray* )array2 key:(NSString* )key;

//数组中是否包含某个字符串
/**
 
 @param arr 要判断的数组
 @param keyname 要判断的字符串
 @return 如果在,返回所在下标，不在返回-1
 **/
+ (NSInteger )isInArr:(NSArray* )arr key:(NSString* )keyname;
/**
 @param path  文件路径
 @return 图片
 */
+ (UIImage* )getOcImage:( NSString* __nullable )path;
@end
