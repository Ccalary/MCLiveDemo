//
//  VotingResultsViewController.m
//  LiveHome
//
//  Created by nie on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VotingResultsViewController.h"
#import "VotingResultsCell.h"
#import "VotingResultsModel.h"
#import "VoteViewController.h"

@interface VotingResultsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,assign) int allCount;

@end

@implementation VotingResultsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSArray alloc] init];
    [self initView];
    [self requestVoteInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"投票结果";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const cellIdentifier = @"CellIdentifier";
    VotingResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[VotingResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.allCount = self.allCount;
    cell.voteModel = self.dataArray[indexPath.row];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, ScreenWidth, 60);
    v.backgroundColor = [UIColor bgColorMain];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"s_voteActive_bg"];
    [v addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(v);
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"2017阿里校友创业黄埔榜-创新创业峰会";
    lab.textAlignment = NSTextAlignmentCenter;
    [v addSubview:lab];
    self.titleLabel = lab;
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//网络获取
- (void)requestVoteInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.activitID forKey:@"id"];
    [LHConnect postVoteInfo:params loading:nil success:^(id  _Nonnull response) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",response[@"title"]];
        self.dataArray = [VotingResultsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"results"]];
        
        self.allCount = 0;
        for (VotingResultsModel *model in self.dataArray) {
            self.allCount = self.allCount+model.count;
        }
        [self.tableView reloadData];
        
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

@end
