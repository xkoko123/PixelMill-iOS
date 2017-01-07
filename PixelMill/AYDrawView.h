//
//  AYDrawView.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCanvas.h"
#import "AYPublicHeader.h"
@class AYPixelAdapter;

@protocol AYDrawViewDelegate <NSObject>

@optional

-(void)drawViewChangeAdapter:(AYPixelAdapter*)adapter;
-(void)drawViewChangeAdapters:(NSMutableArray*)adapters;
-(void)drawViewHasRefreshContent;
-(void)pasteSlectPixels;


@end

@interface AYDrawView : AYCanvas

@property (nonatomic, assign) BOOL mirrorMode;
@property (nonatomic, assign) int maxUndoQueueCount;
@property (nonatomic, strong) UIColor *slectedColor;
@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, strong) NSMutableDictionary *slectedPixels;

@property (nonatomic, assign) AYCursorDrawType currentType;
@property (nonatomic, assign) AYCursorDrawType lastType;

@property (nonatomic, assign) BOOL isInPaste;

@property (nonatomic,assign)id delegate;


- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size;

-(instancetype)initWithSize:(NSInteger)size;

-(CGPoint)locationWithPoint:(CGPoint)point;

-(void)drawPixelAtLoc:(CGPoint)loc;

-(void)erasePixelAtLoc:(CGPoint)loc;

-(void)addLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;

-(void)eraseLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;

-(void)drawLineBetweenLoc:(CGPoint)locA and:(CGPoint)locB;

-(void)slectLineBetweenLoc:(CGPoint)locA and:(CGPoint)loc;

-(void)move:(NSUInteger)move;

-(void)clearCanvas;

-(void)fillUpWithLoc:(CGPoint)loc;


-(void)pushToUndoQueue;

-(void)undo;

-(void)redo;

-(void)clearUndoRedo;

-(void)submitDrawingPixels;


-(void)drawCircleAtLoc:(CGPoint)a toLoc:(CGPoint)b;

-(void)drawCircleAtLoc:(CGPoint)point withR:(int)r;

-(void)flipHorizontal;

-(void)flipVertical;

-(void)rotate90;

-(void)moveSlectedPixels:(MOVE)move;


-(void)pasteShape;

-(void)setNeedsDisplayInLoc:(CGPoint)loc;

@end
