//
//  JWMyNewsTV.h
//  JXT
//
//  Created by JWX on 15/9/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWMyNewsTV : UITableViewController
//
//@property (nonatomic, strong) NSMutableArray *myNewArr;
//@property (nonatomic, strong) NSMutableArray *myNews;

/**推送消息*/
//- (void)setNews:(NSString *)newMsg newDate:(NSString *)newDate;

+ (NSMutableArray *)setNews:(NSString *)newsMsg newsDate:(NSString *)newsDate newsType:(NSString *)newsType;

//+(NSMutableDictionary*)deleteNews:(NSString*)key;
@end
