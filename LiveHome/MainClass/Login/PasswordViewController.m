//
//  PasswordViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/2.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PasswordViewController.h"
#import "CountdownTableViewCell.h"
#import "PopSecurityCodeView.h"
#import "CNPPopupController.h"

#define Cell_Tag  6666

@interface PasswordViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, PopSecurityCodeViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) PasswordVCType type;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) PopSecurityCodeView *codeView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *tempCode;
@end

@implementation PasswordViewController

- (instancetype)initWithType:(PasswordVCType)type{
    if (self = [super init]){
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == PasswordVCTypeRegister){
        self.navigationItem.title = @"注册";
        self.dataArray = @[@[@"手机号",@"请输入手机号"],@[@"验证码",@"请输入验证码"],@[@"密码",@"请输入密码，至少6位"]];
    }else if (self.type == PasswordVCTypeForgotPsd){
        self.navigationItem.title = @"忘记密码";
        self.dataArray = @[@[@"手机号",@"请输入手机号"],@[@"验证码",@"请输入验证码"],@[@"新密码",@"请输入密码，至少6位"]];
    }else{
        self.dataArray = @[];
    }
    self.resultArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@""]];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
   
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    aTap.delegate = self;
    [self.view addGestureRecognizer:aTap];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.tableFooterView = self.footerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionHeaderHeight = NO;
    _tableView.estimatedSectionFooterHeight = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - 懒加载
- (UIView *)footerView{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70*UIRate)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15*UIRate, 25*UIRate, ScreenWidth - 30*UIRate, 40*UIRate)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SYSTEM_BOLD(15);
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
    }
    return _footerView;
}

//弹窗
- (PopSecurityCodeView *)codeView{
    if (!_codeView){
        _codeView = [[PopSecurityCodeView alloc] initWithFrame:CGRectMake(0, 0, 330*UIRate, 160*UIRate)];
        _codeView.delegate = self;
    }
    return _codeView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const cellIdentifier = @"CellIdentifier";
    CountdownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CountdownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.dataArray[indexPath.row];
    //最后一个隐藏分割线
    cell.dividerLine.hidden = (self.dataArray.count - 1 == indexPath.row) ? YES : NO;
    cell.nameLabel.text = array.firstObject;
    cell.textField.placeholder = array.lastObject;
    cell.textField.secureTextEntry = NO;
    cell.textField.tag = 1000 + (int)indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    switch (indexPath.row) {
        case 0:
        {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.textField becomeFirstResponder];
            cell.tag = Cell_Tag;//特殊的tag标记
            //验证码按钮点击
            __weak typeof (self) weakSelf = self;
            cell.block = ^{
                NSString *phoneNum = weakSelf.resultArray.firstObject;
                if (phoneNum.length != 11){
                    [LCProgressHUD showFailure:@"请输入11位手机号码"];
                    return;
                }
                self.popupController = [[CNPPopupController alloc] initWithContents:@[self.codeView]];
                [self.popupController presentPopupControllerAnimated:YES];
                [self.codeView.textField becomeFirstResponder];
                [weakSelf requestCodePictureWith:phoneNum];
            };
            [cell countdownViewHidden:NO];
        }
            break;
        case 1:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 2:
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.secureTextEntry = YES;
        default:
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            [cell countdownViewHidden:YES];
            break;
    }
    [cell.clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.clearBtn.tag = 1000 + (int)indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

#pragma mark - PopSecurityCodeViewDelegate
- (void)securityCodeBtnAction:(PopSecurityCodeViewBtnType)type{
    switch (type) {
        case PopSecurityCodeViewBtnCode://更换验证码
            [self requestCodePictureWith:self.resultArray.firstObject];
            break;
        case PopSecurityCodeViewBtnSubmit://提交
            [self requestSmsCode];
            break;
        case PopSecurityCodeViewBtnCancel://取消
            [self hiddenCodeView];
            break;
    }
}

- (void)hiddenCodeView{
    [self.codeView endEditing:YES];
    self.codeView.textField.text = @"";
    [self.popupController dismissPopupControllerAnimated:YES];
}

#pragma mark - Action
//清除和隐藏工作在cell中处理了
- (void)clearBtnAction:(UIButton *)button{
    int i = (int)button.tag - 1000;
    if (_resultArray.count > i){
        _resultArray[i] = @"";
    }
}

- (void)textFieldAction:(UITextField *)textField{
    int i = (int)textField.tag - 1000;
    if (_resultArray.count > i){
        _resultArray[i] = textField.text;
    }
}

- (void)tapAction{
    [self.view endEditing:YES];
}

#pragma mark - 网络
//下载验证码图片
-(void)requestCodePictureWith:(NSString *)phoneNum
{
    self.codeView.textField.text = @"";
    _imageUrl = [NSString stringWithFormat:@"%@?mobile=%@",ValidImage,phoneNum];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    self.codeView.codeImageView.image = image;
}

//请求短信
- (void)requestSmsCode{
    [LCProgressHUD showKeyWindowLoading:@"加载中..."];
    NSString *phoneNum = self.resultArray.firstObject;
    NSString *code = self.codeView.textField.text;
    if (code.length == 0) {
        [LCProgressHUD showKeyWindowFailure:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setValue:phoneNum forKey:@"mobile"];
    [parma setValue:code forKey:@"code"];
    
    [LHConnect postSendSms:parma loading:nil success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"发送成功"];
        self.tempCode = response;
        //开始倒计时
        CountdownTableViewCell *cell = (CountdownTableViewCell *)[self.view viewWithTag:Cell_Tag];
        [cell codeCountdownStart];
        [self hiddenCodeView];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//提交
- (void)buttonAction{
    NSString *phoneNum = self.resultArray.firstObject;
    NSString *code = self.resultArray[1];
    NSString *psd = self.resultArray.lastObject;
    if (phoneNum.length != 11) {
        [LCProgressHUD showFailure:@"请输入11位手机号码"];
        return;
    }
    if (code.length == 0){
        [LCProgressHUD showFailure:@"请输入验证码"];
        return;
    }
    if (psd.length < 6){
        [LCProgressHUD showFailure:@"请输入6位以上密码"];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneNum forKey:@"mobile"];
    [params setValue:self.tempCode forKey:@"tempcode"];
    [params setValue:code forKey:@"code"];
    [params setValue:psd forKey:@"password"];

    if (self.type == PasswordVCTypeRegister){
        [LHConnect postRegister:params loading:@"注册中..." success:^(id  _Nonnull response) {
            [LCProgressHUD showKeyWindowSuccess:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } successBackFail:^(id  _Nonnull response) {
            
        }];
        
    }else if (self.type == PasswordVCTypeForgotPsd){
        [LHConnect postForgetPsd:params loading:@"请求中..." success:^(id  _Nonnull response) {
            [LCProgressHUD showKeyWindowSuccess:@"更改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } successBackFail:^(id  _Nonnull response) {
        }];
    }
}
@end
