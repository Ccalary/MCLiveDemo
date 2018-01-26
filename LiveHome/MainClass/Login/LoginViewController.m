//
//  LoginViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/2.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "LoginViewController.h"
#import "PasswordViewController.h"
#import "UserHelper.h"
#import "RCDLive.h"

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *psdTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)initView{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"login_logo_110x85"];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110*UIRate);
        make.height.mas_equalTo(85*UIRate);
        make.top.offset(60*UIRate);
        make.centerX.equalTo(self.view);
    }];
    //name
    UIImageView *nameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_name_30"]];
    [self.view addSubview:nameImageView];
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30*UIRate);
        make.top.offset(240*UIRate);
        make.left.offset(45*UIRate);
    }];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.font = FONT_SYSTEM(15);
    _nameTextField.textColor = [UIColor fontColorBlack];
    _nameTextField.placeholder = @"请输入手机号码";
    _nameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameImageView.mas_right).offset(20*UIRate);
        make.width.mas_equalTo(180*UIRate);
        make.centerY.equalTo(nameImageView);
        make.height.mas_equalTo(20*UIRate);
    }];
    
    UIView *nameLine = [[UIView alloc] init];
    nameLine.backgroundColor = [UIColor themeColor];
    [self.view addSubview:nameLine];
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTextField).offset(-5*UIRate);
        make.right.offset(-45*UIRate);
        make.bottom.equalTo(_nameTextField).offset(2*UIRate);
        make.height.mas_equalTo(1);
    }];
    
    //psd
    UIImageView *psdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_psd_30"]];
    [self.view addSubview:psdImageView];
    [psdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(nameImageView);
        make.top.equalTo(nameImageView.mas_bottom).offset(30*UIRate);
        make.left.equalTo(nameImageView);
    }];
    
    _psdTextField = [[UITextField alloc] init];
    _psdTextField.font = FONT_SYSTEM(15);
    _psdTextField.secureTextEntry = YES;
    _psdTextField.textColor = [UIColor fontColorBlack];
    _psdTextField.placeholder = @"请输入密码";
    [self.view addSubview:_psdTextField];
    [_psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTextField);
        make.size.equalTo(_nameTextField);
        make.centerY.equalTo(psdImageView);
    }];
    
    UIView *psdLine = [[UIView alloc] init];
    psdLine.backgroundColor = [UIColor themeColor];
    [self.view addSubview:psdLine];
    [psdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_psdTextField).offset(-5*UIRate);
        make.right.equalTo(nameLine);
        make.bottom.equalTo(_psdTextField).offset(2*UIRate);
        make.height.equalTo(nameLine);
    }];
    
    //button
    UIButton  *loginButton = [self creatButtonWithTitle:@"登录" font:FONT_SYSTEM_BOLD(24) textColor:[UIColor whiteColor] tag:1000];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"btn_corner_290x40"] forState:UIControlStateNormal];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(45*UIRate);
        make.right.offset(-45*UIRate);
        make.top.equalTo(psdImageView.mas_bottom).offset(35*UIRate);
        make.height.mas_equalTo(40*UIRate);
    }];
    
    UIButton *registerButton = [self creatButtonWithTitle:@"立即注册" font:FONT_SYSTEM(12) textColor:[UIColor themeColor] tag:1001];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.width.mas_equalTo(100*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.equalTo(loginButton.mas_bottom);
    }];
    
    UIButton *forgetButton = [self creatButtonWithTitle:@"忘记密码?" font:FONT_SYSTEM(12) textColor:[UIColor fontColorLightGray] tag:1002];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginButton);
        make.size.equalTo(registerButton);
        make.centerY.equalTo(registerButton);
    }];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color tag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.tag = tag;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (![touch.view isKindOfClass:[UITextField class]]){
        [self.view endEditing:YES];
    }
}

- (void)buttonAction:(UIButton *)button{
    [self.view endEditing:YES];
    switch (button.tag) {
        case 1000://登录
            [self requestLogin];
            break;
        case 1001://注册
            self.nameTextField.text = @"";
            self.psdTextField.text = @"";
            [self.navigationController pushViewController:[[PasswordViewController alloc] initWithType:PasswordVCTypeRegister] animated:YES];
            break;
        case 1002://忘记密码
            self.nameTextField.text = @"";
            self.psdTextField.text = @"";
            [self.navigationController pushViewController:[[PasswordViewController alloc] initWithType:PasswordVCTypeForgotPsd] animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - 网络
- (void)requestLogin{

    NSString *phoneNum = self.nameTextField.text;
    NSString *psd = self.psdTextField.text;
    if (phoneNum.length != 11) {
        [LCProgressHUD showFailure:@"请输入11位手机号码"];
        return;
    }
    if (psd.length < 6){
        [LCProgressHUD showFailure:@"请输入6位以上密码"];
        return;
    }
    [LCProgressHUD showKeyWindowLoading:@"登录中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneNum forKey:@"m"];
    [params setValue:psd forKey:@"p"];
    [LHConnect postLogin:params loading:nil success:^(id  _Nonnull response) {
        [UserHelper setReviewAccount:phoneNum];
        [UserHelper setLogInfo:response];
        [self connectRongCloud];
        [self getUserInfo];
        //登录成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeLoginSuccess object:nil];
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//连接融云
- (void)connectRongCloud{
    [[RCDLive sharedRCDLive] connectRongCloudWithToken:[UserHelper getRongCloudToken] success:^(NSString *userId) {
        DLog(@"融云登录成功");
    } error:^(RCConnectErrorCode status) {
        DLog(@"融云登录失败");
    } tokenIncorrect:^{
        DLog(@"融云登录Token错误");
    }];
}

//获取个人信息
- (void)getUserInfo{
    NSString *userId = [UserHelper getMemberId];
    if (userId.length == 0) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[UserHelper getMemberId] forKey:@"userid"];
    [LCProgressHUD showKeyWindowLoading:@"初始化中..."];
    [LHConnect postUserInfo:params loading:@"" success:^(id  _Nonnull response) {
         [LCProgressHUD showKeyWindowSuccess:@"登录成功"];
         [UserHelper setUserInfo:response];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
