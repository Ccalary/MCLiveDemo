//
//  StreamStreamingView.m
//  LiveHome
//
//  Created by chh on 2017/11/5.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StreamStreamingView.h"
#import "CountdownLabel.h"
#import "RCDLiveChatListView.h"
#import "RCDLiveInputBar.h"
#import "ToolsHelper.h"

//输入框的高度
#define MinHeight_InputView 50.0f

@interface StreamStreamingView()<RCTKInputBarControlDelegate>
@property (nonatomic, strong) UIButton *beautyBtn;
@property (nonatomic, strong) CountdownLabel *countdownLabel;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) UIView *contentView; //承载listView和InputBar
@property (nonatomic, strong) RCDLiveChatListView *chatListView;
//输入工具栏
@property (nonatomic, strong) RCDLiveInputBar *inputBar;
@property (nonatomic, strong) NSString *targetId; //聊天室id
@property (nonatomic, assign) BOOL isLandScape;
@end

@implementation StreamStreamingView
- (instancetype)initWithFrame:(CGRect)frame targetId:(NSString *)targetId isLandScape:(BOOL)isLandScape{
    if (self = [super initWithFrame:frame]){
  
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (size.width > size.height){
            _rate = size.height/375.0;
        }else {
            _rate = size.width/375.0;
        }
        self.targetId = targetId;
        self.isLandScape = isLandScape;
        [self initTopView];
        [self initContenView];
        [self initBtnView];
        [self addSubview:self.countdownLabel];
    }
    return self;
}

- (int)joinNum{
    return self.chatListView.joinNum;
}

- (void)initTopView{
    if (self.isLandScape){
         self.topView = [[StreamingTopView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 70*self.rate) andItemWidth:30*self.rate];
    }else {
         self.topView = [[StreamingTopView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, self.frame.size.width, 70*self.rate) andItemWidth:30*self.rate];
    }
   
    [self addSubview:self.topView];
    [self.topView.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-35);
    }];
}

- (void)initContenView{
    //适配iPhoneX
    CGFloat offsetX;
    if (self.isLandScape && [ToolsHelper isiPhoneX]){
        offsetX = 44;
    }else{
        offsetX = 0;
    }
    CGRect contentViewFrame = CGRectMake(offsetX, self.bounds.size.height-237, self.bounds.size.width,237);
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
    [self addSubview:self.contentView];
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapAction:)];
    [self addGestureRecognizer:aTap];
    
    self.chatListView = [[RCDLiveChatListView alloc] initWithFrame:CGRectMake(0, 0, 300*_rate, self.contentView.bounds.size.height - 50) andTargetId:self.targetId];
    [self.contentView addSubview:self.chatListView];
    //输入工具栏
    self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(0, self.chatListView.bounds.size.height + 30, self.contentView.frame.size.width,MinHeight_InputView)];
    self.inputBar.delegate = self;
    self.inputBar.backgroundColor = [UIColor clearColor];
    self.inputBar.hidden = YES;
    [self.contentView addSubview:self.inputBar];
}

//倒计时
- (CountdownLabel *)countdownLabel{
    if (!_countdownLabel){
        _countdownLabel = [[CountdownLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _countdownLabel.center = self.center;
        [_countdownLabel startCount];
    }
    return _countdownLabel;
}

//按钮
- (void)initBtnView{
    
    UIButton *closeBtn = [self createButtonWithImageStr:@"s_close_17" andType:StrStreamingViewBtnTypeClose];
    UIButton *appBtn = [self createButtonWithImageStr:@"s_app_32" andType:StrStreamingViewBtnTypeApp];
    UIButton *shareBtn = [self createButtonWithImageStr:@"s_share_32" andType:StrStreamingViewBtnTypeShare];
    _beautyBtn = [self createButtonWithImageStr:@"s_beauty_s_32" andType:StrStreamingViewBtnTypeBeauty];
    UIButton *cameraBtn = [self createButtonWithImageStr:@"s_camera_32" andType:StrStreamingViewBtnTypeCamera];
    UIButton *chatBtn = [self createButtonWithImageStr:@"s_chat_32" andType:StrStreamingViewBtnTypeChat];
    
    if (self.isLandScape){
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.right.equalTo(self).offset(0);
            make.top.offset(20);
        }];
        
    }else {
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.right.equalTo(self).offset(0);
            make.top.offset(StatusBarHeight);
        }];
    }
    
    [appBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.offset(-10);
        make.bottom.offset(-5);
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(appBtn);
        make.right.equalTo(appBtn.mas_left).offset(-10);
        make.centerY.equalTo(appBtn);
    }];
    
    [_beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(appBtn);
        make.right.equalTo(shareBtn.mas_left).offset(-10);
        make.centerY.equalTo(appBtn);
    }];
    
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(appBtn);
        make.right.equalTo(_beautyBtn.mas_left).offset(-10);
        make.centerY.equalTo(appBtn);
    }];
    
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(appBtn);
        make.left.offset(10);
        make.centerY.equalTo(appBtn);
    }];
}

//创建button
- (UIButton *)createButtonWithImageStr:(NSString *)imgStr andType:(StreamStreamingViewBtnType )type{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    button.tag = type;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

#pragma mark - Action
- (void)buttonAction:(UIButton *)button{
    
    switch (button.tag) {
        case StrStreamingViewBtnTypeChat://信息
        {
            self.inputBar.hidden = NO;
            [self.inputBar setInputBarStatus:RCDLiveBottomBarKeyboardStatus];
        }
            break;
        case StrStreamingViewBtnTypeClose://关闭
            [self setInputHidden];
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(streamingViewBtnAction:)]){
        [self.delegate streamingViewBtnAction:button.tag];
    }
}

//点击键盘消失
- (void)aTapAction:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setInputHidden];
    }
}

#pragma mark - 方法
//退出聊天室
- (void)quiteChatRoom{
    [self.chatListView quitConversationView];
}

//发送消息
- (void)sendMessage:(RCMessageContent *)messageContent{
    [self.chatListView sendMessage:messageContent pushContent:nil];
}

//根据开关状态更改图片
- (void)showBeautyBtnImageWithIsOn:(BOOL)isOn{
    if (isOn){
        [self.beautyBtn setImage:[UIImage imageNamed:@"s_beauty_s_32"] forState:UIControlStateNormal];
    }else {
        [self.beautyBtn setImage:[UIImage imageNamed:@"s_beauty_n_32"] forState:UIControlStateNormal];
    }
}

//隐藏输入框
- (void)setInputHidden{
    [self.inputBar setInputBarStatus:RCDLiveBottomBarDefaultStatus];
    self.inputBar.hidden = YES;
}

#pragma mark - 输入框代理事件
- (void)onTouchSendButton:(NSString *)text{
    RCTextMessage *rcTextMessage = [RCTextMessage messageWithContent:text];
    [self.chatListView sendTextMessage:rcTextMessage pushContent:nil];
    //清空输入框
    [self.inputBar clearInputView];
    [self setInputHidden];
}

- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    
    CGRect collectionViewRect = self.contentView.frame;

    collectionViewRect.origin.y = self.bounds.size.height - frame.size.height - 237 + 50;
    collectionViewRect.size.height = 237;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.contentView setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    
    CGRect inputbarRect = self.inputBar.frame;
    inputbarRect.origin.y = self.contentView.frame.size.height - 50;
    
    [self.inputBar setFrame:inputbarRect];
    [self bringSubviewToFront:self.inputBar];
    [self.chatListView scrollToBottomAnimated:NO];
}
@end
