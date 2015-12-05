//
//  JWWeChatHeadModel.h
//  JXT
//
//  Created by JWX on 15/9/15.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWWeChatHeadModel : NSObject

/**是否成功*/
@property (nonatomic,copy)NSString *issuccess;
/**状态识别码*/
@property (nonatomic,copy)NSString *statecode;
/**是否有数据*/
@property (nonatomic,copy)NSString *stateinfo;

/**body数组*/
@property(copy,nonatomic) NSArray *body;
@end
