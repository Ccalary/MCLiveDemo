//
//  MsgDetailViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/16.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MsgDetailViewController.h"
@interface MsgDetailViewController ()

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chatSessionInputBarControl removeFromSuperview];
    self.view.backgroundColor = [UIColor bgColorMain];
    self.conversationMessageCollectionView.backgroundColor = [UIColor bgColorMain];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(50*UIRate, 50*UIRate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
