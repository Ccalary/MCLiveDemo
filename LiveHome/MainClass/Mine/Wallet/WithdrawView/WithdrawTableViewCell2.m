//
//  WithdrawTableViewCell2.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WithdrawTableViewCell2.h"
@interface WithdrawTableViewCell2()
@property (nonatomic, strong) UILabel *leftTopLabel, *leftBottomLabel;
@property (nonatomic, strong) UILabel *centerTopLabel, *centerBottomLabel;
@property (nonatomic, strong) UITextField *moneyField;
@end

@implementation WithdrawTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _leftTopLabel = [[UILabel alloc] init];
    _leftTopLabel.font = FONT_SYSTEM(15);
    _leftTopLabel.textColor = [UIColor fontColorBlack];
    _leftTopLabel.text = @"普通提现";
    [self.contentView addSubview:_leftTopLabel];
    [_leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.offset(10*UIRate);
    }];
    
    _leftBottomLabel = [[UILabel alloc] init];
    _leftBottomLabel.font = FONT_SYSTEM(12);
    _leftBottomLabel.textColor = [UIColor themeColor];
    _leftBottomLabel.text = @"10%手续费";
    [self.contentView addSubview:_leftBottomLabel];
    [_leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.equalTo(_leftTopLabel.mas_bottom).offset(5*UIRate);
    }];
    
    _centerTopLabel = [[UILabel alloc] init];
    _centerTopLabel.font = FONT_SYSTEM(12);
    _centerTopLabel.textColor = [UIColor fontColorLightGray];
    _centerTopLabel.text = @"10.00元以上起提";
    [self.contentView addSubview:_centerTopLabel];
    [_centerTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100*UIRate);
        make.centerY.equalTo(_leftTopLabel);
    }];
    
    _centerBottomLabel = [[UILabel alloc] init];
    _centerBottomLabel.font = FONT_SYSTEM(12);
    _centerBottomLabel.textColor = [UIColor fontColorLightGray];
    _centerBottomLabel.text = @"1-7个工作日到账";
    [self.contentView addSubview:_centerBottomLabel];
    [_centerBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerTopLabel);
        make.centerY.equalTo(_leftBottomLabel);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(60*UIRate);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *moneyText = [[UILabel alloc] init];
    moneyText.font = FONT_SYSTEM(15);
    moneyText.textColor = [UIColor fontColorBlack];
    moneyText.text = @"提现金额";
    [self.contentView addSubview:moneyText];
    [moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.centerY.equalTo(self.contentView).offset(30*UIRate);
    }];
    
    _moneyField = [[UITextField alloc] init];
    _moneyField.textColor = [UIColor fontColorBlack];
    _moneyField.font = FONT_SYSTEM(15);
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyField.placeholder = @"请输入提现金额(元)";
    [_moneyField addTarget:self action:@selector(moneyFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_moneyField];
    [_moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerTopLabel);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(moneyText);
    }];
}

- (void)moneyFieldAction:(UITextField *)textField{
    if (self.block){
        self.block(textField.text);
    }
}
@end
