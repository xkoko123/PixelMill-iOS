//
//  AYCanvas.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYPixelAdapter;

@interface AYCanvas : UIView{
    @protected
    CGFloat _pixelWidth;
    NSInteger _size;
    
    CAShapeLayer *_gridLayer;
    CAShapeLayer *_alignmentLineLayer;

}

- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size;

-(instancetype)initWithSize:(NSInteger)size;
-(instancetype)initWithFrame:(CGRect)fram andAdapter:(AYPixelAdapter*)adapter;
//- (instancetype)initWithFrame:(CGRect)frame andPixelsManage:(AYPixelsManage*)pm;

@property (nonatomic,strong) AYPixelAdapter *adapter;
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,assign)CGFloat pixelWidth;
@property (nonatomic,assign)NSInteger size;
@property (nonatomic,assign) BOOL showExtendedContent;

@property (nonatomic,assign) BOOL showGrid;
@property (nonatomic,assign) BOOL showAlignmentLine;

@property (nonatomic, assign) BOOL layerBlendMode;
@property (nonatomic, weak) NSMutableArray *layerAdapters;

+(CGFloat)getAdjustedWidthWithWidth:(CGFloat)width andSize:(NSInteger)size;


- (UIImage*)exportImage;
@end

