//
//  LHConnect.m
//  LiveHome
//
//  Created by chh on 2017/11/6.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "LHConnect.h"


@implementation LHConnect
+ (NSMutableDictionary *_Nullable)getBaseRequestParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    return params;
}
#pragma mark - 历史视频
/**
 * 历史视频接口
 */
+ (void)postVideoList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable operation, NSError * _Nullable error))failure
{
    [[Connect sharedInstance] postWithUrl:VideoList parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation,error);
    }];
}


/**
 * 更新历史视频接口
 */
+ (void)postVideoUpdateInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VideoUpdateInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 删除历史视频接口
 */
+ (void)postVideoDeleteItems:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VideoDeleteItems parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 模版列表接口
 */
+ (void)postTemplateList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:TemplateList parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma makr - 应用模块
/**
 * 礼物接口
 */
+ (void)postGiftList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:GiftList parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 礼物取消选择接口
 */
+ (void)postGiftExclude:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:GiftExclude parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 直播模块
/**
 * 直播房间信息接口
 */
+ (void)postLiveRoomInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:LiveRoomInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 直播推流接口
 */
+ (void)postLiveGetAddress:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:LiveGetAddress parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 上传直播间信息
 */
+ (void)postLiveUpdateMyRoom:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:LiveUpdateMyRoom parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 观众列表接口
 */
+ (void)postLiveRoomUsers:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:LiveRoomUsers parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 敏感词接口
 */
+ (void)postLiveKeyWords:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:LiveKeyWords parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark - 个人中心模块

/**
 * 获取用户信息
 */
+ (void)postUserInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:UserInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 获取用户简单信息
 */
+ (void)postUserShortInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:UserShortInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 更新用户信息
 */
+ (void)postUpdateUserInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:UpdateUserInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 上传图片资源
 */
+ (void)uploadImageResource:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text imageArray:(NSArray *_Nullable)array success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postImageWithUrl:HomeResource parameters:params loadingText:text imageArray:array success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
         successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 反馈
 */
+ (void)postFeedback:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:FeedBack parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 实名认证
 */
+ (void)postCertification:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:Certification parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 余额信息
 */
+ (void)postWalletWalletMoney:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletWalletMoney parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 钱包账单
 */
+ (void)postWalletWalletMoneyLog:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletWalletMoneyLog parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 添加银行卡
 */
+ (void)postWalletAddBankCard:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletAddBankCard parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 获取银行卡类型
 */
+ (void)postWalletGetCardType:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletGetCardType parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 获取银行卡列表
 */
+ (void)postWalletBankCard:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletBankCard parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 提现
 */
+ (void)postWalletWithdrawals:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:WalletWithdrawals parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
/**
 * 套餐上方的广告接口
 */
+ (void)postPackageAd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackageAd parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 当前套餐
 */
+ (void)postPackageMyPackage:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackageMyPackage parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 请求订单接口
 */
+ (void)postPackageOrder:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackageOrder parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


/**
 * 请求支付接口
 */
+ (void)postPackagePay:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackagePay parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 当前套餐余量
 */
+ (void)postPackageInformation:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackageInformation parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 套餐详情
 */
+ (void)postPackageList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:PackageList parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 直播统计
 */
+ (void)postZhiBoData:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:ZhiBo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 内购
 */
+ (void)postAppleNotify:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:AppleNotify parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - ****************************注册登录*************************
/**
 * 登录
 */
+ (void)postLogin:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:Login parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}
/**
 * 注册
 */
+ (void)postRegister:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:Register parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}
/**
 * 忘记密码
 */
+ (void)postForgetPsd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:ForgetPwd parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}
/**
 发送短信验证码
 */
+ (void)postSendSms:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:SendSms parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}
/**
 更改手机号
 */
+ (void)postChangeMobile:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:BangdingMobile parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}


#pragma mark - ****************************投票模块*************************

/**
 投票活动列表
 */
+ (void)postVoteList:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteList parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 新增投票活动
 */
+ (void)postVoteAdd:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteAdd parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 修改投票活动
 */
+ (void)postVoteEdit:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteEdit parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 删除投票活动
 */
+ (void)postVoteDelete:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteDelete parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 投票活动信息
 */
+ (void)postVoteInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteInfo parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 投票
 */
+ (void)postVoteVote:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteVote parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

/**
 投票活动详情
 */
+ (void)postVoteDetail:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:VoteDetail parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

#pragma mark - 其他
/**
 错误日志
 */
+ (void)postAppErrorInfo:(NSMutableDictionary *_Nullable) params loading:(NSString *_Nullable)text success:(void (^_Nullable)(id _Nonnull response))success successBackFail:(void (^_Nonnull)(id _Nonnull response))successBackFail
{
    [[Connect sharedInstance] postWithUrl:AppError parameters:params loadingText:text success:^(id response) {
        success(response);
    } successBackFail:^(id response) {
        successBackFail(response);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    }];
}

@end
