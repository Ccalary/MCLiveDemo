//
//  VotingListCell.h
//  LiveHome
//
//  Created by 谢炳 on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VotingListModel.h"
@protocol VotingListCellDelegate <NSObject>

//投票结果
-(void)votingResultWithIndexPath:(NSIndexPath *)indexPath;

//投票状态编辑
-(void)votingStatusEditorWithIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)sender;

@end

@interface VotingListCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) VotingListModel *votingListModel;
@property(nonatomic, weak) id<VotingListCellDelegate> delegate;
@end
