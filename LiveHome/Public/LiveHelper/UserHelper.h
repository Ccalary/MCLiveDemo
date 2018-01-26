//
//  UserHelper.h
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelper : NSObject
/** 是否是审核帐号 */
+ (BOOL)getIsReviewAccount;
/** 保存审核帐号 */
+ (void)setReviewAccount:(NSString *)account;

/** 是否登录 */
+(BOOL)isLogin;

/** 保存登录信息 */
+(void)setLogInfo:(NSDictionary *)dic;

/** 保存用户信息 */
+(void)setUserInfo:(NSDictionary *)dic;

/** 退出 */
+(void)logout;

/** 获得用户信息 */
+ (NSDictionary *)getUserInfo;

/** 获得auth */
+ (NSString *)getMemberAuth;

/** 获得userId*/
+ (NSString *)getMemberId;

/** 获得融云Token */
+ (NSString *)getRongCloudToken;

/** 保存敏感词 */
+(void)setLiveKeyWords:(NSArray *)array;

/** 获取敏感词 */
+ (NSArray *)getLiveKeyWords;

/** 保存网络状态 1-无网络 2-数据网络 3-wifi 其他-未知网络*/
+ (void)setNetStatus:(NSInteger)status;

/** 获取网络状态 1-无网络 2-数据网络 3-wifi 其他-未知网络*/
+ (NSInteger)getNetStatus;

#pragma mark - 错误信息
/** 保存错误信息 */
+(void)setAppErrorInfo:(NSString *)info;
/** 获取错误信息 */
+ (NSString *)getAppErrorInfo;
@end
