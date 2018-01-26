//
//  MineViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "MineTableViewCell.h"
#import "WalletViewController.h"
#import "UserInfoEditVC.h"
#import "MyPackageVC.h"
#import "StatisticsViewController.h"
#import "SettingViewController.h"
#import "UserInfoModel.h"
#import "UserHelper.h"
#import "RealNameVC.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource,MineHeaderViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UserInfoModel *model;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@[@"我的套餐"],@[@"直播统计"],@[@"实名认证"],@[@"设置"]];//,@[@"我的钱包"]
    _imageArray = @[@[@"mine_package_18"],@[@"mine_statics_18"],@[@"mine_cer_18"],@[@"mine_setting_18"]];//,@[@"mine_wallet_18"]
   
    [self initView];
    [self requestCacheData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self requestUserInfo];
}
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionHeaderHeight = NO;
    _tableView.estimatedSectionFooterHeight = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.offset(-TabBarHeight);
        make.top.equalTo(self.view).offset(-StatusBarHeight);
    }];
}

- (MineHeaderView *)headerView{
    if (!_headerView){
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 155*UIRate)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const cellIdentifier = @"CellIdentifier";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.dividerLine.hidden = (array.count-1 == indexPath.row) ? YES : NO;
    cell.iconImageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.rightLabel.text = @"";
    
    NSString *name = array.firstObject;
    if ([@"实名认证" isEqualToString:name]){
        cell.rightLabel.text = self.model.cerStr;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataArray[indexPath.section];
    NSString *name = array.firstObject;
    if ([@"我的套餐" isEqualToString:name]){
        [self.navigationController pushViewController:[[MyPackageVC alloc] init] animated:YES];
    }else if ([@"直播统计" isEqualToString:name]){
         [self.navigationController pushViewController:[[StatisticsViewController alloc] init] animated:YES];
    }else if ([@"实名认证" isEqualToString:name]){
        if ([@"1" isEqualToString:self.model.iscer]){
            [LCProgressHUD showMessage:@"正在审核中"];
            return;
        }
        RealNameVC *vc = [[RealNameVC alloc] init];
        vc.isSuccess =  ([@"2" isEqualToString:self.model.iscer]) ? YES : NO;
        __weak typeof (self) weakSelf = self;
        vc.block = ^{
            [weakSelf requestUserInfo];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"设置" isEqualToString:name]){
         [self.navigationController pushViewController:[[SettingViewController alloc] init] animated:YES];
    }
}

#pragma mark - MineHeaderViewDelegate
- (void)mineHeaderViewBtnAction{
    [self.navigationController pushViewController:[[UserInfoEditVC alloc] init] animated:YES];
}
//加载缓存数据
- (void)requestCacheData{
    NSDictionary *dic = [UserHelper getUserInfo];
    self.model = [UserInfoModel mj_objectWithKeyValues:dic];
    self.headerView.model = self.model;
}

//获取个人信息
- (void)requestUserInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[UserHelper getMemberId] forKey:@"userid"];
    [LHConnect postUserInfo:params loading:@"" success:^(id  _Nonnull response) {
        self.model = [UserInfoModel mj_objectWithKeyValues:response];
        self.headerView.model = self.model;
        [UserHelper setUserInfo:response];
        [self.tableView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
