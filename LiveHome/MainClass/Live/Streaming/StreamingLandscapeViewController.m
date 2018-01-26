//
//  StreamingLandscapeViewController.m
//  LiveDemo
//
//  Created by 白璐 on 16/8/10.
//  Copyright © 2016年 baidu. All rights reserved.
//  

#import "StreamingLandscapeViewController.h"

@implementation StreamingLandscapeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
   }

- (void)dealloc{
    NSLog(@"dealloc");
}

- (AVCaptureVideoOrientation)cameraOrientation {
    return AVCaptureVideoOrientationLandscapeRight;
}


@end
