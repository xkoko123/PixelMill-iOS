//
//  AYColorPickerViewViewController.m
//  PixelMill
//
//  Created by GoGo on 23/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYColorPickerViewController.h"
#import <HRColorPickerView.h>
#import "UIColor+colorWithInt.h"
@interface AYColorPickerViewController ()

@end

@implementation AYColorPickerViewController
{
    HRColorPickerView *colorPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTopBar];
    [self initPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//顶栏
-(void)initTopBar
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBar];
    
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backBtn];
    

    backBtn.frame = CGRectMake(2, 2, 40, 40);
    [backBtn setTintColor:[UIColor blackColor]];
    
    
    //上传
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didClickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:saveBtn];
    saveBtn.frame = CGRectMake(self.view.frame.size.width - 42, 2, 40, 40);
    [saveBtn setTintColor:[UIColor blackColor]];
    
}


-(void)initPicker
{
    colorPicker = [[HRColorPickerView alloc] init];
    colorPicker.color = [UIColor redColor];
    [colorPicker addTarget:self action: @selector(action:) forControlEvents:UIControlEventValueChanged];
    colorPicker.frame  = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    colorPicker.color = [self.colors objectAtIndex:self.index];
    [self.view addSubview:colorPicker];
    [colorPicker.brightnessSlider setValue:@0.0 forKey:@"brightnessLowerLimit"];

}


-(void)action:(HRColorPickerView*)colorPicker
{
    self.view.backgroundColor = colorPicker.color;
    CGFloat a,r,g,b;
    [colorPicker.color getRed:&r green:&g blue:&b alpha:&a];
    NSInteger alpha = (int)(a * 255);
    NSInteger red = (int)(r * 255);
    NSInteger green = (int)(g * 255);
    NSInteger blue = (int)(b * 255);
}

-(void)didClickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickSaveBtn
{
    [self.colors replaceObjectAtIndex:self.index withObject:colorPicker.color];
    [self.btn setBackgroundColor:colorPicker.color];
    if ([self.delegate respondsToSelector:@selector(colorPickerDidSlectedColor:)]) {
        [self.delegate colorPickerDidSlectedColor:colorPicker.color];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:[colorPicker.color intData] forKey:[NSString stringWithFormat:@"color%ld",(long)self.index]];
        [userDefaults synchronize];
    }];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
