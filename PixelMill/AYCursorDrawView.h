//
//  AYCursorDrawView.h
//  PixelMill
//
//  Created by GoGo on 18/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//  模拟鼠标画图模式，，

#import "AYBaseDrawView.h"

@interface AYCursorDrawView : AYBaseDrawView


- (instancetype)initWithFrame:(CGRect)frame ansSize:(int)size;

-(void)touchDown;

-(void)touchUp;

-(void)longPress;

-(void)fillUp;
@end
