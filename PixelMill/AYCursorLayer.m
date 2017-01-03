//
//  AYCursorLayer.m
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYCursorLayer.h"
#import "AYPublicHeader.h"
#import <UIKit/UIKit.h>
@implementation AYCursorLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.shadowColor = [UIColor lightGrayColor].CGColor;
        self.shadowOffset = CGSizeMake(1, 1);
        self.shadowOpacity = 0.7;
        
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"draw");
    CGContextSetShouldAntialias(ctx, YES);
    CGFloat width = self.bounds.size.width;
    switch (self.type) {
        case PEN:
        case LINE:
        case COPY:
        case CIRCLE:
        {
            
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, width, width / 2.5);
            CGContextAddLineToPoint(ctx, width / 2, width / 2);
            CGContextAddLineToPoint(ctx, width / 2.5, width);
            CGContextClosePath(ctx);
            
            CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);

            CGContextSetLineWidth(ctx, 1);
            CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
            CGContextDrawPath(ctx, kCGPathFillStroke);
        }
            break;
        case BUCKET:
        {
            CGContextDrawImage(ctx, CGRectMake(0, 0, width, width), [UIImage imageNamed:@"bucket"].CGImage);
        }
            break;
        case ERASER:
        {
            CGContextDrawImage(ctx, CGRectMake(0, 0, width, width), [UIImage imageNamed:@"eraser"].CGImage);

        }
            break;
        default:
            break;
    }
    
}


-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    NSLog(@"dasdas");
    [self setNeedsDisplay];
}

-(void)setType:(AYCursorDrawType)type
{
    _type = type;
    [self setNeedsDisplay];
}

@end
