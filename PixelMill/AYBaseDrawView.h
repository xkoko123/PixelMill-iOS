//
//  AYBaseDrawView.h
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//  实现了画图功能的接口，所有画图方式的父类

#import "AYBoardCanvas.h"

@interface AYBaseDrawView : AYBoardCanvas

@property (nonatomic, assign) int maxUndoQueueCount;
@property (nonatomic, assign) int slectedColor;


- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size;


-(CGPoint)locationWithPoint:(CGPoint)point;
-(void)drawPixelAtLoc:(CGPoint)loc;
-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;
-(void)move:(NSUInteger)move;
-(void)clearCanvas;
-(void)fillUpWithLoc:(CGPoint)loc;

-(void)pushToUndoQueue;
-(void)undo;
-(void)redo;
@end
