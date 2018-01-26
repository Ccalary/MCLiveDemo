
//
//  WithdrawFooterView.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WithdrawFooterView.h"
#import "ToolsHelper.h"

@interface WithdrawFooterView()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation WithdrawFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = FONT_SYSTEM(12);
    _moneyLabel.textColor = [UIColor fontColorLightGray];
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.offset(7*UIRate);
    }];
    self.totalMoney = @"0.00";
    
    UIButton *withdrawBtn = [[UIButton alloc] init];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [withdrawBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(withdrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:withdrawBtn];
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.offset(50*UIRate);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(12);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"(首次提现免费 最低提现金额为10元)提现仅收取10%的手续费";
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.equalTo(withdrawBtn.mas_bottom).offset(15*UIRate);
    }];
}

- (void)setTotalMoney:(NSString *)totalMoney{
    NSString *str = [NSString stringWithFormat:@"当前可提现%.2f元",[totalMoney doubleValue]];
    self.moneyLabel.attributedText = [ToolsHelper changeSomeText:totalMoney
                                                          inText:str
                                                       withColor:[UIColor themeColor]];
}

//提现按钮
- (void)withdrawBtnAction{
    if (self.block){
        self.block();
    }
}

@end
