//
//  AYPopupWindow.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYPopupWindow.h"
#import "AYUnderLineTextField.h"
@interface AYPopupWindow()


@end

@implementation AYPopupWindow
{
    UIView *_panel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void) initView
{
    _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 248)];
    _panel.backgroundColor = [UIColor whiteColor];
//    _panel.layer.shadowOffset = CGSizeMake(1, 1);
//    _panel.layer.shadowColor = [UIColor grayColor].CGColor;
    [self addSubview:_panel];
    
    UIControl *dismissControll = [[UIControl alloc] init];
    dismissControll.frame = CGRectMake(0, _panel.frame.size.height, self.frame.size.width, self.frame.size.height - 248);
    [dismissControll addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissControll];
    
    
    //title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"登陆";
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_panel addSubview:_titleLabel];
    
    
    //username
    _userField = [[AYUnderLineTextField alloc] init];
    _userField.frame = CGRectMake(0,
                                  _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 20,
                                   self.frame.size.width,
                                   30);
    _userField.textAlignment = NSTextAlignmentCenter;
    _userField.placeholder = @"账号";
    _userField.font = [UIFont systemFontOfSize:17];
    _userField.underlineColor = [UIColor lightGrayColor];
    [_panel addSubview:_userField];
    
    //password
    _passwordField = [[AYUnderLineTextField alloc] init];
    _passwordField.frame = CGRectMake(0,
                                  _userField.frame.origin.y + _userField.frame.size.height + 10,
                                  self.frame.size.width,
                                  30);
    _passwordField.textAlignment = NSTextAlignmentCenter;
    _passwordField.placeholder = @"密码";
    _passwordField.font = [UIFont systemFontOfSize:17];
    _passwordField.secureTextEntry = YES;
    _passwordField.underlineColor = [UIColor lightGrayColor];
    [_panel addSubview:_passwordField];
    
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                           _passwordField.frame.origin.y +_passwordField.frame.size.height + 40,
                                                           self.frame.size.width/2, 54)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelBtn.layer.borderWidth = 0.3;
    _cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_panel addSubview:_cancelBtn];
    
    _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2,
                                                            _passwordField.frame.origin.y +_passwordField.frame.size.height + 40,
                                                            self.frame.size.width/2, 54)];
    [_okBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_panel addSubview:_okBtn];
    _okBtn.layer.borderWidth = 0.3;
    _okBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
}

-(void)dismiss
{
    [self resignAllFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, -248, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

-(void)resignAllFirstResponder
{
    for (UIView *view in [_panel subviews]) {
        [view resignFirstResponder];
    }
}


@end
