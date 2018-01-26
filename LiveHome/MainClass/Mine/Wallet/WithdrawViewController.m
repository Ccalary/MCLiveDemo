//
//  WithdrawViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawTableViewCell1.h"
#import "WithdrawTableViewCell2.h"
#import "WithdrawFooterView.h"
#import "BillViewController.h"
#import "WalletAddCardVC.h"
#import "WalletCardsVC.h"
#import "WithdrawingVC.h"

#define kCell  @"kCell"
NSString * const withdrawCellId1 = @"withdrawTableViewCell1";
NSString * const withdrawCellId2 = @"withdrawTableViewCell2";
@interface WithdrawViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WithdrawFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@property (nonatomic, strong) NSString *withdrawMoney; //提现金额
@property (nonatomic, assign) BOOL isHaveCard;
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellsArray = [NSMutableArray array];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"提现";
    
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
    
    [self updateUI];
    
    [self updateCell];
}

//更新UI
- (void)updateUI{
    
    if (self.moneyModel.cardID.length > 0){
        self.isHaveCard = YES;
    }else {
        self.isHaveCard = NO;
    }
    
    if (self.isHaveCard){
       self.navigationItem.title = @"提现";
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else {
       self.navigationItem.title = @"添加银行卡";
    }
}

- (void)updateCell{
    [self.cellsArray removeAllObjects];
    
    NSMutableArray *array1 = [NSMutableArray array];
    NSDictionary *dic1 = @{kCell:withdrawCellId1};
    [array1 addObject:dic1];
    [self.cellsArray addObject:array1];
    
    NSMutableArray *array2 = [NSMutableArray array];
    NSDictionary *dic2 = @{kCell:withdrawCellId2};
    [array2 addObject:dic2];
    [self.cellsArray addObject:array2];
    
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (WithdrawFooterView *)footerView{
    if (!_footerView){
        _footerView = [[WithdrawFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120*UIRate)];
        _footerView.totalMoney = self.moneyModel.money;
        __weak typeof (self) weakSelf = self;
        //提现
        _footerView.block = ^{
            [weakSelf requestWithdraw];
        };
    }
    return _footerView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.cellsArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array = self.cellsArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    if ([dic[kCell] isEqualToString:withdrawCellId1]){
        WithdrawTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:withdrawCellId1];
        if (!cell){
             cell = [[WithdrawTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawCellId1];
        }
        cell.noCardView.hidden = self.isHaveCard;
        
        cell.model = self.moneyModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if ([dic[kCell] isEqualToString:withdrawCellId2]){
        WithdrawTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:withdrawCellId2];
        if (!cell){
            cell = [[WithdrawTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawCellId2];
        }
        __weak typeof (self) weakSelf = self;
        cell.block = ^(NSString *text) {
            weakSelf.withdrawMoney = text;//提现金额
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = self.cellsArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    if ([dic[kCell] isEqualToString:withdrawCellId2]){
        return 120*UIRate;
    }
    return 60*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = self.cellsArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    if ([dic[kCell] isEqualToString:withdrawCellId1]){
        if (self.isHaveCard){//选择银行卡
            WalletCardsVC *vc = [[WalletCardsVC alloc] init];
            vc.model = self.moneyModel;
            __weak typeof (self) weakSelf = self;
            //切换银行卡
            vc.block = ^(WalletMoneyModel *model) {
                NSString *money = weakSelf.moneyModel.money;
                weakSelf.moneyModel = model;
                weakSelf.moneyModel.money = money;
                [weakSelf.tableView reloadData];
            };
           [self.navigationController pushViewController:vc animated:YES];
        }else{//添加银行卡
           WalletAddCardVC *vc = [[WalletAddCardVC alloc] init];
            __weak typeof (self) weakSelf = self;
            vc.block = ^{
                //添加成功后刷新数据
                [weakSelf requestData];
            };
           [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Action
- (void)rightBarButtonItemAction{
    [self.view endEditing:YES];
    [self.navigationController pushViewController:[[BillViewController alloc] init] animated:YES];
}

//提现
- (void)requestWithdraw{
    [self.view endEditing:YES];
    if ([self.withdrawMoney doubleValue] < 10.0){
        [LCProgressHUD showFailure:@"最低提现金额为10元"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.moneyModel.cardID forKey:@"id"];
    [params setValue:self.withdrawMoney forKey:@"money"];
    [LHConnect postWalletWithdrawals:params loading:@"提现中..." success:^(id  _Nonnull response) {
        double money = [self.moneyModel.money doubleValue] - [self.withdrawMoney doubleValue];
        self.footerView.totalMoney = [NSString stringWithFormat:@"%.2f", money];
        WithdrawingVC *vc = [[WithdrawingVC alloc] init];
        vc.withdrawMoney = self.withdrawMoney;
        [self.navigationController pushViewController:vc animated:YES];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//网络请求
- (void)requestData{
    [LHConnect postWalletWalletMoney:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        _moneyModel = [WalletMoneyModel mj_objectWithKeyValues:response];
        [self updateUI];
        [self.tableView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
