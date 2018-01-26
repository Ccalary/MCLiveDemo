//
//  RealNameFooterView.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RealNameFooterViewBtnType) {
    RealNameFooterViewBtnTypePhoto      = 0,
    RealNameFooterViewBtnTypeSubmit     = 1,
};

@protocol RealNameFooterViewDelegate<NSObject>
- (void)realNameFooterViewButtonClick:(RealNameFooterViewBtnType)type;
@end

@interface RealNameFooterView : UIView

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, weak) id<RealNameFooterViewDelegate> delegate;
@end
