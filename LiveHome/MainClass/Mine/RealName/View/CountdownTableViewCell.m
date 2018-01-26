
//
//  CountdownTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "CountdownTableViewCell.h"
#import "SendCodeButton.h"

@interface CountdownTableViewCell()<SendCodeButtonDelegate>
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) SendCodeButton *codeButton;
@end

@implementation CountdownTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT_SYSTEM(15);
    _nameLabel.textColor = [UIColor fontColorBlack];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.width.mas_equalTo(80*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.font = FONT_SYSTEM(15);
    _textField.textColor = [UIColor fontColorBlack];
    [_textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right);
        make.right.offset(-50*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _clearBtn = [[UIButton alloc] init];
    _clearBtn.hidden = YES;
    [_clearBtn setImage:[UIImage imageNamed:@"btn_clear_15"] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_clearBtn];
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(37*UIRate);
        make.right.offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self addCountdownView];
}

- (void)addCountdownView{
    //倒计时按钮
    _holdView = [[UIView alloc] init];
    _holdView.backgroundColor = [UIColor whiteColor];
    _holdView.hidden = YES;
    [self.contentView addSubview:_holdView];
    [_holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.mas_equalTo(105*UIRate);
        make.top.offset(2);
        make.bottom.offset(-2);
    }];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = [UIColor bgColorLine];
    [self.holdView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25*UIRate);
        make.centerY.equalTo(self.holdView);
        make.left.equalTo(self.holdView);
    }];
    
    _codeButton = [[SendCodeButton alloc] initManualWithTitle:@"获取验证码" seconds:60];
    _codeButton.delegate = self;
    [self.holdView addSubview:_codeButton];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.centerY.equalTo(self.holdView);
        make.height.equalTo(self.holdView);
    }];
}

#pragma mark - Public
- (void)countdownViewHidden:(BOOL)hidden{
    self.holdView.hidden = hidden;
}

#pragma mark - Action
- (void)textFieldAction:(UITextField *)textField{
    self.clearBtn.hidden = (textField.text.length > 0) ? NO : YES;
}

- (void)clearBtnAction:(UIButton *)button{
    self.textField.text = @"";
    button.hidden = YES;
}

#pragma mark - SendCodeButtonDelegate
- (void)sendCodeButtonClick{
    if (self.block){
        self.block();
    }
}

//开始倒计时
- (void)codeCountdownStart{
    [self.codeButton startCountdown];
}
@end
