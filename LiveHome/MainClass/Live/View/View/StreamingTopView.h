//
//  StreamingTopView.h
//  Find
//
//  Created by chh on 2017/10/16.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveRoomModel.h"
#import "RoomUserModel.h"

@interface StreamingTopView : UIView
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) LiveRoomModel *roomModel;//房间信息
@property (nonatomic, strong) RoomUserModel *userModel;//观众信息

- (instancetype)initWithFrame:(CGRect)frame andItemWidth:(CGFloat)itemWidth;
//刷新人气值
//- (void)refreshUIWithPopularNum:(int)num;
@end
