//
//  AYBaseDrawView.m
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseDrawView.h"
#import "AYPixelsManage.h"
#import "UIColor+colorWithInt.h"
@implementation AYBaseDrawView
{
    NSMutableArray *_undoQueue;
    NSMutableArray *_redoQueue;
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
        _maxUndoQueueCount = 20;
        _undoQueue = [[NSMutableArray alloc] init];
        _redoQueue = [[NSMutableArray alloc] init];
        //TODO : sfsf
        _slectedColor = 0xffe3f2;
    }
    return self;
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
    
    [self.pixelsManage replaceObjectAtRow:loc.y
                                      Col:loc.x
                               WithObject:@(self.slectedColor)
     ];
}

-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB
{
    CGFloat distance = sqrt((locA.x - locB.x)*(locA.x - locB.x) + (locA.y - locB.y) * (locA.y - locB.y));
    
    if(distance<1){
        [self drawPixelAtLoc:locB];
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
            [self drawPixelAtLoc:CGPointMake(x, y)];
            
        }
    }else{
        for (int y=MIN(locA.y, locB.y); y<MAX(locB.y,locA.y); y++) {
            int x = locA.x + (y - locA.y) / k;
            [self drawPixelAtLoc:CGPointMake(x, y)];
        }
    }
}


#pragma mark - 撤回

-(void)pushToUndoQueue
{
    if (_undoQueue.count > self.maxUndoQueueCount) {
        [_undoQueue removeObjectAtIndex:0];
    }
    [_undoQueue addObject:[self.pixelsManage copy]];
}

-(void)undo
{
    if ([_undoQueue count] >0) {
        [self pushToRedoQueue];
        self.pixelsManage = [_undoQueue lastObject];
        [_undoQueue removeLastObject];
//        [self setNeedsDisplay]; 加在setter中了
    }
}

-(void)pushToRedoQueue
{
    if (_redoQueue.count > self.maxUndoQueueCount) {
        [_redoQueue removeObjectAtIndex:0];
    }
    [_redoQueue addObject:[self.pixelsManage copy]];
}

-(void)redo
{
    if ([_redoQueue count] >0) {
        [self pushToUndoQueue];
        self.pixelsManage = [_redoQueue lastObject];
        [_redoQueue removeLastObject];
//        [self setNeedsDisplay];
    }
}

//清空
-(void)clearCanvas
{
    [self pushToUndoQueue];
    [self.pixelsManage reset];
    [self.pixelsManage resetOrigin];
    [self setNeedsDisplay];
}


- (void)move:(NSUInteger)move
{
    [self pushToUndoQueue];
    //todododods
    if([self.pixelsManage move:move]){
        [self setNeedsDisplay];
    }
    
}


-(void)fillUpWithLoc:(CGPoint)loc
{
    int row = loc.y;
    int col = loc.x;
    int c = [[self.pixelsManage objectAtRow:row Col:col] intValue];
    if (c == self.slectedColor) {
        return;
    }
    [self pushToUndoQueue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //填充所有颜色和选中方块一样的
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
    
    int c = [[self.pixelsManage objectAtRow:row Col:col] intValue];
    
    
    //和选中的颜色一样,填充成画笔颜色
    if (c == color) {
        [self.pixelsManage replaceObjectAtRow:row
                                          Col:col
                                   WithObject:[NSNumber numberWithInt:self.slectedColor]
         ];
    }else{
        return;
    }
    
    [self fillUp:row-1 andCol:col andColor:c];//up
    [self fillUp:row+1 andCol:col andColor:c];//down
    [self fillUp:row andCol:col+1 andColor:c];//right
    [self fillUp:row andCol:col-1 andColor:c];//left
    
    return;
}





@end
