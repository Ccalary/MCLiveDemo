
//
//  SettingViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/8.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoTableViewCell.h"
#import <SDWebImage/SDImageCache.h>
#import "ChangePhoneNumVC.h"
#import "FeedbackViewController.h"
#import "UserHelper.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "RCDLive.h"
#import "HHAlertController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, strong) NSString *memoryStr; //缓存大小
@property (nonatomic, strong) NSString *version; //版本号
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@[@"更换手机号"],@[@"清除缓存",@"意见反馈",@"软件版本"],@[@"注销"]];

//    float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024 /1024;
//    self.memoryStr  = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"设置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    NSArray *array = self.dataArray[indexPath.section];
    
    NSString * const cellIdentifier = @"CellIdentifier";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.dividerLine.hidden = (array.count - 1 == indexPath.row) ? YES : NO;
    cell.nameLabel.text = array[indexPath.row];
    cell.textField.hidden = YES;
    cell.headerImageView.hidden = YES;
    cell.rightLabel.text = @"";
    cell.rightDetailLabel.text = @"";
    cell.arrowImageView.hidden = NO;
    if (indexPath.section == 1){
        if (indexPath.row == 0){//缓存
           cell.rightDetailLabel.text = @"";
        }else if (indexPath.row == 2){
            cell.rightLabel.text = self.version;
            cell.arrowImageView.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row == 0){//更改手机号
            [self.navigationController pushViewController:[[ChangePhoneNumVC alloc] init] animated:YES];
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0://清除缓存
                [self presentAlertController:1000 title:@"清除缓存"];
                break;
            case 1://意见反馈
                [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
                break;
            case 2://版本号
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){//推出
            [self presentAlertController:2000 title:@"是否注销登录"];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*UIRate;
}

//弹窗
- (void)presentAlertController:(int)tag title:(NSString *)title{
    __weak typeof (self) weakSelf = self;
    HHAlertController *alert = [HHAlertController alertWithTitle:title
                                                         message:nil
                                                 sureButtonTitle:@"确定"
                                               cancelButtonTitle:@"取消"
                                                      sureHandel:^{
                                                          if (tag == 1000){ //清缓存
                                                              [weakSelf clearMemory];
                                                          }else if (tag == 2000){//退出
                                                              [weakSelf logout];
                                                          }
                                                      }
                                                    cancelHandel:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

//清除缓存
- (void)clearMemory{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [LCProgressHUD showSuccess:@"清除成功"];
    }];
}

//退出
- (void)logout{
    [UserHelper logout];
    //退出融云
    [[RCDLive sharedRCDLive] logoutRongCloud];
    if (![UserHelper isLogin]){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
