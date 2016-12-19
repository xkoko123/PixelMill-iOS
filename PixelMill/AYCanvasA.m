//
//  AYCanvasA.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCanvasA.h"

@implementation AYCanvasA
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    [self pushToUndoQueue];
    CGPoint loc = [self getLocationFromPoint:point];
    [self fillPixelAtLoc:loc];
    _lastLoc = loc;
    [self setNeedsDisplay];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    CGPoint loc = [self getLocationFromPoint:point];
    
    [self addLineBetweenLoc:_lastLoc and:loc];
    
    _lastLoc = loc;
    [self setNeedsDisplay];
}

- (void)fillUp
{
    CGPoint loc = _lastLoc;
    [self fillUpLoc:loc];
}
@end
