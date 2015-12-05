//
//  JWDLTVCell.h
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWDriveBodyModel;
@class JWDriveHeadModel;

@interface JWDLTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *driveName;
@property (weak, nonatomic) IBOutlet UILabel *driveNo;

@property (weak, nonatomic) IBOutlet UILabel *driveProvince;

@property (weak, nonatomic) IBOutlet UILabel *driveCity;


@property (nonatomic,strong)JWDriveBodyModel *driveData;


@end
