//
//  OldVideoWebVC.h
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldVideoWebVC : UIViewController
-(instancetype)initWithTitle:(NSString *)title andUrl:(NSString *)url;

@property (nonatomic, assign) BOOL isCanGoBack;//是否网页有回退,默认YES
@end
