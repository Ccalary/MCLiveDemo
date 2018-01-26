//
//  LiveRoomModel.m
//  LiveHome
//
//  Created by chh on 2017/11/11.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "LiveRoomModel.h"

@implementation LiveRoomModel
//更改字段名字
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"roomid":@"id"};
}
@end
