//
//  ToolsHelper.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsHelper : NSObject
/** 判断是否是iPhoneX */
+ (BOOL)isiPhoneX;

/** 字典转Json字符串 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/** 数组转Json字符串 */
+ (NSString*)arrayToJson:(NSMutableArray *)array;
/** json转字典 */
+ (NSDictionary *)dictionaryFromJson:(NSString *)jsonString;
/** 处理string为空的情况 */
+ (NSString *)stringDealNull:(NSString *)result;
/** 处理字典中value为空的情况 */
+ (NSMutableDictionary *)dictionaryDealNull:(NSDictionary *)dic;
/**
 改变某些字体的颜色
 @param str 要改变的文本
 @param result 总文本
 @param color 要改变的文本的颜色
 @return 改变后的总文本
 */
+ (NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color;

/**
 计算多行高度
 @param width 字符串宽度
 @param font 字体大小
 @param string 内容
 @return 高度
 */
+ (CGFloat )getStringHeightWithWidth:(CGFloat)width font:(UIFont *)font string:(NSString *)string;

/** 秒数转换成时间 */
+ (NSString *)getMMSSFromSS:(double )totalTime;

/** 判断字符串是否为空 */
+ (BOOL)isBlankString:(NSString *)string;

@end
