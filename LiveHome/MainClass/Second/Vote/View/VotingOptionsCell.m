//
//  VotingOptionsCell.m
//  LiveHome
//
//  Created by 谢炳 on 2017/12/21.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "VotingOptionsCell.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>
 #import <SDWebImage/UIButton+WebCache.h>
#import "ToolsHelper.h"
@interface VotingOptionsCell()<UITextViewDelegate>

@end

@implementation VotingOptionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);//.with.offset(17*UIRate);
        make.left.equalTo(self).with.offset(15*UIRate);
        make.right.equalTo(self).with.offset(-15*UIRate);
        make.height.mas_equalTo(140*UIRate);
    }];
    
    _addImageBtn = [UIButton new];
    _addImageBtn.backgroundColor = [UIColor bgColorMain];
    [_addImageBtn setImage:[UIImage imageNamed:@"s_addImage-default"] forState:UIControlStateNormal];
    [_addImageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_addImageBtn];
    [_addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(15*UIRate);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(100*UIRate, 100*UIRate));
    }];
    
    _describeTF = [UITextView new];
    _describeTF.delegate = self;
    _describeTF.placeholder = @"投票项描述......";
    _describeTF.backgroundColor = [UIColor bgColorMain];
    [bgView addSubview:_describeTF];
    [_describeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addImageBtn.mas_right).with.offset(10*UIRate);
        make.right.equalTo(bgView).with.offset(-15*UIRate);
        make.centerY.equalTo(bgView);
        make.height.mas_equalTo(100*UIRate);
    }];
    
}


-(void)addImage:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addImageWithIndexPath:)]){
        [self.delegate addImageWithIndexPath:self.indexPath];
    }
}

-(void)setVotingOptionsModel:(VotingOptionsModel *)votingOptionsModel
{
    _votingOptionsModel = votingOptionsModel;
    _describeTF.text = votingOptionsModel.describe;
    
    if ([ToolsHelper isBlankString:votingOptionsModel.imageUrl] == NO)
    {
        [_addImageBtn sd_setImageWithURL:[NSURL URLWithString:votingOptionsModel.imageUrl] forState:UIControlStateNormal];
    }
//    else
//    {
//        [_addImageBtn setImage:votingOptionsModel.image forState:UIControlStateNormal];
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder]; //［要实现的方法］
        return NO;
    }
    
    
    NSString *textViewText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing: WithIndexPath:)]) {
        [self.delegate textViewDidEndEditing:textViewText WithIndexPath:self.indexPath];
    }
    return YES;
}
@end
