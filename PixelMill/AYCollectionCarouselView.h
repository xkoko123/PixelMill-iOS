//
//  AYCollectionCarouselViewCollectionReusableView.h
//  PixelMill
//
//  Created by GoGo on 01/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCollectionCarouselViewDelegate <NSObject>

@optional
-(void)carouselViewDidClickAtIndex:(NSInteger)index;

@end


@interface AYCollectionCarouselView : UICollectionReusableView

@property (nonatomic, assign)id delegate;
//- (instancetype)initWithFrame:(CGRect)frame ImageArr:(NSArray *)imageNameArray
//           AndImageClickBlock:(void(^)(NSInteger index))clickBlock;



-(void)setImageArr:(NSArray *)imageNameArray AndImageClickBlock:(void(^)(NSInteger index)) clickBlock;

-(void)slecteButtonAtIndex:(NSInteger)index;
@end
