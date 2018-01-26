//
//  PayPopView.m
//  LiveHome
//
//  Created by chh on 2017/11/20.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PayPopView.h"
@interface PayPopView()

@property (nonatomic, strong) UIButton *weChatBtn, *aliPayBtn;
@end

@implementation PayPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"去支付";
    titleLabel.font = FONT_SYSTEM(18);
    titleLabel.textColor = [UIColor fontColorDarkGray];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(55*UIRate);
        make.top.offset(0);
    }];
    
    UIButton *closeBtn = [self creatBtnWithImage:[UIImage imageNamed:@"btn_close_13"] selectImage:nil tag:PayPopViewBtnTypeClose];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30*UIRate);
        make.left.offset(5*UIRate);
        make.centerY.equalTo(titleLabel);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor bgColorLine];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom);
        make.width.equalTo(self);
        make.height.equalTo(@1);
    }];
   
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = FONT_SYSTEM(26);
    _moneyLabel.textColor = [UIColor blackColor];
    _moneyLabel.text = @"¥ 0.00";
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(lineView.mas_bottom).offset(20*UIRate);
    }];
    
    UILabel *wayLabel = [[UILabel alloc] init];
    wayLabel.text = @"支付方式";
    wayLabel.font = FONT_SYSTEM(15);
    wayLabel.textColor = [UIColor fontColorLightGray];
    [self addSubview:wayLabel];
    [wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*UIRate);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(45*UIRate);
    }];
    
    UIImageView *alipayImageView = [[UIImageView alloc] init];
    alipayImageView.image = [UIImage imageNamed:@"icon_alipay_32"];
    [self addSubview:alipayImageView];
    [alipayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32*UIRate);
        make.centerY.equalTo(wayLabel);
        make.right.offset(-15*UIRate);
    }];
    
    UIImageView *wxImageView = [[UIImageView alloc] init];
    wxImageView.image = [UIImage imageNamed:@"icon_wx_32"];
    [self addSubview:wxImageView];
    [wxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(alipayImageView);
        make.right.equalTo(alipayImageView.mas_left).offset(-45*UIRate);
        make.centerY.equalTo(alipayImageView);
    }];
    
    _weChatBtn = [self creatBtnWithImage:[UIImage imageNamed:@"icon_unselect_16"] selectImage:[UIImage imageNamed:@"icon_select_16"] tag:PayPopViewBtnTypeWeChat];
    _weChatBtn.selected = YES;
    _aliPayBtn = [self creatBtnWithImage:[UIImage imageNamed:@"icon_unselect_16"] selectImage:[UIImage imageNamed:@"icon_select_16"] tag:PayPopViewBtnTypeAlipay];
    
    [_weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40*UIRate);
        make.centerY.equalTo(wxImageView);
        make.right.equalTo(wxImageView.mas_left);
    }];
    
    [_aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40*UIRate);
        make.centerY.equalTo(alipayImageView);
        make.right.equalTo(alipayImageView.mas_left);
    }];
    
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = FONT_SYSTEM(15);
    [payBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = PayPopViewBtnTypePay;
    [self addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(345*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.centerX.equalTo(self);
        make.bottom.offset(-10*UIRate);
    }];
}

- (UIButton *)creatBtnWithImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage tag:(PayPopViewBtnType)type{
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    button.tag = type;
    [self addSubview:button];
    return button;
}

- (void)buttonAction:(UIButton *)button{
    
    switch (button.tag) {
        case PayPopViewBtnTypeWeChat:
            _weChatBtn.selected = YES;
            _aliPayBtn.selected = NO;
            break;
        case PayPopViewBtnTypeAlipay:
            _weChatBtn.selected = NO;
            _aliPayBtn.selected = YES;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(payPopViewButtonAction:)]){
        [self.delegate payPopViewButtonAction:button.tag];
    }
}
@end
