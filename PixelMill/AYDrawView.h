//
//  AYDrawView.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCanvas.h"

@class AYPixelAdapter;

@protocol AYDrawViewDelegate <NSObject>

@optional

-(void)drawViewChangeAdapter:(AYPixelAdapter*)adapter;
-(void)drawViewChangeAdapters:(NSMutableArray*)adapters;

@end

@interface AYDrawView : AYCanvas


@property (nonatomic, assign) int maxUndoQueueCount;
@property (nonatomic, strong) UIColor *slectedColor;


@property (nonatomic,assign)id delegate;


- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size;

-(instancetype)initWithSize:(NSInteger)size;

-(CGPoint)locationWithPoint:(CGPoint)point;

-(void)drawPixelAtLoc:(CGPoint)loc;

-(void)erasePixelAtLoc:(CGPoint)loc;

-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;

-(void)eraseLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;

-(void)move:(NSUInteger)move;

-(void)clearCanvas;

-(void)fillUpWithLoc:(CGPoint)loc;


-(void)pushToUndoQueue;

-(void)undo;

-(void)redo;

-(void)clearUndoRedo;
@end
