//
//  NSString+Extend.h
//  JzyTest
//
//  Created by 姜志远 on 2017/5/27.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString(Encrypt)

/**
 AES 256加密，ECB/PKCS7Padding模式，兼容C#、Android、Java

 @param key 32位的加密密匙
 @return 加密过后的字符串
 */
- (NSString *)AES256EncryptWithKey:(NSString *)key;

/**
 AES 256解密，ECB/PKCS7Padding模式，兼容C#、Android、Java

 @param key 32位的加密密匙
 @return 解密过后的字符串
 */
- (NSString *)AES256DecryptWithKey:(NSString *)key;

/**
 获取MD5值，此为小写

 @return MD5加密后的字符串
 */
- (NSString *)md5;

- (NSString*) sha1;
@end

@interface NSString (JSON)

/**
 json转换成对象
 
 @return json转换成对象
 */
- (NSDictionary *)jsonDeserialize;

@end
@interface NSString (Valid)

/**
 是否是手机号

 @return 是否是手机号
 */
-(BOOL)isMobile;

-(BOOL)isEmail;
@end

@interface NSString (Extend)
-(NSString *) trim;
@end

@interface NSString (Encode)


/**
 URLEncode

 @return URLEncode
 */
- (NSString *)URLEncodedString;

/**
 URLDecode

 @return URLDecode
 */
- (NSString *)URLDecodedString;

@end

/**
 如果需要更多的内容，请查询  NSMutableParagraphStyle
 */
@interface NSString (UILabel_Font)


/**
 根据字符串和指定的字体，获取UILabel的大小

 @param font 指定的UILabel的字体大小
 @return UILabel的大小
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 根据字符串和指定的字体，获取UILabel的大小

 @param font 指定的UILabel的字体大小
 @param lineSpacing 行高，行间距
 @return UILabel的大小
 */
- (CGSize)sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/**
 根据字符串和指定的字体，获取富文本

 @param font 指定的富文本的字体大小
 @param lineSpacing 行高，行间距
 @return 带有下划线的富文本
 */
- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/**
 根据字符串、指定的字体和最大尺寸，获取UILabel的大小，常用来限制宽度，获取实际的高度

 @param font 指定的UILabel的字体大小
 @param lineSpacing 行高，行间距
 @param maxSize 最大尺寸
 @return UILabel的大小
 */
- (CGSize)sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize;


@end
