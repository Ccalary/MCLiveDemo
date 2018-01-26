 //
//  BaseTabBarController.m
//  LiveHome
//
//  Created by caohouhong on 17/3/15.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "BaseTabbar.h"
#import "OldVideosVC.h"
#import "MyUseViewController.h"
#import "MineViewController.h"
#import "MessageViewController.h"

#import "StreamingPortraitViewController.h"
#import "StreamingLandscapeViewController.h"
#import "SettingViewModel.h"
#import "StreamingViewModel.h"
#import "CNPPopupController.h"
#import "StreamDirectionPopView.h"
#import "PhotoHelper.h"
#import "AppDelegate.h"

@interface BaseTabBarController ()<BaseTabbarDelegate,StreamDirectionPopViewDelegate, PhotoHelperDelegate>
@property (nonatomic, strong) CNPPopupController *popController;
@property (nonatomic, strong) StreamDirectionPopView *popView;
@property (nonatomic, assign) BOOL isLandScape; //横屏
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) BOOL is480P; //是否流畅，默认标清
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBar *tabbar = [UITabBar appearance];
    tabbar.tintColor = [UIColor themeColor];
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    BaseTabbar *baseTabbar = [[BaseTabbar alloc] init];
    baseTabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:baseTabbar forKeyPath:@"tabBar"];
    
    [self addChildViewControllers];
    
    self.is480P = YES;
    self.imageArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//添加子控制器
- (void)addChildViewControllers{
    
    [self addChildrenViewController:[[OldVideosVC alloc] init] andTitle:@"历史" andImageName:@"tab_history" andSelectImage:@"tab_history_pre"];
     [self addChildrenViewController:[[MyUseViewController alloc] init] andTitle:@"应用" andImageName:@"tab_use" andSelectImage:@"tab_use_pre"];
     [self addChildrenViewController:[[MessageViewController alloc] init] andTitle:@"消息" andImageName:@"tab_msg" andSelectImage:@"tab_msg_pre"];
    [self addChildrenViewController:[[MineViewController alloc] init] andTitle:@"我" andImageName:@"tab_mine" andSelectImage:@"tab_mine_pre"];
}

- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage =  [UIImage imageNamed:selectedImage];
    childVC.title = title;
    
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:baseNav];
}

#pragma mark - BaseTabbarDelegate
- (void)baseTabbarClickButtonAction:(BaseTabbar *)tabBar{
    self.popController = [[CNPPopupController alloc] initWithContents:@[self.popView]];
    self.popController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    self.popController.theme.shouldDismissOnBackgroundTouch = YES;
    [self.popController presentPopupControllerAnimated:YES];
}

- (StreamDirectionPopView *)popView{
    if (!_popView){
        _popView = [[StreamDirectionPopView alloc] initWithFrame:CGRectMake(0, 0, 285*UIRate, 240*UIRate)];
        _popView.delegate = self;
    }
    return _popView;
}

#pragma mark - 弹窗代理
- (void)streamPopViewBtnActionWithType:(StreamDirPopViewBtnType)type{
    switch (type) {
        case StreamDirPopViewBtnTypePhoto:
        {
            PhotoHelper *photoHelper = [PhotoHelper sharedInstance];
            photoHelper.delegate = self;
            [photoHelper addPhotoWithController:self];
            __weak typeof (self) weakSelf = self;
            photoHelper.block = ^(UIImage *image) {
                [self.imageArray removeAllObjects];
                weakSelf.popView.bannerImage = image;
                [self.imageArray addObject:image];
                [self.popController presentPopupControllerAnimated:YES];
            };
        }
            break;
        case StreamDirPopViewBtnTypeResolution480P://流畅
            self.is480P = YES;
            break;
        case StreamDirPopViewBtnTypeResolution720P://高清
            self.is480P = NO;
            break;
        case StreamDirPopViewBtnTypeHorizontal:
            [self goToStreamingWithIsLandscape:YES];
            break;
        case StreamDirPopViewBtnTypeVertical:
            [self goToStreamingWithIsLandscape:NO];
            break;
        default:
            break;
    }
}
//请求跳转
- (void)goToStreamingWithIsLandscape:(BOOL)isLandScape{
    if (self.imageArray.count == 0) {
        [LCProgressHUD showKeyWindowFailure:@"请上传封面"];
        return;
    }
    [self.popController dismissPopupControllerAnimated:YES];
    self.isLandScape = isLandScape;
    [self postImageSource];
}

#pragma mark - PhotoHelperDelegate 添加图片代理
- (void)clickAddPhotoBtn{
    [self.popController dismissPopupControllerAnimated:YES];
}

#pragma mark - 网络请求
- (void)postImageSource{
    [LHConnect uploadImageResource:nil loading:@"图片上传中..." imageArray:self.imageArray success:^(id  _Nonnull response) {
        NSArray *array = (NSArray *)response;
        self.imageUrl = array.firstObject;
        [self requestData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//请求网络数据
- (void)requestData{
    
    [LHConnect postLiveGetAddress:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        NSString *streamingUrl = [NSString stringWithFormat:@"%@",response[@"addr"]];
        NSString *targetId = [NSString stringWithFormat:@"%@",response[@"roomid"]];
        if (self.isLandScape){
            [self goToLandscapeVCWithUrl:streamingUrl andTargetId:targetId];
        }else {
            [self goToPortraitVCWithUrl:streamingUrl andTargetId:targetId];
        }
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
//横屏推流
- (void)goToLandscapeVCWithUrl:(NSString *)url andTargetId:(NSString *)targetId{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowLandscapeRight = YES;
    //强制旋转成全屏
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    
    SettingViewModel *model = [[SettingViewModel alloc] init];
    model.url = url;
    model.direction = DirectionLandscape;
    model.resolution = (self.is480P) ? Resolution_480P : Resolution_720P;
    StreamingViewModel *vm = [[StreamingViewModel alloc] initWithSettingViewModel:model];
    
    StreamingLandscapeViewController *vc = [[StreamingLandscapeViewController alloc] init];
    vc.model = vm;
    vc.isLandScape = YES;
    vc.targetId = targetId;
    vc.imageUrl = self.imageUrl;
    [self presentViewController:vc animated:YES completion:nil];
}
//竖屏推流
- (void)goToPortraitVCWithUrl:(NSString *)url andTargetId:(NSString *)targetId{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowLandscapeRight = NO;
    
    SettingViewModel *model = [[SettingViewModel alloc] init];
    model.url = url;
    model.direction = DirectionPortrait;
    model.resolution = (self.is480P) ? Resolution_480P : Resolution_720P;
    StreamingViewModel *vm = [[StreamingViewModel alloc] initWithSettingViewModel:model];
    
    StreamingPortraitViewController *vc = [[StreamingPortraitViewController alloc] init];
    vc.model = vm;
    vc.isLandScape = NO;
    vc.targetId = targetId;
    vc.imageUrl = self.imageUrl;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
