//
//  SendCodeButton.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SendCodeButtonDelegate<NSObject>
- (void)sendCodeButtonClick;
@end

@interface SendCodeButton : UIButton
@property (nonatomic, weak) id<SendCodeButtonDelegate> delegate;

/**
 初始化 (自动布局使用)

 @param title 按钮标题
 @param seconds 总倒计时时间
 @return 实例
 */
- (instancetype)initWithTitle:(NSString *)title seconds:(int)seconds;


/**
 初始化 (自动布局使用), 手动调用开始
 
 @param title 按钮标题
 @param seconds 总倒计时时间
 @return 实例
 */
- (instancetype)initManualWithTitle:(NSString *)title seconds:(int)seconds;

/**
 常规初始化

 @param frame 布局
 @param title 按钮标题
 @param seconds 总倒计时间
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title seconds:(int)seconds;

//开始
- (void)startCountdown;
@end
