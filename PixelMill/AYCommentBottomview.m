//
//  AYCommentBottomview.m
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCommentBottomview.h"
@interface AYCommentBottomview()<UITextFieldDelegate>

@end


@implementation AYCommentBottomview
{
    UITextField *_textField;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"说点什么";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textField];
        _textField.frame = CGRectMake(4, 4, self.frame.size.width - 8, 36);
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        
    }
    return self;
}

-(void)setPlaceHolder:(NSString *)text
{
    _textField.placeholder = text;
}

-(BOOL)becomeFirstResponder{
    return [_textField becomeFirstResponder];
}

-(BOOL)resignFirstResponder{
    return [_textField resignFirstResponder];
}


-(void)clearText
{
    _textField.text = @"";
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length != 0) {
        if ([self.delegate respondsToSelector:@selector(commentBottomViewDidClickSend:)]) {
            [self. delegate commentBottomViewDidClickSend:_textField.text];
        }
        [textField resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}

@end

