//
//  AppDelegate.m
//  PixelMill
//
//  Created by GoGo on 14/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AppDelegate.h"
#import "AYTabBarController.h"

#import "UIColor+colorWithInt.h"
#import "AYNetManager.h"
#import "AYLoginViewController.h"



#import "AYPixelAdapter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIColor colorWithInt:0xf86924];
    
    AYTabBarController *tabVc = [[AYTabBarController alloc] init];
    AYLoginViewController *logVc = [[AYLoginViewController alloc] init];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud stringForKey:@"username"];
    NSString *password = [ud stringForKey:@"password"];
    NSLog(@"%@  %@  hhahahah",username, password);
    if (username!=nil && password!=nil) {
        [self.window setRootViewController:tabVc];
        [[AYNetManager shareManager] loginWithUser:username password:password success:^(id responseObject) {
            NSLog(@"~~%@", responseObject);
            if ([responseObject[@"status"] integerValue] != 1) {
                AYLoginViewController *vc = [[AYLoginViewController alloc] init];
                self.window.rootViewController = vc;
                [self.window.window makeKeyAndVisible];
            }
        } failure:^(NSError *error) {

        }];
    }else{
        [self.window setRootViewController:logVc];
    }
    
    //发布时注释掉啊
//    [self.window setRootViewController:tabVc];
    
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    
//    [self.window setRootViewController:tabVc];
    [self.window makeKeyAndVisible];
    
    
    
//    NSArray *array = [self getRGBAsFromImage:image atX:0 andY:0 count:image.size.width];
//    NSLog(@"==%@", array);

    
    
    return YES;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
