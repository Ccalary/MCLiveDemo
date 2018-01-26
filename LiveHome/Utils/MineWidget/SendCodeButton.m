//
//  SendCodeButton.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "SendCodeButton.h"

@interface SendCodeButton()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int totalSeconds;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL isAuto;//是否自动开始
@end

@implementation SendCodeButton
- (instancetype)initWithTitle:(NSString *)title seconds:(int)seconds{
    if (self = [super init]){
        self.isAuto = YES;
        self.title = title;
        self.totalSeconds = seconds;
        [self setUp];
    }
    return self;
}

- (instancetype)initManualWithTitle:(NSString *)title seconds:(int)seconds{//手动开始
    if (self = [super init]){
        self.isAuto = NO;
        self.title = title;
        self.totalSeconds = seconds;
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title seconds:(int)seconds{
    if (self = [super initWithFrame:frame]){
        self.isAuto = YES;
        self.title = title;
        self.totalSeconds = seconds;
        [self setUp];
    }
    return self;
}


- (void)setUp{
    [self setTitle:self.title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)button{
    if (self.isAuto){//自动开始
       [self startCountdown];
    }
    //代理方法
    if ([self.delegate respondsToSelector:@selector(sendCodeButtonClick)]){
        [self.delegate sendCodeButtonClick];
    }
}

- (void)startCountdown{
    [self destroyTimer];//避免多次创建
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.num = self.totalSeconds;
}

//倒计时
- (void)countdown{
    self.num --;
    [self setTitle:[NSString stringWithFormat:@"%ds",self.num] forState:UIControlStateNormal];
    if (self.num <= 0){
        [self destroyTimer];
        [self setTitle:self.title forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
    }else {
        self.userInteractionEnabled = NO;
    }
}

//销毁计时器
- (void)destroyTimer{
    [_timer invalidate];
    _timer = nil;
}
@end
