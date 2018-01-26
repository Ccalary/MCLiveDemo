
//
//  VoteViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VoteViewController.h"
#import "VoteCreationViewController.h"
#import "VotingResultsViewController.h"

#import "VotingListCell.h"
#import "VotingListModel.h"

#import "BaseTableView.h"
@interface VoteViewController ()<UITableViewDelegate, UITableViewDataSource,VotingListCellDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;

@end

@implementation VoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _page = 1;
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    
    /*********************导航栏title按钮*********************/
    self.navigationItem.title = @"投票列表";
    self.view.backgroundColor = [UIColor bgColorMain];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
 
    
    _page = 1;//默认从1开始
    _dataArray = [NSMutableArray array];
    
    /*********************初始化tableView*********************/
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    
    /*********************下拉刷新*********************/
    __weak typeof (self) weakSelf = self;
    //下拉刷新
    _tableView.mj_header = [HHRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    
    //上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestData];
    }];
    
    [_tableView.mj_header beginRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    VotingListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VotingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.votingListModel = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Action
- (void)rightBarButtonItemAction{
    
    VoteCreationViewController *voteVC = [[VoteCreationViewController alloc]init];
    [self.navigationController pushViewController:voteVC animated:YES];
}

//投票结果
-(void)votingResultWithIndexPath:(NSIndexPath *)indexPath
{
    VotingListModel *model = self.dataArray[indexPath.section];
    VotingResultsViewController *vc = [[VotingResultsViewController alloc] init];
    vc.activitID = model._id;
    [self.navigationController pushViewController:vc animated:YES];
}

//投票状态编辑
-(void)votingStatusEditorWithIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)sender
{
    VotingListModel *model = self.dataArray[indexPath.section];
    __weak __typeof(self)weakSelf = self;
    //编辑
    if (sender.tag == 100)
    {
        VoteCreationViewController *voteVC = [[VoteCreationViewController alloc]init];
        voteVC.votingId = model._id;
        voteVC.type = 1;
        [self.navigationController pushViewController:voteVC animated:YES];
    }
    else//删除
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该投票选项？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf voteDeleteRequestData:model._id];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//网络获取
#pragma mark - 网络请求
- (void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@(10) forKey:@"size"];
    [LHConnect postVoteList:params loading:nil success:^(id  _Nonnull response) {
        if (self.page == 1){
            [self.dataArray removeAllObjects];
        }
        
        //DLog(@"%@",response);
        NSArray *array = [VotingListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"rows"]];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (array.count < 10){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } successBackFail:^(id  _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)voteDeleteRequestData:(NSString *)_id
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_id forKey:@"id"];
    
    [LHConnect postVoteDelete:params loading:nil success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"投票删除成功"];
        _page = 1;
        [self requestData];
    } successBackFail:^(id  _Nonnull response) {
       
    }];
}
@end
