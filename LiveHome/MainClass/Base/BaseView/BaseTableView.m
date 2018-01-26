//
//  BaseTableView.m
//  LiveHome
//
//  Created by caohouhong on 17/4/14.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "BaseTableView.h"
#import "FBKVOController.h"

@interface BaseTableView()
@property (nonatomic, strong) FBKVOController *kvoController;
@property (nonatomic, strong) UIView *holdView;

@end

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self){
        //默认无数据高度
        self.noDataHeight = 20*UIRate;
        
        [self drawView];
        [self initFBKVO];
    }
    return self;
}

- (void)drawView{
    
    _holdView = [[UIView alloc] init];
    _holdView.backgroundColor = [UIColor clearColor];
    _holdView.hidden = YES;
    [self addSubview:_holdView];
    
    UIImageView *defaultImageView = [[UIImageView alloc] init];
    defaultImageView.image = [UIImage imageNamed:@"default_nothing_115"];
    [_holdView addSubview:defaultImageView];
    
    UILabel *stringLabel = [[UILabel alloc] init];
    stringLabel.text = @"什么都没有哎～";
    stringLabel.font = FONT_SYSTEM(15);
    stringLabel.textAlignment = NSTextAlignmentCenter;
    stringLabel.textColor = [UIColor fontColorLightGray];
    [_holdView addSubview:stringLabel];
    
    [_holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.mas_equalTo(200*UIRate);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_holdView);
        make.top.equalTo(_holdView);
        make.width.mas_equalTo(115*UIRate);
        make.height.mas_equalTo(115*UIRate);
    }];

    [stringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_holdView);
        make.top.equalTo(defaultImageView.mas_bottom).offset(10*UIRate);
    }];
}

- (void)initFBKVO{
    
    //KVO
    __weak typeof (self) weakSelf = self;
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:self keyPath:@"contentSize" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        CGFloat height =  weakSelf.contentSize.height;
        if ( height > weakSelf.noDataHeight){
            _holdView.hidden = YES;
        }else {
            _holdView.hidden = NO;
            _holdView.center = self.center;
        }
    }];
}

@end
