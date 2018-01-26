//
//  MessageTableViewCell.h
//  LiveHome
//
//  Created by chh on 2017/11/15.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel, *numLabel;
@property (nonatomic, strong) UIView *dividerLine;
@end
