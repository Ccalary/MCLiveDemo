//
//  FunUtil.h
//  JzyTest
//
//  Created by 姜志远 on 2017/6/3.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunUtil : NSObject

/**
 是否为空

 @return 是否为空
 */
+ (BOOL)isNull:(id)o;

/**
 是否是空字符串

 @return 是否是空字符串
 */
+ (BOOL)isBlankString:(id)o;

/**
 是否有值，和isNull相对

 @return 是否有值
 */
+ (BOOL)hasValue:(id)o;

@end
