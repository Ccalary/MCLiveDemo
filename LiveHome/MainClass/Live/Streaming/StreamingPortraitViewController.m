//
//  StreamingPortraitViewController.m
//  LiveDemo
//
//  Created by 白璐 on 16/8/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "StreamingPortraitViewController.h"

@implementation StreamingPortraitViewController

- (AVCaptureVideoOrientation)cameraOrientation {
    return AVCaptureVideoOrientationPortrait;
}

- (void)dealloc{
    NSLog(@"dealloc");
}
@end
