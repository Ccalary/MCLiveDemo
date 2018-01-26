//
//  FunUtil.m
//  JzyTest
//
//  Created by 姜志远 on 2017/6/3.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import "FunUtil.h"

@implementation FunUtil

+(BOOL)isNull:(id)o
{
    return o == nil || o == NULL || [o isKindOfClass:[NSNull class]];
}

+(BOOL)isBlankString:(id)o
{
    if([self isNull:o]) return YES;
    NSString *testString = [o copy];
    if ([testString isEqualToString:@""]) {
        return YES;
    }
    if ([[testString stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        return YES;
    }
    if ([[testString stringByReplacingOccurrencesOfString:@"\n" withString:@""] length] == 0) {
        return YES;
    }
    
    NSString* b = [testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([b isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
+(BOOL)hasValue:(id)o
{
    return ![self isNull:o];
}

@end
