//
//  RealNameVC.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "RealNameVC.h"
#import "RealNameFooterView.h"
#import "CountdownTableViewCell.h"
#import "PhotoHelper.h"
#import "CNPPopupController.h"
#import "PopSecurityCodeView.h"


#define Cell_Tag  666


@interface RealNameVC ()<UITableViewDelegate, UITableViewDataSource,RealNameFooterViewDelegate,PopSecurityCodeViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) RealNameFooterView *footerView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) PopSecurityCodeView *codeView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *tempCode;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *photoUrl; //图片地址
@end

@implementation RealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"实名认证";
    if (self.isSuccess) {
        [self initFinishView];
    }else{
        [self initNormalView];
    }
}

- (void)initNormalView{
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:aTap];
    
    self.dataArray = @[@[@"真实姓名",@"请输入真实姓名"],@[@"手机号码",@"请输入手机号码"],@[@"验证码",@"请输入验证码"],@[@"身份证号",@"请输入身份证号"]];
    self.resultArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = self.footerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initFinishView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"real_success_97"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(97*UIRate);
        make.top.offset(115*UIRate);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT_SYSTEM(15);
    label.textColor = [UIColor fontColorLightGray];
    label.text = @"实名认证已成功";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(25*UIRate);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - 懒加载
- (UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*UIRate)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*UIRate, 0, ScreenWidth - 30*UIRate, 30*UIRate)];
        label.font = FONT_SYSTEM(12);
        label.textColor = [UIColor fontColorLightGray];
        label.text = @"以下信息均为必填项，为了保证您的利益请如实填写";
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (RealNameFooterView *)footerView{
    if (!_footerView){
        _footerView = [[RealNameFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 350*UIRate)];
        _footerView.delegate = self;
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
    cell.textField.tag = 1000 + (int)indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    switch (indexPath.row) {
        case 1:
        {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.tag = Cell_Tag;//特殊的tag标记
            __weak typeof (self) weakSelf = self;
            //倒计时按钮点击
            cell.block = ^{
                NSString *phoneNum = weakSelf.resultArray[indexPath.row];
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
        case 2:
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
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
    return 45*UIRate;
}

#pragma mark - RealNameFooterViewDelegate
- (void)realNameFooterViewButtonClick:(RealNameFooterViewBtnType)type{
    switch (type) {
        case RealNameFooterViewBtnTypePhoto://添加照片
        {
            PhotoHelper *photoHelper = [PhotoHelper sharedInstance];
            [photoHelper addPhotoWithController:self];
            __weak typeof (self) weakSelf = self;
            photoHelper.block = ^(UIImage *image) {
                weakSelf.photoUrl = @"";
                weakSelf.footerView.photoImage = image;
                weakSelf.imageArray = @[image];
            };
        }
            break;
        case RealNameFooterViewBtnTypeSubmit://提交审核
            [self submit];
            break;
        default:
            break;
    }
}

#pragma mark - PopSecurityCodeViewDelegate
- (void)securityCodeBtnAction:(PopSecurityCodeViewBtnType)type{
    switch (type) {
        case PopSecurityCodeViewBtnCode://更换验证码
            [self requestCodePictureWith:self.resultArray[1]];
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
    NSString *phoneNum = self.resultArray[1];
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
- (void)submit{
    //信息
    NSString *name = self.resultArray.firstObject;
    NSString *phoneNum = self.resultArray[1];
    NSString *code = self.resultArray[2];
    NSString *idCard = self.resultArray.lastObject;
    if (name.length == 0){
        [LCProgressHUD showFailure:@"请输入姓名"];
        return;
    }
    if (phoneNum.length != 11) {
        [LCProgressHUD showFailure:@"请输入11位手机号码"];
        return;
    }
    if (code.length == 0){
        [LCProgressHUD showFailure:@"请输入验证码"];
        return;
    }
    if (idCard.length < 6){
        [LCProgressHUD showFailure:@"请输入18位身份证号"];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:name forKey:@"name"];
    [params setValue:phoneNum forKey:@"mobile"];
    [params setValue:self.tempCode forKey:@"tempcode"];
    [params setValue:code forKey:@"code"];
    [params setValue:idCard forKey:@"idcard"];

    //照片
    if (self.imageArray.count == 0) {
        [LCProgressHUD showFailure:@"请添加照片"];
        return;
    }
    
    //如果是上传过并且图片没更改则不再上传图片
    if (_photoUrl.length > 0){
        [params setValue:_photoUrl forKey:@"image"];
        [self postCerInfo:params];
        return;
    }
    
    [LHConnect uploadImageResource:nil loading:@"图片上传中..." imageArray:self.imageArray success:^(id  _Nonnull response) {
        NSArray *array = (NSArray *)response;
        _photoUrl = array.firstObject;
        [params setValue:_photoUrl forKey:@"image"];
        [self postCerInfo:params];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
//信息提交
- (void)postCerInfo:(NSMutableDictionary *)params{
    [LHConnect postCertification:params loading:@"提交中..." success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"提交审核成功"];
        if (self.block){
            self.block();
        }
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
