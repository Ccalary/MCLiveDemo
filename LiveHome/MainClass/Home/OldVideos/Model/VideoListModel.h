//
//  VideoListModel.h
//  LiveHome
//
//  Created by chh on 2017/11/22.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 count = 0;
 h = 1280;
 id = T636484115943922701;
 image = "http://res.o2o.com.cn:8082/img/dd2b00f703214826aabe0e68dd32a24d";
 isshow = 1;
 name = "\U54e6\U54e6\U54e6";
 roomid = 3f2b2aa05683473db94bed303e112d59;
 template = 1dbcb0b1f08d4408aefb91bdae461597;
 time = "2017-12-09 10:19:00";
 url = "http://livefamily.o2o.com.cn/LiveDiy/Show/22825311?logId=T636484115943922701";
 userid = e65fe1955a08415e811affe829bfd3b1;
 w = 720;
 */
@interface VideoListModel : NSObject
/**
 模版编号
 */
@property (nonatomic, copy) NSString *templateId;//template
@property (nonatomic, copy) NSString *videoId;//id
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name; 
@property (nonatomic, copy) NSString *url; //视频地址
@property (nonatomic, assign) BOOL isSelected; //是否选中
@end
