//
//  AYPopupWindow.h
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
//从上面掉下来的登陆界面

#import <UIKit/UIKit.h>


@protocol AYPopupWindowDelegate <NSObject>

@optional
-(void)popupWindowClickOkWithUserName:(NSString*)username password:(NSString*)password;

@end


@class AYUnderLineTextField;

@interface AYPopupWindow : UIView
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIButton *cancelBtn;
@property (strong, nonatomic)  UIButton *okBtn;
@property (strong, nonatomic)  AYUnderLineTextField *userField;
@property (strong, nonatomic)  AYUnderLineTextField *passwordField;

@property (nonatomic, assign)id delegate;

@end
