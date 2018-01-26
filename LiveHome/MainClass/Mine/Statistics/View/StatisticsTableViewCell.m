//
//  StatisticsTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StatisticsTableViewCell.h"
#import "StatciCollectionViewCell.h"

@interface StatisticsTableViewCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mCollectionView;
@end
@implementation StatisticsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{

    CGFloat ItemWidth = (ScreenWidth - 34)/4.0;
    CGFloat ItemHeight = 40*UIRate;
    UICollectionViewFlowLayout * aLayOut = [[UICollectionViewFlowLayout alloc]init];
    aLayOut.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    aLayOut.minimumLineSpacing = 1;
    aLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:aLayOut];
    [_mCollectionView registerClass:[StatciCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    _mCollectionView.backgroundColor = [UIColor bgColorLineDarkGray];
    [self addSubview:_mCollectionView];
    [_mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.bottom.offset(-1);
    }];
    
    UIView *lineView = [self creatLine];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.right.offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    UIView *leftLine = [self creatLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.width.equalTo(@1);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
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
    StatciCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = self.bgColor;
    if (self.dataArray.count > indexPath.row){
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIView *)creatLine{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLineDarkGray];
    [self.contentView addSubview:line];
    return line;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.mCollectionView reloadData];
}
@end
