//
//  AYCursorDrawer.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDrawView.h"
#import "AYPublicHeader.h"
@interface AYCursorDrawView : AYDrawView

@property (nonatomic, assign) AYCursorDrawType currentType;
@property (nonatomic, assign) AYCursorDrawType fingerMode;

- (instancetype)initWithFrame:(CGRect)frame andSize:(int)size;

-(void)touchDown;

-(void)touchUp;


@end
