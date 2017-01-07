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

@interface AYCanvas()


@end

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
        _bgColor = [UIColor whiteColor];
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

-(instancetype)initWithFrame:(CGRect)fram andAdapter:(AYPixelAdapter*)adapter
{
    self= [self initWithSize:adapter.size];
    if (self) {
        self.frame = fram;
        self.adapter = adapter;
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
    _gridLayer.strokeColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.showGrid) {
        for (int i=0; i<=_size; i++) {
            [path moveToPoint:CGPointMake(0, self.pixelWidth * i)];
            [path addLineToPoint:CGPointMake(self.frame.size.width, self.pixelWidth * i)];
        }
        
        for (int i=0; i<=_size; i++) {
            [path moveToPoint:CGPointMake(self.pixelWidth * i, 0)];
            [path addLineToPoint:CGPointMake(self.pixelWidth * i, self.frame.size.width)];
        }
    }
    
    if (self.showAlignmentLine) {
        [path moveToPoint:CGPointMake(_size/2 * self.pixelWidth, 0)];
        [path addLineToPoint:CGPointMake(_size/2 * self.pixelWidth, self.frame.size.width)];
        [path moveToPoint:CGPointMake(0, _size/2 * self.pixelWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, _size/2 * self.pixelWidth)];
    }
    
    _gridLayer.path = [path CGPath];
}


-(void)drawRect:(CGRect)rect
{   NSLog(@"%f %f",_pixelWidth,self.frame.size.width);
    [self drawContentWithRect:rect];
    if (!self.showExtendedContent) {
        return;
    }
}

-(void)pixelsWithRect:(CGRect)rect
{
    NSInteger originX = ceil(rect.origin.x / _pixelWidth);
    NSInteger originY = ceil(rect.origin.y / _pixelWidth);
    NSInteger col = ceil(rect.size.width / _pixelWidth);
    NSInteger row = ceil(rect.size.height / _pixelWidth);
}

-(void)drawContentWithRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, NO);
    
    //从rect中计算出需要更新的像素区域
    NSInteger originX = ceil(rect.origin.x / _pixelWidth);
    NSInteger originY = ceil(rect.origin.y / _pixelWidth);
    NSInteger col = floor(rect.size.width / _pixelWidth);
    NSInteger row = floor(rect.size.height / _pixelWidth);
    
    if (!self.layerBlendMode) {
        for (int y=0; y<_size; y++) {
            for (int x=0; x<_size; x++) {
                UIColor *color = [self.adapter colorWithLoc:CGPointMake(x, y)];
                if (color) {
                    [color setFill];
                    CGRect pixelRect = CGRectMake(x * self.pixelWidth,
                                                    y * self.pixelWidth,
                                                    self.pixelWidth,
                                                    self.pixelWidth);
                    CGContextAddRect(ctx, pixelRect);
                    CGContextFillPath(ctx);
                }
            }
        }
    }else{//图层模式的全部绘制
        for (NSInteger x = originX; x < originX + col; x++) {
            for (NSInteger y = originY; y<originY+row; y++) {
                CGPoint loc = CGPointMake(x, y);
                UIColor *topColor = nil;
                //从顶层向下扫
                for (NSInteger i=0; i<self.layerAdapters.count; i++) {
                    AYPixelAdapter *adapter = [self.layerAdapters objectAtIndex:i];
                    if (adapter.visible == NO){
                        continue;
                    }
                    UIColor *color = [adapter colorWithLoc:CGPointMake(loc.x, loc.y)];//最上面的数据
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
                
                //填充最顶上的颜色
                if (topColor) {
                    [topColor setFill];
                }else{
                    [self.bgColor setFill];
                }
                
                CGRect pixelRect = CGRectMake(loc.x * self.pixelWidth,
                                              loc.y * self.pixelWidth,
                                              self.pixelWidth,
                                              self.pixelWidth);
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

- (void)setShowExtendedContent:(BOOL)showExtendedContent
{
    _showExtendedContent = showExtendedContent;
    _gridLayer.hidden = !showExtendedContent;
    [self setNeedsDisplay];
}


- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    self.pixelWidth = self.frame.size.width / _size;
    [self resetGridLayer];
    [self setNeedsDisplay];

}

+(CGFloat)getAdjustedWidthWithWidth:(CGFloat)width andSize:(NSInteger)size
{
    CGFloat pixelWidth = [[NSString stringWithFormat:@"%.2f",width/size] floatValue];
//    CGFloat pixelWidth = floor(width/size);
    NSLog(@"---%f",pixelWidth);
    CGFloat viewWidth = pixelWidth * size;
    NSLog(@"---%f",viewWidth);
    return viewWidth;
}


@end
