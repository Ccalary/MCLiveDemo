//
//  VotingResultsCell.h
//  LiveHome
//
//  Created by nie on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VotingResultsModel.h"

@interface VotingResultsCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel, *numLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic,assign) int allCount;
@property (nonatomic,strong) VotingResultsModel *voteModel;

@end
