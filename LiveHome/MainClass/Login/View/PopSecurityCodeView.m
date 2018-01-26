//
//  PopSecurityCodeView.m
//  LiveHome
//
//  Created by chh on 2017/11/2.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PopSecurityCodeView.h"

@implementation PopSecurityCodeView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    UILabel *toplabel = [[UILabel alloc] init];
    toplabel.font = FONT_SYSTEM(18);
    toplabel.textColor = [UIColor fontColorBlack];
    toplabel.text = @"请输入图形验证码";
    [self addSubview:toplabel];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25*UIRate);
        make.top.offset(25*UIRate);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入图形验证码";
    _textField.font = FONT_SYSTEM(15);
    _textField.textColor = [UIColor fontColorBlack];
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25*UIRate);
        make.width.mas_equalTo(150*UIRate);
        make.height.mas_equalTo(20*UIRate);
        make.top.equalTo(toplabel.mas_bottom).offset(15*UIRate);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor themeColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toplabel);
        make.top.equalTo(_textField.mas_bottom).offset(2);
        make.width.mas_equalTo(190*UIRate);
        make.height.mas_equalTo(2);
    }];
    
    _codeImageView = [[UIImageView alloc] init];
    [self addSubview:_codeImageView];
    [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90*UIRate);
        make.height.mas_equalTo(30*UIRate);
        make.left.equalTo(line.mas_right).offset(2);
        make.bottom.equalTo(line);
    }];
    
    UIButton *codeBtn = [[UIButton alloc] init];
    [codeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.tag = PopSecurityCodeViewBtnCode;
    [self addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_codeImageView);
    }];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = FONT_SYSTEM(15);
    [submitButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    submitButton.tag = PopSecurityCodeViewBtnSubmit;
    [submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60*UIRate);
        make.height.mas_equalTo(30*UIRate);
        make.right.offset(-15*UIRate);
        make.bottom.offset(-10*UIRate);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = FONT_SYSTEM(15);
    [cancelButton setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
    cancelButton.tag = PopSecurityCodeViewBtnCancel;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(submitButton);
        make.right.equalTo(submitButton.mas_left);
        make.centerY.equalTo(submitButton);
    }];
}

- (void)buttonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(securityCodeBtnAction:)]){
        [self.delegate securityCodeBtnAction:button.tag];
    }
}
@end
