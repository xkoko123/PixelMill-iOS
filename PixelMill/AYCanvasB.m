//
//  AYCanvasB.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCanvasB.h"
#import "UIColor+colorWithInt.h"
@implementation AYCanvasB
{
    CGFloat _cursorX;
    CGFloat _cursorY;
    CGPoint _lastLoc;
    CGFloat _curcorWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//if([self.delegate respondsToSelector:@selector(clickChangeBtn)]){
//    [self.delegate clickChangeBtn];
//}

-(instancetype)initWithFrame:(CGRect)frame andSize:(int)size pallets:(NSArray *)pallets
{
    self = [super initWithFrame:frame andSize:size pallets:pallets];
    if (self) {
        _cursorX = self.frame.size.width / 2;
        _cursorY = self.frame.size.width / 2;
        _curcorWidth = 15;
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawCursor];
}

- (void)drawCursor
{
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(_cursorX,
//                                                                     _cursorY,
//                                                                     self.pixelWidth,
//                                                                     self.pixelWidth)];
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
    
    [[UIColor colorWithInt:self.currentColor] setFill];
    [path fill];
    path.lineWidth = 1;
    [[UIColor blackColor] setStroke];
    [path stroke];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [[touches allObjects] firstObject];
//    CGPoint point = [touch locationInView:self];
//}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    
    CGPoint lastpoint = [touch previousLocationInView:self];
    
    CGFloat offsetX = point.x - lastpoint.x ;
    CGFloat offsetY = point.y - lastpoint.y;
//    NSLog(@" offsetX %.1f  ",offsetX);
    
    CGFloat x = _cursorX + offsetX * 2.0;
    CGFloat y = _cursorY + offsetY * 2.0;
    
    x = MIN(x, self.frame.size.width - _curcorWidth / 3);
    x = MAX(x, 0);
    y = MIN(y, self.frame.size.width - _curcorWidth / 3);
    y = MAX(y, 0);
    
//    NSLog(@"cursorX:%.1f",x - _cursorX);
    _cursorX = x ;
    _cursorY = y ;
    
    
//    NSLog(@"%f %f", _cursorX, _cursorY);
    [self setNeedsDisplay];
}

-(void)touchDown
{
    [self pushToUndoQueue];
    CGPoint point = CGPointMake(_cursorX, _cursorY);
    CGPoint loc = [self getLocationFromPoint:point];
//    [self fillPixelAtLoc:loc];
    _lastLoc = loc;
    self.isPress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self.isPress) {
            CGPoint point = CGPointMake(_cursorX, _cursorY);
            CGPoint loc = [self getLocationFromPoint:point];
            [self addLineBetweenLoc:_lastLoc and:loc];
            _lastLoc = loc;
            [self setNeedsDisplay];
        }
    });

    [self setNeedsDisplay];
}

-(void)touchUp
{
    self.isPress = NO;
}


-(void)longPress
{
    if(self.isPress){
        CGPoint point = CGPointMake(_cursorX, _cursorY);
        CGPoint loc = [self getLocationFromPoint:point];
        [self addLineBetweenLoc:_lastLoc and:point];
        _lastLoc = loc;
        [self setNeedsDisplay];
    }
}

-(void)setCurrentColor:(int)currentColor
{
    [super setCurrentColor:currentColor];
    [self setNeedsDisplay];
}

-(void)fillUp
{
    CGPoint point = CGPointMake(_cursorX, _cursorY);
    CGPoint loc = [self getLocationFromPoint:point];
    [self fillUpLoc:loc];
}

@end
