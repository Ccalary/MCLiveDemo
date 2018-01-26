//
//  LocationSettingPopView.h
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnBlock)(BOOL isSure);

@interface LocationSettingPopView : UIView
@property (nonatomic, copy) btnBlock block;
@end
