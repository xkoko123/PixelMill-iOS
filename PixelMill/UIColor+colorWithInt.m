//
//  UIColor+colorWithInt.m
//  PixelMill
//
//  Created by GoGo on 16/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "UIColor+colorWithInt.h"

@implementation UIColor (colorWithInt)


// TODO : alpha通道
+(UIColor *)colorWithInt:(int)i
{
    int red, green, blue;
    blue = i % 0x100;
    i = (i - blue) / 0x100;
    green = i % 0x100;
    i = (i - green) / 0x100;
    red = i % 0x100;
    UIColor *c = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
    return c;
}


@end
