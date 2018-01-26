//
//  OldVideosCollectionViewCell.h
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
@class OldVideosCollectionViewCell;
typedef NS_ENUM(NSUInteger, OldVideosCollectionCellBtnType){
    OldVideosCollectionCellBtnTypeSelect = 0,  //选择
    OldVideosCollectionCellBtnTypeWrite = 1    //更改
};
@protocol OldVideosCollectionCellDelegate<NSObject>
- (void)oldVideoCellBtnActionWithCell:(OldVideosCollectionViewCell *)cell type:(OldVideosCollectionCellBtnType)type;
@end

@interface OldVideosCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) VideoListModel *model;
@property (nonatomic, assign) BOOL isManager; //是否管理
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, weak) id<OldVideosCollectionCellDelegate> delegate;
@end
