//
//  JWQZMNVC.h
//  JXT
//
//  Created by JWX on 15/8/17.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWQZMNVC : UIViewController

/**解决cell重用问题*/
@property (nonatomic, strong) NSArray *cellDataArr;

/**返回cell数*/
@property (nonatomic, assign) int cellCount;

/**存放答题后的字典*/
@property (nonatomic, strong) NSMutableDictionary *dtDic;

@end
