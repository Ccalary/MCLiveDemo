//
//  StatisticsViewController.m
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsTableViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "HHPopSelectView.h"
#import "StatisticsSelectView.h"
#import "StaticHeaderView.h"
#import "LHConnect.h"
#import "StatisticsModel.h"
@interface StatisticsViewController ()<UITableViewDelegate, UITableViewDataSource, StatisticsSelectViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) StatisticsSelectView *selectView;
@property (nonatomic, strong) HHPopSelectView *popSelectView;
@property (nonatomic, strong) StaticHeaderView *headerView;
@property (nonatomic, assign) int selectType; //0，1，2 筛选种类
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectType = 0;
    self.dataArray = [NSMutableArray array];
    [self initView];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"直播统计";
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70*UIRate, 30*UIRate)];
    customView.backgroundColor = [UIColor clearColor];
    _rightButton = [[UIButton alloc] initWithFrame:customView.frame];
    [_rightButton setTitle:@"一周内" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = FONT_SYSTEM(15);
    [_rightButton setImage:[UIImage imageNamed:@"arrow_white_9x15"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
    [customView addSubview:_rightButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (StaticHeaderView *)headerView{
    if (!_headerView){
        _headerView = [[StaticHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250*UIRate)];
    }
    return _headerView;
}

- (StatisticsSelectView *)selectView{
    if (!_selectView){
        _selectView = [[StatisticsSelectView alloc] initWithFrame:CGRectMake(0, 0, 100*UIRate, 120*UIRate)
                                                     andDataArray:@[@"一周内",@"一月内",@"一年内"]];
        _selectView.delegate = self;
    }
    return _selectView;
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
    StatisticsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bgColor = (indexPath.row%2 == 0) ? [UIColor colorWithHex:0xe3e8ee] : [UIColor bgColorWhite];
    cell.dataArray = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 0, ScreenWidth - 29, 1)];
    line.backgroundColor = [UIColor bgColorLineDarkGray];
    [holdView addSubview:line];
    return holdView;
}

#pragma mark - StatisticsSelectViewDelegate 筛选代理
- (void)didSelectRow:(int)row title:(NSString *)text{
    self.selectType = row;
    [_rightButton setTitle:text forState:UIControlStateNormal];
    [_popSelectView dismiss];
    [self requestData];
}


#pragma mark - Action
- (void)rightButtonAction{
    _popSelectView = [[HHPopSelectView alloc] initWithOrigin:CGPointMake(ScreenWidth - 30, TopFullHeight) andCustomView:self.selectView];
    [_popSelectView popView];
}

- (void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.selectType) forKey:@"type"];
    [LHConnect postZhiBoData:params loading:@"加载中..." success:^(id  _Nonnull response) {
        NSArray *array = [StatisticsModel mj_objectArrayWithKeyValuesArray:response];
        [self.dataArray removeAllObjects];
        NSArray *titleArray = @[@"日期",@"时长(分)",@"人数",@"打赏(元)"];
        [self.dataArray addObject:titleArray];
        //数据处理
        NSMutableArray *peopleArray = [NSMutableArray array];
        NSMutableArray *dateArray = [NSMutableArray array];
        for (StatisticsModel *model in array){
            NSArray *cellArray = @[model.date, model.length, model.count, model.m];
            [self.dataArray addObject:cellArray];
            [peopleArray addObject:model.count];
            if (self.selectType == 0){//周
               [dateArray addObject:[self getTheDateString:model.date withIndex:0]];
            }else if (self.selectType == 1){//月
                 [dateArray addObject:[self getTheDateString:model.date withIndex:2]];
            }else{//年
               [dateArray addObject:[self getTheDateString:model.date withIndex:1]];
            }
        }
        [self.headerView resetDataArray:peopleArray andXLabelData:dateArray];
        [self.tableView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//获得周,月份,几号（dateString 类型为yyyy-MM-dd）
-(NSString *)getTheDateString:(NSString *)dateString withIndex:(int)index{
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];//周几，月份，天
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    return [weekArray objectAtIndex:index];
}


@end
