//
//  AYDrawView.m
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDrawView.h"
#import "AYPixelAdapter.h"

@implementation AYDrawView
{
    @protected
        
    NSMutableArray *_undoQueue;
    NSMutableArray *_redoQueue;
    NSMutableArray *_drawingPixels;//正在画但还没提交的东西
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size
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
        _maxUndoQueueCount = 20;
        _undoQueue = [[NSMutableArray alloc] init];
        _redoQueue = [[NSMutableArray alloc] init];
        //TODO : sfsf
        _slectedColor = [UIColor blackColor];
        _drawingPixels = [[NSMutableArray alloc] init];
        self.lineWidth = 1;
        self.mirrorMode = NO;
        _slectedPixels= [[NSMutableDictionary alloc] init];
        self.isInPaste = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([_drawingPixels count] != 0) {//画正在画的点...
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(ctx, NO);
        [self.slectedColor setFill];
        for (NSValue *value in _drawingPixels ) {
            CGPoint loc = [value CGPointValue];
            CGRect pixelRect;
            
            if (self.lineWidth == 2) {
                pixelRect = CGRectMake((loc.x-1) * _pixelWidth,
                                                (loc.y-1) * _pixelWidth,
                                                _pixelWidth *3,
                                                _pixelWidth *3);
            }else{
                pixelRect = CGRectMake(loc.x * _pixelWidth,
                                       loc.y * _pixelWidth,
                                       _pixelWidth,
                                       _pixelWidth);
            }

            CGContextAddRect(ctx, pixelRect);
            CGContextFillPath(ctx);
        }
    }else if(
             (self.currentType == COPY || self.isInPaste)
             &&
             [_slectedPixels count] != 0
             ){
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(ctx, NO);
        
        [[UIColor redColor] setFill];

        for (NSValue *value in _slectedPixels ) {
            CGPoint loc = [value CGPointValue];
            CGRect pixelRect;
            //粘贴时显示的是复制的颜色
            if (self.isInPaste) {
                UIColor *color = [self.slectedPixels objectForKey:value];
                [color setFill];
            }
            
            if (self.lineWidth == 2) {
                pixelRect = CGRectMake((loc.x-1) * _pixelWidth,
                                       (loc.y-1) * _pixelWidth,
                                       _pixelWidth *3,
                                       _pixelWidth *3);
            }else{
                pixelRect = CGRectMake(loc.x * _pixelWidth,
                                       loc.y * _pixelWidth,
                                       _pixelWidth,
                                       _pixelWidth);
            }
            
            CGContextAddRect(ctx, pixelRect);
            CGContextFillPath(ctx);
        }
        
    }
}


-(CGPoint)locationWithPoint:(CGPoint)point
{
    int y = point.y / _pixelWidth;
    int x = point.x / _pixelWidth;
    return CGPointMake(x, y);
}


-(void)drawPixelAtLoc:(CGPoint)loc
{
    if (self.lineWidth == 1) {
        [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y) Withcolor:self.slectedColor];
        [self setNeedsDisplayInLoc:loc];
    }else{
        [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y-1) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y+1) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y+1) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y-1) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y+1) Withcolor:self.slectedColor];
        [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y-1) Withcolor:self.slectedColor];
        //TODO :
    }
    
    if (self.mirrorMode) {
        loc = CGPointMake(self.size-1-loc.x, loc.y);
        if (self.lineWidth == 1) {
            [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y) Withcolor:self.slectedColor];
            [self setNeedsDisplayInLoc:loc];

        }else{
            [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y-1) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x+1, loc.y+1) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y+1) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x-1, loc.y-1) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y+1) Withcolor:self.slectedColor];
            [self.adapter replaceAtLoc:CGPointMake(loc.x, loc.y-1) Withcolor:self.slectedColor];
            
            //TODO:
        }

    }

}

-(void)erasePixelAtLoc:(CGPoint)loc
{
    [self.adapter removeAtLoc:CGPointMake(loc.x, loc.y)];
    [self setNeedsDisplayInLoc:loc];


    if (self.lineWidth == 2) {
        [self.adapter removeAtLoc:CGPointMake(loc.x+1, loc.y)];
        [self.adapter removeAtLoc:CGPointMake(loc.x+1, loc.y-1)];
        [self.adapter removeAtLoc:CGPointMake(loc.x+1, loc.y+1)];
        [self.adapter removeAtLoc:CGPointMake(loc.x-1, loc.y)];
        [self.adapter removeAtLoc:CGPointMake(loc.x-1, loc.y+1)];
        [self.adapter removeAtLoc:CGPointMake(loc.x-1, loc.y-1)];
        [self.adapter removeAtLoc:CGPointMake(loc.x, loc.y+1)];
        [self.adapter removeAtLoc:CGPointMake(loc.x, loc.y-1)];
        //TODO:
    }
}


//用这个向待处理序列加对象，能自动处理镜像模式
-(void)addToDrawingPixelsAtX:(NSInteger)x andY:(NSInteger)y
{
    [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    
    if (self.mirrorMode) {
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(self.size-1-x, y)]];
    }
}



//改为Bresenham算法
-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    int x0 = locA.x;
    int y0 = locA.y;
    int x1 = locB.x;
    int y1 = locB.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            [self drawPixelAtLoc:CGPointMake(y, x)];
        }else{
            [self drawPixelAtLoc:CGPointMake(x, y)];
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }
}

-(void)eraseLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    
    int x0 = locA.x;
    int y0 = locA.y;
    int x1 = locB.x;
    int y1 = locB.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            [self erasePixelAtLoc:CGPointMake(y, x)];
        }else{
            [self erasePixelAtLoc:CGPointMake(x, y)];
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }

}

//添加到那个里面正在画的数组里面。。。。
-(void)drawLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    
    [_drawingPixels removeAllObjects];
    int x0 = locA.x;
    int y0 = locA.y;
    int x1 = locB.x;
    int y1 = locB.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            [self addToDrawingPixelsAtX:y andY:x];
            
        }else{
            [self addToDrawingPixelsAtX:x andY:y];
            
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }
    [self setNeedsDisplay];
}


//添加到临时复制数组里面。。。。
-(void)slectLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    [_drawingPixels removeAllObjects];
    int x0 = locA.x;
    int y0 = locA.y;
    int x1 = locB.x;
    int y1 = locB.y;
    BOOL steep;
    short t, deltaX, deltaY, error;
    CGFloat x,y,ystep;
    
    steep = (ABS(y1 - y0)  >  ABS(x1 - x0));
    if (steep) {
        t = x0;
        x0 = y0;
        y0 = t;
        
        t = x1;
        x1 = y1;
        y1 = t;
    }
    
    if (x0 > x1) {
        t = x0;
        x0 = x1;
        x1 = t;
        
        t = y0;
        y0 = y1;
        y1 = t;
    }
    
    deltaX = x1 - x0;
    deltaY = ABS(y1 - y0);
    error = 0;
    y = y0;
    
    if (y0 < y1) {
        ystep = 1;
    }else{
        ystep = -1;
    }
    for (x=x0; x <= x1; x++) {
        if (steep) {
            NSValue *key = [NSValue valueWithCGPoint:CGPointMake(y, x)];
            UIColor *color = [self.adapter colorWithKey:key];
            if (color) {
                [_slectedPixels setObject: color forKey: key];
                [self setNeedsDisplayInLoc:CGPointMake(y, x)];
            }
        }else{
            NSValue *key = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            UIColor *color = [self.adapter colorWithKey:key];
            if (color) {
                [_slectedPixels setObject: color forKey: key];
                [self setNeedsDisplayInLoc:CGPointMake(x, y)];
            }
        }
        error += deltaY;
        if ((error << 1) >= deltaX ){
            y += ystep;
            error -= deltaX;
        }
    }
}


// 以a为圆心，过b点画圆
-(void)drawCircleAtLoc:(CGPoint)a toLoc:(CGPoint)b
{
    [_drawingPixels removeAllObjects];
    int distance = sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    
    [self drawCircleAtLoc:a withR:distance];
    [self setNeedsDisplay];
}


//以a为圆心 r为半径画圆
-(void)drawCircleAtLoc:(CGPoint)point withR:(int)r
{
    int x = 0;
    int y = r;
    int mx = point.x;
    int my = point.y;
    int d = 1 - r;
    
    while (x<=y) {
        [self addToDrawingPixelsAtX:mx+x andY:my+y];
        [self addToDrawingPixelsAtX:mx+y andY:my+x];
        [self addToDrawingPixelsAtX:mx-x andY:my+y];
        [self addToDrawingPixelsAtX:mx-y andY:my+x];
        
        [self addToDrawingPixelsAtX:mx-x andY:my-y];
        [self addToDrawingPixelsAtX:mx-y andY:my-x];
        [self addToDrawingPixelsAtX:mx+x andY:my-y];
        [self addToDrawingPixelsAtX:mx+y andY:my-x];
        if(d < 0){
            d = d+2*x+3;
        }else{
            d=d+2*(x-y)+5;
            y--;
        }
        x++;
    }
    
}


//将正在处理中的像素点提交到到画布上
-(void)submitDrawingPixels
{
    if ([_drawingPixels count] != 0) {
        for (NSValue *value in _drawingPixels ) {
            CGPoint loc = [value CGPointValue];
            [self drawPixelAtLoc:CGPointMake(loc.x, loc.y)];
        }
    }
    [_drawingPixels removeAllObjects];
    [self setNeedsDisplay];
    
}
#pragma mark - 撤回

-(void)pushToUndoQueue
{
    [self.adapter pushToUndoQueue];
}

-(void)undo
{
    [self.adapter undo];
    [self setNeedsDisplay];
}

-(void)pushToRedoQueue
{
    [self.adapter pushToRedoQueue];
}

-(void)redo
{
    [self.adapter redo];
    [self setNeedsDisplay];}


//清空
-(void)clearCanvas
{
    [self pushToUndoQueue];
    [self.adapter reset];
    [_drawingPixels removeAllObjects];
    [self setNeedsDisplay];
}

- (void)move:(NSUInteger)move
{
    [self pushToUndoQueue];
    if([self.adapter move:move]){
        [self setNeedsDisplay];
    }
}


-(void)fillUpWithLoc:(CGPoint)loc
{
    int y = loc.y;
    int x = loc.x;
    UIColor *c = [self.adapter colorWithLoc:CGPointMake(x, y)];
    if(!c){
        c = self.bgColor;
    }
    if (CGColorEqualToColor(c.CGColor, self.slectedColor.CGColor)) {
        return;
    }
    
    [self fillUpX:x andY:y andColor:c];
}

-(void)fillUpX:(int)x andY:(int)y andColor:(UIColor*)color;
{
    //    NSLog(@"++++%d %d",row,col);
    //越界不搜索
    if (x<0 || y<0 || x>=_size || y >=_size) {
        return;
    }
    
    UIColor *c = [self.adapter colorWithLoc:CGPointMake(x, y)];
    if(!c){
        c = self.bgColor;
    }
    
    //和选中的颜色一样,填充成画笔颜色
    if (CGColorEqualToColor(c.CGColor, color.CGColor)) {
//        [self.adapter replaceAtLoc: Withcolor:self.slectedColor];
        [self drawPixelAtLoc:CGPointMake(x, y)];
//        [self setNeedsDisplayInRect:CGRectMake(x * _pixelWidth, y * _pixelWidth, _pixelWidth, _pixelWidth)];
    }else{
        return;
    }
    
    
    [self fillUpX:x-1 andY:y andColor:c];
    [self fillUpX:x+1 andY:y andColor:c];
    [self fillUpX:x andY:y-1 andColor:c];
    [self fillUpX:x andY:y+1 andColor:c];
    
    return;
}


// TODO: 翻转
-(void)flipHorizontal
{
    [self pushToUndoQueue];
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc] init];

    for (NSValue *key in [self.adapter.dict allKeys]) {

        CGPoint loc = [self.adapter locWithKey:key];
        UIColor *color = [self.adapter colorWithLoc:CGPointMake(loc.x, loc.y)];
        [self.adapter removeAtLoc:CGPointMake(loc.x, loc.y)];
        [tempD setObject:color forKey:[NSValue valueWithCGPoint:CGPointMake(self.size - 1 - loc.x, loc.y)]];
    }
    
    for (NSValue *key in tempD) {
        CGPoint loc = [key CGPointValue];
        UIColor *color = [tempD objectForKey:key];
        [self.adapter replaceAtLoc:loc Withcolor:color];
    }
    
    [self setNeedsDisplay];
}

-(void)flipVertical
{
    [self pushToUndoQueue];
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc] init];
    
    for (NSValue *key in [self.adapter.dict allKeys]) {
        
        CGPoint loc = [self.adapter locWithKey:key];
        UIColor *color = [self.adapter colorWithLoc:CGPointMake(loc.x, loc.y)];
        [self.adapter removeAtLoc:CGPointMake(loc.x, loc.y)];
        [tempD setObject:color forKey:[NSValue valueWithCGPoint:CGPointMake(loc.x, self.size - 1 - loc.y)]];
    }
    
    for (NSValue *key in tempD) {
        CGPoint loc = [key CGPointValue];
        UIColor *color = [tempD objectForKey:key];
        [self.adapter replaceAtLoc:loc Withcolor:color];
    }
    
    [self setNeedsDisplay];
}

-(void)rotate90
{
    [self pushToUndoQueue];
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc] init];
    
    for (NSValue *key in [self.adapter.dict allKeys]) {
        
        CGPoint loc = [self.adapter locWithKey:key];
        UIColor *color = [self.adapter colorWithLoc:CGPointMake(loc.x, loc.y)];
        [tempD setObject:color forKey:[NSValue valueWithCGPoint:CGPointMake(loc.y, self.size - 1 - loc.x)]];
    }
    [self.adapter.dict removeAllObjects];
    
    for (NSValue *key in tempD) {
        CGPoint loc = [key CGPointValue];
        UIColor *color = [tempD objectForKey:key];
        [self.adapter replaceAtLoc:loc Withcolor:color];
    }
    
    [self setNeedsDisplay];

}


//通知视图修改adapter....
-(void)setAdapter:(AYPixelAdapter *)adapter
{
    [super setAdapter:adapter];
    if ([self.delegate respondsToSelector:@selector(drawViewChangeAdapter:)]) {
        [self.delegate  drawViewChangeAdapter:adapter];
    }
}



-(void)moveSlectedPixels:(MOVE)move
{
    CGPoint offset = CGPointZero;
    switch (move) {
        case MOVE_UP:
            offset = CGPointMake(0,-1);
            break;
        case MOVE_DOWN:
            offset = CGPointMake(0,1);
            break;
        case MOVE_LEFT:
            offset = CGPointMake(-1,0);
            break;
        case MOVE_RIGHT:
            offset = CGPointMake(1,0);
            break;
        default:
            break;
    }
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    for (NSValue *value in [self.slectedPixels allKeys]) {
        CGPoint p = [value CGPointValue];
        NSValue *key =  [NSValue valueWithCGPoint:CGPointMake(p.x + offset.x, p.y + offset.y)];
        [tempDict setObject:[self.slectedPixels objectForKey:value] forKey:key];
    }
    self.slectedPixels = tempDict;
    [self setNeedsDisplay];
}


//将所选择区域粘贴到移动的位置
-(void)pasteShape
{
    [self pushToUndoQueue];
    //成功粘贴再用这个
    for (NSValue *v in [self.slectedPixels allKeys]) {
        CGPoint loc = [v CGPointValue];
        UIColor *color = [self.slectedPixels objectForKey:v];
        [self.adapter replaceAtLoc:loc Withcolor:color];
    }
    
    
    self.isInPaste = NO;
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(drawViewHasRefreshContent)]) {
        [self.delegate drawViewHasRefreshContent];
    }
}

-(void)setCurrentType:(AYCursorDrawType)currentType
{
    _lastType = _currentType;
    _currentType = currentType;
}

//只绘制刷新区域，只遍历刷新对象
-(void)setNeedsDisplayInLoc:(CGPoint)loc
{
    [self setNeedsDisplayInRect:CGRectMake(loc.x * _pixelWidth, loc.y * _pixelWidth, _pixelWidth, _pixelWidth)];
}



@end
