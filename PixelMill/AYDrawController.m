//
//  AYDrawController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDrawController.h"
#import "AYCursorDrawView.h"
#import "UIColor+colorWithInt.h"
#import "AYPublicHeader.h"
#import "AYPixelsManage.h"

@interface AYDrawController ()
@property (nonatomic, strong)UIView *panelbar;
@property (nonatomic, strong)UIButton *undoBtn;
@property (nonatomic, strong)UIButton *clearBtn;
@property (nonatomic, strong)UIButton *fillBtn;
@property (nonatomic, strong)UIButton *moveBtn;
@property (nonatomic, strong)AYCursorDrawView *drawView;
@property (nonatomic, strong)UIControl *movePanel;
@end

@implementation AYDrawController
{
    NSArray *_btnArray;
    BOOL _isMovePanelExpanded;
    CGFloat _barHeight;
    CGFloat _canvasHeight;
    CGFloat _tapbtnHeight;
    CGFloat _colorHeight;
    CGFloat _slectedColorOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isMovePanelExpanded = NO;
    //--------delete
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (int i=0; i<16; i++) {
        int red = arc4random()%256;
        int green = arc4random()%256;
        int blue = arc4random()%256;
        NSInteger data = red * 256 * 256 + green * 256 + blue;
        [arrM addObject:@(data)];
    }
    self.pallets = [arrM copy];
    
    self.canvas_size = 32;
    //--------
    
    _slectedColorOffset = 10;
    _barHeight = 44;
    _canvasHeight = self.view.frame.size.width;
    _tapbtnHeight = (self.view.frame.size.height - _barHeight*2 - _canvasHeight - _slectedColorOffset)/5;
    _colorHeight = _tapbtnHeight *2;
    _tapbtnHeight = _tapbtnHeight*3;
    
    
    
    [self initTopBar];
    [self initCanvas];
    [self initPanelBar];
    [self initPalletSelector];
    [self initMovePanel];
    
    
    // Do any additional setup after loading the view.
}

-(void) initTopBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    //BACK
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(2, 2, 40, 40);
    [backBtn addTarget:self action:@selector(didClickBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    //上传
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [uploadBtn setImage:[[UIImage imageNamed:@"upload"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    uploadBtn.frame = CGRectMake(self.view.frame.size.width - 42, 2, 40, 40);
    [uploadBtn addTarget:self action:@selector(didClickUpload) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:uploadBtn];
    
    
}


-(void)initCanvas
{
    CGRect viewRect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.width);
    _drawView = [[AYCursorDrawView alloc] initWithFrame:viewRect ansSize:32];
    _drawView.slectedColor = [self.pallets[0] intValue];
    [self.view addSubview:_drawView];
    
    //tapbtn;
    UIControl *tapBar = [[UIControl alloc] init];
    tapBar.backgroundColor = [UIColor grayColor];
    tapBar.frame = CGRectMake(0, self.view.frame.size.height - _tapbtnHeight,
                             self.view.frame.size.width, _tapbtnHeight);
    
    [tapBar addTarget:self action:@selector(didTapBartouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [tapBar addTarget:self action:@selector(didTapBartouchUp:) forControlEvents:UIControlEventTouchUpOutside];

    
    [tapBar addTarget:self action:@selector(didTapBartouchDown:) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:tapBar];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2,
                                                             (tapBar.frame.size.height - 40)/2, 200, 40)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    lab.text = @"TAP!!";
//    lab.font = [UIFont systemFontOfSize:40 weight:10];
    lab.font = [UIFont fontWithName:@"Pixel" size:40];

    lab.textColor = [UIColor whiteColor];
    [tapBar addSubview:lab];
    
}


-(void)initPanelBar
{
    _panelbar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                         _drawView.frame.origin.y + _drawView.frame.size.height,
                                                         self.view.frame.size.width,
                                                         44)];
    _panelbar.backgroundColor = [UIColor colorWithRed:39 / 255.0 green:39 / 255.0 blue:39 / 255.0 alpha:1];
    [self.view addSubview:_panelbar];
    
    
    
    //eraser
    UIButton *eraserBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [eraserBtn setImage:[[UIImage imageNamed:@"eraser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    eraserBtn.frame = CGRectMake(10, 2, 40, 40);
    [eraserBtn addTarget:self action:@selector(didClickEraser:) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:eraserBtn];
    
    //FILL
    _fillBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_fillBtn setImage:[[UIImage imageNamed:@"bucket"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    _fillBtn.frame = CGRectMake(50, 2, 40, 40);
    [_fillBtn addTarget:self action:@selector(didClickFill) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:_fillBtn];
    
    
    //MOVE
    _moveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_moveBtn setImage:[[UIImage imageNamed:@"move"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    _moveBtn.frame = CGRectMake(90, 2, 40, 40);
    [_moveBtn addTarget:self action:@selector(didClickMove) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:_moveBtn];
    
    
    //Grid
    UIButton *gridBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [gridBtn setImage:[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    gridBtn.frame = CGRectMake(130, 2, 40, 40);
    [gridBtn addTarget:self action:@selector(didClickGridBtn) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:gridBtn];
    
    //centerLine
    
    UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [lineBtn setImage:[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    lineBtn.frame = CGRectMake(170, 2, 40, 40);
    [lineBtn addTarget:self action:@selector(didClickLineBtn) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:lineBtn];
    
    //UNDO
    _undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_undoBtn setImage:[[UIImage imageNamed:@"undo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _undoBtn.frame = CGRectMake(210, 2, 40, 40);
    [_undoBtn addTarget:self action:@selector(didClickUndo) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:_undoBtn];
    
    
    
    //REDO
    UIButton *redoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [redoBtn setImage:[[UIImage imageNamed:@"redo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    redoBtn.frame = CGRectMake(250, 2, 40, 40);
    [redoBtn addTarget:self action:@selector(didClickRedo) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:redoBtn];

    
    
    
    //CLEAR
    _clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clearBtn setImage:[[UIImage imageNamed:@"clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _clearBtn.frame = CGRectMake(290, 2, 40, 40);
    [_clearBtn addTarget:self action:@selector(didClickClear) forControlEvents:UIControlEventTouchUpInside];
    [_panelbar addSubview:_clearBtn];
    



}

-(void)initPalletSelector
{
    NSMutableArray *arryM = [[NSMutableArray alloc] init];
    CGFloat width = self.view.frame.size.width / 16.0;
    for (int i=0;i<self.pallets.count; i++) {
        UIColor *color = [UIColor colorWithInt:[self.pallets[i] intValue]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        btn.backgroundColor = color;
        if (i==0) {
            btn.frame = CGRectMake(0,
                                   self.view.frame.size.height - _tapbtnHeight - _colorHeight- _slectedColorOffset,
                                   width,
                                   _colorHeight + _slectedColorOffset);
        }else{
            btn.frame = CGRectMake(width*i,
                                   self.view.frame.size.height - _tapbtnHeight - _colorHeight,
                                   width,
                                   _colorHeight);
        }
        
        [btn addTarget:self action:@selector(didSelectColor:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [arryM addObject:btn];
        _btnArray = [arryM copy];
        [self.view addSubview:btn];
    }
}

- (void)initMovePanel
{
    _movePanel = [[UIControl alloc] initWithFrame:CGRectMake(0,
                                                             _barHeight,
                                                             self.view.frame.size.width,
                                                             self.view.frame.size.width)];
    _movePanel.alpha = 0;
    _movePanel.backgroundColor = [UIColor blackColor];
    [_movePanel addTarget:self action:@selector(dismissMovePanel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_movePanel];
    
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake((_movePanel.frame.size.width - 70)/2,
                                                                10,
                                                                70,
                                                                 70)];
    upBtn.tag = 0;
    [_movePanel addSubview:upBtn];
    [upBtn setImage:[[UIImage imageNamed:@"up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [upBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake((_movePanel.frame.size.width - 70)/2,
                                                                 _movePanel.frame.size.height - 80,
                                                                 70,
                                                                 70)];
    downBtn.tag = 1;
    [_movePanel addSubview:downBtn];
    [downBtn setImage:[[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [downBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,
                                                                   (_movePanel.frame.size.height - 70)/2,
                                                                   70,
                                                                   70)];
    leftBtn.tag = 2;
    [_movePanel addSubview:leftBtn];
    [leftBtn setImage:[[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [leftBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_movePanel.frame.size.width - 80,
                                                                   (_movePanel.frame.size.height - 70)/2,
                                                                   70,
                                                                   70)];
    rightBtn.tag = 3;
    [_movePanel addSubview:rightBtn];
    [rightBtn setImage:[[UIImage imageNamed:@"right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [rightBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];

    
    
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
-(void)didClickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)didClickUndo
{
    [self.drawView undo];
}

-(void)didClickRedo
{
    [self.drawView redo];
}

-(void)didClickClear
{
    [self.drawView clearCanvas];
}

-(void)didClickFill
{
    [self.drawView setCurrentType:FILL];
}

-(void)didClickMove
{
    if(_isMovePanelExpanded){
        [self dismissMovePanel];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.movePanel.alpha = 0.7;
        }];
        _isMovePanelExpanded = YES;
    }
}

-(void)didClickUpload
{
    // TODO: UPLOAD
//    [self.drawView.pixelsManage exportData];
    UIImage *image =  [self.drawView exportImage];
    UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
        [self presentViewController:ac animated:YES completion:NULL];


}

-(void)didClickGridBtn
{
    self.drawView.showGrid = !self.drawView.showGrid;
}


-(void)didClickLineBtn
{
    self.drawView.showAlignmentLine = !self.drawView.showAlignmentLine;
}

-(void)didTapBartouchUp:(UIControl*)btn
{
    btn.alpha = 1.0;
    if ([self.drawView isMemberOfClass:[AYCursorDrawView class]]) {
        id x = self.drawView;
        [x touchUp];
    }
}

-(void)didTapBartouchDown:(UIControl*)btn
{
    btn.alpha = 0.8;
    if ([self.drawView isMemberOfClass:[AYCursorDrawView class]]) {
        id x = self.drawView;
        [x touchDown];
    }
}

-(void)didSelectColor:(UIButton*)btn
{
//    CGFloat width = self.view.frame.size.width / 16;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self disSelectAllColor];
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        btn.frame = CGRectMake(btn.frame.origin.x,
                               self.view.frame.size.height - _tapbtnHeight - _colorHeight - _slectedColorOffset,
                               btn.frame.size.width,
                               _colorHeight + _slectedColorOffset);
    }];
    
    self.drawView.slectedColor = [self.pallets[btn.tag] intValue];
}

- (void) disSelectAllColor
{
    for (UIButton *b in _btnArray) {
        b.frame = CGRectMake(b.frame.origin.x,
                             self.view.frame.size.height - _tapbtnHeight - _colorHeight,
                             b.frame.size.width,
                             _colorHeight);
    }
}



-(void)dismissMovePanel
{
    [UIView animateWithDuration:0.2 animations:^{
        self.movePanel.alpha = 0;
    }];
    _isMovePanelExpanded = NO;
}

-(void)didClickMove:(UIControl*)c
{
    switch (c.tag) {
        case 0:
            [self.drawView move:MOVE_UP];
            break;
        case 1:
            [self.drawView move:MOVE_DOWN];
            break;
        case 2:
            [self.drawView move:MOVE_LEFT];
            break;
        case 3:
            [self.drawView move:MOVE_RIGHT];
            break;
        default:
            break;
    }
}
-(void)didClickEraser:(UIButton *)btn
{
    [self disSelectAllColor];
    self.drawView.slectedColor = self.drawView.bgColor;
}


@end
