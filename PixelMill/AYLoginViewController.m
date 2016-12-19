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

@interface AYLoginViewController ()
@property (nonatomic, strong)UIImageView *logoImg;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *registBtn;

@property (nonatomic, strong)AYPopupWindow *popView;
@end

@implementation AYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:17 / 255.0 green:17 / 255.0 blue:17 / 255.0 alpha:1];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void) initView
{
    UIColor *tintColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    _logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab4"]];
    _logoImg.frame = CGRectMake(self.view.frame.size.width/2 - 100, 100, 200, 200);
    [self.view addSubview:_logoImg];
    
    
    _registBtn = [[UIButton alloc] init];
    _registBtn.frame = CGRectMake(20,
                                  self.view.frame.size.height - 40 - 20,
                                  100,
                                  40);
    [_registBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn.titleLabel setFont:[UIFont fontWithName:@"Pixel" size:15]];
    [_registBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_bg"] forState:UIControlStateNormal];
    
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

    
}
-(AYPopupWindow *)popView
{
    if (_popView == nil) {
        _popView = [[AYPopupWindow alloc] initWithFrame:CGRectMake(0,
                                                                   -248,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
        _popView.hidden = YES;
        [self.view addSubview:_popView];
    }
    return _popView;
}

-(void)didLoginBtnClicked
{
    self.popView.hidden = NO;
    [self.popView.userField becomeFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.popView.frame = CGRectMake(0,
                                   0,
                                   self.view.frame.size.width,
                                        self.view.frame.size.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
// TODO: delete
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
