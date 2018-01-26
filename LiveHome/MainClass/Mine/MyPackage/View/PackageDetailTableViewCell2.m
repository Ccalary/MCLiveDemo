//
//  PackageDetailTableViewCell2.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PackageDetailTableViewCell2.h"
@interface PackageDetailTableViewCell2()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *flowLabel, *cloudLabel, *moneyLabel;
@property (nonatomic, strong) NSArray *dataArray;
@end
@implementation PackageDetailTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSArray array];
    
    UILabel *nameLabel = [self creatLabelWithText:@"选套餐" andColor:[UIColor fontColorBlack]];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.offset(15*UIRate);
    }];
    
    UIView *holdView = [[UIView alloc] init];
    holdView.backgroundColor = [UIColor whiteColor];
    holdView.layer.borderWidth = 2;
    holdView.layer.cornerRadius = 15*UIRate;
    holdView.layer.borderColor = [UIColor themeColor].CGColor;
    [self.contentView addSubview:holdView];
    [holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.offset(50*UIRate);
        make.height.mas_equalTo(225*UIRate);
    }];
    
    UILabel *selectText = [self creatLabelWithText:@"您选择了" andColor:[UIColor themeColor]];
    selectText.font = FONT_SYSTEM_BOLD(17);
    selectText.backgroundColor = [UIColor whiteColor];
    selectText.textAlignment = NSTextAlignmentCenter;
    [selectText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100*UIRate);
        make.height.mas_equalTo(20*UIRate);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(holdView.mas_top);
    }];
    
    UIView *dotView1 = [[UIView alloc] init];
    dotView1.backgroundColor = [UIColor themeColor];
    dotView1.layer.cornerRadius = 5*UIRate;
    [self.contentView addSubview:dotView1];
    [dotView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10*UIRate);
        make.left.equalTo(selectText).offset(2);
        make.centerY.equalTo(selectText);
    }];
    
    UIView *dotView2 = [[UIView alloc] init];
    dotView2.backgroundColor = [UIColor themeColor];
    dotView2.layer.cornerRadius = 5*UIRate;
    [self.contentView addSubview:dotView2];
    [dotView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(dotView1);
        make.right.equalTo(selectText).offset(-2);
        make.centerY.equalTo(selectText);
    }];
    
    /************流量信息View************/
    UIView *flowView = [[UIView alloc] init];
    flowView.backgroundColor = [UIColor colorWithHex:0xd1e4f5];
    [self.contentView addSubview:flowView];
    [flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holdView).offset(2);
        make.right.equalTo(holdView).offset(-2);
        make.top.equalTo(holdView).offset(20*UIRate);
        make.height.mas_equalTo(55*UIRate);
    }];
    
    _flowLabel = [self creatLabelWithText:@"100G" andColor:[UIColor themeColor]];
    _cloudLabel = [self creatLabelWithText:@"100G" andColor:[UIColor themeColor]];
    _moneyLabel = [self creatLabelWithText:@"2988/年" andColor:[UIColor themeColor]];
    UILabel *flowText = [self creatLabelWithText:@"流量" andColor:[UIColor fontColorDarkGray]];
    flowText.font = FONT_SYSTEM(12);
    UILabel *cloudText = [self creatLabelWithText:@"包年云存储" andColor:[UIColor fontColorDarkGray]];
    cloudText.font = FONT_SYSTEM(12);
    UILabel *addText = [self creatLabelWithText:@"+" andColor:[UIColor fontColorDarkGray]];
    UILabel *equalText = [self creatLabelWithText:@"=" andColor:[UIColor fontColorDarkGray]];
    
    [flowText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(70*UIRate);
        make.bottom.equalTo(flowView).offset(-6*UIRate);
    }];
    
    [_flowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(flowText);
        make.top.equalTo(flowView).offset(10*UIRate);
    }];
    
    [cloudText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(flowText);
    }];
    
    [_cloudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cloudText);
        make.centerY.equalTo(_flowLabel);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_right).offset(-70*UIRate);
        make.centerY.equalTo(flowView);
    }];
    
    [addText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(-60*UIRate);
        make.centerY.equalTo(_moneyLabel);
    }];
    
    [equalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(60*UIRate);
        make.centerY.equalTo(_moneyLabel);
    }];
    
    /**************tableView**************/
    UILabel *tipsLabel = [self creatLabelWithText:@"您可享受的优惠" andColor:[UIColor fontColorBlack]];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35*UIRate);
        make.top.equalTo(flowView.mas_bottom).offset(20*UIRate);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*UIRate);
        make.top.equalTo(tipsLabel.mas_bottom).offset(5*UIRate);
        make.right.offset(-20*UIRate);
        make.height.mas_equalTo(100*UIRate);
    }];
}

- (UILabel *)creatLabelWithText:(NSString *)text andColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = FONT_SYSTEM(15*UIRate);
    label.textColor = color;
    [self.contentView addSubview:label];
    return label;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor fontColorDarkGray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25*UIRate;
}

- (void)setModel:(PackageDetailModel *)model{
    self.dataArray = model.youhui;
    _flowLabel.text = model.flux ?: @"";
    _cloudLabel.text= model.space ?: @"";
    _moneyLabel.text = [NSString stringWithFormat:@"%@/元",model.price ?: @""];
    [self.tableView reloadData];
}
@end
