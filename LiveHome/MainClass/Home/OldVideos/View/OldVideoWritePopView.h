//
//  OldVideoWritePopView.h
//  LiveHome
//
//  Created by chh on 2017/11/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

typedef NS_ENUM(NSInteger, OldVideoWritePopViewBtnType) {
    OldVideoWritePopViewBtnTypeAdd         = 1,    //选择封面
    OldVideoWritePopViewBtnTypeSubmit      = 2,     //提交
    OldVideoWritePopViewBtnTypeTemp        = 3      //模版选择
};

@protocol OldVideoWritePopViewDelegate<NSObject>
- (void)oldVideoWriteViewBtnClick:(OldVideoWritePopViewBtnType)type;
@end

@interface OldVideoWritePopView : UIView
@property (nonatomic, weak) id<OldVideoWritePopViewDelegate> delegate;
@property (nonatomic, strong) UIImage *bannerImage;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *tempLabel; //模版信息
@property (nonatomic, strong) VideoListModel *model;
@end
