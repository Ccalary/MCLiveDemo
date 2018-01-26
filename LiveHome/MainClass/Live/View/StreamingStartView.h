//
//  StreamingStartView.h
//  Find
//
//  Created by chh on 2017/8/21.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveRoomModel.h"

typedef NS_ENUM(NSInteger, StrStartViewBtnType) {
    StrStartViewBtnTypeLocation      = 0,    // 定位
    StrStartViewBtnTypeCamera        = 1,    //反转
    StrStartViewBtnTypeClose         = 2,    //关闭
    StrStartViewBtnTypeStart         = 3,    //开始
    StrStartViewBtnTypeShareQQ       = 4,    //分享 qq
    StrStartViewBtnTypeShareWechat   = 5,    //微信
    StrStartViewBtnTypeShareFriends  = 6,    //朋友圈
    StrStartViewBtnTypeSecret        = 7,    //私密
};

@protocol StreamStartViewDelegate <NSObject>
- (void)streamingStartViewBtnAction:(StrStartViewBtnType)type;
@end

@interface StreamingStartView : UIView
@property (nonatomic, strong) LiveRoomModel *model;
@property (nonatomic, weak) id<StreamStartViewDelegate> delegate;
@property (nonatomic, copy) NSString *imageUrl; //封面地址
- (instancetype)initWithFrame:(CGRect)frame andIsLandScape:(BOOL)landScape;
@end
