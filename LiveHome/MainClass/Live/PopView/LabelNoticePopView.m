//
//  LabelNoticePopView.m
//  Find
//
//  Created by chh on 2017/8/23.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "LabelNoticePopView.h"

@interface LabelNoticePopView()
@property (nonatomic, strong) NSString *noticeStr;
@end

@implementation LabelNoticePopView

- (instancetype)initWithFrame:(CGRect)frame andType:(LabelNoticePopViewType)type{
    if (self = [super initWithFrame:frame]){
        
        switch (type) {
            case LabelNoticePopViewLocation:
                _noticeStr = @"关闭定位直播不会被附近的人看到，直播间人数可能会减少，确定关闭吗？";
                break;
            case LabelNoticePopViewAddManager:
                _noticeStr = @"是否将该用户任命为房管？";
                break;
            case LabelNoticePopViewRemoveManager:
                _noticeStr = @"是否取消该房管的任命？";
                break;
            case LabelNoticePopViewNoTalking:
                _noticeStr = @"是否禁言该用户？";
                break;
            case LabelNoticePopViewBarrage:
                _noticeStr = @"是否举报该用户？";
                break;
            default:
                break;
        }
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.text = self.noticeStr;
    textlabel.font = [UIFont systemFontOfSize:14];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.numberOfLines = 0;
    textlabel.textColor = [UIColor blackColor];
    [self addSubview:textlabel];
    
    [textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self).offset(-22);
    }];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = [UIColor bgColorLine];
    [self addSubview:dividerLine1];
    [dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.width.equalTo(self);
        make.bottom.equalTo(self).offset(-45);
        make.centerX.equalTo(self);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = 10000;
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX);
        make.height.mas_equalTo(44);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    [self addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(44);
        make.right.equalTo(self);
        make.centerY.equalTo(closeBtn);
    }];
    
    UIView *dividerLine2 = [[UIView alloc] init];
    dividerLine2.backgroundColor = [UIColor bgColorLine];
    [self addSubview:dividerLine2];
    [dividerLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.bottom.equalTo(self);
        make.top.equalTo(dividerLine1);
        make.centerX.equalTo(self);
    }];
    
}

- (void)btnAction:(UIButton *)button{
    if (self.block){
        self.block((button.tag == 10001) ? YES : NO);
    }
}


@end
