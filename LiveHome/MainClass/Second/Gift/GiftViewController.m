//
//  GiftViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/15.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "GiftViewController.h"
#import "GiftCollectionViewCell.h"
#import "HHAlertController.h"
#import "GiftModel.h"

@interface GiftViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *holdView;
@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    [self initView];
    [self initFootView];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"礼物";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    
    CGFloat ItemWidth = ScreenWidth/4.0;
    CGFloat ItemHeight = 120*UIRate;
    UICollectionViewFlowLayout * aLayOut = [[UICollectionViewFlowLayout alloc]init];
    aLayOut.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    aLayOut.minimumLineSpacing = 0;
    aLayOut.minimumInteritemSpacing = 0;
    aLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:aLayOut];
    [_mCollectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mCollectionView];
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.offset(-95*UIRate);
    }];
}

- (void)initFootView{
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(15);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"需要定制请联系客服";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-50*UIRate);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = FONT_SYSTEM(12);
    phoneLabel.textColor = [UIColor fontColorLightGray];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipsLabel.mas_bottom).offset(8*UIRate);
    }];
    NSString *number = @"0510-68560855";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:1],NSUnderlineColorAttributeName:[UIColor fontColorLightGray]} range:NSMakeRange(0, attributeString.length)];
    //用法
    phoneLabel.attributedText = attributeString;
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn addTarget:self action:@selector(phoneCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(tipsLabel);
        make.height.mas_equalTo(50*UIRate);
        make.centerX.equalTo(phoneLabel);
        make.top.equalTo(tipsLabel);
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
    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.verLine.hidden = ((indexPath.row + 1)%4 == 0) ? YES : NO;
    cell.topLine.hidden = ((indexPath.row)/4 == 0) ? NO : YES;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftModel *model = self.dataArray[indexPath.row];
    if ([@"1" isEqualToString:model.include]){//已选
        model.include = @"0";
    }else {
        model.include = @"1";
    }
    [collectionView reloadData];
}

#pragma mark - Action
//保存
- (void)rightBarButtonItemAction{
    NSMutableArray *mArray = [NSMutableArray array];
    for (GiftModel *model in self.dataArray){
        if (!model.isInclud){
            [mArray addObject:model.giftId];
        }
    }
    NSString *str = [mArray componentsJoinedByString:@","];//,为分隔符
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:str forKey:@"id"];
    [LHConnect postGiftExclude:params loading:@"保存中..." success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"保存成功"];
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//打电话
- (void)phoneCallAction{
    __weak typeof (self) weakSelf = self;
    HHAlertController *alert = [HHAlertController alertWithTitle:@"客服电话"
                                                         message:@"0510-68560855"
                                                 sureButtonTitle:@"呼叫"
                                               cancelButtonTitle:@"取消"
                                                      sureHandel:^{
                                                          [weakSelf phoneCall];
                                                      }
                                                    cancelHandel:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

//打电话
- (void)phoneCall{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        NSString *phone = [NSString stringWithFormat:@"tel://051068560855"];
        NSURL *url = [NSURL URLWithString:phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
        } else {
           
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://051068560855"]];
    }
}

#pragma mark - 数据请求
- (void)requestData{
    [LHConnect postGiftList:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        [self.dataArray removeAllObjects];
        NSArray *array = [GiftModel mj_objectArrayWithKeyValuesArray:response];
        [self.dataArray addObjectsFromArray:array];
        [self.mCollectionView reloadData];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
