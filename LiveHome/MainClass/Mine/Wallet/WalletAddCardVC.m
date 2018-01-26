//
//  WalletAddCardVC.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WalletAddCardVC.h"
#import "AddCardTableViewCell.h"

@interface WalletAddCardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSArray *dataArray, *placeArray;
@property (nonatomic, strong) NSMutableArray *stringArray;
@property (nonatomic, assign) BOOL canGetCardType;//可以请求银行卡类型
@property (nonatomic, strong) NSString *binNum;
@end

@implementation WalletAddCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"开户名",@"银行账号",@"银行名称",@"支行名称"];
    _placeArray = @[@"请输入开户名",@"请输入银行账号",@"自动获取银行名称",@"请输入支行名称"];
    _stringArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    _canGetCardType = YES;
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.navigationItem.title = @"添加银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initFooterView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15*UIRate)];
    _tableView.tableFooterView = self.footerView;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initFooterView{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70*UIRate)];
    _footerView.backgroundColor = [UIColor bgColorMain];
    [_footerView addSubview:self.submitButton];
}

- (UIButton *)submitButton{
    if (!_submitButton){
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15*UIRate, 25*UIRate, ScreenWidth - 30*UIRate, 40*UIRate)];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = FONT_SYSTEM_BOLD(15);
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const cellIdentifier = @"CellIdentifier";
    AddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.textField.placeholder = self.placeArray[indexPath.row];
    cell.textField.text = self.stringArray[indexPath.row];
    cell.textField.tag = 1000 + (int)indexPath.row;
    cell.textField.userInteractionEnabled = YES;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    [cell.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    if (indexPath.row == 1){
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 2){
        cell.textField.userInteractionEnabled = NO;
        cell.clearBtn.hidden = YES;
    }
    [cell.clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.clearBtn.tag = 1000 + (int)indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*UIRate;
}

//刷新某一行
- (void)reloadTableViewRow:(NSUInteger)row{
    NSIndexPath *position = [NSIndexPath indexPathForRow:row inSection:0];//刷新第一个section的第row行
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:position,nil] withRowAnimation:UITableViewRowAnimationNone];
}
//Action 清除和隐藏工作在cell中处理了
- (void)clearBtnAction:(UIButton *)button{
    int i = (int)button.tag - 1000;
    if (_stringArray.count > i){
        _stringArray[i] = @"";
    }
}

- (void)textFieldAction:(UITextField *)textField{
    int i = (int)textField.tag - 1000;
    if (_stringArray.count > i){
        _stringArray[i] = textField.text;
    }
    
    if (textField.tag == 1001){//银行账号
        if (textField.text.length > 9){
            if (self.canGetCardType){
                self.canGetCardType = NO;
                [self requestWalletCardType];
            }
        }else {
            self.canGetCardType = YES;
            self.stringArray[2] = @"";
            [self reloadTableViewRow:2];
        }
    }
}

//获得银行卡类型
- (void)requestWalletCardType{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.stringArray[1] forKey:@"card"];
    
    [LHConnect postWalletGetCardType:params loading:nil success:^(id  _Nonnull response) {
        self.stringArray[2] = [NSString stringWithFormat:@"%@",[response objectForKey:@"type"]];
        self.binNum = [NSString stringWithFormat:@"%d",[[response objectForKey:@"id"] intValue]];
        [self reloadTableViewRow:2];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//提交
- (void)submitBtnAction{
    [self.view endEditing:YES];
    for (NSString *text in self.stringArray){
        if (text.length == 0){
            [LCProgressHUD showFailure:@"信息不全!"];
            return;
        }
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.stringArray[0] forKey:@"name"];
    [params setValue:self.stringArray[1] forKey:@"account"];
    [params setValue:self.binNum forKey:@"binnum"];
    [params setValue:self.stringArray.lastObject forKey:@"bankname"];
    
    [LHConnect postWalletAddBankCard:params loading:@"提交中..." success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"添加成功"];
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.block){
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
