//
//  AYPixelAdapter.m
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYPixelAdapter.h"
#import "UIColor+colorWithInt.h"
@interface AYPixelAdapter()<NSCopying>



@end
@implementation AYPixelAdapter
{
    
    CGPoint _origin;
    NSMutableArray *_undoQueue;
    NSMutableArray *_redoQueue;

    
}

-(instancetype)initWithSize:(NSInteger)size
{
    self = [super init];
    if(self){
        _size = size;
        _dict = [[NSMutableDictionary alloc] init];
        _origin = CGPointZero;
        _maxUndoQueueCount = 10;

        _defaultColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _visible = YES;
        _undoQueue = [[NSMutableArray alloc] init];
        _redoQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithString:(NSString*)string
{
    self = [super init];
    if(self){
        NSArray *splitArray = [string componentsSeparatedByString:@"@"];
        
        _maxUndoQueueCount = 20;
        int size = [[splitArray objectAtIndex:0] intValue];
        _size = size;
        _dict = [[NSMutableDictionary alloc] init];
        _origin = CGPointZero;
        _visible = YES;
        
        _undoQueue = [[NSMutableArray alloc] init];
        _redoQueue = [[NSMutableArray alloc] init];

        
        for (int i=0;i<[splitArray count] -1 ; i++) {
            NSInteger color = [[splitArray objectAtIndex: i+1] integerValue];
            int y = i / size;
            int x = i % size;
            [self replaceAtLoc:CGPointMake(x, y) Withcolor:[UIColor colorWithInt:color]];
        }
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    AYPixelAdapter *pa = [[[self class] allocWithZone:zone] init];
    pa.size = _size;
    pa->_origin = _origin;
    pa.defaultColor = self.defaultColor;
    
    NSMutableDictionary *dm = [[NSMutableDictionary alloc] init];
    for (NSValue *v in [_dict allKeys]) {
        UIColor *c = [_dict objectForKey:v];
        UIColor *x = [UIColor colorWithInt:[c intData]];
        [dm setObject:x forKey:v];
    }
    pa->_dict = dm;
    
    return pa;
}

- (NSValue*)keyForLoc:(CGPoint)loc// row  col
{
    int y = (int)(loc.y + _origin.y + _size) % _size;
    int x = (int)(loc.x + _origin.x + _size) % _size;
    loc = CGPointMake(x, y);
    NSValue *key = [NSValue valueWithCGPoint:loc];
    return key;
}

- (UIColor*)colorWithLoc:(CGPoint)loc
{
    NSValue *key = [self keyForLoc:loc];
    UIColor *c = [_dict objectForKey:key];
    return c;
}

-(UIColor *)colorWithKey:(NSValue *)key
{
    CGPoint loc = [key CGPointValue];
    return [self colorWithLoc:CGPointMake((int)(-_origin.x + _size + loc.x) % _size, (int)(-_origin.y + _size + loc.y) % _size)];
}


- (CGPoint)locWithKey:(NSValue*)key;
{
    CGPoint loc = [key CGPointValue];
    return CGPointMake((int)(-_origin.x + _size + loc.x) % _size, (int)(-_origin.y + _size + loc.y) % _size);
}


- (void)replaceAtLoc:(CGPoint)loc Withcolor:(UIColor*)color;
{
    if(loc.x > _size -1 ||
       loc.x < 0 ||
       loc.y > _size -1 ||
       loc.y < 0 ){
        return;
    }
    NSValue *key = [self keyForLoc:loc];
    
    [_dict setObject:color forKey:key];
}


- (void)reset
{
    [_dict removeAllObjects];
    [self resetOrigin];
}

- (void)resetOrigin
{
    _origin = CGPointZero;
}


//最开始画布可以移动出空白区域的方式需要这个有效判断函数，，现在循环移动了啊啊啊啊啊啊
//-(BOOL)validateOrigin:(CGPoint)origin
//{
//    //上移／／左移
//    if (origin.y<1-_size || origin.x<1-_size) {
//        return NO;
//    }
//    
//    if(origin.y > _size-1 || origin.x >_size-1){
//        return NO;
//    }
//    
//    return YES;
//}

//移动画布内容，返回是否成功
- (BOOL)move:(MOVE)move
{
    switch (move) {
        case MOVE_UP:
        {
            _origin = CGPointMake((int)(_origin.x + _size) % _size, (int)(_origin.y + 1 + _size) % _size);
        }
            break;
        case MOVE_DOWN:
        {
            _origin = CGPointMake((int)(_origin.x + _size) % _size, (int)(_origin.y - 1 + _size) % _size);
        }
            break;
        case MOVE_RIGHT:
        {
            _origin = CGPointMake((int)(_origin.x - 1 + _size) % _size, (int)(_origin.y + _size) % _size);
        }
            break;
        case MOVE_LEFT:
        {
            _origin = CGPointMake((int)(_origin.x + 1 + _size) % _size, (int)(_origin.y + _size) % _size);
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)removeAtLoc:(CGPoint)loc
{
    [_dict removeObjectForKey:[self keyForLoc:loc]];
}

- (NSString*)getStringData
{
    NSString *s = [NSString stringWithFormat:@"%ld",_size];
    
    for (int y=0; y < _size;  y++) {
        for (int x=0; x < _size;  x++) {
            CGPoint loc = CGPointMake(x, y);
            UIColor *color = [self colorWithLoc:loc];
            NSInteger data;
            if (color) {
                data = [color intData];
            }else{
                data = [self.defaultColor intData];
            }
            s = [s stringByAppendingString:[NSString stringWithFormat:@"@%ld",data]];
        }
    }
    return s;
}


//undo redo
-(void)pushToUndoQueue
{
    if (_undoQueue.count > self.maxUndoQueueCount) {
        [_undoQueue removeObjectAtIndex:0];
    }
    
    
    [_undoQueue addObject:[_dict mutableCopy]];
}

-(void)undo
{
    if ([_undoQueue count] >0) {
        [self pushToRedoQueue];
        _dict = [_undoQueue lastObject];
        
        [_undoQueue removeLastObject];
    }
}


-(void)pushToRedoQueue
{
    if (_redoQueue.count > self.maxUndoQueueCount) {
        [_redoQueue removeObjectAtIndex:0];
    }
//    NSMutableDictionary *dm = [[NSMutableDictionary alloc] init];
//    for (NSValue *v in [_dict allKeys]) {
//        UIColor *c = [_dict objectForKey:v];
//        UIColor *x = [UIColor colorWithInt:[c intData]];
//        [dm setObject:x forKey:v];
//    }

    
    [_redoQueue addObject:[_dict mutableCopy]];
}

-(void)redo
{
    if ([_redoQueue count] >0) {
        [self pushToUndoQueue];
        _dict = [_redoQueue lastObject];
        [_redoQueue removeLastObject];
        //        [self setNeedsDisplay];
    }
}

+(AYPixelAdapter *)getBlendAdapter:(NSArray *)arrays withSize:(NSInteger)size
{
    AYPixelAdapter *adapter = [[AYPixelAdapter alloc] initWithSize:size];
    for (int y=0; y<size; y++) {
        for (int x=0; x<size; x++) {
            UIColor *topColor = nil;
            //从顶层向下扫
            for (NSInteger i=0; i<arrays.count; i++) {
                AYPixelAdapter *adapter = [arrays objectAtIndex:i];
                if (adapter.visible == NO){
                    continue;
                }
                UIColor *color = [adapter colorWithLoc:CGPointMake(x, y)];//最上面的数据
                
                if (color == nil) {
                    continue;
                }
                
                if (topColor == nil) {
                    topColor = color;
                }else{
                    topColor = [UIColor blendBgColor:color andFrontColor:topColor];
                }
                
                if ([color getAlpha] ==  1) {//遇到不透明的颜色后，，它下面的就不用混和了
                    break;
                }
            }
            if (topColor){
                [adapter replaceAtLoc:CGPointMake(x, y) Withcolor:topColor];
            }
        }
    }
    return adapter;
}

@end
