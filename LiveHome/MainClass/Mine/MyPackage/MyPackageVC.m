//
//  MyPackageVC.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MyPackageVC.h"
#import "MyPackageTableViewCell.h"
#import "PackageHeaderView.h"
#import "PackageDetailVC.h"
#import "BaseWebViewController.h"
#import "MyPackageModel.h"
#import "UserHelper.h"

@interface MyPackageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PackageHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) MyPackageModel *model;
@end

@implementation MyPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestBanners];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMyPackage];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的套餐";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = self.footerView;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionHeaderHeight = NO;
    _tableView.estimatedSectionFooterHeight = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//header
- (PackageHeaderView *)headerView{
    if (!_headerView){
        _headerView = [[PackageHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120*UIRate)];
        __weak typeof (self) weakSelf = self;
        _headerView.block = ^{
            if (weakSelf.imageUrl.length > 0){
                BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithTitle:@"" andUrl:weakSelf.imageUrl];
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            }
        };
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80*UIRate)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15*UIRate, 35*UIRate, ScreenWidth - 30*UIRate, 40*UIRate)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"升级套餐" forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SYSTEM_BOLD(15);
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
    }
    return _footerView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        MyPackageTableViewCell  *cell = [[MyPackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.flueModel = self.model;
        return cell;
    }else {
         MyPackageTableViewCell  *cell = [[MyPackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.spaceModel = self.model;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - Action
- (void)buttonAction{
    [self.navigationController pushViewController:[[PackageDetailVC alloc] init] animated:YES];
}

#pragma mark - 网络请求
//广告图
- (void)requestBanners{
    [LHConnect postPackageAd:nil loading:nil success:^(id  _Nonnull response) {
        self.imageUrl = [response objectForKey:@"url"];
        NSString *imageName = [response objectForKey:@"image"];
        NSArray *array = @[imageName];
        _headerView.imageArray = array;
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//我的套餐余量
- (void)requestMyPackage{
    [LHConnect postPackageInformation:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        _model = [MyPackageModel mj_objectWithKeyValues:response];
        [self.tableView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
