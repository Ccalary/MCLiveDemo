//
//  OldVideosCollectionViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "OldVideosCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface OldVideosCollectionViewCell()
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *selectBtn, *writeBtn;
@end

@implementation OldVideosCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _videoImageView = [[UIImageView alloc] init];
    _videoImageView.image = [UIImage imageNamed:@"video_default_180x95"];
    _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoImageView.clipsToBounds = YES;
    [self.contentView addSubview:_videoImageView];
    [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(97*UIRate);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT_SYSTEM(15);
    _nameLabel.textColor = [UIColor fontColorBlack];
    _nameLabel.numberOfLines = 0;
    _nameLabel.text = @"企业发展";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.equalTo(_videoImageView.mas_bottom).offset(5);
        make.bottom.offset(-5);
    }];
    
    _selectBtn = [[UIButton alloc] init];
    [_selectBtn setImage:[UIImage imageNamed:@"btn_round_30"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"btn_check_30"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.tag = OldVideosCollectionCellBtnTypeSelect;
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40*UIRate);
        make.center.equalTo(_videoImageView);
    }];
    
    _writeBtn = [[UIButton alloc] init];
    [_writeBtn setImage:[UIImage imageNamed:@"btn_write_13"] forState:UIControlStateNormal];
    [_writeBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
    [_writeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _writeBtn.tag = OldVideosCollectionCellBtnTypeWrite;
    [self.contentView addSubview:_writeBtn];
    [_writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40*UIRate);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
}

- (void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(oldVideoCellBtnActionWithCell:type:)]){
        [self.delegate oldVideoCellBtnActionWithCell:self type:button.tag];
    }
}

- (void)setIsManager:(BOOL)isManager{
    _isManager = isManager;
    if (isManager){
        _selectBtn.hidden = NO;
        _writeBtn.hidden = NO;
    }else {
        _selectBtn.hidden = YES;
        _writeBtn.hidden = YES;
    }
}

- (void)setModel:(VideoListModel *)model{
    _model = model;
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] placeholderImage:[UIImage imageNamed:@"video_default_180x95"]];
    _nameLabel.text= model.name ?: @"";
    _selectBtn.selected = model.isSelected;
}
@end
