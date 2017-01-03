//
//  AYCollectionCarouselViewCollectionReusableView.m
//  PixelMill
//
//  Created by GoGo on 01/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYCollectionCarouselView.h"
#import "AYCarouselView.h"
#import <Masonry.h>
@implementation AYCollectionCarouselView
{
    AYCarouselView *cv;
    UIView *indexView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        
        //226 轮播
        //16间距
        
        // 38图片
        // 20文字
        
        //16间距
        //-----------------16+38+22+16=92   ---------92+226=318
        //关注 最新 热门 挑战
        
        //20分割条
        
        cv = [[AYCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 226)];
        [self addSubview:cv];
        
        
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 226, self.frame.size.width, 102)];
        vv.backgroundColor = [UIColor whiteColor];
        UIControl *v1 = [[UIControl alloc] init];
        [vv addSubview:v1];
        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(vv.mas_bottom).offset(-16);
            make.left.equalTo(vv.mas_left);
            make.height.equalTo(@60);
        }];
        
        UIControl *v2 = [[UIControl alloc] init];
        [vv addSubview:v2];
        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(vv.mas_bottom).offset(-16);
            make.width.equalTo(v1);
            make.left.equalTo(v1.mas_right);
            make.height.equalTo(@60);
        }];
        
        UIControl *v3 = [[UIControl alloc] init];
        [vv addSubview:v3];
        [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(vv.mas_bottom).offset(-16);
            make.width.equalTo(v2);
            make.left.equalTo(v2.mas_right);
            make.height.equalTo(@60);
        }];
        
        UIControl *v4 = [[UIControl alloc] init];
        [vv addSubview:v4];
        [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(vv.mas_bottom).offset(-16);
            make.width.equalTo(v3);
            make.left.equalTo(v3.mas_right);
            make.height.equalTo(@60);
            make.right.equalTo(vv.mas_right);
        }];

        UIImageView *newsImage = [[UIImageView alloc] init];
        [newsImage setImage:[UIImage imageNamed:@"new_tag"]];
        [v1 addTarget:self action:@selector(clickAt:) forControlEvents:UIControlEventTouchUpInside];
        v1.tag = 1;
        [v1 addSubview:newsImage];
        [newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@25);
            make.centerX.equalTo(v1);
            make.top.equalTo(v1.mas_top);
        }];
        UILabel *newsLabel = [[UILabel alloc] init];
        newsLabel.font = [UIFont systemFontOfSize:16];
        newsLabel.textColor = [UIColor darkTextColor];
        newsLabel.text = @"最新";
        newsLabel.textAlignment = NSTextAlignmentCenter;
        [v1 addSubview:newsLabel];
        [newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.right.left.equalTo(v1);
            make.bottom.equalTo(v1.mas_bottom);
        }];
        
        UIImageView *followImage = [[UIImageView alloc] init];
        [followImage setImage:[UIImage imageNamed:@"follow_tag"]];
        [v2 addTarget:self action:@selector(clickAt:) forControlEvents:UIControlEventTouchUpInside];
        v2.tag = 2;
        [v2 addSubview:followImage];
        [followImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@25);
            make.centerX.equalTo(v2);
            make.top.equalTo(v2.mas_top);
        }];
        UILabel *followLabel = [[UILabel alloc] init];
        followLabel.font = [UIFont systemFontOfSize:16];
        followLabel.textColor = [UIColor darkTextColor];
        followLabel.text = @"关注";
        followLabel.textAlignment = NSTextAlignmentCenter;
        [v2 addSubview:followLabel];
        [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.right.left.equalTo(v2);
            make.bottom.equalTo(v2.mas_bottom);
        }];

        UIImageView *hotImage = [[UIImageView alloc] init];
        [hotImage setImage:[UIImage imageNamed:@"hot_tag"]];
        [v3 addTarget:self action:@selector(clickAt:) forControlEvents:UIControlEventTouchUpInside];
        v3.tag = 3;
        [v3 addSubview:hotImage];
        [hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@25);
            make.centerX.equalTo(v3);
            make.top.equalTo(v3.mas_top);
        }];
        UILabel *hotLabel = [[UILabel alloc] init];
        hotLabel.font = [UIFont systemFontOfSize:16];
        hotLabel.textColor = [UIColor darkTextColor];
        hotLabel.text = @"热门";
        hotLabel.textAlignment = NSTextAlignmentCenter;
        [v3 addSubview:hotLabel];
        [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.right.left.equalTo(v3);
            make.bottom.equalTo(v3.mas_bottom);
        }];

        UIImageView *challengeImage = [[UIImageView alloc] init];
        [challengeImage setImage:[UIImage imageNamed:@"challenge_tag"]];
        [v4 addTarget:self action:@selector(clickAt:) forControlEvents:UIControlEventTouchUpInside];
        v4.tag = 4;
        [v4 addSubview:challengeImage];
        [challengeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@25);
            make.centerX.equalTo(v4);
            make.top.equalTo(v4.mas_top);
        }];
        UILabel *challengeLabel = [[UILabel alloc] init];
        challengeLabel.font = [UIFont systemFontOfSize:16];
        challengeLabel.textColor = [UIColor darkTextColor];
        challengeLabel.text = @"挑战";
        challengeLabel.textAlignment = NSTextAlignmentCenter;
        [v4 addSubview:challengeLabel];
        [challengeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.right.left.equalTo(v4);
            make.bottom.equalTo(v4.mas_bottom);
        }];
        
        
        indexView = [[UIView alloc] init];
        [vv addSubview:indexView];
        indexView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        [indexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v1);
            make.height.equalTo(@5);
            make.bottom.equalTo(vv.mas_bottom);
            make.left.equalTo(v1.mas_left);
        }];
        
        [self addSubview:vv];
        
        
    }
    return self;
}

-(void)setImageArr:(NSArray *)imageNameArray AndImageClickBlock:(void(^)(NSInteger index)) clickBlock
{
    [cv setImageArr:imageNameArray];
    [cv setClickBlock:clickBlock];
    
}

-(void) setViews
{

}

-(void)clickAt:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(carouselViewDidClickAtIndex:)]) {
        [self.delegate carouselViewDidClickAtIndex:sender.tag];
        if (sender.tag < 4) {
            [self slecteButtonAtIndex:sender.tag];
        }
    }
}

-(void)slecteButtonAtIndex:(NSInteger)index
{
    [indexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(indexView.frame.size.width * (index-1));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
