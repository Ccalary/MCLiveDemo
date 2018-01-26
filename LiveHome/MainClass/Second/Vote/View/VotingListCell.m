//
//  VotingListCell.m
//  LiveHome
//
//  Created by 谢炳 on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VotingListCell.h"
#import "FL_Button.h"

@interface VotingListCell()

@property(nonatomic, strong) UILabel *votingLabel;
@property(nonatomic, strong) UILabel *startLabel;
@property(nonatomic, strong) UILabel *endLabel;
@property(nonatomic, strong) FL_Button *resultBtn;
@property(nonatomic, strong) FL_Button *editBtn;
@property(nonatomic, strong) FL_Button *delegateBtn;
@property(nonatomic, strong) UIView *line;

@end
@implementation VotingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _votingLabel = [UILabel new];
    [self setLabel:_votingLabel];
    [self addSubview:_votingLabel];
    
    _line = [UIView new];
    _line.backgroundColor = [UIColor bgColorMain];
    [self addSubview:_line];
    
    _startLabel = [UILabel new];
    [self setLabel:_startLabel];
    [self addSubview:_startLabel];
    
    _endLabel = [UILabel new];
    _endLabel.text = @"截止时间：2017.12.30";
    [self setLabel:_endLabel];
    [self addSubview:_endLabel];
    
    _resultBtn = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusRight];
    [self setButton:_resultBtn title:@"投票结果" imageName:@"s_result" color:[UIColor themeColor]];
    [_resultBtn addTarget:self action:@selector(votingResult:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_resultBtn];
    
    _editBtn = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusLeft];
    _editBtn.tag = 100;
    [self setButton:_editBtn title:@"编辑" imageName:@"s_edit" color:[UIColor lightGrayColor]];
    [_editBtn addTarget:self action:@selector(votingStatusEditor:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editBtn];

    _delegateBtn = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusLeft];
    _delegateBtn.tag = 101;
    [self setButton:_delegateBtn title:@"删除" imageName:@"s_delete" color:[UIColor lightGrayColor]];
    [_delegateBtn addTarget:self action:@selector(votingStatusEditor:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_delegateBtn];
    
    
    [_votingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15*UIRate);
        make.top.equalTo(self).with.offset(15*UIRate);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_offset(@1);
        make.top.equalTo(_votingLabel.mas_bottom).with.offset(15*UIRate);
    }];
    
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15*UIRate);
        make.top.equalTo(_line.mas_bottom).with.offset(15*UIRate);
    }];
    
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15*UIRate);
        make.top.equalTo(_startLabel.mas_bottom).with.offset(12*UIRate);
    }];
    
    [_resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_votingLabel);
        make.right.equalTo(self).with.offset(-15*UIRate);
        make.size.mas_equalTo(CGSizeMake(100*UIRate, 15*UIRate));
    }];
    
    [_delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*UIRate, 15*UIRate));
        make.right.equalTo(self).with.offset(-15*UIRate);
        make.bottom.equalTo(self).with.offset(-20*UIRate);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_delegateBtn);
        make.centerY.equalTo(_delegateBtn);
        make.right.equalTo(_delegateBtn.mas_left).with.offset(-15*UIRate);
    }];
}

-(void)setLabel:(UILabel *)label
{
    label.font = FONT_SYSTEM(15);
}

-(void)setButton:(UIButton *)sender title:(NSString *)title imageName:(NSString *)imageName color:(UIColor *)color
{
    sender.titleLabel.font = FONT_SYSTEM(15);
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:color forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)votingResult:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(votingResultWithIndexPath:)]) {
        [self.delegate votingResultWithIndexPath:self.indexPath];
    }
}

-(void)votingStatusEditor:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(votingStatusEditorWithIndexPath: sender:)]) {
        [self.delegate votingStatusEditorWithIndexPath:self.indexPath sender:sender];
    }
}

-(void)setVotingListModel:(VotingListModel *)votingListModel
{
    _votingLabel.text = votingListModel.name;
    _startLabel.text = [NSString stringWithFormat:@"开始时间：%@",votingListModel.start];
    _endLabel.text = [NSString stringWithFormat:@"结束时间：%@",votingListModel.end];
}
@end
