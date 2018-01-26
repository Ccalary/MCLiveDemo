//
//  UserHelper.m
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "UserHelper.h"
#import "ToolsHelper.h"

@implementation UserHelper
#pragma mark - 是否是审核帐号
/** 是否是审核帐号 */
+ (BOOL)getIsReviewAccount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isReview = [defaults objectForKey:@"isReviewAccount"];
    return [isReview isEqualToString:ReviewAccount];//审核帐号
}

/** 保存审核帐号 */
+ (void)setReviewAccount:(NSString *)account{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:@"isReviewAccount"];
    [defaults synchronize];
}
#pragma mark - 登录信息
//是否登录
+(BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [defaults objectForKey:@"isLogin"];
    return [isLogin isEqualToString:@"1"];
}
//保存登录信息
+(void)setLogInfo:(NSDictionary *)dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"isLogin"];//登录
    [defaults setObject:[dic objectForKey:@"auth"] forKey:@"auth"];//auth
    [defaults setObject:[dic objectForKey:@"id"] forKey:@"userId"];//id
    [defaults setObject:[dic objectForKey:@"t"] forKey:@"RongCloudToken"];//融云token
    [defaults synchronize];
}

//保存用户信息
+(void)setUserInfo:(NSDictionary *)dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ToolsHelper dictionaryDealNull:dic] forKey:@"userInfo"];//UserInfoModel 信息
    [defaults synchronize];
}

//退出
+(void)logout{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isLogin"];
    [defaults setObject:@""  forKey:@"auth"];
    [defaults setObject:@""  forKey:@"userId"];
    [defaults setObject:@""  forKey:@"RongCloudToken"];
    [defaults setObject:nil forKey:@"userInfo"];
    [defaults synchronize];
}

/** 获得用户信息 */
+ (NSDictionary *)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [defaults objectForKey:@"userInfo"];
    return userInfo;
}

/** 获得auth */
+ (NSString *)getMemberAuth{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth = [defaults objectForKey:@"auth"];
    return auth;
}

/** 获得userId*/
+ (NSString *)getMemberId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userId"];
    return userId;
}

/** 获得融云Token */
+ (NSString *)getRongCloudToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"RongCloudToken"];
    return token;
}

#pragma mark - 敏感词
/** 保存敏感词 */
+(void)setLiveKeyWords:(NSArray *)array{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:@"liveKeyWords"];
    [defaults synchronize];
}

/** 获取敏感词 */
+ (NSArray *)getLiveKeyWords{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"liveKeyWords"];
    return array;
}

#pragma mark - 网络状态
/** 保存网络状态 1-无网络 2-数据网络 3-wifi 其他-未知网络*/
+ (void)setNetStatus:(NSInteger)status{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:status forKey:@"netStatus"];
    [defaults synchronize];
}

/** 获取网络状态 */
+ (NSInteger)getNetStatus{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger status = [defaults integerForKey:@"netStatus"];
    return status;
}
#pragma mark - 错误信息
/** 保存错误信息 */
+(void)setAppErrorInfo:(NSString *)info{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:info forKey:@"appErrorInfo"];
    [defaults synchronize];
}

/** 获取错误信息 */
+ (NSString *)getAppErrorInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:@"appErrorInfo"];
    return string;
}

@end
