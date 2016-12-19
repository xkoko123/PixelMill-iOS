//
//  AYDrawView.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCanvas.h"

@interface AYDrawView : AYCanvas


@property (nonatomic, assign) int maxUndoQueueCount;
@property (nonatomic, strong) UIColor *slectedColor;


- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size;


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
