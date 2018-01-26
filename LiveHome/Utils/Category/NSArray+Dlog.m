//
//  NSArray+Dlog.m
//  LiveHome
//
//  Created by caohouhong on 17/6/6.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "NSArray+Dlog.h"

@implementation NSArray (Dlog)

-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个[
    [string appendString:@"[\n"];
    
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 结尾有个]
    [string appendString:@"]"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}
@end

@implementation NSDictionary (DLog)
//一个三方框架看到的写法
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)descriptionWithLocale:(id)locale{
    
    if (![self count]) {
        return @"";
    }
    NSString *tempStr1 =
    [[self description] stringByReplacingOccurrencesOfString:@"\\u"
                                                  withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    
    [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
    return str;
    
}

/* 另一种写法
 - (NSString *)descriptionWithLocale:(id)locale
 {
 NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
 
 [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
 [strM appendFormat:@"\t%@ = %@;\n", key, obj];
 }];
 
 [strM appendString:@"}\n"];
 
 return strM;
 }
 */

@end

