//
//  UserInfoModel.m
//  LiveHome
//
//  Created by chh on 2017/11/10.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
//单位属性转化
- (NSString *)propName{
    int pro = [self.prop intValue];
    switch (pro) {
        case 0:
            return @"事业单位";
        case 1:
            return @"外企";
        case 2:
            return @"私企";
        case 3:
            return @"民企";
        default:
            return @"请选择";
    }
}

//认证状态转化
- (NSString *)cerStr{
    int cer = [self.iscer intValue];
    switch (cer) {
        case 0:
            return @"未申请认证";
        case 1:
            return @"审核中";
        case 2:
            return @"审核通过";
        default:
            return @"审核不通过";
    }
}
@end
