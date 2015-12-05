//
//  iCocosPushNoticeViewController.m
//  JWX
//
//  Created by JWX on 15/6/29.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "iCocosPushNoticeViewController.h"
#import "JiaxiaotongAPI.h"
#import "JWNoticeModel.h"
@interface iCocosPushNoticeViewController ()

@end

@implementation iCocosPushNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"公告";
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, -65, self.view.frame.size.width-30, 300)];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    lab.textAlignment = UITextLayoutDirectionLeft;
    lab.backgroundColor = [UIColor whiteColor];
    [JiaxiaotongAPI requestOfficialAnnounceByOfficialAnnounce:nil andCallback:^(id obj) {
        JWNoticeModel* jn=obj;
        jn.result =[jn.result stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        lab.text =jn.result;
        [self.view addSubview:lab];
    }];
    
//    // 1.1
//    iCocosSettingItem *item1 = [iCocosSettingItem itemWithIcon:niCocos title:@"" type:iCocosSettingItemTypeArrow];
//    
//    // 1.2
//    iCocosSettingItem *item2 = [iCocosSettingItem itemWithIcon:niCocos title:@"" type:iCocosSettingItemTypeArrow];
//    
//    // 1.3
//    iCocosSettingItem *item3 = [iCocosSettingItem itemWithIcon:niCocos title:@"" type:iCocosSettingItemTypeArrow];
//    
//    // 1.4
//    iCocosSettingItem *item4 = [iCocosSettingItem itemWithIcon:niCocos title:@"" type:iCocosSettingItemTypeArrow];
//    
//    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
//    group.items = @[item1, item2, item3, item4];
//    [_allGroups addObject:group];
}

@end
