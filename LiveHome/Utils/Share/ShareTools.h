//
//  ShareTools.h
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"


@interface ShareTools : NSObject

/**
 分享到QQ
 @param model 配置参数
 */
+ (void)shareToQQWithParams:(ShareModel *)model;

/**
 分享到微信
 @param model 配置参数
 */
+ (void)shareToWeixinWithParams:(ShareModel *)model;


/**
 分享到朋友圈
 @param model 配置参数
 */
+ (void)shareToFriendsWithParams:(ShareModel *)model;
@end
