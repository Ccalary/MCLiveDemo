//
//  StreamingViewController.h
//  LiveHome
//
//  Created by chh on 2017/11/3.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamingViewModel.h"

@interface StreamingViewController : UIViewController
@property (nonatomic, strong) StreamingViewModel *model;

#pragma mark - 会话属性
/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

/*!
 屏幕方向
 */
@property(nonatomic, assign) BOOL isLandScape;//是否横屏
/** 图片资源*/
@property (nonatomic, copy) NSString *imageUrl;
@end
