//
//  StreamingViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/3.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StreamingViewController.h"
#import <VideoCore/VideoCore.h>
#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "StreamingStartView.h"
#import "StreamStreamingView.h"
#import "StreamingEndView.h"
#import "CNPPopupController.h"
#import "CloseStreamingPopView.h"
#import "LiveRoomModel.h"
#import "RoomUserModel.h"
#import "StreamSharePopView.h"
#import "UserHelper.h"
#import "HHAlertController.h"
#import "ShareModel.h"

@interface StreamingViewController ()<VCSessionDelegate,StreamStartViewDelegate, StreamStreamingViewDelegate>

@property (nonatomic, strong) StreamingStartView *startView;
@property (nonatomic, strong) StreamStreamingView *streamingView;
@property (nonatomic, strong) StreamingEndView *endView;
@property (nonatomic, strong) NSTimer *timer; //刷新房间信息定时器
//弹窗
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) CloseStreamingPopView *closePopView;
@property (nonatomic, strong) StreamSharePopView *sharePopView;
@property (nonatomic, strong) CNPPopupController *sharePopController;
@property (nonatomic, assign) BOOL isBacking, isStart;
@property (nonatomic, strong) LiveRoomModel *roomModel;
@property (nonatomic, assign) int restartCount; //记录重新连接次数
@property (nonatomic, strong) NSDate *startDate; //直播开始时间

@end

@implementation StreamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//屏幕常亮
    self.restartCount = 0;
    self.isBacking = NO;
    [self.model setupSession:[self cameraOrientation] delegate:self];
    [self.model preview:self.view];
    
    [self.view addSubview:self.startView];
    //请求房间数据
    [self requestLiveRoomInfoWihtEnd:NO];
}

- (void)viewDidLayoutSubviews {
    [self.model updateFrame:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (AVCaptureVideoOrientation)cameraOrientation {
    return AVCaptureVideoOrientationPortrait;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//屏幕常亮
    [IQKeyboardManager sharedManager].enable = YES;
    
    if (self.isLandScape){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowLandscapeRight = NO;
        //强制旋转成竖屏
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

//开始界面
- (StreamingStartView *)startView{
    if (!_startView){
        _startView = [[StreamingStartView alloc] initWithFrame:self.view.bounds andIsLandScape:self.isLandScape];
        _startView.delegate = self;
        _startView.imageUrl = self.imageUrl;//封面地址
    }
    return _startView;
}
//直播界面
- (StreamStreamingView *)streamingView{
    if (!_streamingView){
        _streamingView = [[StreamStreamingView alloc] initWithFrame:self.view.frame targetId:self.targetId isLandScape:self.isLandScape];
        _streamingView.delegate = self;
        [self requestRoomUsersInfo];
        [self requestLiveRoomInfoWihtEnd:NO];
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(requestRoomUsersInfo) userInfo:nil repeats:YES];
        self.startDate = [NSDate date];//直播开始时间
    }
    return _streamingView;
}
//结束界面
- (StreamingEndView *)endView{
    if(!_endView){
        _endView = [[StreamingEndView alloc] initWithFrame:self.view.frame andIsLandscape:self.isLandScape];
        __weak typeof (self) weakSelf = self;
        _endView.closeBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _endView;
}

//关闭弹窗
- (CloseStreamingPopView *)closePopView{
    if (!_closePopView){
        _closePopView = [[NSBundle mainBundle] loadNibNamed:@"CloseStreamingPopView" owner:self options:nil].firstObject;
        __weak typeof (self) weakSelf = self;
        _closePopView.block = ^(BOOL isSure) {
            [weakSelf.popupController dismissPopupControllerAnimated:YES];
            if (isSure){
                weakSelf.isBacking = YES;
                BOOL result = [weakSelf.model back];
                if (!result) {
                    [weakSelf finishStreaming];
                }
            }
        };
    }
    return _closePopView;
}

- (StreamSharePopView *)sharePopView{
    if (!_sharePopView){
        ShareModel *shareModel = [[ShareModel alloc] init];
        shareModel.title = self.roomModel.share_title;
        shareModel.content = self.roomModel.share_dec;
        shareModel.imageUrl = self.roomModel.share_img;
        shareModel.shareUrl = self.roomModel.share_url;
        _sharePopView = [[StreamSharePopView alloc] initWithFrame:CGRectMake(0, 0, 250, 120) andShareModel:shareModel];
        __weak typeof (self) weakSelf = self;
        _sharePopView.block = ^{
            [weakSelf.sharePopController dismissPopupControllerAnimated:YES];
        };
    }
    return _sharePopView;
}

#pragma mark - VCSessionDelegate
- (void) connectionStatusChanged: (VCSessionState) sessionState {
    switch(sessionState) {
        case VCSessionStatePreviewStarted:
            [self.model toggleBeauty];//开始后开启美颜
            break;
        case VCSessionStateStarting:
            DLog(@"准备推流\n");
            self.isStart = YES;
            break;
        case VCSessionStateStarted:
            DLog(@"开始推流\n");
            self.isStart = YES;
            break;
        case VCSessionStateError:
            DLog(@"推流出错\n");
            self.isStart = NO;
            //如果出错了则重新推流(尝试连接3次后弹窗提醒)
            if (self.restartCount <= 2){
                //延时1s重新连接
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.model toggleStream];//开始
                    self.restartCount++;
                    DLog(@"重新连接次数：%d",self.restartCount);
                });
                
            }else {
                [self showErrorAlert];
            }
            break;
        case VCSessionStateEnded:
            DLog(@"推流结束\n");
            self.isStart = NO;
            if (self.isBacking) {
                self.isBacking = NO;
                [self finishStreaming];
            }
            break;
        default:
            break;
    }
}

- (void)onError:(VCErrorCode)error{
    DLog(@"推流错误error:%ld",(long)error);
}
#pragma mark - StreamStartViewDelegate 开始界面代理
- (void)streamingStartViewBtnAction:(StrStartViewBtnType)type{
    switch (type) {
        case StrStartViewBtnTypeStart://开始
        {//1-无网络 2-数据网络 3-wifi 其他-未知网络
            if ((int)[UserHelper getNetStatus] == 2){
                [self showNetAlert];
            }else {
                [self startStreaming];
            }
        }
            break;
        case StrStartViewBtnTypeClose://关闭
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case StrStartViewBtnTypeCamera://摄像头
            [self.model switchCamera];
            break;
        default:
            break;
    }
}

//推流界面
- (void)streamingViewBtnAction:(StreamStreamingViewBtnType)type{
    switch (type) {
        case StrStreamingViewBtnTypeClose://关闭
            self.popupController = [[CNPPopupController alloc] initWithContents:@[self.closePopView]];
            self.popupController.theme.backgroundColor = [UIColor clearColor];
            [self.popupController presentPopupControllerAnimated:YES];
            break;
        case StrStreamingViewBtnTypeBeauty://美颜
        {
            BOOL toggle = [self.model toggleBeauty];
            [self.streamingView showBeautyBtnImageWithIsOn:toggle];
        }
            break;
        case StrStreamingViewBtnTypeShare://分享
            self.sharePopController = [[CNPPopupController alloc] initWithContents:@[self.sharePopView]];
            self.sharePopController.theme.backgroundColor = [UIColor clearColor];
            self.sharePopController.theme.popupStyle = CNPPopupStyleActionSheet;
            self.sharePopController.theme.shouldDismissOnBackgroundTouch = YES;
            [self.sharePopController presentPopupControllerAnimated:YES];
            break;
        case StrStreamingViewBtnTypeApp://应用
            [LCProgressHUD showMessage:@"功能开发中"];
            break;
        case StrStreamingViewBtnTypeCamera://摄像头
            [self.model switchCamera];
            break;
        default:
            break;
    }
}

//开始直播
- (void)startStreaming{
    [self.startView removeFromSuperview];
    [self.view addSubview:self.streamingView];
    [self.model toggleStream];//开始
}

//直播结束
- (void)finishStreaming{
    [_timer invalidate];
    _timer = nil;
    [self.streamingView removeFromSuperview];
    [self.streamingView quiteChatRoom];//退出聊天室
    [self requestLiveRoomInfoWihtEnd:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeHaveNewVideoData object:nil];
    [self.view addSubview:self.endView];
}

- (void)showErrorAlert{
    __weak typeof (self) weakSelf = self;
     HHAlertController *alert = [HHAlertController alertWithTitle:@"哎呀！直播出了点问题～"
                                                          message:@"点击尝试重新连接"
                                                  sureButtonTitle:@"重新连接"
                                                cancelButtonTitle:@"结束直播"
                                                       sureHandel:^{
                                                            [weakSelf.model toggleStream];//开始
                                                       } cancelHandel:^{
                                                           weakSelf.isBacking = YES;
                                                           BOOL result = [weakSelf.model back];
                                                           if (!result) {
                                                               [weakSelf finishStreaming];
                                                           }
                                                       }];
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showNetAlert{
    __weak typeof (self) weakSelf = self;
    HHAlertController *alert = [HHAlertController alertWithTitle:@"网络状态提示"
                                                         message:@"你现在在使用流量，确定要直播吗？"
                                                 sureButtonTitle:@"确定直播"
                                               cancelButtonTitle:@"取消直播"
                                                      sureHandel:^{
                                                          [weakSelf startStreaming];//开始
                                                      } cancelHandel:^{
                                                          
                                                      }];
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -网络数据 - 详情数据
//房间数据(分开始和结束时，默认开始时的数据)
- (void)requestLiveRoomInfoWihtEnd:(BOOL)isEndView{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetId forKey:@"id"];
    [LHConnect postLiveRoomInfo:params loading:@"加载中..." success:^(id  _Nonnull response) {
         _roomModel = [LiveRoomModel mj_objectWithKeyValues:response];
        if (isEndView){
            self.endView.model = _roomModel;
            self.endView.startDate = self.startDate;
            self.endView.peopleCount = self.streamingView.joinNum;//进入人数
        }else {
            self.startView.model = _roomModel;
            if (_streamingView){
                _streamingView.topView.roomModel = _roomModel;
            }
        }
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//获得观众列表
- (void)requestRoomUsersInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetId forKey:@"id"];
    [LHConnect postLiveRoomUsers:params loading:nil success:^(id  _Nonnull response) {
        RoomUserModel *userModel = [RoomUserModel mj_objectWithKeyValues:response];
        self.streamingView.topView.userModel = userModel;
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
