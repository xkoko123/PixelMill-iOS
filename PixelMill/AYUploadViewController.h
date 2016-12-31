//
//  AYUploadViewController.h
//  PixelMill
//
//  Created by GoGo on 28/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseViewController.h"

@interface AYUploadViewController : AYBaseViewController

-(instancetype)initWithImage:(UIImage*)image andType:(NSString*)type;
@property(nonatomic,strong)UIImage *image;

@end
