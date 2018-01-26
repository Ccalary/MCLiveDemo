//
//  OldVideoDeleteView.h
//  LiveHome
//
//  Created by chh on 2017/11/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, OldVideoDeleteViewBtnType){
    OldVideoDeleteViewBtnTypeSelect = 0,  //选择
    OldVideoDeleteViewBtnTypeDelete = 1   //删除
};
@protocol OldVideoDeleteViewDelegate<NSObject>
- (void)oldVideoManagerBtnAction:(UIButton *)button;
@end

@interface OldVideoDeleteView : UIView
@property (nonatomic, weak) id<OldVideoDeleteViewDelegate> delegate;
@property (nonatomic, strong)UIButton *selectBtn;
@end
