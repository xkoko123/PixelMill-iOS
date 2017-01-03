//
//  AYCarouselView.h
//  PixelMill
//
//  Created by GoGo on 01/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageClickBlock)(NSInteger index);

@interface AYCarouselView : UIView


@property(strong,nonatomic) UIScrollView * direct;


@property(strong,nonatomic) UIPageControl *pageVC;

@property(assign,nonatomic) CGFloat time;

+(instancetype)direcWithtFrame:(CGRect)frame
                      ImageArr:(NSArray *)imageNameArray
            AndImageClickBlock:(imageClickBlock)clickBlock;



-(void)beginTimer;

-(void)stopTimer;

-(void)setImageArr:(NSArray *)imageArr;

-(void)setClickBlock:(imageClickBlock)clickBlock;



@end
