//
//  StreamingCollectionViewCell.m
//  Find
//
//  Created by chh on 2017/8/23.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "StreamingCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface StreamingCollectionViewCell()
@property (nonatomic, strong) UIImageView *headerImageView;
@end

@implementation StreamingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    _headerImageView.layer.cornerRadius = self.contentView.frame.size.width/2.0;
    _headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headerImageView];
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.center.equalTo(self.contentView);
    }];
    
}

- (void)setUserRowsModel:(RoomUserRowsModel *)userRowsModel{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userRowsModel.image]] placeholderImage:[UIImage imageNamed:@"header_default_60"]];
}

@end
