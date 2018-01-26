//
//  GiftModel.h
//  LiveHome
//
//  Created by chh on 2017/11/22.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject
@property (nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
/** 是否选中 1是 0否*/
@property (nonatomic, copy) NSString *include;
/** include数据处理*/
@property (nonatomic, assign) BOOL isInclud;
@end
