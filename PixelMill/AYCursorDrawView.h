//
//  AYCursorDrawer.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDrawView.h"
#import "AYPublicHeader.h"

@protocol AYCursorDrawViewDelegate <NSObject>

@optional
//画板内容有变化时调用;
@end

@interface AYCursorDrawView : AYDrawView


@property (nonatomic, assign) AYCursorDrawType currentType;
@property (nonatomic, assign) AYCursorDrawType fingerMode;

- (instancetype)initWithFrame:(CGRect)frame andSize:(NSInteger)size;
-(instancetype)initWithSize:(NSInteger)size;
-(void)touchDown;

-(void)touchUp;


@end
