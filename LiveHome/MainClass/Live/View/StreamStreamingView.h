//
//  StreamStreamingView.h
//  LiveHome
//
//  Created by chh on 2017/11/5.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamingTopView.h"
#import <RongIMLib/RongIMLib.h>

typedef NS_ENUM(NSUInteger, StreamStreamingViewBtnType){
    StrStreamingViewBtnTypeClose        = 0,    //关闭
    StrStreamingViewBtnTypeShare        = 1,    //分享
    StrStreamingViewBtnTypeChat         = 2,    //聊天
    StrStreamingViewBtnTypeBeauty       = 3,    //美颜
    StrStreamingViewBtnTypeApp          = 4,    //应用
    StrStreamingViewBtnTypeCamera       = 5,    //摄像头
};
@protocol StreamStreamingViewDelegate <NSObject>
- (void)streamingViewBtnAction:(StreamStreamingViewBtnType)type;
@end

@interface StreamStreamingView : UIView
@property (nonatomic, weak) id<StreamStreamingViewDelegate> delegate;
@property (nonatomic, strong) StreamingTopView *topView;
@property (nonatomic, assign, readonly) int joinNum; //进入直播间的人数
/**
 初始化
 @param frame frame
 @param targetId 聊天室id
 @param isLandScape 横竖屏
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame targetId:(NSString *)targetId isLandScape:(BOOL)isLandScape;
//根据开关状态更改图片
- (void)showBeautyBtnImageWithIsOn:(BOOL)isOn;

/** 退出聊天室*/
- (void)quiteChatRoom;
/** 发送消息 */
- (void)sendMessage:(RCMessageContent *)messageContent;
@end
