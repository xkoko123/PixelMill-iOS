//
//  AYBaseCanvasView.h
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    MOVECANVAS_UP,
    MOVECANVAS_DOWN,
    MOVECANVAS_LEFT,
    MOVECANVAS_RIGHT,
}MOVE;
@interface AYBaseCanvasView : UIView
//@property (nonatomic, strong) NSArray *palletArray;
@property (nonatomic, assign) int currentColor;
@property (nonatomic, assign) int maxUndoQueueCount;
@property (nonatomic, assign) CGFloat pixelWidth;
@property (nonatomic, assign) BOOL showGrid;
@property (nonatomic, assign) BOOL showCenterLine;
@property (nonatomic, assign) int backgroundColor;

- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size pallets:(NSArray*)pallets;

-(void)drawGrid;
-(void)drawPaint;

-(CGPoint)getLocationFromPoint:(CGPoint)point;//屏幕坐标转换成画布坐标
-(void)fillPixelAtLoc:(CGPoint)loc;//在指定画布坐标填充
-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;//填充两个画布坐标连线经过的像素，快速滑动需要用。。。

-(void)clearCanvas;

-(void)pushToUndoQueue;

- (NSString*)getPaintData;

- (void)selectColor:(int)color;
- (void)undo;
-(void)redo;

- (void)moveCanvas:(MOVE)move;

-(void)fillUpLoc:(CGPoint)loc;



-(NSString*) getData;

@end
