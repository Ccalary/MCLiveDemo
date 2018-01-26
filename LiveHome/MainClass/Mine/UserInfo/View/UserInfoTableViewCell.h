//
//  UserInfoTableViewCell.h
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *dividerLine;

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@end
