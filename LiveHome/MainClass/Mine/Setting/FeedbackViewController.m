//
//  FeedbackViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/8.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define TOTAL_NUM 200

@interface FeedbackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *connectText;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, assign) int textNum;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)initView{
    self.view.backgroundColor = [UIColor bgColorMain];
    self.navigationItem.title = @"反馈";
    
    UIView *holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*UIRate, ScreenWidth, 165*UIRate)];
    holdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:holdView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15*UIRate, 5*UIRate, ScreenWidth - 30*UIRate, 130*UIRate)];
    self.textView.placeholder = @"请您详细描述使用中遇到的问题也欢迎对我们的吐槽，感谢您提出的宝贵意见";
    self.textView.placeholderColor = [UIColor fontColorLightGray];
    self.textView.textColor = [UIColor fontColorBlack];
    self.textView.font = FONT_SYSTEM(15);
    _textView.delegate = self;
    [holdView addSubview:self.textView];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = FONT_SYSTEM(12);
    _numLabel.textColor = [UIColor fontColorLightGray];
    _numLabel.text = [NSString stringWithFormat:@"0/%d", TOTAL_NUM];
    [holdView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom).offset(5);
    }];
    
    UIView *connectView = [[UIView alloc] init];
    connectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:connectView];
    [connectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(35*UIRate);
        make.top.equalTo(holdView.mas_bottom).offset(10*UIRate);
        make.centerX.equalTo(self.view);
    }];
    
    _connectText = [[UITextField alloc] init];
    _connectText.placeholder = @"请输入您的手机/QQ/邮箱";
    _connectText.font = FONT_SYSTEM(15);
    _connectText.textColor = [UIColor fontColorBlack];
    [connectView addSubview:_connectText];
    [_connectText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.center.equalTo(connectView);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(12);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"您的联系方式有助于我们的沟通和解决问题，仅工作人员可见";
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connectView.mas_bottom).offset(10*UIRate);
        make.left.offset(15*UIRate);
    }];
    
    _commitBtn = [[UIButton alloc] init];
    [_commitBtn setBackgroundColor:[UIColor colorWithHex:0xdcdcdc]];
    [_commitBtn setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _commitBtn.enabled = NO;
    _commitBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    _commitBtn.layer.cornerRadius = 4.0;
    [_commitBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.equalTo(tipsLabel.mas_bottom).offset(20*UIRate);
        make.height.mas_equalTo(40*UIRate);
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > (TOTAL_NUM - 50)){
        //获得已输出字数与正输入字母数
        UITextRange *textRange = textView.markedTextRange;
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:textRange.start offset:0];
        if (position != nil){
            return;
        }
        NSString *textContent = textView.text;
        int textNum = (int)textContent.length;
           //截取200个字
        if (textNum > TOTAL_NUM)
        {
            NSRange rangeIndex = [textContent rangeOfComposedCharacterSequenceAtIndex:TOTAL_NUM];
            if (rangeIndex.length == 1)//表情占用两个字符这里能更好的判断
            {
                textView.text = [textContent substringToIndex:TOTAL_NUM];
            }
            else
            {
                NSRange rangeRange = [textContent rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, TOTAL_NUM)];
                textView.text = [textContent substringWithRange:rangeRange];
            }
        }
    }
    self.textNum = (int)textView.text.length;
    self.numLabel.text = [NSString stringWithFormat:@"%d/%d",self.textNum, TOTAL_NUM];
    if (self.textNum > 0){
        [self.commitBtn setBackgroundColor:[UIColor themeColor]];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitBtn.enabled = YES;
    }else {
        [self.commitBtn setBackgroundColor:[UIColor colorWithHex:0xdcdcdc]];
        [self.commitBtn setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
        self.commitBtn.enabled = NO;
    }
}

//提交
- (void)buttonAction{
    if (self.connectText.text.length == 0){
        [LCProgressHUD showFailure:@"请填写联系方式"];
        return;
    }
    [self.view endEditing:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.textView.text forKey:@"content"];
    [params setValue:self.connectText.text forKey:@"contact"];
    [LHConnect postFeedback:params loading:@"提交中..." success:^(id  _Nonnull response) {
        [LCProgressHUD showSuccess:@"反馈成功"];
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}

@end
