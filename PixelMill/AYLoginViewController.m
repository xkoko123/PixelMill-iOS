//
//  AYLoginViewController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYLoginViewController.h"
#import "AYPopupWindow.h"
#import "AYUnderLineTextField.h"
#import "AYTabBarController.h"
#import "AYNetManager.h"
#import <MBProgressHUD.h>
@interface AYLoginViewController ()<AYPopupWindowDelegate>
@property (nonatomic, strong)UIImageView *logoImg;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *registBtn;

@property (nonatomic, strong)AYPopupWindow *popView;
@end

@implementation AYLoginViewController
{
    BOOL isLogin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:17 / 255.0 green:17 / 255.0 blue:17 / 255.0 alpha:1];
    // Do any additional setup after loading the view.
    [self initView];
    isLogin = YES;
}

-(void) initView
{
    
    _logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _logoImg.frame = CGRectMake(self.view.frame.size.width/2 - 120, -60, 240, 240); // 60
    [self.view addSubview:_logoImg];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -340, self.view.frame.size.width, 40)];  // 340
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.font = [UIFont fontWithName:@"Pixel" size:34];
    logoLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    logoLabel.text = @"PIXEL MILL";
    [self.view insertSubview:logoLabel belowSubview:_logoImg];
    
    logoLabel.alpha = 0;
    _logoImg.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _logoImg.frame = CGRectMake(self.view.frame.size.width/2 - 120, 60, 240, 240);
        logoLabel.frame = CGRectMake(0, 340, self.view.frame.size.width, 40);
        logoLabel.alpha = 1;
        _logoImg.alpha = 1;
    } completion:nil];
    
    
    UIInterpolatingMotionEffect *motionEffect;
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(-25);
    motionEffect.maximumRelativeValue = @(25);
    
    [_logoImg addMotionEffect:motionEffect];
    [logoLabel addMotionEffect:motionEffect];

    
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @(-25);
    motionEffect.maximumRelativeValue = @(25);
    
    [_logoImg addMotionEffect:motionEffect];
    [logoLabel addMotionEffect:motionEffect];

    
    
    
    _registBtn = [[UIButton alloc] init];
    _registBtn.frame = CGRectMake(20,
                                  self.view.frame.size.height - 40 - 20,
                                  100,
                                  40);
    [_registBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn.titleLabel setFont:[UIFont fontWithName:@"Pixel" size:15]];
    [_registBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_bg"] forState:UIControlStateNormal];
    [_registBtn addTarget:self action:@selector(didSignupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registBtn];
    
    
    _loginBtn =[[UIButton alloc] init];
    _loginBtn.frame = CGRectMake(self.view.frame.size.width - 20 - 100,
                                  self.view.frame.size.height - 40 - 20,
                                  100,
                                  40);
    _loginBtn.backgroundColor = [UIColor clearColor];
    [_loginBtn setTitle:@"Log in" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont fontWithName:@"Pixel" size:15]];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_green2_bg"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(didLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:_loginBtn];

    
    _registBtn.alpha = 0;
    _loginBtn.alpha = 0;
    [UIView animateWithDuration:1.5 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _registBtn.alpha = 1;
        _loginBtn.alpha = 1;
    } completion:nil];
    
}
-(AYPopupWindow *)popView
{
    if (_popView == nil) {
        _popView = [[AYPopupWindow alloc] initWithFrame:CGRectMake(0,
                                                                   -248,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
        _popView.hidden = YES;
        _popView.delegate = self;
        [self.view addSubview:_popView];
    }
    return _popView;
}

-(void)didLoginBtnClicked
{
    self.popView.hidden = NO;
    self.popView.titleLabel.text = @"登陆";
    [self.popView.okBtn setTitle:@"登陆" forState:UIControlStateNormal];
    isLogin = YES;
    [self.popView.userField becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.popView.frame = CGRectMake(0,
                                        0,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height);
    } completion:nil];
}

-(void)didSignupBtnClicked
{
    self.popView.hidden = NO;
    self.popView.titleLabel.text = @"注册";
    [self.popView.okBtn setTitle:@"注册" forState:UIControlStateNormal];

    isLogin = NO;
    [self.popView.userField becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.popView.frame = CGRectMake(0,
                                        0,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height);
    } completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)popupWindowClickOkWithUserName:(NSString *)username password:(NSString *)password
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (isLogin) {
        //登陆
        [[AYNetManager shareManager] loginWithUser:username password:password success:^(id responseObject) {
            [self.popView dismiss];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([responseObject[@"status"] integerValue] == 1) {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:username forKey:@"username"];
                [ud setObject:password forKey:@"password"];
                [ud synchronize];
                AYTabBarController *vc = [[AYTabBarController alloc] init];
                self.view.window.rootViewController = vc;
                [self.view.window makeKeyAndVisible];
            }else{
                [self showToastWithMessage:@"失败啊" andDelay:1 andView:nil];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showToastWithMessage:@"失败啊" andDelay:1 andView:nil];
        }];
        
    }else{
        //注册
        [[AYNetManager shareManager] registWithName:username password:password  success:^(id responseObject) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.popView dismiss];
            if ([responseObject[@"status"] integerValue] == 1) {
                [self showToastWithMessage:@"注册成功" andDelay:1 andView:nil];
            }else{
                [self showToastWithMessage:@"失败啊" andDelay:1 andView:nil];
            }
            
        } failure:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showToastWithMessage:@"失败啊" andDelay:1 andView:nil];
        }];

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
