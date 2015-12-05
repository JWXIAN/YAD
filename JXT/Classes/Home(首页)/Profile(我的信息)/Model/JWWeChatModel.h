//
//  JWWeChatModel.h
//  JXT
//
//  Created by JWX on 15/9/15.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWWeChatModel : NSObject
//
//{"head":{"issuccess":"true","statecode":"2000","stateinfo":"有数据"},"body":[{"id":"1","zftype":"wx","username":"wxc1452ee4722071a5","userid":"1264830201","key":"&nbsp;","encrypt":"bjs1039softsoftsoftsoftsoftsofts","jxid":"00012","remark":"&nbsp;"}]}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *zftype;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *jxid;
@property (nonatomic, copy) NSString *remark;

/**AppID*/
@property (nonatomic, copy) NSString *username;
/**商户号*/
@property (nonatomic, copy) NSString *userid;
/**商户秘钥*/
@property (nonatomic, copy) NSString *encrypt;

@end
