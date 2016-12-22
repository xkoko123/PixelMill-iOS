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
    
}

-(instancetype)initWithSize:(int)size
{
    self = [super init];
    if(self){
        _size = size;
        _dict = [[NSMutableDictionary alloc] init];
        _origin = CGPointZero;
        _defaultColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _visible = YES;
    }
    return self;
}

-(instancetype)initWithString:(NSString*)string
{
    self = [super init];
    if(self){
        NSArray *splitArray = [string componentsSeparatedByString:@"@"];
        
        int size = [[splitArray objectAtIndex:0] intValue];
        _size = size;
        _dict = [[NSMutableDictionary alloc] init];
        _origin = CGPointZero;
        _visible = YES;
        
        for (int i=0;i<[splitArray count] -1 ; i++) {
            NSInteger color = [[splitArray objectAtIndex: i+1] integerValue];
            int row = i / size;
            int col = i % size;
            [self replaceAtLoc:CGPointMake(row, col) Withcolor:[UIColor colorWithInt:color]];
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
    loc = CGPointMake(loc.y + _origin.y,loc.x + _origin.x);
    NSValue *key = [NSValue valueWithCGPoint:loc];
    return key;
}

- (UIColor*)colorWithLoc:(CGPoint)loc
{
    NSValue *key = [self keyForLoc:loc];
    
    UIColor *c = [_dict objectForKey:key];
    return c;
}

- (void)replaceAtLoc:(CGPoint)loc Withcolor:(UIColor*)color;
{
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



-(BOOL)validateOrigin:(CGPoint)origin
{
    //上移／／左移
    if (origin.y<1-_size || origin.x<1-_size) {
        return NO;
    }
    
    if(origin.y > _size-1 || origin.x >_size-1){
        return NO;
    }
    
    return YES;
}

//移动画布内容，返回是否成功
- (BOOL)move:(MOVE)move
{
    NSLog(@"move");
    CGPoint movedOrigin;
    switch (move) {
        case MOVE_UP:
        {
            movedOrigin = CGPointMake(_origin.x + 1, _origin.y);
        }
            break;
        case MOVE_DOWN:
        {
            movedOrigin = CGPointMake(_origin.x -1, _origin.y);
        }
            break;
        case MOVE_RIGHT:
        {
            movedOrigin = CGPointMake(_origin.x, _origin.y - 1);
        }
            break;
        case MOVE_LEFT:
        {
            movedOrigin = CGPointMake(_origin.x, _origin.y + 1);
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
- (void)removeAtLoc:(CGPoint)loc
{
    [_dict removeObjectForKey:[self keyForLoc:loc]];
}


- (NSString*)getStringData
{
    NSString *s = [NSString stringWithFormat:@"%d",_size];
    
    for (int row=0; row < _size;  row++) {
        for (int col=0; col < _size;  col++) {
            CGPoint loc = CGPointMake(row, col);
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

-(UIColor *)colorWithKey:(NSValue *)key
{
    CGPoint loc = [key CGPointValue];
    //row loc.x
    //col loc.y
    return [self colorWithLoc:CGPointMake(loc.y - _origin.x, loc.x - _origin.y)];
}

- (CGPoint)locWithKey:(NSValue*)key;
{
    CGPoint loc = [key CGPointValue];
//    NSLog(@"%f   %f",loc.x,loc.y);
    //x lie y han
    return CGPointMake(loc.y - _origin.x, loc.x - _origin.y);
}
@end
