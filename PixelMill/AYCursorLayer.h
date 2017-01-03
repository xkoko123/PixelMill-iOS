//
//  AYCursorLayer.h
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AYPublicHeader.h"
@class UIColor;
@interface AYCursorLayer : CALayer
@property (nonatomic,assign) CGFloat pixelWidth;
@property (nonatomic,assign) AYCursorDrawType type;
//@property (nonatomic,assign) NSInteger lineWidth;
@property (nonatomic,strong) UIColor *selectedColor;
@end
