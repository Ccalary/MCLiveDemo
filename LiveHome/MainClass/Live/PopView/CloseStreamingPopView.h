//
//  CloseStreamingPopView.h
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^closeStreamBlock)(BOOL isSure);

@interface CloseStreamingPopView : UIView
@property (nonatomic, copy) closeStreamBlock block;
@end
