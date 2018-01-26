//
//  ToolsHelper.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "ToolsHelper.h"
#import "sys/utsname.h"

@implementation ToolsHelper
#pragma mark - 系统相关
+ (BOOL)isiPhoneX{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 数据处理
//字典转Json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//数组转Json字符串
+ (NSString*)arrayToJson:(NSMutableArray *)array
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** json转字典 */
+ (NSDictionary *)dictionaryFromJson:(NSString *)jsonString
{
    if([jsonString isKindOfClass:[NSDictionary class]])
        return (NSDictionary *)jsonString;
    if([jsonString isKindOfClass:[NSMutableDictionary class]])
        return (NSDictionary *)jsonString;
    
    NSDictionary* dict;
    if (jsonString && ![jsonString isKindOfClass:[NSNull class]] && ![jsonString isEqualToString:@""]) {
        NSError * parseError = nil;
        dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    }
    return dict;
}

/** 处理string为空的情况 */
+ (NSString *)stringDealNull:(NSString *)result{
    if (!result || [result isEqual:[NSNull null]]){
        return @"";
    }
    return result;
}

/** 处理字典中value为空的情况 */
+ (NSMutableDictionary *)dictionaryDealNull:(NSDictionary *)dic{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    for (NSString *key in [mDic allKeys]){
        if (!mDic[key] || [mDic[key] isEqual:[NSNull null]]){
            mDic[key] = @"";
        }
    }
    return mDic;
}

///改变某些字的颜色
+ (NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color {
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:result];
    if (str.length){
        NSRange colorRange = NSMakeRange([[attributeStr string] rangeOfString:str].location,[[attributeStr string] rangeOfString:str].length);
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    }
    return attributeStr;
}

//计算多行高度
+ (CGFloat )getStringHeightWithWidth:(CGFloat)width font:(UIFont *)font string:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

/** 秒数转换成时间 */
+ (NSString *)getMMSSFromSS:(double )totalTime{
    int seconds = (int)totalTime;
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

/** 判断字符串是否为空 */
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if([string isKindOfClass:[NSString class]] == NO)
    {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

@end
