//
//  AYGifFramesView.h
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYGifFramesView;
@class AYDragableTableView;


@protocol AYGifFramesViewDelegate <NSObject>

@optional
-(void)gifFrameViewDidClickAddBtn:(AYGifFramesView*)gifFramesView;

@end

@interface AYGifFramesView : UIView
@property (nonatomic, assign) CGFloat bottomOffset;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) AYDragableTableView *tableView;
@property (nonatomic, weak) id delegate;

-(instancetype)initWithFrame:(CGRect)frame Frames:(NSMutableArray*)frames andBottomOffset:(CGFloat)bottomOffset Height:(CGFloat)height;

-(void)reloadAndScrollToRight;

-(void)removeFramesAtIndex:(NSInteger)index;

-(void)didAddedFrames;

@end
