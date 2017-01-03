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
//轮播图片名字的数组
@property(strong,nonatomic) NSArray *imageArr;
//自定义视图的数组
@property(strong,nonatomic) NSArray *viewArr;
//定时器
@property(strong,nonatomic) NSTimer *timer;
//点击图片出发Block
@property(strong,nonatomic) imageClickBlock clickBlock;

@end
//获取ScrollView的X值偏移量
#define contentOffSet_x self.direct.contentOffset.x
//获取ScrollView的宽度
#define frame_width self.direct.frame.size.width
//获取ScrollView的contentSize宽度
#define contentSize_x self.direct.contentSize.width


@implementation AYCarouselView

/**
 *  部分初始代码实现如下，
 */

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
        
        //设置ScrollView的contentSize
        self.direct.contentSize = CGSizeMake((imageNameArray.count+2)*frame_width,0);
        
        self.pageVC.numberOfPages = imageNameArray.count;
        
        //设置滚动图片数组
        self.imageArr=imageNameArray;
        
        //设置图片点击的Block
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
        //初始化轮播ScrollView
        self.direct = [[UIScrollView alloc]init];
        self.direct.delegate = self;
        self.direct.pagingEnabled = YES;
        self.direct.frame = self.bounds;
        self.direct.scrollsToTop = NO;
        self.direct.contentOffset=CGPointMake(frame_width, 0);
        self.direct.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.direct];
        
        //初始化轮播页码控件
        self.pageVC=[[UIPageControl alloc]init];
        //设置轮播页码的位置
        self.pageVC.frame=CGRectMake(0,self.frame.size.height-30, self.frame.size.width, 30);
        _pageVC.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageVC.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:self.pageVC];
        
        self.time = 3.0;
    }
    return self;
}
/**
 *  大部分的轮播广告，我们必不可缺少的神器，没错就是定时器，如何实现自动滚动，加上一个定时器，就变得美好起来了，通过定时器改变滚动视图的偏移量，和页码视图的偏移量。
 
 */
#pragma mark-===========================定时器===============================
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
    //获取并且计算当前页码
    CGPoint currentConOffSet=self.direct.contentOffset;
    currentConOffSet.x+=frame_width;
    
    //动画改变当前页码
    [UIView animateWithDuration:0.5 animations:^{
        self.direct.contentOffset=currentConOffSet;
    }completion:^(BOOL finished) {
        [self updataWhenFirstOrLast];
    }];
}

#pragma mark 判断是否第一或者最后一个图片,改变坐标
-(void)updataWhenFirstOrLast
{
    //当图片移动到最后一张时，动画结束移动到第二张图片的位置
    if(contentOffSet_x>=contentSize_x-frame_width)
    {
        self.direct.contentOffset=CGPointMake(frame_width, 0);
    }
    //当图片移动到第一张时，动画结束移动到倒数第二张的位置
    else if (contentOffSet_x<=0)
    {
        self.direct.contentOffset=CGPointMake(contentSize_x-2*frame_width, 0);
    }
    
    //更新PageControl
    [self updataPageControl];
}
#pragma mark 更新PageControl
-(void)updataPageControl
{
    NSInteger index=(contentOffSet_x-frame_width)/frame_width;
    self.pageVC.currentPage=index;
}
/**
 *  我们也要使用到UIScrollViewDelegate，通过代理方法来控制轮播图的变化，和定时器开启与关闭！
 */
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
    //当最后或者最前一张图片时改变坐标
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
    //设置滚动图片数组
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
/**
 *   很明显我们该如何实现图片的填充到轮播图上呢，那么通过下面的方法就可以了：
 */
#pragma mark 根据图片名添加图片到ScrollView
-(void)addImageToScrollView
{
    //创建一个可变数组
    NSMutableArray *imgMArr=[NSMutableArray arrayWithArray:self.imageArr];
    //添加第一个和最后一个对象到对应可变数组的最后一个位置和第一个位置
    [imgMArr insertObject:[self.imageArr lastObject] atIndex:0];
    [imgMArr addObject:[self.imageArr firstObject]];
    
    NSInteger tag=-1;
    if (imgMArr.count == 0)
    {
        return;
    }
    for (NSString *name in imgMArr) {
        //将传进来的图片名在本地初始化
        UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        
        //设置图片的坐标
        imgView.frame=CGRectMake(self.frame.size.width*(tag+1), 0, self.frame.size.width, self.frame.size.height);
        
        //如果本地没有这张图片进行网络请求
        if(imgView.image ==nil)
        {
            
            imgView.yy_imageURL = [NSURL URLWithString:name];
        }
        //让图片进行裁剪显示
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        //添加手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        
        //开启用户交互
        imgView.userInteractionEnabled=YES;
        
        [self.direct addSubview:imgView];
        
        [imgView addGestureRecognizer:tap];
        
        //设置tag
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
