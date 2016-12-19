//
//  AYBoardCanvas.h
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//  负责画板的读取显示功能

#import <UIKit/UIKit.h>
@class AYPixelsManage;

@interface AYBoardCanvas : UIView{
    @protected
    CGFloat _pixelWidth;
    int _size;
    CAShapeLayer *_gridLayer;
    CAShapeLayer *_alignmentLineLayer;
}
- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size;
//- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size andPixels:(AYPixelsArray*)pixels;
- (instancetype)initWithFrame:(CGRect)frame andPixelsManage:(AYPixelsManage*)pm;


@property (nonatomic,strong) AYPixelsManage *pixelsManage;
@property (nonatomic,assign) int bgColor;
@property (nonatomic,assign) BOOL showGrid;
@property (nonatomic,assign) BOOL showAlignmentLine;
@property (nonatomic,assign) BOOL showExtendedContent;

- (UIImage*)exportImage;
@end
