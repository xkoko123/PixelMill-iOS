//
//  AYBaseViewController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseViewController.h"
@interface AYBaseViewController ()
@property (nonatomic, weak) UIView *toastView;
@end

@implementation AYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:71 /255.0 green:29 / 255.0 blue:52 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    CAShapeLayer *shape = [CAShapeLayer layer];
//    shape.strokeColor = [UIColor lightGrayColor].CGColor;
//    shape.lineWidth = 1;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    int wCount = 10;
//    CGFloat width = self.view.frame.size.width / wCount;
//    int hCount =  self.view.frame.size.height / wCount;
//    for (int i=0; i<wCount; i++) {
//        [path moveToPoint:CGPointMake(i*width, 0)];
//        [path addLineToPoint:CGPointMake(i*width, self.view.frame.size.height)];
//    }
//    for (int i=0; i<hCount; i++) {
//        [path moveToPoint:CGPointMake(0, i*width)];
//        [path addLineToPoint:CGPointMake(self.view.frame.size.width, i*width)];
//    }
//    shape.path = path.CGPath;
//    [self.view.layer addSublayer:shape];
//    self.view.backgroundColor = [UIColor colorWithRed:64 /255.0 green:64 / 255.0 blue:64 / 255.0 alpha:1]; 暗灰色
//    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)showToastWithMessage:(NSString*)text andDelay:(CGFloat)delay
{
    if (_toastView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToastWithMessage:text andDelay:delay];
        });
        return;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    
    _toastView = view;
    
    _toastView.layer.shadowOffset = CGSizeMake(4, 2);
    _toastView.layer.shadowColor = [UIColor blackColor].CGColor;
    _toastView.layer.shadowRadius = 5;
    _toastView.layer.shadowOpacity = 0.5;
    
    
    UILabel *message = [[UILabel alloc] init];
    message.textAlignment = NSTextAlignmentCenter;
    [_toastView addSubview:message];
    message.frame = CGRectMake(5, 2, _toastView.frame.size.width-10, _toastView.frame.size.height-4);
    
    [_toastView addSubview:message];
    
    message.text = text;
    
    [_toastView layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _toastView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _toastView.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
            } completion:^(BOOL finished) {
                [_toastView removeFromSuperview];
            }];

        });
    }];

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
