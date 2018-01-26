//
//  StreamingStartView.m
//  Find
//
//  Created by chh on 2017/8/21.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "StreamingStartView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CNPPopupController.h"
#import "LabelNoticePopView.h"
#import "LocationSettingPopView.h"
#import "CloseStreamingPopView.h"
#import "SecretPsdPopView.h"
#import <CoreLocation/CoreLocation.h>
#import "FL_Button.h"
#import "ShareTools.h"
#import "ShareModel.h"

#define TOTAL_NUM  15
@interface StreamingStartView()<UITextFieldDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) LabelNoticePopView *locationPopupView;
@property (nonatomic, strong) LocationSettingPopView *locationSettingPopView;
@property (nonatomic, strong) SecretPsdPopView *srcretPopView;
@property (nonatomic, strong) CloseStreamingPopView *closeStrPopView;
@property (nonatomic, strong) FL_Button *locationBtn, *reverseBtn, *secretBtn, *closeBtn, *startBtn;//定位、反转、私密、关闭、横屏、竖屏、开始
@property (nonatomic, strong) FL_Button *qqBtn, *wechatBtn, *friendsBtn;
@property (nonatomic, strong) CLLocationManager *locationManager; //定位
@property (nonatomic, assign) BOOL isLocationed; //是否定位过
@property (nonatomic, assign) BOOL isCanLocate;

@property (nonatomic, strong) NSString *province, *city, *county;//省市区
@property (nonatomic, assign) double lng, lat; //经度，纬度
@property (nonatomic, strong) ShareModel *shareModel;
@property (nonatomic, assign) BOOL isLandScape;
@property (nonatomic, strong) NSString *password;//私密密码
@end

@implementation StreamingStartView
- (instancetype)initWithFrame:(CGRect)frame andIsLandScape:(BOOL)landScape{
    if (self = [super initWithFrame:frame]){
        self.province = @"";
        self.city = @"";
        self.county = @"";
        self.isLandScape = landScape;
        [self initView];
        [self startLocation];
        //监听输入
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:_titleField];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setAllFrame];
}

- (void)initView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTap)];
    [self addGestureRecognizer:aTap];
    
    _locationBtn = [self creatImageButtonWithImageStr:@"s_location_16x15" andTitle:@"定位中" andType:StrStartViewBtnTypeLocation];
    
    _reverseBtn = [self creatImageButtonWithImageStr:@"s_camera_16x15" andTitle:@" 翻转" andType:StrStartViewBtnTypeCamera];
    
    _secretBtn = [self creatImageButtonWithImageStr:@"s_secret_16x15" andTitle:@"开私密" andType:StrStartViewBtnTypeSecret];
    
    _closeBtn = [self creatImageButtonWithImageStr:@"s_close_17" andTitle:@"" andType:StrStartViewBtnTypeClose];
    
    _noticeLabel = [[UILabel alloc] init];
    _noticeLabel.font = [UIFont systemFontOfSize:18];;
    _noticeLabel.text = @"— 会显示在开播推送消息中 —";
    _noticeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_noticeLabel];
    
    _titleField = [[UITextField alloc] init];
    _titleField.font = [UIFont boldSystemFontOfSize:23];
    _titleField.delegate = self;
    _titleField.placeholder = @"给直播写个标题吧(15字以内)";
    _titleField.textAlignment = NSTextAlignmentCenter;
    _titleField.textColor = [UIColor whiteColor];
    _titleField.returnKeyType = UIReturnKeyDone;
    [_titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_titleField];

    _startBtn = [[FL_Button alloc] init];
    [_startBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    _startBtn.backgroundColor = [UIColor themeColor];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:18];;
    _startBtn.layer.cornerRadius = 20;
    _startBtn.tag = StrStartViewBtnTypeStart;
    [_startBtn  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startBtn];
   
    _qqBtn = [self creatImageButtonWithImageStr:@"s_qq_23x23" andTitle:@"" andType:StrStartViewBtnTypeShareQQ];
    _wechatBtn = [self creatImageButtonWithImageStr:@"s_weixin_23x23" andTitle:@"" andType:StrStartViewBtnTypeShareWechat];
    _friendsBtn = [self creatImageButtonWithImageStr:@"s_friends_23x23" andTitle:@"" andType:StrStartViewBtnTypeShareFriends];
    
}

- (void)setAllFrame{
    
    if (self.isLandScape){//横屏
        [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
        }];
    }else {
        [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(StatusBarHeight);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
        }];
    }
    
    [_reverseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationBtn.mas_right).offset(10);
        make.centerY.equalTo(_locationBtn);
        make.width.mas_equalTo(70);
        make.height.equalTo(_locationBtn);
    }];
    
    [_secretBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reverseBtn.mas_right).offset(10);
        make.centerY.equalTo(_locationBtn);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(_locationBtn);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(_locationBtn);
        make.right.equalTo(self);
    }];

    
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.centerX.equalTo(self);
        make.bottom.equalTo(_noticeLabel.mas_top).offset(-10);
    }];
    
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(40);
    }];
    
    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self);
        make.bottom.equalTo(_startBtn.mas_top).offset(-10);
    }];
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_wechatBtn);
        make.centerY.equalTo(_wechatBtn);
        make.right.equalTo(_wechatBtn.mas_left).offset(-5);
    }];
    [_friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_wechatBtn);
        make.centerY.equalTo(_wechatBtn);
        make.left.equalTo(_wechatBtn.mas_right);
    }];
}

- (ShareModel *)shareModel{
    if (!_shareModel){
        _shareModel = [[ShareModel alloc] init];
        _shareModel.title = self.model.share_title;
        _shareModel.content = self.model.share_dec;
        _shareModel.imageUrl = self.model.share_img;
        _shareModel.shareUrl = self.model.share_url;
    }
    return _shareModel;
}

- (void)startLocation{
    [self.locationManager requestWhenInUseAuthorization];
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]){
        //开始定位用户位置
        [self.locationManager startUpdatingLocation];
        //精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }else {
        //不能定位
        self.isCanLocate = NO;
    }
}

/**
 定位弹窗
 */
- (LabelNoticePopView *)locationPopupView{
    if (!_locationPopupView){
        _locationPopupView = [[LabelNoticePopView alloc] initWithFrame:CGRectMake(0, 0, 270, 120) andType:LabelNoticePopViewLocation];
        __weak typeof (self) weakSelf = self;
        _locationPopupView.block = ^(BOOL isSure) {
            [weakSelf.popupController dismissPopupControllerAnimated:YES];
            if (isSure){//确定
               [weakSelf.locationBtn setTitle:@"定位关" forState:UIControlStateNormal];
                weakSelf.isLocationed = NO;
            }
        };
    }
    return _locationPopupView;
}

/**
 定位权限
 */
- (LocationSettingPopView *)locationSettingPopView{
    if (!_locationSettingPopView){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LocationSettingPopView" owner:self options:nil];
        //得到第一个UIView
        _locationSettingPopView = [nib firstObject];
        __weak typeof (self) weakSelf = self;
        _locationSettingPopView.block = ^(BOOL isSure){
            [weakSelf.popupController dismissPopupControllerAnimated:YES];
            if (isSure){
                //打开设置界面
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        };
    }
    return _locationSettingPopView;
}
/**
 开启定位
 */
- (CLLocationManager *)locationManager{
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
/**
 私密密码弹窗
 */
- (SecretPsdPopView *)srcretPopView{
    if (!_srcretPopView){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SecretPsdPopView" owner:self options:nil];
        //得到第一个UIView
        _srcretPopView = [nib firstObject];
        __weak typeof (self) weakSelf = self;
        _srcretPopView.block = ^(NSString *str){
            weakSelf.password = str;
            [weakSelf endEditing:YES];
            [weakSelf.popupController dismissPopupControllerAnimated:YES];
        };
    }
    return _srcretPopView;
}


/**
 关闭按钮
 */
- (CloseStreamingPopView *)closeStrPopView{
    if (!_closeStrPopView){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CloseStreamingPopView" owner:self options:nil];
        //得到第一个UIView
        _closeStrPopView = [nib firstObject];
        __weak typeof (self) weakSelf = self;
        _closeStrPopView.block = ^(BOOL isSure){
            [weakSelf.popupController dismissPopupControllerAnimated:YES];
        };
    }
    return _closeStrPopView;
}

- (FL_Button *)creatImageButtonWithImageStr:(NSString *)imageStr andTitle:(NSString *)title andType:(StrStartViewBtnType) buttonType{
    FL_Button *button = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusLeft];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = buttonType;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}


- (FL_Button *)creatTopButtonWithImageStr:(NSString *)imageStr highlightImage:(NSString *)highligth andTitle:(NSString *)title andType:(StrStartViewBtnType) buttonType andSpace:(CGFloat)space{
    FL_Button *button = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusTop];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highligth] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = buttonType;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:space];
    [self addSubview:button];
    return button;
}

#pragma mark - CLLocationManagerDelegate 定位代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //定位失败
    //用户没有开启权限
    if (error.code == kCLErrorDenied){
        NSLog(@"定位失败");
        _isCanLocate = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_locationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //定位一次就好
    if (self.isLocationed) return;
    self.isCanLocate = YES;
    [_locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    DLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    self.lng = currentLocation.coordinate.longitude;//经度
    self.lat = currentLocation.coordinate.latitude;//纬度
    
    _isLocationed = YES;
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
           NSString *_currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"未获取";
            }
            //看需求定义一个全局变量来接收赋值
//            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
//            NSLog(@"当前省份 - %@",placeMark.administrativeArea);//当前省份
//            NSLog(@"当前城市 - %@",_currentCity);//当前城市
//            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
//            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
//            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
            
            self.province = placeMark.administrativeArea;
            self.city = placeMark.locality;
            self.county = placeMark.subLocality;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_locationBtn setTitle:_currentCity forState:UIControlStateNormal];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_locationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
            });
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

//通知
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > TOTAL_NUM)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:TOTAL_NUM];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:TOTAL_NUM];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, TOTAL_NUM)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)aTap{
    [self endEditing:YES];
}

- (void)buttonAction:(UIButton *)button{
    
    switch (button.tag) {
        case StrStartViewBtnTypeLocation://定位
            if (self.isCanLocate){//定位是否允许
                if (self.isLocationed){//关闭定位弹窗
                    self.popupController = [[CNPPopupController alloc] initWithContents:@[self.locationPopupView]];
                    [self.popupController presentPopupControllerAnimated:YES];
                }else {
                    [self.locationManager startUpdatingLocation];//再次定位
                }
                
            }else {//弹窗提醒
                self.popupController = [[CNPPopupController alloc] initWithContents:@[self.locationSettingPopView]];
                [self.popupController presentPopupControllerAnimated:YES];
            }
            break;
        case StrStartViewBtnTypeSecret: //开私密
            self.popupController = [[CNPPopupController alloc] initWithContents:@[self.srcretPopView]];
            [self.popupController presentPopupControllerAnimated:YES];
            return;
        case StrStartViewBtnTypeStart://开始
        {
            if (self.titleField.text.length == 0){
                [LCProgressHUD showFailure:@"请填写直播间名字"];
                return;
            }
            [self postRoomInfo];
        }
            break;
        case StrStartViewBtnTypeShareQQ://分享到QQ
            if (self.titleField.text.length == 0){
                [LCProgressHUD showFailure:@"请填写直播间名字"];
                return;
            }
            self.shareModel.title = self.titleField.text;
            [ShareTools shareToQQWithParams:self.shareModel];
            return;
        case StrStartViewBtnTypeShareWechat://分享到微信
            if (self.titleField.text.length == 0){
                [LCProgressHUD showFailure:@"请填写直播间名字"];
                return;
            }
            self.shareModel.title = self.titleField.text;
            [ShareTools shareToWeixinWithParams:self.shareModel];
            return;
        case StrStartViewBtnTypeShareFriends://分享到朋友圈
            if (self.titleField.text.length == 0){
                [LCProgressHUD showFailure:@"请填写直播间名字"];
                return;
            }
            self.shareModel.title = self.titleField.text;
            [ShareTools shareToFriendsWithParams:self.shareModel];
            return;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(streamingStartViewBtnAction:)]){
        [self.delegate streamingStartViewBtnAction:button.tag];
    }
}

//上传房间信息
- (void)postRoomInfo{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.province forKey:@"province"];//省
    [params setValue:self.city forKey:@"city"];//市
    [params setValue:self.county forKey:@"county"];//区
    [params setValue:@(self.lng) forKey:@"lng"];//经度
    [params setValue:@(self.lat) forKey:@"lat"];//纬度
    [params setValue:self.titleField.text forKey:@"text"];//直播间名字
    [params setValue:self.imageUrl forKey:@"bg"];//背景图片
    [params setValue:self.password forKey:@"pwd"];//密码
    [LHConnect postLiveUpdateMyRoom:params loading:nil success:^(id  _Nonnull response) {
        DLog(@"房间信息上传成功");
    } successBackFail:^(id  _Nonnull response) {
    }];
}
@end
