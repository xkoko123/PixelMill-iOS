//
//  AYColorPickerViewViewController.h
//  PixelMill
//
//  Created by GoGo on 23/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYColorPickerViewDelegate <NSObject>

@optional
-(void)colorPickerDidSlectedColor:(UIColor*)color;

@end

@interface AYColorPickerViewController : UIViewController


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *btn;
@end
