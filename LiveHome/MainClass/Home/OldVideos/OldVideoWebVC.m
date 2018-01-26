//
//  OldVideoWebVC.m
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "OldVideoWebVC.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "UserHelper.h"
#import "ShareModel.h"
#import "StreamSharePopView.h"
#import "CNPPopupController.h"
#import "FBKVOController.h"
#define DEFAULT_USER_AGENT @"Mozilla/5.0 (iPhone 6) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/6.0 Mobile/12H143 Safari/8536.25 livehome/"
@interface OldVideoWebVC ()
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) WKWebView *mWebView;
@property (nonatomic, strong) UIProgressView *mProgressView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, assign) BOOL loadFinsh;
@property (nonatomic, strong) ShareModel *shareModel;
@property (nonatomic, strong) CNPPopupController *sharePopController;
@property (nonatomic, strong) StreamSharePopView *sharePopView;
@property (nonatomic, strong) FBKVOController *kvoController;
@end

@implementation OldVideoWebVC

-(instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.navTitle = title;
        self.requestUrl = url;
        self.isCanGoBack = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItems = @[item1,item2];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share_30"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    [self storeCookie];
    [self setUserAgent];
    [self initWebView];
    [self initFBKVO];

}
- (StreamSharePopView *)sharePopView{
    if (!_sharePopView){
        _sharePopView = [[StreamSharePopView alloc] initWithFrame:CGRectMake(0, 0, 250, 120) andShareModel:self.shareModel];
        __weak typeof (self) weakSelf = self;
        _sharePopView.block = ^{
            [weakSelf.sharePopController dismissPopupControllerAnimated:YES];
        };
    }
    return _sharePopView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mProgressView removeFromSuperview];
}

- (void)initWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    
    _mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TopFullHeight) configuration:config];
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    [self.view addSubview:_mWebView];
    
    //进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _mProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _mProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _mProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar addSubview:_mProgressView];
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.mWebView handler:^(id data, WVJBResponseCallback responseCallback) {
    }];

    __weak typeof (self) weakSelf = self;
    [self.bridge registerHandler:@"setShareConfig" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = (NSDictionary *)data;
        if(dic && ![dic isKindOfClass:[NSNull class]] && dic.allKeys.count > 0){
            //设置分享数据
            weakSelf.shareModel = [[ShareModel alloc] init];
            weakSelf.shareModel.title = [dic valueForKey:@"title"];
            weakSelf.shareModel.shareUrl = [dic valueForKey:@"link"];
            weakSelf.shareModel.imageUrl = [dic valueForKey:@"imgUrl"];
            weakSelf.shareModel.content = [dic valueForKey:@"desc"];
        }
    }];
    //显示/隐藏分享按钮
    [self.bridge registerHandler:@"showShareButton" handler:^(NSDictionary * data, WVJBResponseCallback responseCallback) {
       
    }];
    //显示/隐藏转发按钮
    [self.bridge registerHandler:@"showReplayButton" handler:^(NSDictionary * data, WVJBResponseCallback responseCallback) {

    }];
    
    //显示/隐藏收藏按钮
    [self.bridge registerHandler:@"showCollectButton" handler:^(NSDictionary * data, WVJBResponseCallback responseCallback) {

    }];
}

- (void)initFBKVO{
    
    //KVO
    __weak typeof (self) weakSelf = self;
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:self.mWebView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        weakSelf.mProgressView.alpha = 1;
        [weakSelf.mProgressView setProgress:self.mWebView.estimatedProgress animated:YES];
        if(weakSelf.mWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.mProgressView.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf.mProgressView setProgress:0.0f animated:NO];
            }];
        }  
    }];
    
    [self.kvoController observe:self.mWebView keyPath:@"title" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
         weakSelf.navigationItem.title = self.mWebView.title;
    }];
}

- (void)storeCookie{
    NSString *device = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [self setCookiesForKey:@"lh-user-id" Value:[UserHelper getMemberId]];
    [self setCookiesForKey:@"lh-user-device" Value:device];
    [self setCookiesForKey:@"lh-user-auth" Value:[UserHelper getMemberAuth]];
}

-(void)setCookiesForKey:(NSString *)key Value:(NSString*)value
{
    if(!value){
        return;
    }
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:key forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"LiveHomeAPI.o2o.com.cn" forKey:NSHTTPCookieDomain];
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:30 * 24 * 3600] forKey:NSHTTPCookieExpires];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc]initWithProperties:cookieProperties];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
}

- (void)setUserAgent
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *useragent = [NSString stringWithFormat:@"%@%@",DEFAULT_USER_AGENT,version];

    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:useragent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}


- (void)back:(id)sender
{
    if ([_mWebView canGoBack] && self.isCanGoBack) {
        [_mWebView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (void)share{
    self.sharePopController = [[CNPPopupController alloc] initWithContents:@[self.sharePopView]];
    self.sharePopController.theme.backgroundColor = [UIColor clearColor];
    self.sharePopController.theme.popupStyle = CNPPopupStyleActionSheet;
    self.sharePopController.theme.shouldDismissOnBackgroundTouch = YES;
    [self.sharePopController presentPopupControllerAnimated:YES];
}

@end
