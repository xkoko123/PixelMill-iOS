//
//  AYImageUtils.m
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYImageUtils.h"
#import <UIKit/UIKit.h>
@implementation AYImageUtils

+(UIImage*)pixelImageWithUIImage:(UIImage*)image andSize:(NSInteger)size
{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    
    //创建CIImage
    CIImage *sourceImage = [CIImage imageWithCGImage:image.CGImage];
    
    //将CIImage设为源图片
    [filter setValue:sourceImage forKey:@"inputImage"];
    
    //设置过滤参数(像素大小)
    [filter setValue: @(image.size.width/size) forKey:@"inputScale"];
    //   3 === 3
    //   2 === 2
    //   6 === 6
    //   7 === 7
    
    CIVector *vector = [CIVector vectorWithX:0 Y:0];
    [filter setValue:vector forKey:@"inputCenter"];
    
    //得到输出图片
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgImage= [context createCGImage:outputImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *outImage = [UIImage imageWithCGImage:cgImage];
    
    //调用了create创建，需要release
    CGImageRelease(cgImage);
    
    return outImage;
}


@end
