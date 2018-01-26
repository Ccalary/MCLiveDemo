//
//  NSDate+Format.m
//  JzyTest
//
//  Created by 姜志远 on 2017/5/27.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import "NSDate+Format.h"



@implementation NSDate(Format)

-(NSString *)toDateFormat
{
    return [self toFormat:FormatDate];
}
-(NSString *)toDateTimeFormat
{
    return [self toFormat:FormatDateTime];
}
-(NSString *)toDateTimeUrlFormat
{
    return [self toFormat:FormatDateTimeUrl];
}
-(NSString *)toDateTimeUTCFormat
{
    return [self toUTCFormat:FormatDateTime];
}
-(NSString *)toDateTimeUrlUTCFormat
{
    return [self toUTCFormat:FormatDateTimeUrl];
}
-(NSString *)toFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    
    // 设置日期格式
    [dateFormatter setDateFormat:format];
    
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}
-(NSString *)toUTCFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    NSTimeZone *currentTimezone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"]; //[NSTimeZone systemTimeZone];
    
    [dateFormatter setTimeZone:currentTimezone];
    // 设置日期格式
    [dateFormatter setDateFormat:format];
    
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}
-(long)toLong
{
    long l = (long)([self timeIntervalSince1970] * 1000);
    return l;
}
-(long)toLongUTC
{
    long l = (long)([self timeIntervalSince1970] * 1000);
    
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    return l - interval * 1000;
}
- (NSDate *)getNowDateFromatAnDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
    return destinationDateNow;
}

@end
