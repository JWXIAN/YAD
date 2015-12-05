//
//  UILabel+JWContentSize.m
//  YAD
//
//  Created by JWX on 15/11/20.
//  Copyright © 2015年 YAD. All rights reserved.
//

#import "UILabel+JWContentSize.h"

@implementation UILabel (JWContentSize)

- (CGSize)JWContentSize{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

@end
