//
//  AYCarouselView.m
//  PixelMill
//
//  Created by GoGo on 01/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYCarouselView.h"
#import <YYWebImage.h>

@interface AYCarouselView()<UIScrollViewDelegate>
@property(strong,nonatomic) NSArray *imageArr;
@property(strong,nonatomic) NSArray *viewArr;
@property(strong,nonatomic) NSTimer *timer;
@property(strong,nonatomic) imageClickBlock clickBlock;

@end


#define contentOffSet_x self.direct.contentOffset.x
#define frame_width self.direct.frame.size.width
#define contentSize_x self.direct.contentSize.width


@implementation AYCarouselView



#pragma mark 静态初始化方法
+(instancetype)direcWithtFrame:(CGRect)frame
                      ImageArr:(NSArray *)imageNameArray
            AndImageClickBlock:(imageClickBlock)clickBlock;
{
    //
    return [[AYCarouselView alloc]initWithtFrame:frame
                                       ImageArr:imageNameArray
                             AndImageClickBlock:clickBlock];
}

#pragma mark 默认初始化方法
-(instancetype)initWithtFrame:(CGRect)frame
                     ImageArr:(NSArray *)imageNameArray
           AndImageClickBlock:(imageClickBlock)clickBlock;
{
    if(self=[self initWithFrame:frame])
    {
        
        self.direct.contentSize = CGSizeMake((imageNameArray.count+2)*frame_width,0);
        
        self.pageVC.numberOfPages = imageNameArray.count;
        
        self.imageArr=imageNameArray;
        
        self.clickBlock=clickBlock;
    }
    return self;
}

-(void)setClickBlock:(imageClickBlock)clickBlock
{
    _clickBlock = clickBlock;
}

/**
 */
#pragma mark -  initWithFrame 初始化方法重写
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        //初始化ScrollView
        self.direct = [[UIScrollView alloc]init];
        self.direct.delegate = self;
        self.direct.pagingEnabled = YES;
        self.direct.frame = self.bounds;
        self.direct.scrollsToTop = NO;
        self.direct.contentOffset=CGPointMake(frame_width, 0);
        self.direct.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.direct];
        
        self.pageVC=[[UIPageControl alloc]init];

        
        self.pageVC.frame=CGRectMake(0,self.frame.size.height-30, self.frame.size.width, 30);
        _pageVC.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageVC.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:self.pageVC];
        
        self.time = 3.0;
    }
    return self;
}



#pragma mark 初始化定时器
-(void)beginTimer
{
    if(self.timer == nil)
    {
        self.timer =[NSTimer scheduledTimerWithTimeInterval:self.time
                                                     target:self
                                                   selector:@selector(timerSel) userInfo:nil repeats:YES];
    }
}

#pragma mark 摧毁定时器
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer=nil;
}

#pragma mark 定时器调用的方法
-(void)timerSel
{
    //当前页码
    CGPoint currentConOffSet=self.direct.contentOffset;
    currentConOffSet.x+=frame_width;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.direct.contentOffset=currentConOffSet;
    }completion:^(BOOL finished) {
        [self updataWhenFirstOrLast];
    }];
}

#pragma mark 判断是否第一或者最后一个图片,改变坐标
-(void)updataWhenFirstOrLast
{
    if(contentOffSet_x>=contentSize_x-frame_width)
    {
        self.direct.contentOffset=CGPointMake(frame_width, 0);
    }else if (contentOffSet_x<=0){
        self.direct.contentOffset=CGPointMake(contentSize_x-2*frame_width, 0);
    }
    [self updataPageControl];
}
#pragma mark 更新PageControl
-(void)updataPageControl
{
    NSInteger index=(contentOffSet_x-frame_width)/frame_width;
    self.pageVC.currentPage=index;
}


#pragma mark-========================UIScrollViewDelegate=====================

#pragma mark 开始拖拽代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

#pragma mark 结束拖拽代理
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self beginTimer];
}

#pragma mark 结束滚动代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //最后或者最前一张图片时改变坐标
    [self updataWhenFirstOrLast];
}


#pragma mark -=====================其他一些方法===================
#pragma mark轮播定时器时间
-(void)setTime:(CGFloat)time
{
    if(time>0)
    {
        _time = time;
        [self stopTimer];
        [self beginTimer];
    }
}

#pragma mark 重写图片名字的数组
-(void)setImageArr:(NSArray *)imageArr
{
    _imageArr=imageArr;
    self.direct.contentSize = CGSizeMake((imageArr.count+2)*frame_width,0);
    
    self.pageVC.numberOfPages = imageArr.count;
//
//    self.imageArr=imageArr;

    
    [self addImageToScrollView];
    
    [self beginTimer];
    
    
}


#pragma mark 图片点击事件
-(void)imageClick:(UITapGestureRecognizer *)tap
{
    UIView *view=tap.view;
    if(self.clickBlock)
    {
        self.clickBlock(view.tag);
    }
}



#pragma mark 根据图片名添加图片到ScrollView
-(void)addImageToScrollView
{
    NSMutableArray *imgMArr=[NSMutableArray arrayWithArray:self.imageArr];

    [imgMArr insertObject:[self.imageArr lastObject] atIndex:0];
    [imgMArr addObject:[self.imageArr firstObject]];
    
    NSInteger tag=-1;
    if (imgMArr.count == 0)
    {
        return;
    }
    for (NSString *name in imgMArr) {
        UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        
        imgView.frame=CGRectMake(self.frame.size.width*(tag+1), 0, self.frame.size.width, self.frame.size.height);
        
        if(imgView.image ==nil)
        {
            
            imgView.yy_imageURL = [NSURL URLWithString:name];
        }
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        
        imgView.userInteractionEnabled=YES;
        
        [self.direct addSubview:imgView];
        
        [imgView addGestureRecognizer:tap];
        
        imgView.tag = tag;
        tag++;
        
    }
    
    
    self.pageVC.numberOfPages = self.imageArr.count;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
