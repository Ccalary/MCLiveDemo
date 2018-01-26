//
//  VideoListModel.m
//  LiveHome
//
//  Created by chh on 2017/11/22.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel
//更改字段名字
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"videoId":@"id",@"templateId":@"template"};
}
@end
