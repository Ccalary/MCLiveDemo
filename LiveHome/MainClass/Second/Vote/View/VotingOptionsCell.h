//
//  VotingOptionsCell.h
//  LiveHome
//
//  Created by 谢炳 on 2017/12/21.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VotingOptionsModel.h"

@protocol VotingOptionsCellDelegate <NSObject>

-(void)addImageWithIndexPath:(NSIndexPath *)indexPath;

-(void)textViewDidEndEditing:(NSString *)text WithIndexPath:(NSIndexPath *)indexPath;

@end

@interface VotingOptionsCell : UITableViewCell

@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UITextView *describeTF;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, weak) id<VotingOptionsCellDelegate> delegate;
@property (nonatomic, strong) VotingOptionsModel *votingOptionsModel;
@end
