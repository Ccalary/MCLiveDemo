//
//  MyUseViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MyUseViewController.h"
#import "MineTableViewCell.h"
#import "GiftViewController.h"
#import "VoteViewController.h"
#import "SignInViewController.h"
#import "UserHelper.h"

@interface MyUseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation MyUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UserHelper getIsReviewAccount]){
        _dataArray = @[@[@"投票"]];
        _imageArray = @[@[@"icon_vote_23"]];
    }else {
        _dataArray = @[@[@"投票",@"签到"],@[@"贺卡",@"邀请卡",@"划算"],@[@"大转盘",@"砸金蛋",@"摇一摇抽奖"]];
        _imageArray = @[@[@"icon_vote_23",@"icon_sign_23"],
                        @[@"icon_card_25",@"icon_invite_25",@"icon_worth_25"],
                        @[@"icon_luck_25",@"icon_egg_25",@"icon_shake_25"]];}
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"应用";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.estimatedSectionHeaderHeight = NO;
    _tableView.estimatedSectionFooterHeight = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = self.dataArray[indexPath.section][indexPath.row];
    if ([@"礼物" isEqualToString:name]){
        [self.navigationController pushViewController:[[GiftViewController alloc] init] animated:YES];
    }else if ([@"投票" isEqualToString:name]){
        [self.navigationController pushViewController:[[VoteViewController alloc] init] animated:YES];
    }else{
        SignInViewController *signVC = [[SignInViewController alloc] init];
        signVC.navTitle = name;
        [self.navigationController pushViewController:signVC animated:YES];
    }
}
@end
