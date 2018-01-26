//
//  VoteCreationViewController.m
//  LiveHome
//
//  Created by nie on 2017/12/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VoteCreationViewController.h"
#import "VotingOptionsViewController.h"

#import "FL_Button.h"
#import "PGDatePicker.h"
#import "ToolsHelper.h"

@interface VoteCreationViewController ()<PGDatePickerDelegate>

@property (nonatomic,strong) UIButton *timeBtn_One;
@property (nonatomic,strong) UIButton *timeBtn_Two;
@property (nonatomic,strong) FL_Button *limitBtn_One;
@property (nonatomic,strong) FL_Button *limitBtn_Two;
@property (nonatomic,strong) FL_Button *typetBtn_One;
@property (nonatomic,strong) FL_Button *typetBtn_Two;
@property (nonatomic,strong) FL_Button *typetBtn_Three;
@property (nonatomic,strong) FL_Button *typetBtn_Four;
@property (nonatomic,assign) NSInteger timeBtnTag;
@property (nonatomic,strong) NSDate *tiemBtn_OneDate;
@property (nonatomic,strong) NSDate *tiemBtn_TwoDate;
@property (nonatomic,strong) UITextField *textFiled;
@property (nonatomic,assign) int limitBtnType;
@property (nonatomic,assign) int typetBtnType;
@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end

@implementation VoteCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    if (self.type == 1) {
        
        [self voteDeleteRequestData:self.votingId];
    }
}

- (void)initView
{
    self.navigationItem.title = @"投票";
    self.view.backgroundColor = [UIColor bgColorMain];
    
    CGFloat btnWidth = 80*UIRate;
    CGFloat btnHeight = 40*UIRate;
    CGFloat btnSpace = 20*UIRate;
    NSArray *titleArr = @[@"活动名称",@"开始时间",@"截止时间",@"投票限制",@"选择类型"];
    NSArray *limitArr = @[@"只能一次",@"一天一次"];
    NSArray *typeArr = @[@"单选",@"双选",@"三选",@"多选"];
    
    //类型title
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label.frame = CGRectMake(10*UIRate, i * 40*UIRate + 20*UIRate * (i + 1), 80*UIRate, 40*UIRate);
    }
    
    //输入框
    UITextField *textFiled = [[UITextField alloc]init];
    textFiled.layer.borderWidth = 1;
    textFiled.layer.borderColor = [UIColor fontColorLightGray].CGColor;
    textFiled.frame = CGRectMake(100*UIRate, 20*UIRate, self.view.mj_w - 120*UIRate, 40*UIRate);
    [self.view addSubview:textFiled];
    self.textFiled = textFiled;
    
    //开始时间&截止时间
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor fontColorLightGray].CGColor;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(100*UIRate, i * (btnHeight + 20*UIRate) + 80*UIRate, self.view.mj_w - 120*UIRate, 40*UIRate);
        [self.view addSubview:btn];
        if (i == 0) {
            _timeBtn_One = btn;
        }else{
            _timeBtn_Two = btn;
        }
        
    }
    
    //投票限制选项
    for (int i = 0; i < limitArr.count; i++) {
        NSInteger index = i % 2;
        FL_Button *btn = [[FL_Button alloc]initWithAlignmentStatus:FLAlignmentStatusLeft];
        btn.tag = 2000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%@",limitArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(limitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(index * (btnWidth +btnSpace) + 100*UIRate, 200*UIRate, btnWidth, btnHeight);
        [self.view addSubview:btn];
        
        if (i == 0) {
            _limitBtn_One = btn;
        }else{
            _limitBtn_Two = btn;
        }
    }
    
    //选择类型选项
    for (int i = 0; i < typeArr.count; i++){
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        
        FL_Button *btn = [[FL_Button alloc]initWithAlignmentStatus:FLAlignmentStatusLeft];
        btn.tag = 3000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%@",typeArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(index * (btnWidth + btnSpace) + 100*UIRate, page * (btnHeight + btnSpace) + 260*UIRate, btnWidth, btnHeight);
        [self.view addSubview:btn];
        
        if (i == 0) {
            _typetBtn_One = btn;
        }else if (i == 1) {
            _typetBtn_Two = btn;
        }else if (i == 2) {
            _typetBtn_Three = btn;
        }else if (i == 3) {
            _typetBtn_Four = btn;
        }
    }
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15*UIRate,ScreenHeight - 70*UIRate-64, ScreenWidth - 30*UIRate, 40*UIRate)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    
    _limitBtnType = 0;
    _typetBtnType = 0;
    [self clickBtn:_limitBtn_One select:YES];
    [self clickBtn:_limitBtn_Two select:NO];
    [self clickBtn:_typetBtn_One select:YES];
    [self clickBtn:_typetBtn_Two select:NO];
    [self clickBtn:_typetBtn_Three select:NO];
    [self clickBtn:_typetBtn_Four select:NO];
    
    self.dataDic = [NSMutableDictionary dictionary];
    
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTap)];
    [self.view addGestureRecognizer:aTap];
}

-(void)clickBtn:(UIButton *)sender select:(BOOL)select
{
    if (select == YES) {
        [sender setImage:[UIImage imageNamed:@"s_voteSelect"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"s_voteUnSelect"] forState:UIControlStateNormal];
    }
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    
    int year = (int)[dateComponents year];
    int month = (int)[dateComponents month];
    int day = (int)[dateComponents day];
    int hour = (int)[dateComponents hour];
    int minute = (int)[dateComponents minute];
    int second = (int)[dateComponents second];
    NSString *timeStr = [NSString stringWithFormat:@"%i-%i-%i %i:%i:%i",year,month,day,hour,minute,second];
    
    if (self.timeBtnTag == 1000) {
        [_timeBtn_One setTitle:timeStr forState:UIControlStateNormal];
        _tiemBtn_OneDate = [currentCalender dateFromComponents:dateComponents];
        
        //比较当前时间与开始时间的大小
        NSDate *dateNow = [NSDate date];
        NSComparisonResult andOneResult = [dateNow compare:_tiemBtn_OneDate];
        if (andOneResult != NSOrderedAscending) {
            [LCProgressHUD showFailure:@"开始时间应大于当前时间"];
            [_timeBtn_One setTitle:@"" forState:UIControlStateNormal];
            _tiemBtn_OneDate = nil;
            return;
        }
        
        if (_tiemBtn_TwoDate != nil) {
            //比较截止时间与开始时间的大小
            NSComparisonResult result= [_tiemBtn_OneDate compare:_tiemBtn_TwoDate];
            if (result != NSOrderedAscending ) {
                [_timeBtn_One setTitle:@"" forState:UIControlStateNormal];
                [LCProgressHUD showFailure:@"截止时间应大于开始时间"];
                _tiemBtn_OneDate = nil;
            }
        }
    }else if (self.timeBtnTag == 1001){
        [_timeBtn_Two setTitle:timeStr forState:UIControlStateNormal];
        _tiemBtn_TwoDate = [currentCalender dateFromComponents:dateComponents];
        
        //比较当前时间与开始时间的大小
        NSDate *dateNow = [NSDate date];
        NSComparisonResult andOneResult = [dateNow compare:_tiemBtn_TwoDate];
        if (andOneResult != NSOrderedAscending) {
            [LCProgressHUD showFailure:@"截止时间应大于当前时间"];
            [_timeBtn_Two setTitle:@"" forState:UIControlStateNormal];
            _tiemBtn_TwoDate = nil;
            return;
        }
        
        if (_tiemBtn_OneDate != nil) {
            //比较截止时间与开始时间的大小
            NSComparisonResult result= [_tiemBtn_OneDate compare:_tiemBtn_TwoDate];
            if (result != NSOrderedAscending ) {
                [_timeBtn_Two setTitle:@"" forState:UIControlStateNormal];
                [LCProgressHUD showFailure:@"截止时间应大于开始时间"];
                _tiemBtn_TwoDate = nil;
            }
        }
    }
}

#pragma mark - 点击事件
- (void)aTap
{
    [self.view endEditing:YES];
}

//时间
- (void)timeBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIButton *btn = sender;
    self.timeBtnTag = (int)btn.tag;
    
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
}

//投票限制
- (void)limitBtnClick:(UIButton *)sender
{
    [self clickBtn:_limitBtn_One select:NO];
    [self clickBtn:_limitBtn_Two select:NO];
    [self clickBtn:sender select:YES];
    int type = (int)sender.tag/2000;
    _limitBtnType = type;
}

//投票限制
- (void)typeBtnClick:(UIButton *)sender
{
    [self clickBtn:_typetBtn_One select:NO];
    [self clickBtn:_typetBtn_Two select:NO];
    [self clickBtn:_typetBtn_Three select:NO];
    [self clickBtn:_typetBtn_Four select:NO];
    [self clickBtn:sender select:YES];
    int type = (int)sender.tag%3000;
    _typetBtnType = type;
}

//下一步
- (void)nextBtnClick:(UIButton *)sender
{
    if ([ToolsHelper isBlankString:self.textFiled.text] == YES || [ToolsHelper isBlankString:self.timeBtn_One.titleLabel.text] == YES || [ToolsHelper isBlankString:self.timeBtn_Two.titleLabel.text] == YES) {
        
        [LCProgressHUD showFailure:@"请添加完整信息"];
        return;
    }
    
    [self.dataDic setObject:self.textFiled.text forKey:@"name"];
    [self.dataDic setObject:self.timeBtn_One.titleLabel.text forKey:@"start"];
    [self.dataDic setObject:self.timeBtn_Two.titleLabel.text forKey:@"end"];
    [self.dataDic setObject:@(_limitBtnType) forKey:@"limittype"];
    [self.dataDic setObject:@(_typetBtnType) forKey:@"counttype"];
    
    VotingOptionsViewController *votingVC = [[VotingOptionsViewController alloc]init];
    votingVC.dic = self.dataDic;
    [self.navigationController pushViewController:votingVC animated:YES];
}


- (void)voteDeleteRequestData:(NSString *)_id
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_id forKey:@"id"];
    
    [LHConnect postVoteDetail:params loading:nil success:^(id  _Nonnull response) {
        
        self.dataDic = response;
        NSString *nameStr = self.dataDic[@"title"];
        NSArray *arr = [self.dataDic objectForKey:@"results"];
        [self.dataDic setObject:arr forKey:@"items"];
        [self.dataDic setObject:nameStr forKey:@"name"];
        [self.dataDic removeObjectForKey:@"results"];
        [self.dataDic removeObjectForKey:@"title"];
        
        self.textFiled.text = self.dataDic[@"name"];
        [self.timeBtn_One setTitle:self.dataDic[@"start"] forState:UIControlStateNormal];
        [self.timeBtn_Two setTitle:self.dataDic[@"end"] forState:UIControlStateNormal];
        [self clickBtn:_limitBtn_One select:NO];
        [self clickBtn:_limitBtn_Two select:NO];
        [self clickBtn:_typetBtn_One select:NO];
        [self clickBtn:_typetBtn_Two select:NO];
        [self clickBtn:_typetBtn_Three select:NO];
        [self clickBtn:_typetBtn_Four select:NO];
        
        switch ([self.dataDic[@"limittype"] intValue]) {
            case 0:
                [self clickBtn:_limitBtn_One select:YES];

                break;
            case 1:
                [self clickBtn:_limitBtn_Two select:YES];
                
                break;
            default:
                break;
        }
        
        switch ([self.dataDic[@"counttype"] intValue]) {
            case 0:
                [self clickBtn:_typetBtn_One select:YES];
                
                break;
            case 1:
                [self clickBtn:_typetBtn_Two select:YES];
                
                break;
            case 2:
                [self clickBtn:_typetBtn_Three select:YES];
                
                 break;
            case 3:
                [self clickBtn:_typetBtn_Four select:YES];
                
                break;
            default:
                break;
        }
        
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
