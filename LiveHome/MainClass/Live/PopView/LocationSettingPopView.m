//
//  LocationSettingPopView.m
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "LocationSettingPopView.h"

@implementation LocationSettingPopView

- (IBAction)sureAction:(UIButton *)sender {
    if (self.block){
        self.block(YES);
    }
}

- (IBAction)cancelAction:(UIButton *)sender {
    if (self.block){
        self.block(NO);
    }
}
@end
