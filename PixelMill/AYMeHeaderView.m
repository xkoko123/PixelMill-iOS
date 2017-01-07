//
//  AYMeHeaderView.m
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYMeHeaderView.h"
#import <Masonry.h>
#import "AYUser.h"
#import <YYWebImage.h>


@implementation AYMeHeaderView
{
    UIImageView *_imageView;
    UILabel *_followLabel;
    UIButton *_myworkBtn;
    UIButton *_likeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [logoutBtn setTintColor:[UIColor blackColor]];
        [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(tapLogout) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:logoutBtn];
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@66);
            make.height.equalTo(@24);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self).offset(20);
        }];
        
//        UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [msgBtn setTitle:@"消息" forState:UIControlStateNormal];
//        msgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [msgBtn setTintColor:[UIColor blackColor]];
//        [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [msgBtn addTarget:self action:@selector(tapMsg) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:msgBtn];
//        [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@66);
//            make.height.equalTo(@24);
//            make.left.equalTo(self).offset(5);
//            make.top.equalTo(self).offset(20);
//        }];

        
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.top.equalTo(self).offset(40);
            make.centerX.equalTo(self);
        }];
        _imageView.layer.cornerRadius = 40;
        _imageView.layer.masksToBounds = YES;
        _imageView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)];
        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
        
        _followLabel = [[UILabel alloc] init];
        [self addSubview:_followLabel];
        [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
            make.width.equalTo(self);
            make.centerX.equalTo(self);
        }];
        [_followLabel setText:@"Follow:0 Fans:0"];
        [_followLabel setTextAlignment:NSTextAlignmentCenter];
        
        _myworkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_myworkBtn];
        [_myworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        [_myworkBtn setTitle:@"我的作品" forState:UIControlStateNormal];
        _myworkBtn.tag = 1;
        _myworkBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [_myworkBtn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        _myworkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _myworkBtn.layer.borderWidth = 0.5;
        [_myworkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.height.mas_equalTo(40);
            make.width.equalTo(_myworkBtn);
            make.leading.equalTo(_myworkBtn.mas_trailing);
        }];
        _likeBtn.tag = 2;
        [_likeBtn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];

        
        [_likeBtn setTitle:@"我喜欢的" forState:UIControlStateNormal];
        _likeBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        _likeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _likeBtn.layer.borderWidth = 0.5;
        [_likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    return self;
}

-(void)setUser:(AYUser *)user
{
    _user = user;
    [_followLabel setText:[NSString stringWithFormat:@"Follow:%ld  Follower:%ld", user.followCount, user.followerCount]];
    
    _imageView.yy_imageURL = [NSURL URLWithString:[@"http://182.92.84.1:8000" stringByAppendingString:user.avatar]];
}


-(void)tapAvatar
{
    if ([self.delegate respondsToSelector:@selector(meHeaderViewTappedAvatar)]) {
        [self.delegate meHeaderViewTappedAvatar];
    }
}
-(void)tapLogout
{
    if ([self.delegate respondsToSelector:@selector(meHeaderViewTappedLogout)]) {
        [self.delegate meHeaderViewTappedLogout];
    }
}

-(void)tapMsg
{
    if ([self.delegate respondsToSelector:@selector(meHeaderViewTappedMessage)]) {
        [self.delegate meHeaderViewTappedMessage];
    }
}

-(void)changeType:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(meHeaderViewChangedType:)]) {
        [self.delegate meHeaderViewChangedType:sender.tag];
    }
}

@end
