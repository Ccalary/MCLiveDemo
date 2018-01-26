//
//  StreamSharePopView.m
//  LiveHome
//
//  Created by chh on 2017/11/14.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StreamSharePopView.h"
#import "ShareTools.h"


@interface StreamSharePopView()
@property (nonatomic, strong) ShareModel *shareModel;
@end

@implementation StreamSharePopView

- (instancetype)initWithFrame:(CGRect)frame andShareModel:(ShareModel *)shareModel{
    if (self = [super initWithFrame:frame]){
        self.shareModel = shareModel;
        [self initView];
    }
    return self;
}


- (void)initView{
    UIButton *qqBtn = [self creatButtonWithImage:@"qq_50" andTag:1000];
    UIButton *wxBtn = [self creatButtonWithImage:@"weixin_50" andTag:1001];
    UIButton *friendsBtn = [self creatButtonWithImage:@"friends_50" andTag:1002];
    
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.equalTo(self);
        make.bottom.offset(-50);
    }];
    
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(wxBtn);
        make.right.equalTo(wxBtn.mas_left).offset(-30);
        make.centerY.equalTo(wxBtn);
    }];
    
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(wxBtn);
        make.left.equalTo(wxBtn.mas_right).offset(30);
        make.centerY.equalTo(wxBtn);
    }];
}

- (UIButton *)creatButtonWithImage:(NSString *)image andTag:(int)tag{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonAction:(UIButton *)button{
    if (self.block){
        self.block();
    }
    switch (button.tag) {
        case 1000://qq
             [ShareTools shareToQQWithParams:self.shareModel];
            break;
        case 1001://微信
             [ShareTools shareToWeixinWithParams:self.shareModel];
            break;
        case 1002://朋友圈
            [ShareTools shareToFriendsWithParams:self.shareModel];
            break;
        default:
            break;
    }
}
@end
