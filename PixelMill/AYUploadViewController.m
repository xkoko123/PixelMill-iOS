//
//  AYUploadViewController.m
//  PixelMill
//
//  Created by GoGo on 28/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYUploadViewController.h"
#import "AYTextView.h"
#import <YYImage.h>
#import <Masonry.h>
#import "AYNetManager.h"
#import "AYNetworkHelper.h"
#import <MBProgressHUD.h>
@interface AYUploadViewController ()<UITextViewDelegate>

@end

@implementation AYUploadViewController
{
    YYAnimatedImageView *_imageView;
    AYTextView *_textView;
    UIButton *sendBtn;
    NSString *_imageType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTopBar];
    [self initImage];
    [self initTextEdit];
}

-(instancetype)initWithImage:(UIImage*)image andType:(NSString *)type
{
    self= [super init];
    if (self) {
        _image = image;
        _imageType = type;
    }
    return self;
}

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
    [saveBtn setTitle:@"发布" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didClickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:saveBtn];
    saveBtn.frame = CGRectMake(self.view.frame.size.width - 62, 2, 60, 40);
    [saveBtn setTintColor:[UIColor blackColor]];
    
    //导出
    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [exportBtn setTitle:@"保存到本地" forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(didClickExportBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:exportBtn];
    exportBtn.frame = CGRectMake(self.view.frame.size.width - 167, 2, 100, 40);
    [exportBtn setTintColor:[UIColor blackColor]];
    
}

-(void)initImage
{
    _imageView = [[YYAnimatedImageView alloc] init];
    
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(3, 3);
    _imageView.layer.shadowRadius = 3;
    _imageView.layer.shadowOpacity = 0.8;
    [self.view addSubview:_imageView];
    

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(5);
        make.width.height.mas_equalTo(150);
        make.top.equalTo(self.view).offset(64);
    }];
    _imageView.backgroundColor = [UIColor grayColor];
    [_imageView setImage: _image];
}

-(void)initTextEdit
{
    _textView = [[AYTextView alloc] init];
    _textView.myPlaceholder=@"what's on your mind";
    _textView.myPlaceholderColor= [UIColor lightGrayColor];
    _textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageView.mas_trailing).offset(10);
        make.trailing.equalTo(self.view).offset(-5);
        make.height.mas_equalTo(150);
        make.top.equalTo(self.view).offset(64);
    }];
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"SEND" forState:UIControlStateNormal];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didClickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickExportBtn
{
        UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[_image.yy_imageDataRepresentation] applicationActivities:nil];
    [self presentViewController:ac animated:YES completion:NULL];
}

-(void)didClickSaveBtn
{
    [_textView resignFirstResponder];
    if ([AYNetworkHelper isNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"正在发送";

        [[AYNetManager shareManager] postPaint:_image describe:_textView.text mimeType:_imageType progress:^(NSProgress *progress) {
            CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
            hud.progress = stauts;
        } Success:^(id responseObject) {
            [hud hideAnimated:YES];
            [self showToastWithMessage:@"发送成功" andDelay:1.5 andView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [self showToastWithMessage:@"发送失败" andDelay:2 andView:nil];
        }];

    }else{
        [self showToastWithMessage:@"没有网络" andDelay:2 andView:nil];

    }
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
