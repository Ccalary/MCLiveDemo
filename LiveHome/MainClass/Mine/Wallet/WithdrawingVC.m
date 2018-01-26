//
//  WithdrawingVC.m
//  LiveHome
//
//  Created by chh on 2017/11/8.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WithdrawingVC.h"
#import "BillViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "WalletViewController.h"

@interface WithdrawingVC ()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation WithdrawingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //单个viewController 关闭侧滑手势
    self.fd_interactivePopDisabled = YES;
}

- (void)initView{
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = [UIColor bgColorMain];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"mine_check_90"];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(90*UIRate);
        make.top.offset(45*UIRate);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = FONT_SYSTEM(15);
    textLabel.textColor = [UIColor fontColorBlack];
    textLabel.text = @"提现中";
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(25*UIRate);
    }];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = FONT_SYSTEM(24);
    _moneyLabel.textColor = [UIColor themeColor];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.withdrawMoney];
    [self.view addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(textLabel.mas_bottom).offset(15*UIRate);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(15);
    tipsLabel.textColor = [UIColor fontColorBlack];
    tipsLabel.text = @"由于银行的原因可能会在1-7个工作日内到账";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(textLabel.mas_bottom).offset(70*UIRate);
    }];
    
    UIButton *knowBtn = [[UIButton alloc] init];
    [knowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [knowBtn setTitle:@"好的" forState:UIControlStateNormal];
    knowBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [knowBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [knowBtn addTarget:self action:@selector(knowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.equalTo(tipsLabel.mas_bottom).offset(15*UIRate);
    }];
    
    UIButton *recordBtn = [[UIButton alloc] init];
    [recordBtn setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
    [recordBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    recordBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [recordBtn addTarget:self action:@selector(recordBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.equalTo(knowBtn.mas_bottom).offset(10*UIRate);
    }];
}


//Action
- (void)knowBtnAction{
    [self popViewController];
}

- (void)leftBarButtonItemAction{
    [self popViewController];
}

//后退两个
- (void)popViewController{
    
    for (int i = 0; i < (int)self.navigationController.viewControllers.count; i++){
        if ([self.navigationController.viewControllers[i] isKindOfClass:[WalletViewController class]]){
            [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
            break;
        }
    }
}

//提现记录
- (void)recordBtnAction{
    BillViewController *billVC = [[BillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}
@end
