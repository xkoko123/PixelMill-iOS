//
//  AYPixelAdapter.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYPublicHeader.h"
@interface AYPixelAdapter : NSObject
@property (nonatomic, assign) int size;
@property (nonatomic, strong) UIColor *defaultColor;
@property(nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic, assign)NSInteger maxUndoQueueCount;
@property (nonatomic,assign) BOOL visible;

-(instancetype)initWithSize:(int)size;
-(instancetype)initWithString:(NSString*)string;
- (UIColor*)colorWithLoc:(CGPoint)loc;


- (void)replaceAtLoc:(CGPoint)loc Withcolor:(UIColor*)color;

- (void)removeAtLoc:(CGPoint)loc;

- (void)reset;

- (void)resetOrigin;

- (BOOL)validateOrigin:(CGPoint)origin;

- (BOOL)move:(MOVE)move;

- (NSString*)getStringData;

- (UIColor*)colorWithKey:(NSValue*)key;
- (CGPoint)locWithKey:(NSValue*)key;


-(void)pushToUndoQueue;

-(void)undo;

-(void)redo;

-(void)pushToRedoQueue;

@end
