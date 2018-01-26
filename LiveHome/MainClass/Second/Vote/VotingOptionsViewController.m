//
//  VotingOptionsViewController.m
//  LiveHome
//
//  Created by nie on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VotingOptionsViewController.h"
#import "VoteViewController.h"
#import "VotingOptionsCell.h"
#import "PhotoHelper.h"
#import "VotingOptionsModel.h"
#import "ToolsHelper.h"

@interface VotingOptionsViewController ()<UITableViewDelegate, UITableViewDataSource,VotingOptionsCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *addOptionsArray;
@property (nonatomic, strong) VotingOptionsModel *votingOptionsModel;
@property(nonatomic, assign) BOOL isEdit;
@end

@implementation VotingOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{
    
    //1、页面基础设置 导航栏右侧按钮
    self.navigationItem.title = @"投票选项";
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    
    //2、全局数组初始化
    _addOptionsArray = [NSMutableArray array];
    
    
    //3、判断是否编辑状态
    if ([_dic objectForKey:@"items"]){
        _isEdit = YES;
        
        //编辑状态，根据items数组返回创建新的model添加到全局数组里面
        NSArray *itemsArr = [_dic objectForKey:@"items"];
        for (int i = 0; i < itemsArr.count; i++)
        {
            VotingOptionsModel *model = [[VotingOptionsModel alloc] init];
            model.describe = [itemsArr[i] objectForKey:@"content"];
            model.imageUrl = [itemsArr[i] objectForKey:@"image"];
            [_addOptionsArray addObject:model];
        }
        
    }else{
        _isEdit = NO;
        VotingOptionsModel *model = [[VotingOptionsModel alloc] init];
        model.image = [UIImage imageNamed:@"s_addImage-default"];
        [_addOptionsArray addObject:model];
    }
    
    //4、初始化_tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.footerView;
    _tableView.backgroundColor = [UIColor bgColorMain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionHeaderHeight = NO;
    _tableView.estimatedSectionFooterHeight = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //5、添加手势
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTap)];
    [self.view addGestureRecognizer:aTap];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _addOptionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    VotingOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VotingOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.votingOptionsModel = self.addOptionsArray[indexPath.section];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该投票选项？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self.addOptionsArray removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UIView *)footerView{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80*UIRate)];
        UIButton *button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"添加选项" forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SYSTEM_BOLD(15);
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_footerView);
            make.size.mas_equalTo(CGSizeMake(100*UIRate, 35*UIRate));
        }];
    }
    return _footerView;
}

#pragma mark - Action
#pragma mark _____添加选项
- (void)buttonAction{
    
    //1、投票选项最多创建10个
    if (_addOptionsArray.count >= 10) return;
    
    //2、判断投票信息是否有值
    if ( ![self judgeWhetherTheVotingInformationIsWorth]) return;
    
    //3、创建一个新的model添加到数组中然后刷新表格
    VotingOptionsModel *model = [[VotingOptionsModel alloc] init];
    model.image = [UIImage imageNamed:@"s_addImage-default"];
    [_addOptionsArray addObject:model];
    [_tableView reloadData];
}

- (void)aTap{
    [self.view endEditing:YES];
}

#pragma mark _____保存按钮
- (void)rightBarButtonItemAction{
    
    //1、没有投票选项的时候
    if (_addOptionsArray.count == 0) {
        [LCProgressHUD showFailure:@"请添加投票选项"];
        return;
    }
    
    //2、投票选项不得少于2个
    else if (_addOptionsArray.count < 2){
        [LCProgressHUD showFailure:@"投票选项数量不得少于2个"];
        return;
    }
    
    //3、判断投票信息是否有值
    if ( ![self judgeWhetherTheVotingInformationIsWorth]) return;
    
    //4、调用保存投票接口
    [self requestData];
}

#pragma mark _____判断投票信息是否有值
-(BOOL )judgeWhetherTheVotingInformationIsWorth
{
    //遍历数组判断图片是否上传成功和描述是否都有
    for (int i = 0; i < _addOptionsArray.count; i++)
    {
        VotingOptionsModel *model = _addOptionsArray[i];
        
        if ([ToolsHelper isBlankString:model.imageUrl] == YES)
        {
            [LCProgressHUD showFailure:@"图片未上传成功，请点击重新选择并上传"];
            return NO;
        }
        
        if (model.describe.length == 0)
        {
            [LCProgressHUD showFailure:@"未填写描述"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - VotingOptionsCellDelegate
-(void)addImageWithIndexPath:(NSIndexPath *)indexPath{
    
    //相册选择照片调用
    PhotoHelper *photoHelper = [PhotoHelper sharedInstance];
    [photoHelper addPhotoWithController:self];
    __weak typeof (self) weakSelf = self;
    photoHelper.block = ^(UIImage *image) {
        
        //修改数组中model对应的图片值
        VotingOptionsModel *model = self.addOptionsArray[indexPath.section];
        model.image = image;
        [weakSelf postImageSource:model];//上传图片
        
        //刷新当前表格
        //[weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
}


-(void)textViewDidEndEditing:(NSString *)text WithIndexPath:(NSIndexPath *)indexPath
{
    //修改数组中model对应的投票描述
    VotingOptionsModel *model = self.addOptionsArray[indexPath.section];
    model.describe = text;
}

#pragma mark - 网络请求
#pragma mark _____图片资源上传
- (void)postImageSource:(VotingOptionsModel *)model
{
    NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:model.image, nil];
    [LHConnect uploadImageResource:nil loading:@"图片上传中..." imageArray:imageArray success:^(id  _Nonnull response) {
        NSArray *array = (NSArray *)response;
        model.imageUrl = array.firstObject;
        [LCProgressHUD showSuccess:@"图片上传成功"];
        [self.tableView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

#pragma mark _____添加投票选项
- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params = [_dic mutableCopy];
    
    //1、遍历数组创建一个存储图片上传成功后的URL和投票描述
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < _addOptionsArray.count; i++)
    {
        VotingOptionsModel *model = _addOptionsArray[i];
        NSDictionary *dic = @{@"image":model.imageUrl,@"content":model.describe};
        [arr addObject:dic];
    }
    //2、生成的新数组转换成json字符串
    NSString *items = [ToolsHelper arrayToJson:arr];
    
    //3、创建一个新字典，copy上个页面传值的字典，并且添加新参数items
    [params setValue:items forKey:@"items"];
    
    if (_isEdit == YES){
        //请求数据，成功后直接返回投票列表页面
        [LHConnect postVoteEdit:params loading:nil success:^(id  _Nonnull response) {
            
            [LCProgressHUD showSuccess:@"投票选项修改成功"];
            
            VoteViewController *power = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:power animated:YES];
            
        } successBackFail:^(id  _Nonnull response) {
            
        }];
    }
    else{
        //字典删除ID接口需要
        [params removeObjectForKey:@"id"];
        
        //请求数据，成功后直接返回投票列表页面
        [LHConnect postVoteAdd:params loading:nil success:^(id  _Nonnull response) {
            [LCProgressHUD showSuccess:@"投票选项保存成功"];
            
            VoteViewController *power = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:power animated:YES];
            
        } successBackFail:^(id  _Nonnull response) {
            
        }];
    }
}
@end
