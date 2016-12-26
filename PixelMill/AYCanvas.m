//
//  AYCanvas.m
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AYCanvas.h"
#import "AYPixelAdapter.h"
#import "UIColor+colorWithInt.h"

@implementation AYCanvas
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame andSize:(int)size
{
    self = [super init];
    if (self) {
        self.frame = frame;
    }
    return self;
}


-(instancetype)initWithSize:(NSInteger)size
{
    self = [super init];
    if (self) {
        self.layer.drawsAsynchronously = YES;
        self.layerBlendMode = NO;
        _bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.adapter = [[AYPixelAdapter alloc] initWithSize:size];
        
        _showGrid = NO;
        _showAlignmentLine = NO;
        
        _showExtendedContent = YES;
        _gridLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_gridLayer];
        [self resetGridLayer];

    }
    return self;
}

-(void)setAdapter:(AYPixelAdapter *)adapter
{
    
    _adapter = adapter;
    _size = adapter.size;
    self.pixelWidth = self.frame.size.width / _size;
    [self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.pixelWidth = frame.size.width / _size;
    [self resetGridLayer];
    [self setNeedsDisplay];
}


-(void) resetGridLayer
{
    _gridLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _gridLayer.lineWidth = 0.5;
    _gridLayer.strokeColor = [UIColor grayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.showGrid) {
        for (int i=0; i<=_size; i++) {
            [path moveToPoint:CGPointMake(0, _pixelWidth * i)];
            [path addLineToPoint:CGPointMake(self.frame.size.width, _pixelWidth * i)];
        }
        
        for (int i=0; i<=_size; i++) {
            [path moveToPoint:CGPointMake(_pixelWidth * i, 0)];
            [path addLineToPoint:CGPointMake(_pixelWidth * i, self.frame.size.width)];
        }
    }
    
    if (self.showAlignmentLine) {
        [path moveToPoint:CGPointMake(_size/2 * _pixelWidth, 0)];
        [path addLineToPoint:CGPointMake(_size/2 * _pixelWidth, self.frame.size.width)];
        [path moveToPoint:CGPointMake(0, _size/2 * _pixelWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, _size/2 * _pixelWidth)];
    }
    
    _gridLayer.path = [path CGPath];
}


-(void)drawRect:(CGRect)rect
{
    [self drawContent];
    if (!self.showExtendedContent) {
        return;
    }
}

-(void)drawContent
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, NO);
//    for (int row=0; row<_size; row++) {
//        for (int col=0; col<_size; col++) {
//            UIColor *color = [self.adapter colorWithLoc:CGPointMake(row, col)];
//            if (color) {
//                NSLog(@"sadsa");
//                [color setFill];
//            }else{
//                [self.bgColor setFill];
//            }
//            CGRect pixelRect = CGRectMake(col * _pixelWidth,
//                                          row * _pixelWidth,
//                                          _pixelWidth+0.5,
//                                          _pixelWidth+0.5);
//            CGContextAddRect(ctx, pixelRect);
//            CGContextFillPath(ctx);
//        }
//    }
    
    if (!self.layerBlendMode) {
        for (NSValue *key in [self.adapter.dict allKeys] ) {
            UIColor *color = [self.adapter colorWithKey:key];
            CGPoint loc = [self.adapter locWithKey:key];
            
            if (color) {
                [color setFill];
            }else{
                [self.bgColor setFill];
            }

            
            CGRect pixelRect = CGRectMake(loc.x * _pixelWidth,
                                          loc.y * _pixelWidth,
                                          _pixelWidth,
                                          _pixelWidth);
            CGContextAddRect(ctx, pixelRect);
            CGContextFillPath(ctx);
        }
    }else{


        for (int y=0; y<_size; y++) {
            for (int x=0; x<_size; x++) {
                UIColor *topColor = nil;
                //从顶层向下扫
                for (NSInteger i=0; i<self.layerAdapters.count; i++) {
                    AYPixelAdapter *adapter = [self.layerAdapters objectAtIndex:i];
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
                
                
                
                if (topColor) {
                    [topColor setFill];
                }else{
                    [self.bgColor setFill];
                }
                
                CGRect pixelRect = CGRectMake(x * _pixelWidth,
                                              y * _pixelWidth,
                                              _pixelWidth,
                                              _pixelWidth);
                CGContextAddRect(ctx, pixelRect);
                CGContextFillPath(ctx);
            }
        }
        
    }

}

-(void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    [self setNeedsDisplay];
}

-(void)setShowGrid:(BOOL)showGrid
{
    _showGrid = showGrid;
    [self resetGridLayer];
}

-(void) setShowAlignmentLine:(BOOL)showAlignmentLine
{
    _showAlignmentLine = showAlignmentLine;
    [self resetGridLayer];
    
}


- (UIImage*)exportImage
{
    self.showExtendedContent = NO;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.showExtendedContent = YES;
    return image;
}

-(void)setShowExtendedContent:(BOOL)showExtendedContent
{
    _showExtendedContent = showExtendedContent;
    _gridLayer.hidden = !showExtendedContent;
    [self setNeedsDisplay];
}


-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    self.pixelWidth = self.frame.size.width / _size;
    [self resetGridLayer];
    [self setNeedsDisplay];

}

//-(void)setPixelWidth:(CGFloat)pixelWidth
//{
//    _pixelWidth = ceil(pixelWidth);
//}

@end
