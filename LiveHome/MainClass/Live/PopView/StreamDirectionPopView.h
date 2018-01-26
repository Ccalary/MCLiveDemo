//
//  StreamDirectionPopView.h
//  LiveHome
//
//  Created by chh on 2017/11/10.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, StreamDirPopViewBtnType) {
    StreamDirPopViewBtnTypePhoto           = 1,    //选择封面
    StreamDirPopViewBtnTypeHorizontal      = 2,    //横屏
    StreamDirPopViewBtnTypeVertical        = 3,     //竖屏
    StreamDirPopViewBtnTypeResolution480P  = 4,     //分辨率480P
    StreamDirPopViewBtnTypeResolution720P  = 5      //分辨率720P
};

@protocol StreamDirectionPopViewDelegate<NSObject>
- (void)streamPopViewBtnActionWithType:(StreamDirPopViewBtnType)type;
@end

@interface StreamDirectionPopView : UIView
@property (nonatomic, weak) id<StreamDirectionPopViewDelegate> delegate;

@property (nonatomic, strong) UIImage *bannerImage;
@end
