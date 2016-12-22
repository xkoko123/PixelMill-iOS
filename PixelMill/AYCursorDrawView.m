//
//  AYCursorDrawer.m
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCursorDrawView.h"
#import "AYPublicHeader.h"

@interface AYCursorDrawView()


@end
@implementation AYCursorDrawView
{
    CGPoint _cursorPosition;
    CGPoint _cursorLoc;
    CGPoint _lastLoc;
    CGFloat _curcorWidth;
    BOOL _isPress;
    CGPoint _beginLoc;
    CGPoint _lastFigerPosition;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame andSize:(int)size
{
    self = [super initWithFrame:frame andSize:size];
    if (self) {
        _cursorPosition = CGPointMake(0, 0);
        _curcorWidth = 15;
        _isPress = NO;
        _fingerMode = NO;
        _currentType = PEN;
        _lastFigerPosition = CGPointZero;
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
            
            [self.slectedColor setFill];
            [path fill];
            path.lineWidth = 1;
            [[UIColor blackColor] setStroke];
            [path stroke];
        }
            break;
        case BUCKET:
        {
            [[UIImage imageNamed:@"bucket"] drawInRect:CGRectMake(_cursorPosition.x,
                                                                  _cursorPosition.y,
                                                                  _curcorWidth,
                                                                  _curcorWidth)
             ];
        }
            break;
        case ERASER:
        {
            [[UIImage imageNamed:@"eraser"] drawInRect:CGRectMake(_cursorPosition.x,
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


-(CGPoint)locationWithTouch:(UITouch*)touch
{
    //当前手指在画布的真实坐标
    CGPoint point = [touch locationInView:self];
    if (_fingerMode) {
        _cursorPosition = point;
        return [self locationWithPoint:_cursorPosition];
    }
    
    //手指在画布的上一次真实坐标
//    CGPoint lastpoint = [touch previousLocationInView:self];
    CGPoint lastpoint = _lastFigerPosition;
    
    
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (self.currentType == FINGER) {
//        UITouch *touch = [[touches allObjects] firstObject];
//        CGPoint position = [touch locationInView:self];
//        CGPoint loc = [self locationWithPoint:position];
//        [self drawPixelAtLoc:loc];
//    }
    UITouch *touch = [[touches allObjects] firstObject];

    _lastFigerPosition = [touch locationInView:self];
    
    if (self.fingerMode) {
        _cursorLoc = [self locationWithTouch:touch];
        [self touchDown];
    }

}

//移动时处理拖动操作
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    _cursorLoc = [self locationWithTouch:touch];
    // TODO : 对坐标操作
    //当前操作类型

    if (_fingerMode) {
        _beginLoc = _cursorLoc;
    }
    
    switch (self.currentType) {
        case PEN:
        {
            if (_isPress || _fingerMode) {
                [self addLineBetweenLoc:_beginLoc and:_cursorLoc];
                _beginLoc = _cursorLoc;
            }
        }
            break;
        case ERASER:
        {
            if (_isPress || _fingerMode) {
                [self eraseLineBetweenLoc:_beginLoc and:_cursorLoc];
                _beginLoc = _cursorLoc;
            }
        }
            break;

        case BUCKET:
        {
            
        }
            break;
//        case FINGER:
//        {
//            CGPoint position1 = [touch previousLocationInView:self];
//            CGPoint position2 = [touch locationInView:self];
//            [self addLineBetweenLoc:[self locationWithPoint:position1] and: [self locationWithPoint:position2]];
//        }
//            break;
        default:
            break;
    }
    
    _lastFigerPosition = [touch locationInView:self];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_fingerMode) {
        [self touchUp];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_fingerMode) {
        [self touchUp];
    }
}

//按下时处理单击事件
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
        case BUCKET:
        {
            [self fillUpWithLoc:_cursorLoc];
        }
            break;
        case ERASER:
        {
            [self erasePixelAtLoc:_cursorLoc];
        }
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

//松开时处理拖动操作
-(void)touchUp
{
    _isPress = NO;
    switch (self.currentType) {
        case PEN:
        {
            //
        }
            break;
        case BUCKET:
        {
        }
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
}


//选择颜色后变指针颜色
-(void)setSlectedColor:(UIColor *)slectedColor
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
