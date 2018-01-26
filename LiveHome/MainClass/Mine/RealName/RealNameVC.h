//
//  RealNameVC.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)(void);

@interface RealNameVC : UIViewController
@property (nonatomic, assign) BOOL isSuccess;//是否认证成功
@property (nonatomic, copy) backBlock block;
@end
