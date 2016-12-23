//
//  AYExploreController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYExploreController.h"
#import "AYLoginViewController.h"

#import "AYPixelAdapter.h"
#import "AYCanvas.h"
#import "UIColor+colorWithInt.h"

@interface AYExploreController ()

@end

@implementation AYExploreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(30, 50, 80, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_orange_bg"] forState:UIControlStateNormal];
    [btn setTitle:@"fsdfsdf" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
//    UIColor *c1 = [UIColor colorWithInt:data];
//    NSLog(@"===%@",c);
//    NSLog(@"===%@",c1);
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [view setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:view];
//    CALayer *layer = view.layer;
//    
//    layer.backgroundColor = [UIColor orangeColor].CGColor;
//    layer.cornerRadius = 5.0;
//    layer.frame = CGRectInset(layer.frame, 20, 20);
//    
//    CALayer *subL = [CALayer layer];
//    subL.shadowOffset = CGSizeMake(0, 3);
//    subL.shadowRadius = 5.0;
//    subL.shadowColor = [[UIColor blackColor] CGColor];
//    subL.shadowOpacity = 0.8;
//    subL.frame = CGRectMake(30, 30, 128, 192);
//    
//    subL.contents = (id)[[UIImage imageNamed:@"bucket"] CGImage];
//    subL.borderColor = [[UIColor blackColor] CGColor];
//    subL.borderWidth = 2.0;
//    
//    [layer addSublayer:subL];
//    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timetime) userInfo:nil repeats:YES];

//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"rinima" message:@"gunnima" preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alert animated:YES completion:nil];
//    self.view.frame.origin
//    for (id xx in [alert.view subviews]) {
//        
//        for (id x in [xx subviews]) {
//            for (id c in [x subviews]) {
//                [x setBackgroundColor:[UIColor orangeColor]];
//                NSLog(@"===%@", [NSString stringWithUTF8String:object_getClassName(c)]);
//                if ([[NSString stringWithUTF8String:object_getClassName(c)] isEqualToString: @"_UIDimmingKnockoutBackdropView"]) {
//                    [c setBackgroundColor:[UIColor redColor]];
//                    UIView *v = c;
//                    v.layer.cornerRadius = 50;
//                    v.layer.contents = (id)[[UIImage imageNamed:@"bucket"] CGImage];
//                }
//            };
//
//        };
//
//    };


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    AYLoginViewController *vc = [[AYLoginViewController alloc] init];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
