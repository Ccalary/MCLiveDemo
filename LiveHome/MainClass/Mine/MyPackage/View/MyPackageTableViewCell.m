//
//  MyPackageTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MyPackageTableViewCell.h"

@interface MyPackageTableViewCell()
@property (nonatomic, strong) UILabel *nameLabel, *timeLabel, *restLabel, *totalLabel;
@property (nonatomic, strong) UIView *progressView;
@end

@implementation MyPackageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self initProgressView];
    }
    return self;
}
- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _nameLabel = [self creatLabelWithText:@"流量" andColor:[UIColor fontColorBlack]];
    _timeLabel = [self creatLabelWithText:@"有效期至：" andColor:[UIColor fontColorLightGray]];
    _timeLabel.font = FONT_SYSTEM(12);
    _restLabel = [self creatLabelWithText:@"剩余 0.00G" andColor:[UIColor themeColor]];
    _totalLabel = [self creatLabelWithText:@"总量 20.00G" andColor:[UIColor fontColorBlack]];
    _totalLabel.font = FONT_SYSTEM(12);
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.offset(10*UIRate);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(7*UIRate);
    }];
    
    [_restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(_nameLabel);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_restLabel);
        make.centerY.equalTo(_timeLabel);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.left.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)initProgressView{
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(15*UIRate, 57*UIRate, ScreenWidth - 30*UIRate, 5*UIRate)];
    totalView.backgroundColor = [UIColor clearColor];
    totalView.layer.borderWidth = 0.5;
    totalView.layer.borderColor = [UIColor bgColorLine].CGColor;
    totalView.layer.cornerRadius = 2.5*UIRate;
    [self.contentView addSubview:totalView];
    
    _progressView = [[UIView alloc] initWithFrame:totalView.frame];
    _progressView.backgroundColor = [UIColor themeColor];
    _progressView.layer.cornerRadius = 2.5*UIRate;
    [self.contentView addSubview:_progressView];
}

- (UILabel *)creatLabelWithText:(NSString *)text andColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = FONT_SYSTEM(15*UIRate);
    label.textColor = color;
    [self.contentView addSubview:label];
    return label;
}

- (void)changeBarFrameWithProgress:(CGFloat )progress{
    CGRect originalFrame = _progressView.frame;
    [UIView animateWithDuration:3.0*(1-progress) delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        _progressView.frame = CGRectMake(originalFrame.origin.x + originalFrame.size.width*(1-progress), originalFrame.origin.y, originalFrame.size.width*progress, originalFrame.size.height);
    } completion:nil];
}
//流量数据
- (void)setFlueModel:(MyPackageModel *)flueModel{
    _timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",flueModel.flusEndtime ?: @""];
    _restLabel.text = [NSString stringWithFormat:@"剩余 %.2fG",[flueModel.fluslast doubleValue]];
    _totalLabel.text = [NSString stringWithFormat:@"总量 %dG",[flueModel.flustotal intValue]];
    CGFloat progress;
    double total = [flueModel.flustotal doubleValue];
    progress =  (total > 0) ? [flueModel.fluslast doubleValue]/total : 1;
   
    switch ([flueModel.type intValue]) {
        case -1://试用版
            _nameLabel.text = @"试用版流量";
            [self changeBarFrameWithProgress:progress];
            break;
        case 0://大众版
            _nameLabel.text = @"大众版流量";
            [self changeBarFrameWithProgress:progress];
            break;
        case 1://专业版
            _nameLabel.text = @"专业版流量";
            _restLabel.text = @"剩余 不限";
            _totalLabel.text = @"总量 不限";
            [self changeBarFrameWithProgress:1];
            break;
        default:
            break;
    }
}

//云存储
- (void)setSpaceModel:(MyPackageModel *)spaceModel{
    _timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",spaceModel.spaceEndtime ?: @""];
    _restLabel.text = [NSString stringWithFormat:@"剩余 %.2fG",[spaceModel.spacelast doubleValue]];
    _totalLabel.text = [NSString stringWithFormat:@"总量 %dG",[spaceModel.spacetotal intValue]];
    CGFloat progress;
    double total = [spaceModel.spacetotal doubleValue];
    progress = (total > 0) ? ([spaceModel.spacelast doubleValue]/total) : 1;
    
    [self changeBarFrameWithProgress:progress];
    
    switch ([spaceModel.type intValue]) {
        case -1://试用版
            _nameLabel.text = @"试用版云存储";
            break;
        case 0://大众版
            _nameLabel.text = @"大众版包年云存储";
            break;
        case 1://专业版
            _nameLabel.text = @"专业版包年云存储";
            break;
        default:
            break;
    }
}

@end
