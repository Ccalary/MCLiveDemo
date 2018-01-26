//
//  LabelNoticePopView.h
//  Find
//
//  Created by chh on 2017/8/23.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LabelNoticePopViewType) {
    LabelNoticePopViewLocation      = 0,    // 定位
    LabelNoticePopViewAddManager    = 1,    //任命房管
    LabelNoticePopViewRemoveManager = 2,    //取消房管
    LabelNoticePopViewNoTalking     = 3,    //禁言
    LabelNoticePopViewBarrage       = 4,    //举报
};


typedef void(^buttonBlock)(BOOL isSure);

@interface LabelNoticePopView : UIView
@property (nonatomic, copy) buttonBlock block;

- (instancetype)initWithFrame:(CGRect)frame andType:(LabelNoticePopViewType)type;
@end
