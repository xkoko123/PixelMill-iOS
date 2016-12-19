//
//  AYCursorDrawView.m
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//


#import "AYCursorDrawView.h"
#import "UIColor+colorWithInt.h"
@implementation AYCursorDrawView
{
    CGFloat _cursorX;
    CGFloat _cursorY;
    CGPoint _lastLoc;
    CGFloat _curcorWidth;
    BOOL _isPress;

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
        _cursorX = self.frame.size.width / 2;
        _cursorY = self.frame.size.width / 2;
        _curcorWidth = 15;
        _isPress = NO;
    
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawCursor];
}

- (void)drawCursor
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_cursorX, _cursorY)];
    [path addLineToPoint:CGPointMake(_cursorX + _curcorWidth,
                                     _cursorY +  _curcorWidth / 2.5)
     ];
    
    [path addLineToPoint:CGPointMake(_cursorX  +  _curcorWidth / 2,
                                     _cursorY + _curcorWidth / 2)];
    
    [path addLineToPoint:CGPointMake(_cursorX  +  _curcorWidth / 2.5,
                                     _cursorY + _curcorWidth)
     ];
    
    [path closePath];
    
    [[UIColor colorWithInt:self.slectedColor] setFill];
    [path fill];
    path.lineWidth = 1;
    [[UIColor blackColor] setStroke];
    [path stroke];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    CGPoint lastpoint = [touch previousLocationInView:self];
    
    CGFloat offsetX = point.x - lastpoint.x ;
    CGFloat offsetY = point.y - lastpoint.y;
    
    CGFloat x = _cursorX + offsetX * 2.0;
    CGFloat y = _cursorY + offsetY * 2.0;
    
    //避免画出去
    x = MIN(x, self.frame.size.width - _curcorWidth / 3);
    x = MAX(x, 0);
    y = MIN(y, self.frame.size.width - _curcorWidth / 3);
    y = MAX(y, 0);
    
    _cursorX = x ;
    _cursorY = y ;
    
    [self setNeedsDisplay];
}

-(void)touchDown
{
    [self pushToUndoQueue];
    CGPoint point = CGPointMake(_cursorX, _cursorY);
    CGPoint loc = [self locationWithPoint:point];
    //    [self fillPixelAtLoc:loc];
    _lastLoc = loc;
    _isPress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (_isPress) {
            CGPoint point = CGPointMake(_cursorX, _cursorY);
            CGPoint loc = [self locationWithPoint:point];
            [self addLineBetweenLoc:_lastLoc and:loc];
            _lastLoc = loc;
            [self setNeedsDisplay];
        }
    });
    
    [self setNeedsDisplay];
}

-(void)touchUp
{
    _isPress = NO;
}


-(void)longPress
{
    if(_isPress){
        CGPoint point = CGPointMake(_cursorX, _cursorY);
        CGPoint loc = [self locationWithPoint:point];
        [self addLineBetweenLoc:_lastLoc and:point];
        _lastLoc = loc;
        [self setNeedsDisplay];
    }
}

//选择颜色后变指针颜色
-(void)setSlectedColor:(int)slectedColor
{
    [super setSlectedColor:slectedColor];
    [self setNeedsDisplay];

}
-(void)fillUp
{
    CGPoint point = CGPointMake(_cursorX, _cursorY);
    CGPoint loc = [self locationWithPoint:point];
    [self fillUpWithLoc:loc];
}

@end
