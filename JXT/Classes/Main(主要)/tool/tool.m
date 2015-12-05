//
//  tool.m
//  JXT
//
//  Created by 1039soft on 15/8/5.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "tool.h"

@implementation tool

+(NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}

+ (NSMutableArray *)requirementArray:(NSArray *)array targetArray:(NSArray* )array2  key:(NSString* )key
{
    NSMutableArray* backarr=[NSMutableArray array];
   
    for (int i=0; i<array.count; i++) {
        NSMutableArray* arr=[NSMutableArray array];
        for (int j=0; j<array2.count; j++) {
            if ([[array2[j] valueForKey:key] isEqualToString:array[i]] ) {
                [arr addObject:array2[j]];
               
            }
            
        }
        [backarr addObject:arr];
       
    }
    return backarr;
}

+ (NSInteger)isInArr:(NSArray* )arr key:(NSString* )keyname
{
    if (keyname) {
        for (int i=0; i<arr.count; i++) {
            if ([arr[i] rangeOfString:keyname].location!=NSNotFound||[keyname rangeOfString:arr[i]].location!=NSNotFound) {
                
                return i;
            }
        }
    }
    return -1;
}
+ (UIImage* )getOcImage:(NSString* __nullable)path
{
    return [UIImage imageWithContentsOfFile:path];
}
@end
