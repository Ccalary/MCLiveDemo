//
//  PackageDetailVC.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PackageDetailVC.h"
#import "PackageHeaderView.h"
#import "PackageDetailTableViewCell1.h"
#import "PackageDetailTableViewCell2.h"
#import "WXPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "ToolsHelper.h"
#import "PayPopView.h"
#import "CNPPopupController.h"
#import "PackageDetailModel.h"
#import "BaseWebViewController.h"
#import "HHAlertController.h"
#import <IAPHelper/IAPHelper.h>
#import <IAPHelper/IAPShare.h>
#define kCell @"kCell"
#define kModel @"kModel"

@interface PackageDetailVC ()<UITableViewDelegate, UITableViewDataSource, PayPopViewDelegate>
@property (nonatomic, strong) PackageHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@property (nonatomic, strong) PayPopView *popView;
@property (nonatomic, strong) CNPPopupController *popController;
@property (nonatomic, assign) int payType;//0-微信，1-支付宝
@property (nonatomic, assign) int orderType;//0-大众版 1-专业版
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PackageDetailModel *model;
@end

@implementation PackageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellsArray = [NSMutableArray array];
    self.payType = 0;
    self.orderType = 1;
    self.dataArray = [NSMutableArray array];
    [self initView];
    [self updataCells];
    [self requestBanners];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"升级套餐";
    
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
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70*UIRate)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15*UIRate, 15*UIRate, ScreenWidth - 30*UIRate, 40*UIRate)];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"立即支付" forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SYSTEM_BOLD(15);
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
    }
    return _footerView;
}

- (PayPopView *)popView{
    if (!_popView){
        _popView = [[PayPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 330*UIRate)];
        _popView.delegate = self;
    }
    return _popView;
}

- (void)updataCells
{
    [self.cellsArray removeAllObjects];
    
    NSMutableArray *array1 = [NSMutableArray array];
    NSDictionary *dic1 = @{kCell:@"PackageDetailTableViewCell1"};
    [array1 addObject:dic1];
    [self.cellsArray addObject:array1];
    
    NSMutableArray *array2 = [NSMutableArray array];
    NSDictionary *dic2 = @{kCell:@"PackageDetailTableViewCell2"};
    [array2 addObject:dic2];

    [self.cellsArray addObject:array2];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = self.cellsArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = self.cellsArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    
    if ([dic[kCell] isEqualToString:@"PackageDetailTableViewCell1"])
    {
        PackageDetailTableViewCell1  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell){
            cell = [[PackageDetailTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        __weak typeof (self) weakSelf = self;
        cell.block = ^(NSInteger tag) {
            if (tag == 1000){//大众版
                for (PackageDetailModel *model in weakSelf.dataArray){
                    if ([model.type intValue] == 0){
                        weakSelf.model = model;
                        weakSelf.orderType = 0;
                    }
                }
            }else if (tag == 2000){//专业版
                for (PackageDetailModel *model in weakSelf.dataArray){
                    if ([model.type intValue] == 1){
                        weakSelf.model = model;
                        weakSelf.orderType = 1;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        };
        cell.dataArray = self.dataArray;
        return cell;
    }else if ([dic[kCell] isEqualToString:@"PackageDetailTableViewCell2"]){
        PackageDetailTableViewCell2  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell){
            cell = [[PackageDetailTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.model = self.model;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = self.cellsArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    if ([dic[kCell] isEqualToString:@"PackageDetailTableViewCell1"]) return 115*UIRate;
    return 290*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*UIRate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - Action
//支付
- (void)buttonAction{
    [self pay];
//    [self phoneCallAction];
    
//    self.popController = [[CNPPopupController alloc] initWithContents:@[self.popView]];
//    self.popController.theme.popupStyle = CNPPopupStyleActionSheet;
//    [self.popController presentPopupControllerAnimated:YES];
//    self.popView.moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",[self.model.price doubleValue]];
}

//打电话
- (void)phoneCallAction{
    __weak typeof (self) weakSelf = self;
    HHAlertController *alert = [HHAlertController alertWithTitle:@"升级套餐"
                                                         message:@"请联系官方座机0510-68560855"
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


#pragma mark - 支付弹窗的代理
- (void)payPopViewButtonAction:(PayPopViewBtnType)type{
    switch (type) {
        case PayPopViewBtnTypeClose:
            [self.popController dismissPopupControllerAnimated:YES];
            break;
        case PayPopViewBtnTypeWeChat:
            self.payType = 1;
            break;
        case PayPopViewBtnTypeAlipay:
            self.payType = 2;
            break;
        case PayPopViewBtnTypePay:
            [self requestPackageOrder];
            break;
    }
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

//请求数据
- (void)requestData{
    [LHConnect postPackageList:nil loading:@"加载中..." success:^(id  _Nonnull response) {
        NSArray *array = [PackageDetailModel mj_objectArrayWithKeyValuesArray:response];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        for (PackageDetailModel *model in self.dataArray){
            if ([model.type intValue] == 1){
                self.model = model;
            }
        }
        [self updataCells];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//请求订单
- (void)requestPackageOrder{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@(self.orderType) forKey:@"type"];
//    [LCProgressHUD showKeyWindowLoading:@"请求支付中..."];
//    [LHConnect postPackageOrder:params loading:@"" success:^(id  _Nonnull response) {
//        [self payWithOrdeId:response];
//    } successBackFail:^(id  _Nonnull response) {
//
//    }];
    [self pay];
}

//支付
- (void)payWithOrdeId:(NSString *)orderId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.payType) forKey:@"type"];//0-微信 1-支付宝
    [params setValue:orderId forKey:@"orderid"];//订单号
    [LCProgressHUD showKeyWindowLoading:@"请求支付中..."];
    [LHConnect postPackagePay:params loading:@"" success:^(id  _Nonnull response) {
        if (self.payType == 1){
            NSDictionary *dic = [ToolsHelper dictionaryFromJson:response];
            WXPayModel *model = [WXPayModel mj_objectWithKeyValues:dic];
            PayReq *request = [[PayReq alloc]init];
            request.partnerId = model.partnerid;//商户号
            request.prepayId = model.prepayid;//预支付交易会话ID
            request.nonceStr = model.noncestr;//随机字符串
            request.timeStamp = [model.timestamp intValue];//时间戳
            request.package = model.package;//扩展字段
            request.sign = model.sign;//签名
            [WXApi sendReq:request];
        }else {
            [[AlipaySDK defaultService] payOrder:response fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
                
            }];
        }
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

- (void)pay{
    NSString *typeName = @"professional";
    if (self.orderType == 0){//大众版
        typeName = @"normal";
    }else {//专业版
        typeName = @"professional";
    }

    [LCProgressHUD showLoading:@"支付请求中..."];
    NSSet* dataSet = [[NSSet alloc] initWithObjects:typeName, nil];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [IAPShare sharedHelper].iap.production = YES;//是否是正式环境
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         [LCProgressHUD hide];
         if(response > 0 ) {
             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             DLog(@"Price: %@\nTitle: %@",product.price,product.localizedTitle);
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                     
                                            if(trans.error)
                                            {
                                                DLog(@"Fail %@",[trans.error localizedDescription]);
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                
                                                [self checkReceiptWith:trans typeName:typeName];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                DLog(@"Fail");
                                            }
                                        }];
         }
     }];
}

//购买验证
- (void)checkReceiptWith:(SKPaymentTransaction *)trans typeName:(NSString *)typeName{
    [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:nil onCompletion:^(NSString *response, NSError *error) {
        
        //Convert JSON String to NSDictionary
        NSDictionary* rec = [IAPShare toJSON:response];
        
        if([rec[@"status"] integerValue] == 0)
        {
            //上传返回信息
            [self uploadBackInfo:response];
            [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
            DLog(@"SUCCESS %@",response);
            DLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
            
            //请求接口告知服务器购买成功
            [self uploadPaySuccess:typeName];
        }
        else if ([rec[@"status"] integerValue] == 21007 ){//沙盒测试环境
            [IAPShare sharedHelper].iap.production = NO;//是否是正式环境
            [self checkReceiptWith:trans typeName:typeName];
        }else {
            DLog(@"Fail");
        }
    }];
}


//付款成功信息上传
- (void)uploadPaySuccess:(NSString *)payName{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:payName forKey:@"name"];
    [LHConnect postAppleNotify:params loading:nil success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"购买成功"];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

//付款成功后信息上传
- (void)uploadBackInfo:(NSString *)content{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:content forKey:@"content"];
    [LHConnect postAppErrorInfo:params loading:nil success:^(id  _Nonnull response) {
        
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
