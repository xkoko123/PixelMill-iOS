//
//  AYPixelsManage.m
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//


#import "AYPixelsManage.h"

@implementation AYPixelsManage
{
    NSMutableArray *_array;
}

-(instancetype)initWithSize:(int)size
{
    self = [[AYPixelsManage alloc] init];
    if (self) {
        _size = size;
        _origin = CGPointMake(size-1, size-1);
        _array = [[NSMutableArray alloc] init];
        _expandedSize = size * 3 - 2;
        
        int count = _expandedSize * _expandedSize;
        for (int i=0; i<count; i++) {
            [_array addObject:@(-1)];
        }
    }
    return self;
}

-(instancetype)initWithSize:(int)size String:(NSString *)string
{
    self = [[AYPixelsManage alloc] initWithSize:size];
    if (self) {
        NSArray *splitArray = [string componentsSeparatedByString:@"@"];
        for (int i=0; i<[splitArray count]; i++) {
            NSNumber *number = [splitArray objectAtIndex:i];
            int row = i / size;
            int col = i % size;
            [self replaceObjectAtRow:row Col:col WithObject:number];
        }
    }
    return self;
}


-(id)copyWithZone:(NSZone *)zone
{
    AYPixelsManage *pm = [[[self class] allocWithZone:zone] init];
    pm.size = self.size;
    pm.origin = self.origin;
    pm.expandedSize = self.expandedSize;
    pm->_array = [_array mutableCopy];
    return pm;
}


- (int)indexWithRow:(int)row Col:(int)col
{
    int r = row + self.origin.y;
    int c = col + self.origin.x;
    return r * _expandedSize + c;

}


- (id)objectAtRow:(int)row Col:(int)col
{
    int index = [self indexWithRow:row Col:col];
    return [_array objectAtIndex: index];
}

- (void)replaceObjectAtRow:(int)row Col:(int)col WithObject:(id)object
{
    int index = [self indexWithRow:row Col:col];
    [_array replaceObjectAtIndex:index withObject:object];
}

-(void)reset
{
    [_array removeAllObjects];
    int count = _expandedSize * _expandedSize;
    for (int i=0; i<count; i++) {
        [_array addObject:@(-1)];
    }
}

- (void)resetOrigin
{
    _origin = CGPointMake(_size-1, _size-1);
}

//检查指定origin是否越界
-(BOOL)validateOrigin:(CGPoint)origin
{
    //上移／／左移
    if (origin.y<0 || origin.x<0) {
        return NO;
    }
    
    if(origin.y > _expandedSize - _size || origin.x >_expandedSize - _size){
        return NO;
    }
    
    return YES;
}

//移动画布内容，返回是否成功
- (BOOL)move:(MOVE)move
{
    CGPoint movedOrigin;
    switch (move) {
        case MOVE_UP:
        {
            movedOrigin = CGPointMake(_origin.x, _origin.y - 1);
        }
            break;
        case MOVE_DOWN:
        {
            movedOrigin = CGPointMake(_origin.x, _origin.y + 1);
        }
            break;
        case MOVE_RIGHT:
        {
            movedOrigin = CGPointMake(_origin.x + 1, _origin.y);
        }
            break;
        case MOVE_LEFT:
        {
            movedOrigin = CGPointMake(_origin.x - 1, _origin.y);
        }
            break;
        default:
            break;
    }
    
    if([self validateOrigin:movedOrigin]){
        _origin = movedOrigin;
        return YES;
    }else{
        return NO;
    }
}

-(NSString*) exportData
{
    NSString *s = [[NSString alloc] init];
    for (int row=0; row<_size; row++) {
        for (int col=0; col<_size; col++) {
            int data = [[self objectAtRow:row Col:col] intValue];
            if(row == 0 && col == 0){
                s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",data]];
            }else{
                s = [s stringByAppendingString:[NSString stringWithFormat:@"@%d",data]];
            }
        }
    }
    NSLog(@"===%@",s);
    return s;
}


@end
