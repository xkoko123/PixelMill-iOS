//
//  AYMeHeaderView.h
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AYMeHeaderViewDelegate <NSObject>

@optional
-(void)meHeaderViewTappedAvatar;
-(void)meHeaderViewTappedLogout;
-(void)meHeaderViewTappedMessage;
-(void)meHeaderViewChangedType:(NSInteger)index;

@end


@class AYUser;
@interface AYMeHeaderView : UICollectionReusableView

@property (nonatomic,strong)AYUser *user;
@property (nonatomic, assign)id delegate;

@end
