//
//  AYBoardCanvas.m
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBoardCanvas.h"
#import "UIColor+colorWithInt.h"
#import "AYPixelsManage.h"
@implementation AYBoardCanvas

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.drawsAsynchronously = YES;
        
        _bgColor = 0xFFFFFF;
        
        self.pixelsManage = [[AYPixelsManage alloc] initWithSize:size];

        _showGrid = YES;
        _showAlignmentLine = NO;

        
        _gridLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_gridLayer];
        [self resetGridLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andPixelsManage:(AYPixelsManage*)pm
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.drawsAsynchronously = YES;
        
        _bgColor = 0xFFFFFF;
        
        self.pixelsManage = pm;
        
        _showGrid = YES;
        _showAlignmentLine = NO;
        
        _gridLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_gridLayer];
        [self resetGridLayer];

    }
    return self;
}

-(void)setPixelsManage:(AYPixelsManage *)pixelsManage
{
    _pixelsManage = pixelsManage;
    _size = pixelsManage.size;
    _pixelWidth = self.frame.size.width / _size;
    [self setNeedsDisplay];
}

//- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size andPixels:(NSArray*)pixels
//{
//    self = [self initWithFrame:frame ansSize:size];
//    if (self) {
//        _pixels = [pixels mutableCopy];
//    }
//    return self;
//}


-(void)drawRect:(CGRect)rect
{
    [self drawContent];
}

-(void) resetGridLayer
{
    _gridLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _gridLayer.lineWidth = 0.5;
    _gridLayer.strokeColor = [UIColor blackColor].CGColor;
    
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

-(void)drawContent
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<_size; i++) {
        for (int j=0; j<_size; j++) {
            int pixel_data = [[_pixelsManage objectAtRow:i Col:j] intValue];

            if (pixel_data == -1) {
                [[UIColor colorWithInt:self.bgColor] setFill];
            }else{
                [[UIColor colorWithInt:pixel_data] setFill];
            }
            CGRect pixelRect = CGRectMake(j * _pixelWidth,
                                          i * _pixelWidth,
                                          _pixelWidth,
                                          _pixelWidth);
            CGContextAddRect(ctx, pixelRect);
            CGContextFillPath(ctx);
        }
    }
}

-(void)setBgColor:(int)bgColor
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
    _gridLayer.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _gridLayer.hidden = NO;
    return image;
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
}


@end
