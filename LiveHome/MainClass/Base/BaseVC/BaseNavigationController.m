//
//  BaseNavigationController.m
//  LiveHome
//
//  Created by caohouhong on 17/3/15.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置了NO之后自动下沉navigationBar的高度
    self.navigationBar.translucent = NO;
    //改变左右Item的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];

    //改变title的字体样式
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: FONT_SYSTEM_BOLD(18)};
    [self.navigationBar setTitleTextAttributes:textAttributes];
    //改变navBar的背景颜色
    [self.navigationBar setBarTintColor:[UIColor themeColor]];
    //处理6p上面显示不全的bug
//    UIImage *bgImage = [[UIImage imageNamed:@"bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    
    //解决iPhone X push页面时 tabBar上移的问题
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (void)backAction{
    [self popViewControllerAnimated:YES];
}
@end
