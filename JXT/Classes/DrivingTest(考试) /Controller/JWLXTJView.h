//
//  JWLXTJView.h
//  JXT
//
//  Created by JWX on 15/8/31.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWLXTJView : UIView

/**未做题*/
@property (weak, nonatomic) IBOutlet UILabel *lblWZT;
/**答错题*/
@property (weak, nonatomic) IBOutlet UILabel *lblDCT;
/**答对题*/
@property (weak, nonatomic) IBOutlet UILabel *lblDDT;

/**未做题率*/
@property (weak, nonatomic) IBOutlet UILabel *lblWZTL;
/**答错题率*/
@property (weak, nonatomic) IBOutlet UILabel *lblDCTL;
/**答对题率*/
@property (weak, nonatomic) IBOutlet UILabel *lblDDTL;

@end
