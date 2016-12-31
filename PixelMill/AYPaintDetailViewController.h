//
//  AYPaintDetailViewController.h
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseViewController.h"
@class AYPaint;

@interface AYPaintDetailViewController : AYBaseViewController

- (instancetype)initWithPaintModel:(AYPaint*)paintModel;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AYPaint *paintModel;

@end
