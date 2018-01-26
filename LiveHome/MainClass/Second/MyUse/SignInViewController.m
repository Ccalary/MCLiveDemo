//
//  SignInViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "SignInViewController.h"
#import "VotingResultsCell.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navTitle;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHex:0xf8f8f8 alpha:0.8];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"contribute_default_175"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(200*UIRate);
        make.top.offset(150*UIRate);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM_BOLD(18);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"正在建设中...";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10*UIRate);
        make.centerX.equalTo(self.view);
    }];
}

@end

