//
//  WalletViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WalletViewController.h"
#import "BillViewController.h"
#import "WithdrawViewController.h"
#import "WithdrawingVC.h"
#import "WalletMoneyModel.h"


@interface WalletViewController ()
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) WalletMoneyModel *model;
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"余额";
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*UIRate)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.font = FONT_SYSTEM(12);
    balanceLabel.textColor = [UIColor fontColorLightGray];
    balanceLabel.text = @"我的余额(元)";
    [self.view addSubview:balanceLabel];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(25);
    }];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = FONT_SYSTEM_BOLD(32);
    _moneyLabel.textColor = [UIColor fontColorBlack];
    _moneyLabel.text = @"0.00";
    [self.view addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(balanceLabel.mas_bottom).offset(10*UIRate);
    }];
    
    UILabel *billLabel = [[UILabel alloc] init];
    billLabel.layer.cornerRadius = 9*UIRate;
    billLabel.layer.borderColor = [UIColor bgColorLine].CGColor;
    billLabel.layer.borderWidth = 1;
    billLabel.font = FONT_SYSTEM(12);
    billLabel.textColor = [UIColor fontColorLightGray];
    billLabel.textAlignment = NSTextAlignmentCenter;
    billLabel.text = @"账单明细";
    [self.view addSubview:billLabel];
    [billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65*UIRate);
        make.height.mas_equalTo(18*UIRate);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(bgView).offset(-25*UIRate);
    }];
    
    UIButton *billButton = [[UIButton alloc] init];
    [billButton addTarget:self action:@selector(billButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:billButton];
    [billButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.center.equalTo(billLabel);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor bgColorLine];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(bgView);
    }];
    
    UIButton *withdrawBtn = [[UIButton alloc] init];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [withdrawBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(withdrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawBtn];
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.equalTo(bgView.mas_bottom).offset(20*UIRate);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(12);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"金额超过10元可提现，当天可提现1次";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(withdrawBtn);
        make.top.equalTo(withdrawBtn.mas_bottom).offset(8*UIRate);
    }];
}

//账单详情
- (void)billButtonAction{
    [self.navigationController pushViewController:[[BillViewController alloc] init] animated:YES];
}

//提现
- (void)withdrawBtnAction{
    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
    vc.moneyModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
- (void)requestData{
    [LHConnect postWalletWalletMoney:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        _model = [WalletMoneyModel mj_objectWithKeyValues:response];
        _moneyLabel.text = _model.money ?: @"0.00";
    } successBackFail:^(id  _Nonnull response) {
    }];
}
@end
