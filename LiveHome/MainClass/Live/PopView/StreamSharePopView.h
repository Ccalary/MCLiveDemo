//
//  StreamSharePopView.h
//  LiveHome
//
//  Created by chh on 2017/11/14.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"

typedef void(^shareBlock)(void);
@interface StreamSharePopView : UIView
@property (nonatomic, copy) shareBlock block;

- (instancetype)initWithFrame:(CGRect)frame andShareModel:(ShareModel *)shareModel;
@end
