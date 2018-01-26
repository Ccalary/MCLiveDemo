//
//  NetUrlMacro.h
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#ifndef NetUrlMacro_h
#define NetUrlMacro_h
//服务器地址
#define LiveHome_URL   @"http://LiveHomeAPI.o2o.com.cn/"

#pragma mark - ****************历史*****************
//历史视频
#define  VideoList     @"Video/List"

//历史视频详情
#define VideoInfo      @"Video/Info"

//更新历史视频信息
#define VideoUpdateInfo @"Video/UpdateInfo"

//删除历史视频（多个）
#define  VideoDeleteItems @"Video/DeleteItems"

//模版列表接口
#define TemplateList     @"Template"

#pragma makr - *****************应用****************
//礼物接口
#define GiftList           @"Gift/List"

//礼物取消选择接口（默认全选）
#define GiftExclude        @"Gift/Exclude"

#pragma makr - ***************直播相关****************
//直播房间信息接口
#define LiveRoomInfo       @"Live/LiveRoomInfo"

//推流接口
#define LiveGetAddress     @"Live/GetAddress"

//上传我的直播间信息接口
#define LiveUpdateMyRoom   @"Live/UpdateMyRoom"

//观众列表接口
#define LiveRoomUsers      @"Live/RoomUsers"

//敏感词过滤
#define LiveKeyWords       @"Live/KeyWords"

#pragma mark - ****************个人中心****************
//用户详细信息接口
#define UserInfo           @"User/UserInfo"

//用户信息（融云使用）
#define UserShortInfo      @"User/UserShortInfo"

//更新用户信息接口
#define UpdateUserInfo     @"User/UpdateUserInfo"

//上传图片资源
#define HomeResource       @"Home/Resource"

//意见反馈接口
#define FeedBack           @"FeedBack"

//实名认证接口
#define Certification      @"User/Certification"

//余额
#define WalletWalletMoney  @"Wallet/WalletMoney"

//我的钱包账单
#define WalletWalletMoneyLog @"Wallet/WalletMoneyLog"

//添加银行卡
#define WalletAddBankCard  @"Wallet/AddBankCard"

//获取银行卡的类型
#define WalletGetCardType  @"Wallet/GetCardType"

//我的银行卡列表
#define WalletBankCard     @"Wallet/BankCard"

//我的钱包提现
#define WalletWithdrawals  @"Wallet/Withdrawals"

//套餐上方的广告接口
#define PackageAd          @"Package/Ad"

//当前套餐接口
#define PackageMyPackage   @"Package/MyPackage"

//购买套餐接口
#define PackageOrder       @"Package/Order"

//支付接口
#define PackagePay         @"Pay"

//当前套餐余量接口
#define PackageInformation @"Package/PackageInformation"

//套餐详情
#define PackageList        @"Package/PackageList"

//直播统计
#define ZhiBo              @"Zhibo"

//IAP内购成功接口
#define AppleNotify        @"Pay/AppleNotify"

#pragma mark - ****************登录注册模块*****************
//登录接口
#define Login            @"Account/Login"

//注册接口
#define Register         @"Account/Register"

//忘记密码接口
#define ForgetPwd        @"Account/ForgetPwd"

//发送短信接口
#define SendSms          @"Sms/SendSms"

//图片验证码接口
#define ValidImage       LiveHome_URL@"Sms/ValidImage"

//绑定手机接口(更换手机号)
#define BangdingMobile   @"User/BangdingMobile"

//投票接口
//投票活动列表
#define VoteList   @"Vote/List"

//新增投票活动
#define VoteAdd   @"Vote/Add"

//修改投票活动
#define VoteEdit  @"Vote/Edit"

//删除投票活动
#define VoteDelete   @"Vote/Delete"

//投票活动信息
#define VoteInfo   @"Vote/Info"

//投票
#define VoteVote   @"Vote/Vote"

//投票活动详情
#define VoteDetail   @"Vote/Detail"

#pragma mark - *******************其他*********************
//
#define AppError        @"home/AppError"

#endif /* NetUrlMacro_h */
