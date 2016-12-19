//
//  AYPixelsManage.h
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//负责管理画布数据存储
//画板根据AYPixelsManage来显示数据
//用字符串初始化一个pm再直接赋值给画板的pm，画板就能自动刷新加载像素画了=.=


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYPublicHeader.h"

@interface AYPixelsManage : NSObject<NSCopying>
@property (nonatomic, assign)int size;
@property (nonatomic, assign)int expandedSize;
@property (nonatomic, assign)CGPoint origin;


-(instancetype)initWithSize:(int)size;

-(instancetype)initWithSize:(int)size String:(NSString*)string;

- (id)objectAtRow:(int)row Col:(int)col;

- (void)replaceObjectAtRow:(int)row Col:(int)col WithObject:(id)object;

- (void)reset;

- (BOOL)validateOrigin:(CGPoint)origin;

- (BOOL)move:(MOVE)move;

- (void)resetOrigin;

//-(void)pushToUndoQueue;
//
//-(void)undo;
//
//-(void)pushToRedoQueue;
//
//-(void)redo;

-(NSString*) exportData;




@end
