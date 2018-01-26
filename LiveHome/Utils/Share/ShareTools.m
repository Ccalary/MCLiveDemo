//
//  ShareTools.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "ShareTools.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface ShareTools()
@end

@implementation ShareTools

+ (void)shareToQQWithParams:(ShareModel *)model{
    
    [self shareFounctionWith:SSDKPlatformSubTypeQQFriend andModel:model];
}

+ (void)shareToWeixinWithParams:(ShareModel *)model{
    
    [self shareFounctionWith:SSDKPlatformSubTypeWechatSession andModel:model];
}

+ (void)shareToFriendsWithParams:(ShareModel *)model{
    
    [self shareFounctionWith:SSDKPlatformSubTypeWechatTimeline andModel:model];
}

+ (void)shareFounctionWith:(SSDKPlatformType)type andModel:(ShareModel *)model{
    //1、创建分享参数
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:model.content
                                     images:model.imageUrl
                                        url:[NSURL URLWithString:model.shareUrl]
                                      title:model.title
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [LCProgressHUD showKeyWindowSuccess:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [LCProgressHUD showKeyWindowFailure:@"分享失败"];
                break;
            }
            default:
                break;
        }
    }];
}
@end
