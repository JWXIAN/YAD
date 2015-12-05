//
//  carcell.h
//  JXT
//
//  Created by 1039soft on 15/7/27.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWVenicleBodyModel.h"
@interface carcell : UITableViewCell

@property (nonatomic,strong)JWVenicleBodyModel *driTeaListInfo;

-(void)drawview;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
@property(strong,nonatomic) NSString* zannum;//赞数目

@end
