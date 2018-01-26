//
//  VotingResultsCell.m
//  LiveHome
//
//  Created by nie on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VotingResultsCell.h"
#import "UIImage+fixOrientation.h"
#import "UIImageView+WebCache.h"

@implementation VotingResultsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor bgColorMain];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80*UIRate);
        make.left.top.mas_equalTo(15*UIRate);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_SYSTEM(15);
    _titleLabel.textColor = [UIColor fontColorBlack];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView);
        make.bottom.equalTo(_iconImageView.mas_centerY);
        make.left.equalTo(_iconImageView.mas_right).offset(8*UIRate);
        make.right.equalTo(self.contentView.mas_right).offset(-15*UIRate);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = FONT_SYSTEM(12);
    _numLabel.textColor = [UIColor themeColor];
    _numLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel);
        make.bottom.equalTo(_iconImageView);
        make.height.mas_equalTo(12*UIRate);
    }];
    
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    _progressView = [[UIProgressView alloc]init];
    _progressView.transform = transform;//设定宽高
    [_progressView setProgressImage:[UIImage imageFromColor:[UIColor themeColor] forSize:CGSizeMake(5, 6) withCornerRadius:0]];
    [_progressView setTrackImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"dddddd"] forSize:CGSizeMake(5, 6) withCornerRadius:0]];
    //设定两端弧度
    self.progressView.layer.cornerRadius = 4.0;
    self.progressView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.right.equalTo(_titleLabel);
        make.height.mas_equalTo(6);
        
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.mas_offset(10*UIRate);
    }];
   
    self.iconImageView.backgroundColor = [UIColor redColor];
}

- (void)setVoteModel:(VotingResultsModel *)voteModel
{
    _voteModel = voteModel;
    

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",voteModel.image]] placeholderImage:[UIImage imageNamed:@"video_default_180x95"]];

    self.titleLabel.text = voteModel.content;
    self.numLabel.text = [NSString stringWithFormat:@"%i票",voteModel.count];
    self.progressView.progress = voteModel.count/(double)self.allCount;
}
@end
