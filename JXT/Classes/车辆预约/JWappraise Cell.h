//
//  JWappraise Cell.h
//  JXT
//
//  Created by 1039soft on 15/7/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWappraise_Cell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
-(void)drawview;
@property(strong,nonatomic) NSDictionary* info;
@end
