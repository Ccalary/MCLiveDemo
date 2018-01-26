//
//  CountdownTableViewCell.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^countdownBlock)(void);

@interface CountdownTableViewCell : UITableViewCell

@property (nonatomic, copy) countdownBlock block;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIView *dividerLine;

//是否展示倒计时控件
- (void)countdownViewHidden:(BOOL)hidden;

//开始倒计时
- (void)codeCountdownStart;
@end
