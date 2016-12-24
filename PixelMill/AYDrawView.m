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
        
    }
    return self;

}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([_drawingPixels count] != 0) {//画正在画的点...
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.slectedColor setFill];
        for (NSValue *value in _drawingPixels ) {
            CGPoint loc = [value CGPointValue];
            CGRect pixelRect = CGRectMake(loc.y * _pixelWidth,
                                          loc.x * _pixelWidth,
                                          _pixelWidth,
                                          _pixelWidth);
            CGContextAddRect(ctx, pixelRect);
            CGContextFillPath(ctx);
        }
    }
}

-(CGPoint)locationWithPoint:(CGPoint)point
{
    int row = point.y / _pixelWidth;
    int col = point.x / _pixelWidth;
    return CGPointMake(col, row);
}

-(void)drawPixelAtLoc:(CGPoint)loc
{
    //不知道为什么Touch事件有很小的几率坐标会超出View
    if(loc.x > _size -1 ||
       loc.x < 0 ||
       loc.y > _size -1 ||
       loc.y < 0 ){
        return;
    }
    
    [self.adapter replaceAtLoc:CGPointMake(loc.y, loc.x) Withcolor:self.slectedColor];
}

//改为Bresenham算法
-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    
//    CGFloat distance = sqrt((locA.x - locB.x)*(locA.x - locB.x) + (locA.y - locB.y) * (locA.y - locB.y));
//    
//    if(distance<=1){
//        [self drawPixelAtLoc:locB];
//        return;
//    }
//    
//    if(locA.x > locB.x){
//        CGPoint temp = locA;
//        locA = locB;
//        locB = temp;
//    }
//    
//    CGFloat k = (locB.y - locA.y) / (locB.x - locA.x);
//    
//    //如果纵向比横向断点多，就沿x轴扫描确定y坐标
//    if(fabs(locA.x-locB.x) > fabs(locA.y-locB.y)){
//        for (int x=MIN(locA.x, locB.x); x<MAX(locA.x, locB.x); x++) {
//            int y = k * ( x - locA.x) + locA.y;
//            [self drawPixelAtLoc:CGPointMake(x, y)];
//            
//        }
//    }else{
//        for (int y=MIN(locA.y, locB.y); y<MAX(locB.y,locA.y); y++) {
//            int x = locA.x + (y - locA.y) / k;
//            [self drawPixelAtLoc:CGPointMake(x, y)];
//        }
//    }
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
    
//    CGFloat distance = sqrt((locA.x - locB.x)*(locA.x - locB.x) + (locA.y - locB.y) * (locA.y - locB.y));
//    
//    if(distance<1){
//        [self erasePixelAtLoc:locB];
//        return;
//    }
//    
//    if(locA.x > locB.x){
//        CGPoint temp = locA;
//        locA = locB;
//        locB = temp;
//    }
//    
//    CGFloat k = (locB.y - locA.y) / (locB.x - locA.x);
//    
//    //如果纵向比横向断点多，就沿x轴扫描确定y坐标
//    if(fabs(locA.x-locB.x) > fabs(locA.y-locB.y)){
//        for (int x=MIN(locA.x, locB.x); x<MAX(locA.x, locB.x); x++) {
//            int y = k * ( x - locA.x) + locA.y;
//            [self erasePixelAtLoc:CGPointMake(x, y)];
//            
//        }
//    }else{
//        for (int y=MIN(locA.y, locB.y); y<MAX(locB.y,locA.y); y++) {
//            int x = locA.x + (y - locA.y) / k;
//            [self erasePixelAtLoc:CGPointMake(x, y)];
//        }
//    }
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


//添加到那个里面。。。。
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
            [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }else{
            [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(y, x)]];
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
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my+y,mx+x)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my+x,mx+y)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my+y,mx-x)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my+x,mx-y)]];
        
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my-y,mx-x)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my-x,mx-y)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my-y,mx+x)]];
        [_drawingPixels addObject:[NSValue valueWithCGPoint:CGPointMake(my-x,mx+y)]];
        if(d < 0){
            d = d+2*x+3;
        }else{
            d=d+2*(x-y)+5;
            y--;
        }
        x++;
    }
    
}

//将正在处理中的像素点保存到画布中
-(void)submitDrawingPixels
{
    if ([_drawingPixels count] != 0) {
        for (NSValue *value in _drawingPixels ) {
            CGPoint loc = [value CGPointValue];
            [self drawPixelAtLoc:CGPointMake(loc.y, loc.x)];
        }
    }
    [_drawingPixels removeAllObjects];
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
    //todododods
    if([self.adapter move:move]){
        [self setNeedsDisplay];
    }
}


-(void)fillUpWithLoc:(CGPoint)loc
{
    int row = loc.y;
    int col = loc.x;
    UIColor *c = [self.adapter colorWithLoc:CGPointMake(row, col)];
    if(!c){
        c = self.bgColor;
    }
    if (CGColorEqualToColor(c.CGColor, self.slectedColor.CGColor)) {
        return;
    }
    
    [self fillUp:row andCol:col andColor:c];
    [self setNeedsDisplay];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //填充所有颜色和选中方块一样的
//        [self fillUp:row andCol:col andColor:c];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self setNeedsDisplay];
//        });
//    });
}

-(void)fillUp:(int)row andCol:(int)col andColor:(UIColor*)color;
{
    //    NSLog(@"++++%d %d",row,col);
    //越界不搜索
    if (col<0 || row<0 || col>=_size || row >=_size) {
        return;
    }
    
    UIColor *c = [self.adapter colorWithLoc:CGPointMake(row, col)];
    if(!c){
        c = self.bgColor;
    }
    
    //和选中的颜色一样,填充成画笔颜色
    if (CGColorEqualToColor(c.CGColor, color.CGColor)) {
        [self.adapter replaceAtLoc:CGPointMake(row, col) Withcolor:self.slectedColor];
    }else{
        return;
    }
    
    [self fillUp:row-1 andCol:col andColor:c];//up
    [self fillUp:row+1 andCol:col andColor:c];//down
    [self fillUp:row andCol:col+1 andColor:c];//right
    [self fillUp:row andCol:col-1 andColor:c];//left
    
    return;
}


-(void)erasePixelAtLoc:(CGPoint)loc
{
    [self.adapter removeAtLoc:CGPointMake(loc.y, loc.x)];
}

// TODO: 翻转
-(void)flipHorizontal
{
    
}

-(void)flipVertical
{
    
}


//通知视图修改adapter....
-(void)setAdapter:(AYPixelAdapter *)adapter
{
    [super setAdapter:adapter];
    if ([self.delegate respondsToSelector:@selector(drawViewChangeAdapter:)]) {
        [self.delegate  drawViewChangeAdapter:adapter];
    }

}



@end
