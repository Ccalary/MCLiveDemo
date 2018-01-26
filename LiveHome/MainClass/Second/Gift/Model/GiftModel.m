//
//  GiftModel.m
//  LiveHome
//
//  Created by chh on 2017/11/22.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "GiftModel.h"

@implementation GiftModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"giftId":@"id"};
}

//是否选中
- (BOOL)isInclud{
    if ([@"1" isEqualToString:self.include]){
        return YES;
    }
    return NO;
}

@end
