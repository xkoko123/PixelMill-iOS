//
//  AYSwipeToolBarView.m
//  PixelMill
//
//  Created by GoGo on 20/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYSwipeToolBarView.h"

#import <Masonry.h>

@implementation AYSwipeToolBarView
{
    UIView *_containerView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgeInset = UIEdgeInsetsMake(5, 5, 5, 0);
        
        self.showsHorizontalScrollIndicator = YES;
//        self.pagingEnabled = YES;
        
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        
        
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(self);
        }];

    }
    return self;
}


- (instancetype)initWithButtons:(NSArray *)btns
{
    self = [super init];
    if (self) {
        _btns = btns;
    }
    return self;
}

-(void)initView
{
    UIView *previousView = nil;
    NSLog(@"fsaf");

    
    for (UIView *v in self.btns) {
        [_containerView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_containerView).offset(self.edgeInset.top);
            make.bottom.equalTo(_containerView).offset(-self.edgeInset.bottom);
            make.width.mas_equalTo(self.mas_height).offset(-self.edgeInset.top-self.edgeInset.bottom);
            
            if(previousView){
                make.left.mas_equalTo(previousView.mas_right).offset(self.edgeInset.left);
            }else{
                make.left.mas_equalTo(0).offset(self.edgeInset.left);
            }
        }];
        previousView = v;
    }
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(previousView.mas_right);
    }];
}

-(void)setBtns:(NSMutableArray *)btns
{
    _btns = btns;
    for (UIView *v in [_containerView subviews]) {
        [v removeFromSuperview];
    }
    [self initView];
}


- (NSArray*)allViews
{
    return [_btns copy];
}

@end
