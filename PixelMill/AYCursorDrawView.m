//
//  AYCursorDrawer.m
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCursorDrawView.h"
#import "AYPublicHeader.h"
#import "AYPixelAdapter.h"
#import "AYCursorLayer.h"
@interface AYCursorDrawView()


@end


@implementation AYCursorDrawView
{
    CGPoint _cursorPosition;//鼠标的画布坐标
    CGPoint _cursorLoc;//鼠标的像素坐标
    CGPoint _lastLoc;//上次的像素坐标
    BOOL _isPress;
    CGPoint _beginLoc;//接触屏幕或者按下鼠标时的像素坐标
    CGPoint _lastFigerPosition;//最新的手指画布坐标
    AYCursorLayer *_cursorLayer;//绘制指针的layer
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame andSize:(NSInteger)size
{
    self = [super initWithSize:size];
    if (self) {
        self.frame = frame;
    }
    return self;
}


-(instancetype)initWithSize:(NSInteger)size
{
    self = [super initWithSize:size];
    if (self) {
        _cursorPosition = CGPointMake(0, 0);
        _isPress = NO;
        _fingerMode = NO;
        self.currentType = PEN;
        _lastFigerPosition = CGPointZero;
        _cursorLayer = [[AYCursorLayer alloc] init];
        
        _cursorLayer.bounds = CGRectMake(0, 0, 20, 20);
        _cursorLayer.position = CGPointMake(0, 0);
        _cursorLayer.anchorPoint = CGPointMake(0, 0);
        [self.layer addSublayer:_cursorLayer];
        [_cursorLayer setNeedsDisplay];
        
    }
    return self;
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
    x = MIN(x, self.frame.size.width-5);
    x = MAX(x, 0);
    y = MIN(y, self.frame.size.width-5);
    y = MAX(y, 0);
    
    _cursorPosition = CGPointMake(x, y);
    
    [CATransaction setDisableActions:YES];
    _cursorLayer.position = _cursorPosition;
    [CATransaction commit];

    
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


#pragma mark - 拖动过程中在这里添加
//移动时处理拖动操作
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    _cursorLoc = [self locationWithTouch:touch];
    // TODO : 对坐标操作
    //当前操作类型

//    if (_fingerMode) {
//        _beginLoc = [self locationWithPoint: [touch previousLocationInView:self]];        
//    }
    
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

        case LINE:
        {
            if (_isPress || _fingerMode) {
                [self drawLineBetweenLoc:_beginLoc and:_cursorLoc];
            }

        }
            break;
        case CIRCLE:
        {
            if (_isPress || _fingerMode) {
                [self drawCircleAtLoc:_beginLoc toLoc:_cursorLoc];
            }
            
        }
            break;
        case COPY:
        {
            if (_isPress || _fingerMode) {
                [self slectLineBetweenLoc:_beginLoc and:_cursorLoc];
                _beginLoc = _cursorLoc;
            }

        }
            break;
        default:
            break;
    }
    
    _lastFigerPosition = [touch locationInView:self];
    if (_isPress || _fingerMode){
        [self setNeedsDisplay];
    }
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


#pragma mark - 按下时在这里添加
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
        case COPY:
        {
            NSValue *key = [NSValue valueWithCGPoint:_cursorLoc];
            UIColor *color = [self.adapter colorWithKey:key];
            if (color) {
                [self.slectedPixels setObject:color forKey:key];
            }
            
        }
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}


#pragma mark - 松手时在这里添加
//松开时处理拖动操作
-(void)touchUp
{
    _isPress = NO;
    switch (self.currentType) {
        case LINE:
        case CIRCLE:
        {
            [self submitDrawingPixels];
        }
            break;
        case COPY:
        {
            self.currentType = self.lastType;
        }
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
    //刷新previewView
    if ([self.delegate respondsToSelector:@selector(drawViewHasRefreshContent)]) {
        [self.delegate drawViewHasRefreshContent];
    }
}


//选择颜色后变指针颜色
-(void)setSlectedColor:(UIColor *)slectedColor
{
    [super setSlectedColor:slectedColor];
    _cursorLayer.selectedColor = slectedColor;
}


//选择工具过后 指针应该变
-(void)setCurrentType:(AYCursorDrawType)currentType
{
    [super setCurrentType:currentType];
    
    if (currentType == COPY) {
        [self.slectedPixels removeAllObjects];
    }
    _cursorLayer.type = currentType;
}

-(void)setFingerMode:(AYCursorDrawType)fingerMode{
    _fingerMode = fingerMode;
    if (fingerMode) {
        _cursorLayer.hidden = YES;
    }else{
        _cursorLayer.hidden = NO;
    }
}

@end
