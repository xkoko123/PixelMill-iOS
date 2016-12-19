//
//  AYFingerDrawView.m
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//手指画图

#import "AYFingerDrawView.h"

@implementation AYFingerDrawView
{
    CGPoint _lastLoc;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size
{
    self = [super initWithFrame:frame ansSize:size];
    if (self) {
        
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    [self pushToUndoQueue];
    CGPoint loc = [self locationWithPoint:point];
    
    [self drawPixelAtLoc:loc];
    _lastLoc = loc;
    [self setNeedsDisplay];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    CGPoint loc = [self locationWithPoint:point];
    
    [self addLineBetweenLoc:_lastLoc and:loc];
    
    _lastLoc = loc;
    [self setNeedsDisplay];
}



@end
