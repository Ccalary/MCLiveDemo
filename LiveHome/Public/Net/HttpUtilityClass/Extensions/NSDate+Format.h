//
//  NSDate+Format.h
//  JzyTest
//
//  Created by 姜志远 on 2017/5/27.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FormatDate @"yyyy-MM-dd"
#define FormatDateTime @"yyyy-MM-dd HH:mm:ss"
#define FormatDateTimeUrl @"yyyy-MM-dd'T'HH:mm:ss"

@interface NSDate(Format)

/**
 yyyy-MM-dd

 @return 日期格式
 */
-(NSString *)toDateFormat;

/**
 yyyy-MM-dd HH:mm:ss

 @return 时间格式
 */
-(NSString *)toDateTimeFormat;

/**
 yyyy-MM-ddTHH:mm:ss

 @return 无空格的时间格式
 */
-(NSString *)toDateTimeUrlFormat;

/**
 UTC yyyy-MM-dd HH:mm:ss
 
 @return 时间格式
 */
-(NSString *)toDateTimeUTCFormat;

/**
 UTC yyyy-MM-ddTHH:mm:ss
 
 @return 时间格式
 */
-(NSString *)toDateTimeUrlUTCFormat;
/**
 指定转换格式

 @return 格式时间
 */
-(NSString *)toFormat:(NSString *)format;
/**
 指定转换格式,UTC
 
 @return 格式时间
 */
-(NSString *)toUTCFormat:(NSString *)format;
/**
 返回从1970年到现在的毫秒数

 @return 时间戳
 */
-(long)toLong;
/**
 返回从1970年到现在的毫秒数,UTC
 
 @return 时间戳
 */
-(long)toLongUTC;
@end
