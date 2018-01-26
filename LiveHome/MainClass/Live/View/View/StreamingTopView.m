
//
//  StreamingTopView.m
//  Find
//
//  Created by chh on 2017/10/16.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//
#import "StreamingTopView.h"
#import "StreamingCollectionViewCell.h"
#import "RunLabelView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

static NSString *const kCollectionCellID = @"StreamingCollectionCellID";

@interface StreamingTopView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *holdView;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *seeNumLabel;
@property (nonatomic, strong) RunLabelView *nameLabel;//主播名字
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat rate; //适配比例
@property (nonatomic, strong) UILabel *popularLabel, *roomNumLabel; //观看人数, 人气值， 房间号
@property (nonatomic, assign) CGFloat itemWidth; //头像尺寸（圆形）
@end

@implementation StreamingTopView
- (instancetype)initWithFrame:(CGRect)frame andItemWidth:(CGFloat)itemWidth{
    if (self = [super initWithFrame:frame]){
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (size.width > size.height){
            _rate = size.height/375.0;
        }else {
            _rate = size.width/375.0;
        }
        _dataArray = [[NSMutableArray alloc] init];
        self.itemWidth = itemWidth;
        [self initTopView];
//        [self initPopularView];
    }
    return self;
}

- (void)initTopView{
    
    _holdView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 100*_rate, self.itemWidth + 10*_rate)];
    _holdView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _holdView.layer.cornerRadius = _holdView.frame.size.height/2.0;
    [self addSubview:_holdView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5*_rate, self.itemWidth, self.itemWidth)];
    _headerImageView.layer.cornerRadius = self.itemWidth/2.0;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    [_holdView addSubview:_headerImageView];
    
    _nameLabel = [[RunLabelView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 5, CGRectGetMinY(_headerImageView.frame), 100*_rate - self.itemWidth - self.itemWidth/2.0 - 5, 16*_rate)];
    _nameLabel.font = [UIFont systemFontOfSize:14*_rate];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"主播77777";
    [_holdView addSubview:_nameLabel];
    
    _seeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_headerImageView.frame) - 14*_rate, CGRectGetWidth(_nameLabel.frame), 14*_rate)];
    _seeNumLabel.font = [UIFont systemFontOfSize:13*_rate];
    _seeNumLabel.textColor = [UIColor whiteColor];
    _seeNumLabel.text = @"10";
    [_holdView addSubview:_seeNumLabel];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(self.itemWidth, self.itemWidth);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.showsHorizontalScrollIndicator = NO;
    _mCollectionView.backgroundColor = [UIColor clearColor];
    [_mCollectionView registerClass:[StreamingCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellID];
    [self addSubview:_mCollectionView];
    
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_holdView.mas_right).offset(15);
        make.right.equalTo(self);
        make.centerY.equalTo(_holdView);
        make.height.mas_equalTo(self.itemWidth);
    }];
}

//人气View
- (void)initPopularView{
    _popularLabel = [self creatLabel];
    _popularLabel.text = @"人气值：1000";
    _popularLabel.frame = CGRectMake(10, CGRectGetMaxY(self.holdView.frame) + 5, 100, 20*_rate);
    [self fitLabelWidth:_popularLabel];
    
    _roomNumLabel = [self creatLabel];
    _roomNumLabel.text = @"房间号：32243";
    _roomNumLabel.frame = CGRectMake(self.frame.size.width - 100 - 10, CGRectGetMinY(_popularLabel.frame), 100, 20*_rate);
    [self fitLabelWidth:_roomNumLabel];
    _roomNumLabel.x = self.frame.size.width - 10 - _roomNumLabel.width;
}

- (UILabel *)creatLabel{
    UILabel *popularLabel = [[UILabel alloc] init];
    popularLabel.textColor = [UIColor whiteColor];
    popularLabel.font = [UIFont systemFontOfSize:12*self.rate];
    popularLabel.textAlignment = NSTextAlignmentCenter;
    popularLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    popularLabel.layer.cornerRadius = 10*_rate;
    popularLabel.clipsToBounds = YES;
    [self addSubview:popularLabel];
    return popularLabel;
}

//是否展示人气值和房间号，默认展示
- (void)showPopularView:(BOOL) hidden{
    self.popularLabel.hidden = hidden;
    self.popularLabel.hidden = hidden;
}

//带圆角的label自适应宽度
- (void)fitLabelWidth:(UILabel *)label{
    CGSize maximumLabelSize = CGSizeMake(200, 30);
    //关键语句
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    //设置frame
    label.width = expectSize.width + 16;
}

#pragma mark - UICollectionViewDelegate,DataSource
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
    StreamingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID forIndexPath:indexPath];
    cell.userRowsModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)setRoomModel:(LiveRoomModel *)roomModel{
    _roomModel = roomModel;
    //头像
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",roomModel.userimage]] placeholderImage:[UIImage imageNamed:@"header_default_60"]];
    _nameLabel.text = roomModel.username ?: @"";
    
//    _roomNumLabel.text = [NSString stringWithFormat:@"房间号:%@",roomModel.roomno ?: @""];
//    [self fitLabelWidth:_roomNumLabel];
//    _roomNumLabel.x = self.frame.size.width - 10 - _roomNumLabel.width;

//    [self refreshUIWithPopularNum:roomModel.pcount];
}

//刷新人气值
- (void)refreshUIWithPopularNum:(int)num{
    if (num > 10000){
        _popularLabel.text = [NSString stringWithFormat:@"人气值:%.1f万", num/10000.0];
    }else {
        _popularLabel.text = [NSString stringWithFormat:@"人气值:%d",num];
    }
    [self fitLabelWidth:_popularLabel];
}

- (void)setUserModel:(RoomUserModel *)userModel{
    _userModel = userModel;
    int total = userModel.total;
    if (total > 10000){
        _seeNumLabel.text = [NSString stringWithFormat:@"%.1f万人", total/10000.0];
    }else {
        _seeNumLabel.text = [NSString stringWithFormat:@"%d人",total];
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:userModel.rows];
    [self.mCollectionView reloadData];
}
@end
