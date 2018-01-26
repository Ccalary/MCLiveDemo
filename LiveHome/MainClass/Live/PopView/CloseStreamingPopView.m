//
//  CloseStreamingPopView.m
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "CloseStreamingPopView.h"

@interface CloseStreamingPopView()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation CloseStreamingPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    _closeBtn.layer.borderColor = [UIColor themeColor].CGColor;
    _closeBtn.layer.borderWidth = 1;
    _closeBtn.layer.cornerRadius = 20;
    _closeBtn.layer.masksToBounds = YES;

}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.block){
        self.block(YES);
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.block){
        self.block(NO);
    }
}

@end
