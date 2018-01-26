//
//  BaseTabbar.h
//  LiveHome
//
//  Created by chh on 2017/11/3.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabbar;

@protocol BaseTabbarDelegate <NSObject>
- (void)baseTabbarClickButtonAction:(BaseTabbar *)tabbar;
@end

@interface BaseTabbar : UITabBar
@property (nonatomic, weak) id<BaseTabbarDelegate> myDelegate;
@property (nonatomic, strong) UILabel *titleLabel;
@end
