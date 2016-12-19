//
//  AYUnderLineTextField.m
//  PixelMill
//
//  Created by GoGo on 16/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYUnderLineTextField.h"

@implementation AYUnderLineTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    self = [super init];
    if (self) {
        _underlineColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.underlineColor setFill];
    CGContextFillRect(ctx, CGRectMake(0, self.frame.size.height - 0.7, self.frame.size.width, 0.2));
}
@end
