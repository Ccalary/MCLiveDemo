//
//  BaseWebViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/22.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "BaseWebViewController.h"
#import<WebKit/WebKit.h>

@interface BaseWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) WKWebView *mWebView;
@property (nonatomic, strong) UIProgressView *mProgressView;
@property (nonatomic, assign) BOOL loadFinsh;
@end

@implementation BaseWebViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mProgressView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //TODO:kvo监听，获得页面title和加载进度值
    [self.mWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.mWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)dealloc{
    [self.mWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.mWebView removeObserver:self forKeyPath:@"title"];
}

- (void)initWebView
{
    _mWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _mWebView.navigationDelegate = self;
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    [self.view addSubview:_mWebView];
    
    // 仿微信进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _mProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _mProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _mProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar addSubview:_mProgressView];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.mWebView)
        {
            [self.mProgressView setAlpha:1.0f];
            [self.mProgressView setProgress:self.mWebView.estimatedProgress animated:YES];
            if(self.mWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.mProgressView setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.mProgressView setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.mWebView)
        {
            self.navigationItem.title = self.mWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

//结束加载
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

//内容开始返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
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

@end
