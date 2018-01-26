//
//  MineHeaderView.h
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@protocol MineHeaderViewDelegate<NSObject>
- (void)mineHeaderViewBtnAction;
@end

@interface MineHeaderView : UIView
@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

@property (nonatomic, strong) UserInfoModel *model;
@end
