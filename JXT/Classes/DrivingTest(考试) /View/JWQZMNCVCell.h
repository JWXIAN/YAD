//
//  JWQZMNCVCell.h
//  JXT
//
//  Created by JWX on 15/8/21.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class exam;
@interface JWQZMNCVCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, assign) NSArray *cellNum;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) UITableView *dtTV;

/**答题行数*/
@property (nonatomic, strong) NSIndexPath *cvRowIndexPath;

//设置cell
- (void)setTVCell:(exam *)exam cellNum:(NSIndexPath *)cellNum;

/**顶部视图*/
- (void)loadHeadView:(NSString *)imageType lblText:(NSString *)lblT imageT:(NSString *)imageT;

/**答题模型*/
@property (nonatomic, strong) exam *exam;

@property (nonatomic, strong) NSDictionary *dtdic;


@end
