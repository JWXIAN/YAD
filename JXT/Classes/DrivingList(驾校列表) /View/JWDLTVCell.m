//
//  JWDLTVCell.m
//  JXT
//
//  Created by JWX on 15/6/23.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWDLTVCell.h"
#import "JWDriveBodyModel.h"
#import "JWDriveHeadModel.h"

@implementation JWDLTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.driveName.text = self.driveData.qyname;
    self.driveNo.text = self.driveData.qyid;
    self.driveProvince.text = self.driveData.shengfen;
    self.driveCity.text = self.driveData.shiqu;
}

@end
