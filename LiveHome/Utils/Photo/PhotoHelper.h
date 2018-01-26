//
//  PhotoHelper.h
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PhotoHelperBlock)(UIImage *image);

@protocol PhotoHelperDelegate <NSObject>
- (void)clickAddPhotoBtn;
@end

@interface PhotoHelper : NSObject

@property (nonatomic, copy) PhotoHelperBlock block;

@property (nonatomic, weak) id<PhotoHelperDelegate> delegate;

+ (PhotoHelper *)sharedInstance;

- (void)addPhotoWithController:(UIViewController *)controller;
@end
