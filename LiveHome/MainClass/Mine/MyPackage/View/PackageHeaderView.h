//
//  PackageHeaderView.h
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickBlock)(void);

@interface PackageHeaderView : UIView
@property (nonatomic, copy) clickBlock block;
@property (nonatomic, strong) NSArray *imageArray;
@end
