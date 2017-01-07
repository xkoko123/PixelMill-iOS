//
//  AYGifPlayView.m
//  PixelMill
//
//  Created by GoGo on 28/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYGifPlayView.h"
#import <YYImage.h>
#import "AYPixelAdapter.h"
#import "AYCanvas.h"
@implementation AYGifPlayView
{
    NSMutableArray *_frames;
    YYAnimatedImageView *_imageView;
    UISlider *speedSlide;
    UISwitch *reverseSwitch;
    double _currentDuration;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame andFrames:(NSMutableArray*)frames
{
    self = [super initWithFrame:frame];
    if (self) {
        _frames = frames;
        _currentDuration = 0.3;
        UIControl *bgView = [[UIControl alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        [self addSubview:bgView];
        [bgView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *image = [self getImageWithFrames:frames Duration:_currentDuration reverse:NO];
        _imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        _imageView.backgroundColor = [UIColor redColor];
        CGFloat width = self.frame.size.width - 20;
        _imageView.frame = CGRectMake(self.frame.size.width/2 - width/2, self.frame.size.height/2 - width/2 - 20, width, width);
        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageView.layer.shadowOffset = CGSizeMake(3, 3);
        _imageView.layer.shadowRadius = 3;
        _imageView.layer.shadowOpacity = 0.8;
        [self addSubview:_imageView];
        
        
        speedSlide = [[UISlider alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - width/2,
                                                                self.frame.size.height/2 + width/2 ,
                                                                width - 50,
                                                                44)];
        
        speedSlide.maximumValue = 0.99;
        speedSlide.minimumValue = 0.2;
        speedSlide.value = 1 - _currentDuration;
        speedSlide.continuous = NO;
        [self addSubview:speedSlide];
        [speedSlide addTarget:self action:@selector(speedChanged:) forControlEvents:UIControlEventValueChanged];
        
        reverseSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + width/2 - 50,
                                                                  self.frame.size.height/2 + width/2 ,
                                                                  50,
                                                                  44)];
        [self addSubview:reverseSwitch];
        reverseSwitch.on = NO;
        [reverseSwitch addTarget:self action:@selector(reverseValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(UIImage*)getImageWithFrames:(NSMutableArray*)frames Duration:(double)duration reverse:(BOOL)reverse
{
    
    YYImageEncoder *gifencoder = [[YYImageEncoder alloc]initWithType:YYImageTypeGIF];
    gifencoder.loopCount = 0;
    for (AYPixelAdapter *adapter in frames) {
        AYCanvas *canvas = [[AYCanvas alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) andAdapter:adapter];
        canvas.backgroundColor = [UIColor whiteColor];
        [canvas setNeedsDisplay];
        UIImage *img = [canvas exportImage];
        [gifencoder addImage:img duration:duration];
    }

    if (reverse) {
        for (NSInteger i=frames.count-1; i>=0; i--) {
            AYPixelAdapter *adapter = [frames objectAtIndex:i];
            AYCanvas *canvas = [[AYCanvas alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) andAdapter:adapter];
            canvas.backgroundColor = [UIColor whiteColor];
            [canvas setNeedsDisplay];
            UIImage *img = [canvas exportImage];
            [gifencoder addImage:img duration:duration];
        }
    }
    
    
    NSData *gifData = [gifencoder encode];
    
    UIImage *image = [YYImage imageWithData:gifData];
    
    return image;
}

-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)speedChanged:(UISlider*)sender
{
    _currentDuration = 1 - sender.value;
    UIImage *image = [self getImageWithFrames:_frames Duration:_currentDuration reverse:reverseSwitch.on];
    [_imageView setImage:image];
}

-(void)reverseValueChanged:(UISwitch*)sender
{
    UIImage *image = [self getImageWithFrames:_frames Duration:_currentDuration reverse:reverseSwitch.on];
    [_imageView setImage:image];
}

@end
