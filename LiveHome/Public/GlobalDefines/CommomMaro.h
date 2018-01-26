//
//  CommomMaro.h
//  LiveHome
//
//  Created by chh on 2017/11/16.
//  Copyright © 2017年 chh. All rights reserved.
//

#ifndef CommomMaro_h
#define CommomMaro_h

//融云生产环境Appkey
#define RongIMAppKey_Pro @"e5t4ouvptxdja"
//微信开发者ID
#define WX_APPID @"wx340a4adc541c5e3d"
//支付宝支付scheme（和Info.plist-URL Types 保持一致）
#define AliPayScheme @"LiveHomeAlipay"

#define ReviewAccount @"18925688057" //测试帐号

#pragma mark - 通知
/** 登录成功通知 */
#define NoticeLoginSuccess     @"NoticeLoginSuccess"

//异地登录通知(通过融云处理)
#define NoticeOtherPlaceLogin  @"NoticeOtherPlaceLogin"

//直播结束后通知首页更新历史视频
#define NoticeHaveNewVideoData @"NoticeHaveNewVideoData"

#endif /* CommomMaro_h */
