//
//  LHConnect.h
//  LiveHome
//
//  Created by chh on 2017/11/6.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connect.h"

@interface LHConnect : NSObject
+ (NSMutableDictionary *_Nullable)getBaseRequestParams;

#pragma mark - 视频模块
/**
 * 历史视频接口
 */
+ (void)postVideoList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable operation, NSError * _Nullable error))failure;

/**
 * 更新历史视频接口
 */
+ (void)postVideoUpdateInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 删除历史视频接口
 */
+ (void)postVideoDeleteItems:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 模版列表接口
 */
+ (void)postTemplateList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
#pragma mark - 应用模块

/**
 * 礼物接口
 */
+ (void)postGiftList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 礼物取消选择接口
 */
+ (void)postGiftExclude:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
#pragma mark - 直播模块
/**
 * 直播房间信息接口
 */
+ (void)postLiveRoomInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 直播推流接口
 */
+ (void)postLiveGetAddress:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 上传直播间信息
 */
+ (void)postLiveUpdateMyRoom:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 观众列表接口
 */
+ (void)postLiveRoomUsers:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 敏感词接口
 */
+ (void)postLiveKeyWords:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
#pragma mark - 个人中心模块
/**
 * 获取用户信息
 */
+ (void)postUserInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 获取用户简单信息
 */
+ (void)postUserShortInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 * 更新用户信息
 */
+ (void)postUpdateUserInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 上传图片资源
 */
+ (void)uploadImageResource:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text imageArray:(NSArray *_Nullable)array success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 反馈
 */
+ (void)postFeedback:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 实名认证
 */
+ (void)postCertification:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 余额信息
 */
+ (void)postWalletWalletMoney:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 钱包账单
 */
+ (void)postWalletWalletMoneyLog:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 添加银行卡
 */
+ (void)postWalletAddBankCard:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 获取银行卡类型
 */
+ (void)postWalletGetCardType:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 获取银行卡列表
 */
+ (void)postWalletBankCard:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 提现
 */
+ (void)postWalletWithdrawals:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 套餐上方的广告接口
 */
+ (void)postPackageAd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 当前套餐
 */
+ (void)postPackageMyPackage:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 请求订单接口
 */
+ (void)postPackageOrder:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 请求支付接口
 */
+ (void)postPackagePay:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 当前套餐余量
 */
+ (void)postPackageInformation:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 套餐详情
 */
+ (void)postPackageList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 直播统计接口
 */
+ (void)postZhiBoData:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 内购
 */
+ (void)postAppleNotify:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
#pragma mark - 注册登录
/**
 * 登录
 */
+ (void)postLogin:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 注册
 */
+ (void)postRegister:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 忘记密码
 */
+ (void)postForgetPsd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 * 发送短信验证码
 */
+ (void)postSendSms:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 更改手机号
 */
+ (void)postChangeMobile:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

#pragma mark - 投票模块
/**
 投票活动列表
 */
+ (void)postVoteList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 新增投票活动
 */
+ (void)postVoteAdd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 修改投票活动
 */
+ (void)postVoteEdit:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 删除投票活动
 */
+ (void)postVoteDelete:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 投票活动信息
 */
+ (void)postVoteInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;
/**
 投票
 */
+ (void)postVoteVote:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;

/**
 投票活动详情
 */
+ (void)postVoteDetail:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;


#pragma mark - 其他
/**
 错误日志
 */
+ (void)postAppErrorInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail;


@end
