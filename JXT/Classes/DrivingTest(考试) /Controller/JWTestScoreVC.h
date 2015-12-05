//
//  JWTestScoreVC.h
//  JXT
//
//  Created by JWX on 15/10/15.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTestScoreVC : UIViewController

- (IBAction)btnQuit:(id)sender;
- (IBAction)btnCXKS:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imagePs;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imageBGView;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (nonatomic, assign) NSUInteger score;

@end
