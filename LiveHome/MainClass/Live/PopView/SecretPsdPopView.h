//
//  SecretPsdPopView.h
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)(NSString *pwd);

@interface SecretPsdPopView : UIView
@property (nonatomic, copy) sureBlock block;
@end
