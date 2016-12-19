//
//  AYBaseCanvasView.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseCanvasView.h"
#import "UIColor+colorWithInt.h"

@implementation AYBaseCanvasView
{
    int _size; //像素格数
    NSMutableArray *_data; // 默认 0xffffff
    UIBezierPath *_gridPath;
    UIBezierPath *_centerLinePath;
    NSMutableArray *_undoQueue;
    NSMutableArray *_redoQueue;
}

- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size pallets:(NSArray*)pallets
{
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _size = size;
//        _palletArray = pallets;
        _pixelWidth = self.frame.size.width / size;
        _currentColor = 0;
        _maxUndoQueueCount = 20;
        _showCenterLine = NO;
        _showGrid = YES;
        _backgroundColor = 0xffffff;
        
        _data = [[NSMutableArray alloc] init];
        [self resetPaintData];
        
        _undoQueue = [[NSMutableArray alloc] init];
        _redoQueue = [[NSMutableArray alloc] init];
        
        
        [self initGridPath];
        [self initCenterLine];

        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self drawPaint];
    if(self.showGrid){
        [self drawGrid];
    }
    if(self.showCenterLine){
        [self drawCenterLine];
    }
}

-(void)resetPaintData
{
    [_data removeAllObjects];
    for (int i=0; i<_size*_size; i++) {
        [_data addObject:@(self.backgroundColor)];
    }
}


#pragma mark - DRAW
-(void)initCenterLine
{
    _centerLinePath = [UIBezierPath bezierPath];
    _centerLinePath.lineWidth = 2;
    [_centerLinePath moveToPoint:CGPointMake(_size/2 * _pixelWidth, 0)];
    [_centerLinePath addLineToPoint:CGPointMake(_size/2 * _pixelWidth, self.frame.size.width)];
    [_centerLinePath moveToPoint:CGPointMake(0, _size/2 * _pixelWidth)];
    [_centerLinePath addLineToPoint:CGPointMake(self.frame.size.width, _size/2 * _pixelWidth)];

}

-(void)drawCenterLine
{
    [[UIColor blackColor] setStroke];
    [_centerLinePath stroke];
}

-(void) initGridPath
{
    _gridPath = [UIBezierPath bezierPath];
    
    for (int i=0; i<=_size; i++) {
        [_gridPath moveToPoint:CGPointMake(0, _pixelWidth * i)];
        [_gridPath addLineToPoint:CGPointMake(self.frame.size.width, _pixelWidth * i)];
    }
    
    for (int i=0; i<=_size; i++) {
        [_gridPath moveToPoint:CGPointMake(_pixelWidth * i, 0)];
        [_gridPath addLineToPoint:CGPointMake(_pixelWidth * i, self.frame.size.width)];
    }
    _gridPath.lineWidth = 0.5;
}

-(void)drawGrid
{
    [[UIColor blackColor] setStroke];
    [_gridPath stroke];
}

-(void)drawPaint
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i=0; i< _data.count; i++) {
        int pixel_data = [_data[i] intValue];
        
        
//        if(pixel_data == 0){//默认值
//            [self.backgroundColor setFill];
//        }else{
//        }
        [[UIColor colorWithInt:pixel_data] setFill];

        
        
        CGPoint loc = [self getLocationFromIndex:i];
        CGRect pixelRect = CGRectMake(loc.x*_pixelWidth,
                                      loc.y*_pixelWidth,
                                      _pixelWidth,
                                      _pixelWidth);
        CGContextAddRect(ctx, pixelRect);
        CGContextFillPath(ctx);
    }
}

-(void)fillPixelAtLoc:(CGPoint)loc
{
    //不知道为什么Touch事件有很小的几率坐标会超出View
    if(loc.x > _size -1 ||
       loc.x < 0 ||
       loc.y > _size -1 ||
       loc.y < 0 ){
        return;
    }
    int index = [self getIndexFromLoc:loc];
    _data[index] = @(_currentColor);
//    NSLog(@"%f %f", loc.x, loc.y);
}

-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    CGFloat distance = sqrt((locA.x - locB.x)*(locA.x - locB.x) + (locA.y - locB.y) * (locA.y - locB.y));
    if(distance<1){
        [self fillPixelAtLoc:locB];
        return;
    }
    
    if(locA.x > locB.x){
        CGPoint temp = locA;
        locA = locB;
        locB = temp;
    }
    
    CGFloat k = (locB.y - locA.y) / (locB.x - locA.x);
    
    //如果纵向比横向断点多，就沿x轴扫描确定y坐标
    if(fabs(locA.x-locB.x) > fabs(locA.y-locB.y)){
        for (int x=MIN(locA.x, locB.x); x<MAX(locA.x, locB.x); x++) {
            int y = k * ( x - locA.x) + locA.y;
            [self fillPixelAtLoc:CGPointMake(x, y)];
            
        }
    }else{
        for (int y=MIN(locA.y, locB.y); y<MAX(locB.y,locA.y); y++) {
            int x = locA.x + (y - locA.y) / k;
            [self fillPixelAtLoc:CGPointMake(x, y)];
        }
    }
    
}


#pragma mark - 坐标
-(CGPoint)getLocationFromIndex:(int)index
{
    int row = index / _size;
    int col = index % _size;
    return CGPointMake(col, row);
}

-(CGPoint)getLocationFromPoint:(CGPoint)point
{
    int row = point.y / _pixelWidth;
    int col = point.x / _pixelWidth;
    return CGPointMake(col, row);
}

-(int)getIndexFromLoc:(CGPoint)loc
{
    return loc.y * _size + loc.x;
}


-(NSString*)getPaintData
{
    return @"";
}

-(void)getDataArrayFrom:(NSString*)s
{
    
}





-(void)selectColor:(int)color{
    self.currentColor = color;
}

-(void)pushToUndoQueue
{
    if (_undoQueue.count > self.maxUndoQueueCount) {
        [_undoQueue removeObjectAtIndex:0];
    }
    [_undoQueue addObject:[_data mutableCopy]];
}

-(void)undo
{
    if ([_undoQueue count] >0) {
        [self pushToRedoQueue];
        _data = [_undoQueue lastObject];
        [_undoQueue removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)pushToRedoQueue
{
    if (_redoQueue.count > self.maxUndoQueueCount) {
        [_redoQueue removeObjectAtIndex:0];
    }
    [_redoQueue addObject:[_data mutableCopy]];
}

-(void)redo
{
    if ([_redoQueue count] >0) {
        [self pushToUndoQueue];
        _data = [_redoQueue lastObject];
        [_redoQueue removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)clearCanvas
{
    [self pushToUndoQueue];
    [self resetPaintData];
    [self setNeedsDisplay];
}

- (void)moveCanvas:(MOVE)move
{
    [self pushToUndoQueue];
    switch (move) {
        case MOVECANVAS_UP:
        {
            [_data removeObjectsInRange:NSMakeRange(0, _size)];
            for (int i=0; i<_size; i++) {
                [_data addObject:@(self.backgroundColor)];
            }
        }
            break;
        case MOVECANVAS_DOWN:
        {
            for (int i=0; i<_size; i++) {
                [_data insertObject:@(self.backgroundColor) atIndex:0];
            }
            [_data removeObjectsInRange:NSMakeRange(_size * _size, _size)];
        }
            break;
        case MOVECANVAS_RIGHT:
        {
            for (int i=0; i<_size; i++) {
                [_data removeObjectAtIndex:_size * (i+1) -1];
                [_data insertObject:@(self.backgroundColor) atIndex: i * _size ];
            }
        }
            break;
        case MOVECANVAS_LEFT:
        {
            for (int i=0; i<_size; i++) {
                
                [_data removeObjectAtIndex:i*_size];
                [_data insertObject:@(self.backgroundColor) atIndex:_size * (i+1) -1];
            }
        }
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
}

-(void)fillUpLoc:(CGPoint)loc
{
    int row = loc.y;
    int col = loc.x;
    int c = [[_data objectAtIndex:row*_size + col] intValue];
    if (c == self.currentColor) {
        return;
    }
    [self pushToUndoQueue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fillUp:row andCol:col andColor:c];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

-(void)fillUp:(int)row andCol:(int)col andColor:(int)color;
{
//    NSLog(@"++++%d %d",row,col);
    //越界不搜索
    if (col<0 || row<0 || col>=_size || row >=_size) {
        return;
    }
    
    int c = [[_data objectAtIndex:row*_size + col] intValue];
    
    
    //和选中的颜色一样,填充成画笔颜色
    if (c == color) {
        [_data replaceObjectAtIndex:row*_size + col withObject:[NSNumber numberWithInt:self.currentColor]];
    }else{
        return;
    }
    
    [self fillUp:row-1 andCol:col andColor:c];//up
    [self fillUp:row+1 andCol:col andColor:c];//down
    [self fillUp:row andCol:col+1 andColor:c];//right
    [self fillUp:row andCol:col-1 andColor:c];//left
    
    return;
}


- (void) setShowGrid:(BOOL)showGrid
{
    _showGrid = showGrid;
    [self setNeedsDisplay];
}

-(void) setShowCenterLine:(BOOL)showCenterLine
{
    _showCenterLine = showCenterLine;
    [self setNeedsDisplay];
}


-(NSString *)getData
{
    NSString *s = [[NSString alloc] init];
    for (int i=0; i<_data.count; i++) {
        int data = [[_data objectAtIndex:i] intValue];
        if(i==0){
            s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",data]];
        }else{
            s = [s stringByAppendingString:[NSString stringWithFormat:@"@%d",data]];
        }
    }
    NSLog(@"===%@",s);
    return s;
}

@end
