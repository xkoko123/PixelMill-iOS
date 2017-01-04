//
//  AYImageUtils.h
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AYImageUtils : NSObject

+(UIImage*)pixelImageWithUIImage:(UIImage*)image andSize:(NSInteger)size;

+(UIColor*)getRGBAsFromCGImage:(CGImageRef)imageRef atX:(int)x andY:(int)y;


@end
