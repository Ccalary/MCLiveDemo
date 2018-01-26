//
//  RoomUserModel.h
//  Find
//
//  Created by chh on 2017/8/28.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomUserModel : NSObject

@property (nonatomic, assign) int total; //观看人数

@property (nonatomic, strong) NSArray *rows;//观看者的信息

@end


@interface RoomUserRowsModel : NSObject
@property (nonatomic, copy) NSString *name;    //姓名
@property (nonatomic, copy) NSString *image;   //头像
@property (nonatomic, copy) NSString *ownsign; //个性签名
@end
