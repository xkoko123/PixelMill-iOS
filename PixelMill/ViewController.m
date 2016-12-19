//
//  ViewController.m
//  PixelMill
//
//  Created by GoGo on 14/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "ViewController.h"
#import "AYCanvasA.h"
#import "AYCanvasB.h"
@interface ViewController ()
@property (nonatomic,strong) AYCanvasA *canvas;
@property (nonatomic,strong)NSMutableArray *btnArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"UNDO" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 20, 60, 30);
    [btn addTarget:self action:@selector(undoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"CLEAR" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 20, 60, 30);
    [btn2 addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"TEST" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(180, 20, 60, 30);
    [btn3 addTarget:self action:@selector(testtest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setTitle:@"FILL" forState:UIControlStateNormal];
    btn4.frame = CGRectMake(250, 20, 60, 30);
    [btn4 addTarget:self action:@selector(fillup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];

    

    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = self.view.frame.size.width / 16;
    NSMutableArray *pallets = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc] init];
    for (int i=0; i<16; i++) {
        UIColor *color = [UIColor colorWithRed:arc4random()%255 / 255.0
                        green:arc4random()%255 / 255.0
                         blue:arc4random()%255 / 255.0
                        alpha:1];
        [pallets addObject:color];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = color;
        if (i==0) {
            btn.frame = CGRectMake(btn.frame.origin.x, self.view.frame.size.height - 60 - 15, width, 60 + 15);
        }else{
            btn.frame = CGRectMake(width*i, self.view.frame.size.height - 60, width, 60);
        }
        [btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        [_btnArray addObject:btn];
    }
    
    _canvas = [[AYCanvasA alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width) andSize:32 pallets:pallets];
    _canvas.currentColor = 0;
    [self.view addSubview:self.canvas];

    
    UIControl *view4 = [[UIControl alloc] init];
    view4.backgroundColor = [UIColor blueColor];
    view4.frame = CGRectMake(0, self.canvas.frame.size.height + self.canvas.frame.origin.y,
                            self.view.frame.size.width, 100);
    [self.view addSubview:view4];
    
    
//    [view4 addTarget:self action:@selector(clickclick) forControlEvents:UIControlEventTouchUpInside];
    
    [view4 addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [view4 addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];



}

-(void)touchDown
{
    if ([self.canvas isMemberOfClass:[AYCanvasB class]]) {
        id x = self.canvas;
        [x touchDown];
    }
    
}

-(void)touchUp
{
    
    if ([self.canvas isMemberOfClass:[AYCanvasB class]]) {
        id x = self.canvas;
        [x touchUp];
    }
}

-(void)clear
{
    [self.canvas clearCanvas];
}

-(void)undoBtn
{
    [self.canvas undo];
}

-(void)testtest
{
    [self.canvas moveCanvas:MOVECANVAS_LEFT];
}

-(void)selectColor:(UIButton*)btn
{
    CGFloat width = self.view.frame.size.width / 16;

    [UIView animateWithDuration:0.1 animations:^{
        for (UIButton *b in self.btnArray) {
            b.frame = CGRectMake(b.frame.origin.x, self.view.frame.size.height - 60, width, 60);
        }
    }];

    [UIView animateWithDuration:0.1 animations:^{
        btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 15, width, 60 + 15);
    }];
    self.canvas.currentColor = btn.tag;
}

-(void)fillup
{
    [_canvas fillUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
