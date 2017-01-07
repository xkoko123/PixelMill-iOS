//
//  AYTabBarControllerViewController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYTabBarController.h"
#import "AYMeController.h"
#import "AYMessageController.h"
#import "AYExploreController.h"
#import "AYDrawViewController.h"
#import "AYNavigationController.h"


@interface AYTabBarController ()<UITabBarControllerDelegate>

@end

@implementation AYTabBarController


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initControllers];
        self.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

-(void)initControllers
{
    
    self.tabBarController.delegate = self;
    
    AYExploreController *expVc = [[AYExploreController alloc] init];
    expVc.title = @"首页";
    [expVc.tabBarItem setImage:[[UIImage imageNamed:@"tab_home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//    expVc.tabBarItem.image
//    expVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    expVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 20);

    AYNavigationController *expNvc = [[AYNavigationController alloc] initWithRootViewController:expVc];
    
    AYMeController *meVc = [[AYMeController alloc] init];
    meVc.title = @"我的";
    
    [meVc.tabBarItem setImage:[[UIImage imageNamed:@"tab_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    meVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    meVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 20);
    
    AYNavigationController *meNvc = [[AYNavigationController alloc] initWithRootViewController:meVc];
    
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.title = @"创作";
//    newVc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    newVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 20);

    [newVc.tabBarItem setImage:[[UIImage imageNamed:@"tab_add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    [self setViewControllers:@[expNvc, newVc, meNvc]];
//    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"NEW" image:nil tag:2];
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

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"选择画布尺寸" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [vc addAction:[UIAlertAction actionWithTitle:@"8X8" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AYDrawViewController *dvc = [[AYDrawViewController alloc] init];
            dvc.size = 8;
            [self presentViewController:dvc animated:YES completion:nil];
        }]];

        [vc addAction:[UIAlertAction actionWithTitle:@"16X16" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AYDrawViewController *dvc = [[AYDrawViewController alloc] init];
            dvc.size = 16;
            [self presentViewController:dvc animated:YES completion:nil];
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:@"32X32" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AYDrawViewController *dvc = [[AYDrawViewController alloc] init];
            dvc.size = 32;
            [self presentViewController:dvc animated:YES completion:nil];
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:@"64X64" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AYDrawViewController *dvc = [[AYDrawViewController alloc] init];
            dvc.size = 64;
            [self presentViewController:dvc animated:YES completion:nil];
        }]];

        [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

        [self presentViewController:vc animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

//-(void)viewWillLayoutSubviews
//{
//    CGRect frame = self.tabBar.frame;
//
////    frame.size.height = 40;
////    frame.origin.y = self.view.frame.size.height - 40;
////
////    self.tabBar.frame =frame;
//    
//    CGFloat offset = 5.5;
//    for(UITabBarItem *item in self.tabBar.items){
//        item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    }
//}
@end
