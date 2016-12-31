//
//  AYTextView.m
//  PixelMill
//
//  Created by GoGo on 29/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYTextView.h"
@interface AYTextView()
@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用
@end

@implementation AYTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor= [UIColor clearColor];
        
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        
        placeholderLabel.backgroundColor= [UIColor clearColor];
        
        placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
        
        [self addSubview:placeholderLabel];
        
        self.placeholderLabel= placeholderLabel; //赋值保存
        
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        
        self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变

    }
    return self;
}


- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    //根据文字计算高度
    
    
    CGFloat height = [self.myPlaceholder boundingRectWithSize:CGSizeMake(self.frame.size.width - 10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    
    self.placeholderLabel.frame = CGRectMake(5, 5, self.frame.size.width - 10, height);
}


- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    
    //设置文字
    
    self.placeholderLabel.text= myPlaceholder;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}


- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    
    //设置颜色
    
    self.placeholderLabel.textColor= myPlaceholderColor;
    
}

- (void)setFont:(UIFont*)font{
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}

- (void)setText:(NSString*)text{
    
    [super setText:text];
    
    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
    
}

- (void)setAttributedText:(NSAttributedString*)attributedText{
    
    [super setAttributedText:attributedText];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification 通知的回调
    
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
    
}



@end
