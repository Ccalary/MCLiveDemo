//
//  OldVideosVC.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "OldVideosVC.h"
#import "OldVideosCollectionViewCell.h"
#import "FBKVOController.h"
#import "VideoListModel.h"
#import "OldVideoWebVC.h"
#import "OldVideoDeleteView.h"
#import "CNPPopupController.h"
#import "OldVideoWritePopView.h"
#import "PhotoHelper.h"
#import "TempListModel.h"
#import "TempSelectView.h"

@interface OldVideosVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource, OldVideoDeleteViewDelegate, OldVideosCollectionCellDelegate,OldVideoWritePopViewDelegate,PhotoHelperDelegate>
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) OldVideoDeleteView *managerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *tempArray; //模版列表
@property (nonatomic, strong) UIButton *managerBtn;
@property (nonatomic, strong) FBKVOController *kvoController;
@property (nonatomic, strong) CNPPopupController *popController;
@property (nonatomic, strong) OldVideoWritePopView *popView;
@property (nonatomic, strong) VideoListModel *editModel;//编辑的视频的Model
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) TempSelectView *tempSelectView;
@property (nonatomic, strong) CNPPopupController *tempPopController;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSString *tempID; //模版编号
@end

@implementation OldVideosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _imageArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
    _page = 1;//默认从1开始
    [self initView];
    [self initDefaultView];
    [self initFBKVO];
    //有新的视频产生的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNewVideoData) name:NoticeHaveNewVideoData object:nil];
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:NoticeLoginSuccess object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (OldVideoDeleteView *)managerView{
    if (!_managerView){
        _managerView = [[OldVideoDeleteView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 35*UIRate)];
        _managerView.delegate = self;
    }
    return _managerView;
}
//编辑弹窗
- (OldVideoWritePopView *)popView{
    if (!_popView){
        _popView = [[OldVideoWritePopView alloc] initWithFrame:CGRectMake(0, 0, 280*UIRate, 305*UIRate)];
        _popView.delegate = self;
    }
    return _popView;
}

//模版列表
- (TempSelectView *)tempSelectView{
    if (!_tempSelectView){
        _tempSelectView = [[TempSelectView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 120*UIRate)];
        __weak typeof (self) weakSelf = self;
        _tempSelectView.block = ^(TempListModel *model) {
            [weakSelf.tempPopController dismissPopupControllerAnimated:YES];
            weakSelf.popView.tempLabel.text = model.title ?: @"";
            weakSelf.tempID = model.pid;
        };
    }
    return _tempSelectView;
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"历史";
    
    _managerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [_managerBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_managerBtn setTitle:@"完成" forState:UIControlStateSelected];
    _managerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_managerBtn addTarget:self action:@selector(managerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_managerBtn];
    
    CGFloat ItemWidth = (ScreenWidth - 15*UIRate)/2.0;
    CGFloat ItemHeight = 153*UIRate;
    UICollectionViewFlowLayout * aLayOut = [[UICollectionViewFlowLayout alloc]init];
    aLayOut.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    aLayOut.minimumLineSpacing = 3*UIRate;
    aLayOut.minimumInteritemSpacing = 4*UIRate;
    aLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:aLayOut];
    [_mCollectionView registerClass:[OldVideosCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.backgroundColor = [UIColor bgColorMain];
    [self.view addSubview:_mCollectionView];
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5*UIRate);
        make.right.offset(-5*UIRate);
        make.top.offset(10*UIRate);
        make.bottom.equalTo(self.view);
    }];
    
    __weak typeof (self) weakSelf = self;
    _mCollectionView.mj_header = [HHRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf requestData];
    }];
    _mCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [weakSelf requestData];
    }];
    
    [_mCollectionView.mj_header beginRefreshing];
    //iOS11 适配
    if (@available(iOS 11.0, *)) {
        _mCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mCollectionView.contentInset = UIEdgeInsetsMake(0, 0, TabBarHeight, 0);
        _mCollectionView.scrollIndicatorInsets = _mCollectionView.contentInset;
    }
}

- (void)initDefaultView{
    
    _holdView = [[UIView alloc] init];
    _holdView.backgroundColor = [UIColor clearColor];
    _holdView.hidden = YES;
    [self.mCollectionView addSubview:_holdView];
    
    UIImageView *defaultImageView = [[UIImageView alloc] init];
    defaultImageView.image = [UIImage imageNamed:@"camera_150"];
    [_holdView addSubview:defaultImageView];
    
    UILabel *stringLabel = [[UILabel alloc] init];
    stringLabel.numberOfLines = 0;
    stringLabel.font = FONT_SYSTEM(15);
  
    stringLabel.textColor = [UIColor fontColorLightGray];
    [_holdView addSubview:stringLabel];
    
    NSString *textString = @"您还没有直播历史\n请开始直播吧！";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8]; //调整行间距
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeStr length])];
    stringLabel.attributedText = attributeStr;
    stringLabel.textAlignment = NSTextAlignmentCenter;
    
    [_holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.mCollectionView);
        make.center.equalTo(self.mCollectionView);
    }];
    [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_holdView);
        make.top.offset(135*UIRate);
        make.width.mas_equalTo(150*UIRate);
        make.height.mas_equalTo(150*UIRate);
    }];
    [stringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_holdView);
        make.top.equalTo(defaultImageView.mas_bottom).offset(35*UIRate);
    }];
}

- (void)initFBKVO{
    //KVO
    __weak typeof (self) weakSelf = self;
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:self.mCollectionView keyPath:@"contentSize" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        CGFloat height =  weakSelf.mCollectionView.contentSize.height;
        _holdView.hidden = (height > 20) ? YES : NO;
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//cell的记载
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OldVideosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.dataArray[indexPath.row];
    cell.isManager = _managerBtn.selected;
    cell.delegate = self;
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_managerBtn.selected) {
        [LCProgressHUD showFailure:@"编辑状态不可观看"];
        return;
    }
    VideoListModel *videoModel = self.dataArray[indexPath.row];
    if (videoModel.url.length == 0){
        [LCProgressHUD showFailure:@"此视频不可播放"];
        return;
    }
    OldVideoWebVC *webVC = [[OldVideoWebVC alloc] initWithTitle:videoModel.name andUrl:videoModel.url];
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - 全选删除代理
- (void)oldVideoManagerBtnAction:(UIButton *)button{
    switch (button.tag) {
        case OldVideoDeleteViewBtnTypeSelect://全选
        {   button.selected = !button.selected;
            [self selectAllVideo:button.selected];
            [self.mCollectionView reloadData];
        }
            break;
        case OldVideoDeleteViewBtnTypeDelete://删除
            [self requestDeleteVideo];
            break;
    }
}

#pragma mark - cell的代理
- (void)oldVideoCellBtnActionWithCell:(OldVideosCollectionViewCell *)cell type:(OldVideosCollectionCellBtnType)type{
    switch (type) {
        case OldVideosCollectionCellBtnTypeSelect://选择
        {
            VideoListModel *videoModel = self.dataArray[cell.indexPath.row];
            videoModel.isSelected = !videoModel.isSelected;
            [self.mCollectionView reloadItemsAtIndexPaths:@[cell.indexPath]];
            if (!videoModel.isSelected){
               self.managerView.selectBtn.selected = NO;
            }
        }
            break;
        case OldVideosCollectionCellBtnTypeWrite://编辑
        {
            self.editModel = self.dataArray[cell.indexPath.row];
            self.tempID = self.editModel.templateId;
            self.popController = [[CNPPopupController alloc] initWithContents:@[self.popView]];
            self.popView.model = self.editModel;
            self.popController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
            self.popController.theme.shouldDismissOnBackgroundTouch = YES;
            [self.popController presentPopupControllerAnimated:YES];
            break;
        }
    }
}

#pragma mark - 编辑弹窗代理
- (void)oldVideoWriteViewBtnClick:(OldVideoWritePopViewBtnType)type{
    switch (type) {
        case OldVideoWritePopViewBtnTypeAdd://添加照片
        {
            PhotoHelper *photoHelper = [PhotoHelper sharedInstance];
            photoHelper.delegate = self;
            [photoHelper addPhotoWithController:self];
            __weak typeof (self) weakSelf = self;
            photoHelper.block = ^(UIImage *image) {
                [self.imageArray removeAllObjects];
                weakSelf.popView.bannerImage = image;
                [self.imageArray addObject:image];
                [self.popController presentPopupControllerAnimated:YES];
            };
        }
            break;
        case OldVideoWritePopViewBtnTypeSubmit://提交
            [self.popController dismissPopupControllerAnimated:YES];
            [self submitAction];
            break;
        case OldVideoWritePopViewBtnTypeTemp://模版
            self.tempPopController = [[CNPPopupController alloc] initWithContents:@[self.tempSelectView]];
            self.tempSelectView.dataArray = self.tempArray;
            self.tempPopController.theme.popupStyle = CNPPopupStyleActionSheet;
            self.tempPopController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
            self.tempPopController.theme.shouldDismissOnBackgroundTouch = YES;
            [self.tempPopController presentPopupControllerAnimated:YES];
            break;
    }
}

- (void)submitAction{
    NSString *titel = self.popView.textView.text;
    if (titel.length == 0){
        [LCProgressHUD showFailure:@"标题不可为空"];
        return;
    }
    if (self.imageArray.count){//如果图片进行了更改
        self.editModel.name = titel;
        [LHConnect uploadImageResource:nil loading:@"更新中..." imageArray:self.imageArray success:^(id  _Nonnull response) {
            NSArray *array = (NSArray *)response;
            self.editModel.image = array.firstObject;
            [self requestUpdateListInfo];
        } successBackFail:^(id  _Nonnull response) {
        }];
    }else {//图片没更改,模版没更改
       if([titel isEqualToString:self.editModel.name] && [self.tempID isEqualToString:self.editModel.templateId]) {
           return;
       }
        self.editModel.name = titel;
        [self requestUpdateListInfo];
    }
}

#pragma mark - PhotoHelperDelegate 添加图片代理
- (void)clickAddPhotoBtn{
    [self.popController dismissPopupControllerAnimated:YES];
}


#pragma mark - Action
//通知消息
- (void)haveNewVideoData{
    [_mCollectionView.mj_header beginRefreshing];
}

//登录成功
- (void)loginSuccessAction{
    [_mCollectionView.mj_header beginRefreshing];
}

//是否全选所有数据
- (void)selectAllVideo:(BOOL)select{
    for (VideoListModel *model in self.dataArray){
        model.isSelected = select;
    }
}

//管理按钮
- (void)managerBtnAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.hidden){
        button.selected = NO;
    }
    [self.mCollectionView reloadData];
    if (button.selected){
        [self requestTempList];
        [self.view addSubview:self.managerView];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.managerView.frame;
            frame.origin.y = ScreenHeight - frame.size.height - TabBarHeight - TopFullHeight;
            self.managerView.frame = frame;
        }];
        
        [_mCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5*UIRate);
            make.right.offset(-5*UIRate);
            make.top.offset(10*UIRate);
            make.bottom.equalTo(self.view).offset(-35*UIRate);
        }];
        
    }else {
        self.managerView.selectBtn.selected = NO;
        [self selectAllVideo:NO];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.managerView.frame;
            frame.origin.y = ScreenHeight;
            self.managerView.frame = frame;
        }];
        [_mCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5*UIRate);
            make.right.offset(-5*UIRate);
            make.top.offset(10*UIRate);
            make.bottom.equalTo(self.view);
        }];
    }
}

//请求数据
- (void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.page) forKey:@"page"];
    [params setValue:@(10) forKey:@"size"];
    [LHConnect postVideoList:params loading:nil success:^(id  _Nonnull response) {
        if (self.page == 1){
            [self.dataArray removeAllObjects];
        }
        NSArray *array = [VideoListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"rows"]];
        //根据是否全选显示状态
        if (self.managerView.selectBtn.selected){
            for (VideoListModel *model in array){
                model.isSelected = YES;
            }
        }
        
        [self.dataArray addObjectsFromArray:array];
        if (self.dataArray.count == 0){
            self.managerBtn.hidden = YES;
            [self managerBtnAction:self.managerBtn];
        }else {
            self.managerBtn.hidden = NO;
        }
        
        [self.mCollectionView reloadData];
        [self.mCollectionView.mj_header endRefreshing];
        [self.mCollectionView.mj_footer endRefreshing];
        
        if (array.count < 10){
            [self.mCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } successBackFail:^(id  _Nonnull response) {
        [self.mCollectionView.mj_header endRefreshing];
        [self.mCollectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nullable error) {
        [self.mCollectionView.mj_header endRefreshing];
        [self.mCollectionView.mj_footer endRefreshing];
    }];
}

//更新历史记录的信息
- (void)requestUpdateListInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.editModel.videoId forKey:@"id"];//视频编号
    [params setValue:self.editModel.name forKey:@"title"];
    [params setValue:self.editModel.image forKey:@"bgimage"];//图片地址
    [params setValue:self.tempID forKey:@"template"];//模版编号可为空
    [LHConnect postVideoUpdateInfo:params loading:@"更新中..." success:^(id  _Nonnull response) {
        [self requestData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//删除历史视频
- (void)requestDeleteVideo{
    NSMutableArray *selectArray = [NSMutableArray array];
    for (VideoListModel *model in self.dataArray){
        if (model.isSelected){
            [selectArray addObject:model.videoId];
        }
    }
    if (selectArray.count == 0){
        [LCProgressHUD showMessage:@"请选择要删除的视频"];
        return;
    }
    NSString *string = [selectArray componentsJoinedByString:@";"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:string forKey:@"ids"]; //id用，分隔
    [LHConnect postVideoDeleteItems:params loading:@"删除中..." success:^(id  _Nonnull response) {
         [self requestData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//模版列表接口
- (void)requestTempList{
    [LHConnect postTemplateList:nil loading:@"" success:^(id  _Nonnull response) {
        NSArray *array = [TempListModel mj_objectArrayWithKeyValuesArray:response];
        [self.tempArray removeAllObjects];
        [self.tempArray addObjectsFromArray:array];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
