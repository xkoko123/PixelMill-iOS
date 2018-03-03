//
//  UIColor+colorWithInt.h
//  PixelMill
//
//  Created by GoGo on 16/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithInt)

+(UIColor *)colorWithInt:(NSInteger)i;

-(NSInteger)intData;

-(CGFloat)getAlpha;

+(UIColor*)blendBgColor:(UIColor*)color1 andFrontColor:(UIColor*)color2;
@end
