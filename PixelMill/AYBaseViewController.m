//
//  AYBaseViewController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseViewController.h"
@interface AYBaseViewController ()

@end

@implementation AYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:71 /255.0 green:29 / 255.0 blue:52 / 255.0 alpha:1];
//    self.view.backgroundColor = [UIColor colorWithRed:64 /255.0 green:64 / 255.0 blue:64 / 255.0 alpha:1]; 暗灰色
//    self.view.backgroundColor = [UIColor whiteColor];

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
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
