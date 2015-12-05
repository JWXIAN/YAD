//
//  iCocosBaseSettingViewController.h
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCocosSettingGroup.h"
#import "iCocosSettingItem.h"

@interface iCocosBaseSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
- (IBAction) updateSwitchAtIndexPath:(id) sender;
@end
