//
//  JWLXTJView.m
//  JXT
//
//  Created by JWX on 15/8/31.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWLXTJView.h"

@implementation JWLXTJView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrView = [[NSBundle mainBundle] loadNibNamed:@"JWLXTJVIew" owner:nil options:nil];
        self = [arrView objectAtIndex:0];
    }
    return self;
}
@end

