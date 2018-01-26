//
//  SecretPsdPopView.m
//  Find
//
//  Created by chh on 2017/8/22.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "SecretPsdPopView.h"
@interface SecretPsdPopView()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;

@property (strong, nonatomic) NSString *password;
@end

@implementation SecretPsdPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    _textField1.userInteractionEnabled = NO;
    _textField2.userInteractionEnabled = NO;
    _textField3.userInteractionEnabled = NO;
    _textField4.userInteractionEnabled = NO;
    _totalTextField.tintColor = [UIColor clearColor];
    [_totalTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)sureButtonAction:(UIButton *)sender {
    NSString *password = @"";
    if (self.totalTextField.text.length == 4){
        password = self.totalTextField.text;
    }else {
        [LCProgressHUD showKeyWindowFailure:@"请输入四位密码"];
        return;
    }
    
    if (self.block){
        self.block([password copy]);
    }
    
    [self resetTextField];
    
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.block){
        self.block(@"");
    }
     [self resetTextField];
}

- (void)textFieldDidChange:(UITextField *)textField{

    //限制4位
    if (textField.text.length > 4){
        textField.text = [textField.text substringToIndex:4];
    }
    
    int count = (int)textField.text.length;

    switch (count) {
        case 0:
            _textField1.text = @"";
            _textField2.text = @"";
            _textField3.text = @"";
            _textField4.text = @"";
            break;
        case 1:
            _textField1.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
            _textField2.text = @"";
            _textField3.text = @"";
            _textField4.text = @"";
            break;
        case 2:
            _textField2.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
            _textField3.text = @"";
            _textField4.text = @"";
            break;
        case 3:
            _textField3.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
             _textField4.text = @"";
            break;
        case 4:
            _textField4.text = [textField.text substringWithRange:NSMakeRange(3, 1)];
            break;
        default:
            break;
    }
}

- (void)resetTextField{
    _textField1.text = @"";
    _textField2.text = @"";
    _textField3.text = @"";
    _textField4.text = @"";
    _totalTextField.text = @"";
}
@end
