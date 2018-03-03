//
//  UIColor+colorWithInt.m
//  PixelMill
//
//  Created by GoGo on 16/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "UIColor+colorWithInt.h"

@implementation UIColor (colorWithInt)


+(UIColor *)colorWithInt:(NSInteger)i
{
    NSInteger red, green, blue, alpha;
    blue = i % 0x100;
    i = (i - blue) / 0x100;
    green = i % 0x100;
    i = (i - green) / 0x100;
    red = i % 0x100;
    
    i = (i - red) / 0x100;
    alpha = i % 0x100;
    
    UIColor *c = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
    return c;
}

//UIColor -> int,,,只能转argb形式的color
- (NSInteger)intData
{
    CGFloat a,r,g,b;
    [self getRed:&r green:&g blue:&b alpha:&a];
    NSInteger alpha = (int)(a * 255);
    NSInteger red = (int)(r * 255);
    NSInteger green = (int)(g * 255);
    NSInteger blue = (int)(b * 255);
    
    return alpha * 0x1000000 + red * 0x10000 + green * 0x100  + blue;
}


//计算混合后的颜色 只能用在argb模式上,,,
//color1 背景色   color2覆盖色
+(UIColor*)blendBgColor:(UIColor*)color1 andFrontColor:(UIColor*)color2
{
    CGFloat a1,r1,g1,b1,   a2,r2,g2,b2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    
    CGFloat alpha = 1- (1-a1) * (1-a2);
    CGFloat red =   (r1 * a1 * (1-a2) + a2 * r2)  /  (a1 + a2 - a1*a2);
    CGFloat green = (g1 * a1 * (1-a2) + a2 * g2)  /  (a1 + a2 - a1*a2);
    CGFloat blue =  (b1 * a1 * (1-a2) + a2 * b2)  /  (a1 + a2 - a1*a2);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(CGFloat)getAlpha
{
    CGFloat a;
    [self getRed:nil green:nil blue:nil alpha:&a];
    return a;
}
@end
