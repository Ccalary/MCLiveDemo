//
//  AppDelegate.m
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "UserHelper.h"
#import <SDWebImage/SDImageCache.h>
#import <AlipaySDK/AlipaySDK.h>
//融云相关
#import "RCDEntryRoomMessage.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDLive.h"
#import "RCDGiveGiftMessage.h"

#import "LoginViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "NSString+Extend.h"


@interface AppDelegate ()<WXApiDelegate>
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //隐藏键盘的toolBar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[BaseTabBarController alloc] init];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //初始化shardSdk
    [self registerShareSDK];
    //初始化融云
    [self initRongCloud];
    //网络请求
    [self requestLiveKeyWords];
    //判断登录
    [self judgeLogin];
    //网络状态
    [self AFNReachability];
    //注册微信支付
    [WXApi registerApp:WX_APPID];
    //发送错误日志
    [self sendErrorInfo];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
 
    return YES;
}

//横竖屏切换使用
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 判断是否登录
- (void)judgeLogin{
    if (![UserHelper isLogin]){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 初始化融云
- (void)initRongCloud{
    
    [[RCDLive sharedRCDLive] initRongCloud:RongIMAppKey_Pro];
    //注册自定义消息
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDGiveGiftMessage class]];
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDEntryRoomMessage class]];
    [self connectRongCloud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeOtherPlaceLogin) name:NoticeOtherPlaceLogin object:nil];
}

//连接融云
- (void)connectRongCloud{
    //如果已经登录过则有token，否则登录后要重新登录下
    [[RCDLive sharedRCDLive] connectRongCloudWithToken:[UserHelper getRongCloudToken] success:^(NSString *userId) {
        DLog(@"融云登录成功");
    } error:^(RCConnectErrorCode status) {
        DLog(@"融云登录失败");
    } tokenIncorrect:^{
        DLog(@"融云登录Token错误");
    }];
}

#pragma mark - ============异地登录处理===========
- (void)noticeOtherPlaceLogin{
    DLog(@"异地登录，强制下线");
    [UserHelper logout];
    //退出融云
    [[RCDLive sharedRCDLive] logoutRongCloud];
    [self judgeLogin];//跳出登录界面
    [LCProgressHUD showFailure:@"您的账号在其他设备登录"];
}

#pragma mark - ================= 支付宝&微信支付 =================
//微信支付 重写AppDelegate的handleOpenURL和openURL方法
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSString *urlStr = [options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    
    
    if ([urlStr isEqualToString:@"com.tencent.xin"])
    {   //  微信支付
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            id resultStatus = [resultDic objectForKey:@"resultStatus"];
            switch ([resultStatus integerValue]) {
                case 9000:
                    //支付成功
                    [LCProgressHUD showSuccess:@"支付成功"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAliPayResultSuccess object:nil];
                    break;
                case 4000:
                    [LCProgressHUD showFailure:@"支付失败"];
                    break;
                case 6001:
                    [LCProgressHUD showMessage:@"支付取消"];
                    break;
                case 6002:
                    [LCProgressHUD showMessage:@"网络连接失败"];
                    break;
                default:
                    break;
            }
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"com.tencent.xin"])
    {   //  微信支付
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return YES;
}

//WXApiDelegate
-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {
                // 支付成功后发送通知，在控制器里面进行操作
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWexinPayResultSuccess object:nil];
                NSLog(@"支付成功");
                
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                NSLog(@"支付失败");
                [LCProgressHUD showFailure:@"支付失败"];
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSLog(@"取消支付");
                [LCProgressHUD showFailure:@"取消支付"];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                [LCProgressHUD showFailure:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                [LCProgressHUD showFailure:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                [LCProgressHUD showFailure:@"授权失败"];
            }
                break;
            default:
                break;
        }
    }else{
        NSLog(@"error -- %@",resp);
    }
}

#pragma mark - 集成shareSDK
- (void)registerShareSDK{
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
     onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx91737bff344d87aa"
                                       appSecret:@"5e3a4d34662c928813290df6a30fd65d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106055212"
                                      appKey:@"D5Hw9mvdniDCk8ht"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - 敏感词获取
- (void)requestLiveKeyWords{
    [LHConnect postLiveKeyWords:nil loading:nil success:^(id  _Nonnull response) {
        [UserHelper setLiveKeyWords:response];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//使用AFN框架来检测网络状态的改变
-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {//1-无网络 2-数据网络 3-wifi 其他-未知网络
            case AFNetworkReachabilityStatusUnknown://未知
                [LCProgressHUD showMessage:@"未知网络连接"];
                [UserHelper setNetStatus:0];
                break;
            case AFNetworkReachabilityStatusNotReachable://没有网络
                [LCProgressHUD showFailure:@"似乎断开了网络连接!"];
                [UserHelper setNetStatus:1];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://数据网络
                [LCProgressHUD showMessage:@"数据网络连接"];
                [UserHelper setNetStatus:2];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://wifi
                [LCProgressHUD showMessage:@"wifi连接"];
                [UserHelper setNetStatus:3];
                break;
                
            default:
                break;
        }
    }];
    //3.开始监听
    [manager startMonitoring];
}

//发送上次错误信息
- (void)sendErrorInfo{
    NSString *errorStr = [UserHelper getAppErrorInfo];
    errorStr = [errorStr URLEncodedString];
    
    if (errorStr.length == 0) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:errorStr forKey:@"content"];
    [LHConnect postAppErrorInfo:params loading:nil success:^(id  _Nonnull response) {
       
    } successBackFail:^(id  _Nonnull response) {
        
    }];
    [UserHelper setAppErrorInfo:@""];//清空错误信息
}

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"====异常错误报告=====\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    [UserHelper setAppErrorInfo:content];
}
@end
