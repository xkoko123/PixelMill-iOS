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
//    CGFloat _cursorX;
//    CGFloat _cursorY;
    CGPoint _cursorPosition;
    CGPoint _cursorLoc;
    CGPoint _lastLoc;
    CGFloat _curcorWidth;
    BOOL _isPress;
    CGPoint _beginLoc;
    
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
//        _cursorX = self.frame.size.width / 2;
//        _cursorY = self.frame.size.width / 2;
        _cursorPosition = CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2);
        _curcorWidth = 15;
        _isPress = NO;
        
        
        _currentType = PEN;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.showExtendedContent) {
        [self drawCursor];
    }
    
}

- (void)drawCursor
{
    switch (self.currentType) {
        case PEN:
        {
            UIBezierPath *path = [UIBezierPath bezierPath];

            [path moveToPoint:CGPointMake(_cursorPosition.x, _cursorPosition.y)];
            [path addLineToPoint:CGPointMake(_cursorPosition.x + _curcorWidth,
                                             _cursorPosition.y +  _curcorWidth / 2.5)
             ];
            
            [path addLineToPoint:CGPointMake(_cursorPosition.x  +  _curcorWidth / 2,
                                             _cursorPosition.y + _curcorWidth / 2)];
            
            [path addLineToPoint:CGPointMake(_cursorPosition.x  +  _curcorWidth / 2.5,
                                             _cursorPosition.y + _curcorWidth)
             ];
            
            [path closePath];
            
            [[UIColor colorWithInt:self.slectedColor] setFill];
            [path fill];
            path.lineWidth = 1;
            [[UIColor blackColor] setStroke];
            [path stroke];

        }
            break;
        case FILL:
        {
            [[UIImage imageNamed:@"bucket"] drawInRect:CGRectMake(_cursorPosition.x,
                                                                  _cursorPosition.y,
                                                                  _curcorWidth,
                                                                  _curcorWidth)
             ];
        }
            break;
        default:
            break;
    }
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    _cursorLoc = [self locationWithTouch:touch];
    // TODO : 对坐标操作
    //当前操作类型

    switch (self.currentType) {
        case PEN:
        {
            if (_isPress) {
                [self addLineBetweenLoc:_beginLoc and:_cursorLoc];
                _beginLoc = _cursorLoc;
            }
        }
            break;
        case FILL:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    [self setNeedsDisplay];
}

//从UITouch中计算出指针的像素坐标，并顺便设置指针的真实坐标
-(CGPoint)locationWithTouch:(UITouch*)touch
{
    //当前手指在画布的真实坐标
    CGPoint point = [touch locationInView:self];
    
    //手指在画布的上一次真实坐标
    CGPoint lastpoint = [touch previousLocationInView:self];
    
    //手指移动偏移
    CGFloat offsetX = point.x - lastpoint.x ;
    CGFloat offsetY = point.y - lastpoint.y;
    
    //计算指针的真实坐标
    CGFloat x = _cursorPosition.x + offsetX * 1.5;
    CGFloat y = _cursorPosition.y + offsetY * 1.5;
    
    //避免画出去
    x = MIN(x, self.frame.size.width - _curcorWidth / 3);
    x = MAX(x, 0);
    y = MIN(y, self.frame.size.width - _curcorWidth / 3);
    y = MAX(y, 0);
    
    _cursorPosition = CGPointMake(x, y);
    
    
    return [self locationWithPoint:_cursorPosition];
}


-(void)touchDown
{
    [self pushToUndoQueue];

    _beginLoc = _cursorLoc;
    _isPress = YES;
    
    switch (self.currentType) {
        case PEN:
        {
            [self drawPixelAtLoc:_cursorLoc];
        }
            break;
        case FILL:
        {
            [self fillUpWithLoc:_cursorLoc];
        }
            break;
        default:
            break;
    }
    
    
    [self setNeedsDisplay];
    
}

-(void)touchUp
{
    _isPress = NO;
}


//选择颜色后变指针颜色
-(void)setSlectedColor:(int)slectedColor
{
    [super setSlectedColor:slectedColor];
    [self setNeedsDisplay];
}

//选择工具过后 指针应该变
-(void)setCurrentType:(AYCursorDrawType)currentType
{
    _currentType = currentType;
    [self setNeedsDisplay];
}


@end
