//
//  AYDrawViewController.m
//  PixelMill
//
//  Created by GoGo on 20/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDrawViewController.h"
#import <Masonry.h>

#import "UIColor+colorWithInt.h"
#import "AYPublicHeader.h"

#import "AYPixelAdapter.h"
#import "AYCanvas.h"
#import "AYCursorDrawView.h"
#import "AYSwipeToolBarView.h"
//#import "AYLayerViewController.h"
#import "AYLayerEditorView.h"
#import "AYLayerTableViewCell.h"
#import "AYColorPickerViewController.h"

@interface AYDrawViewController () <LayerEditorViewDelegate, AYDrawViewDelegate, UIScrollViewDelegate, AYCursorDrawViewDelegate, AYColorPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *layerAdapters;

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, assign) int canvasSize;
@property (nonatomic, strong) AYCursorDrawView *drawView;
@property (nonatomic, strong) UIScrollView *drawBoard;
@property (nonatomic, strong) UIControl *movePanel;

@property (nonatomic,strong) UIControl *previewView;



@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) AYSwipeToolBarView *colorBar;
@property (nonatomic, strong) AYSwipeToolBarView *toolsBar;


@property (nonatomic, weak) AYLayerEditorView *layerEditor;


@end

@implementation AYDrawViewController
{
    BOOL _isMovePanelExpanded;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isMovePanelExpanded = NO;
    _layerAdapters = [[NSMutableArray alloc] init];

    _editIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.size = 32;
    [self initTopBar];
    [self initDrawBoard];
    [self initTapButton];
    [self initToolsBar];
    [self initColorBar];
    [self initMovePanel];
    
}

//顶栏
-(void)initTopBar
{
    _topBar = [[UIView alloc] init];
    _topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topBar];
    
    
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(_topBar).with.offset(2);
    }];
    [backBtn setTintColor:[UIColor blackColor]];

    
    //上传
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setImage:[[UIImage imageNamed:@"upload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didClickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_topBar).with.offset(2);
    }];
    [saveBtn setTintColor:[UIColor blackColor]];
    
    
    //中间！
    _previewView = [[UIControl alloc] init];
    [_topBar addSubview:_previewView];
    [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.center.equalTo(_topBar);
    }];
    [_previewView addTarget:self action:@selector(testtest) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //undo
    UIButton *undoBtn = [[UIButton alloc] init];
    [undoBtn setImage:[[UIImage imageNamed:@"undo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [undoBtn addTarget:self action:@selector(didClickUndoBtn) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:undoBtn];
    [undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_previewView.mas_left).offset(-5);
        make.centerY.equalTo(_topBar);
    }];
    
    //redo
    UIButton *redoBtn = [[UIButton alloc] init];
    [redoBtn setImage:[[UIImage imageNamed:@"redo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [redoBtn addTarget:self action:@selector(didClickRedoBtn) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:redoBtn];
    [redoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(_previewView.mas_right).offset(5);
        make.centerY.equalTo(_topBar);
    }];
}

//画板
-(void)initDrawBoard
{
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = [UIColor blackColor];
    [self.view addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(border.mas_width);
        make.top.equalTo(_topBar.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
    }];
    
    _drawBoard = [[UIScrollView alloc] init];
    _drawBoard.backgroundColor = [UIColor whiteColor];
    _drawBoard.clipsToBounds = YES;
    [border addSubview:_drawBoard];
    CGFloat borderWidth = 2;
    [_drawBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(border.mas_width).offset(-borderWidth*2);
        make.height.equalTo(_drawBoard.mas_width);
        make.top.equalTo(border).offset(borderWidth);
        make.left.equalTo(border.mas_left).offset(borderWidth);
    }];
    _drawBoard.panGestureRecognizer.minimumNumberOfTouches = 2;
    _drawBoard.delaysContentTouches = NO;
    _drawBoard.bounces = NO;
    _drawBoard.delegate = self;
    _drawBoard.minimumZoomScale = 1;
    _drawBoard.maximumZoomScale = 2;
    _drawBoard.zoomScale = 1.0;
    _drawBoard.bouncesZoom = NO;
    
    container = [[UIView alloc] init];
    [_drawBoard addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_drawBoard);
    }];
    
    
    
    _drawView = [[AYCursorDrawView alloc] initWithSize:self.size];
    _drawView.delegate = self;
    _drawView.layerAdapters = self.layerAdapters;
    _drawView.layerBlendMode = YES;
    _drawView.backgroundColor = [UIColor clearColor];
    
    [container addSubview:_drawView];

    [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(_drawBoard.mas_width);
        make.edges.equalTo(container);
    }];
    
    
    
    [self.layerAdapters addObject:_drawView.adapter];
    
    [_drawView layoutIfNeeded];
}

-(void)initTapButton
{
    _tapButton = [[UIButton alloc] init];
    [_tapButton setBackgroundImage:[UIImage imageNamed:@"btn_grey_bg"] forState:UIControlStateNormal];
    [_tapButton addTarget:self action:@selector(didTapButtonDown:) forControlEvents:UIControlEventTouchDown];
    [_tapButton setTitle:@"Tap!!!" forState:UIControlStateNormal];
    _tapButton.titleLabel.font = [UIFont fontWithName:@"Pixel" size:30];
    
    [_tapButton addTarget:self action:@selector(didTapButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tapButton addTarget:self action:@selector(didTapButtonUp:) forControlEvents:UIControlEventTouchUpOutside];

    [self.view addSubview:_tapButton];
    
    [_tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(64);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

-(void)initToolsBar
{
    UIButton *layerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    layerBtn.backgroundColor = [UIColor whiteColor];
    [layerBtn addTarget:self action:@selector(didClickLayerBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:layerBtn];
    [layerBtn setBackgroundImage:[[UIImage imageNamed:@"layer_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [layerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.tapButton.mas_top);
    }];
    [layerBtn setTintColor:[UIColor blackColor]];
    
    
    _toolsBar = [[AYSwipeToolBarView alloc] init];
    _toolsBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolsBar];
    
    [_toolsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.equalTo(layerBtn.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.tapButton.mas_top);
    }];
    
    
    UIButton *penBtn = [[UIButton alloc] init];
    [penBtn setImage:[[UIImage imageNamed:@"pen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [penBtn addTarget:self action:@selector(didClickPenBtn) forControlEvents:UIControlEventTouchUpInside];

    //
    UIButton *eraserBtn = [[UIButton alloc] init];
    [eraserBtn setImage:[[UIImage imageNamed:@"eraser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [eraserBtn addTarget:self action:@selector(didClickEraserBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *fillBtn = [[UIButton alloc] init];
    [fillBtn setImage:[[UIImage imageNamed:@"bucket"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [fillBtn addTarget:self action:@selector(didClickBucketBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *moveBtn = [[UIButton alloc] init];
    [moveBtn setImage:[[UIImage imageNamed:@"move"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [moveBtn addTarget:self action:@selector(didClickMoveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *gridBtn = [[UIButton alloc] init];
    [gridBtn setImage:[[UIImage imageNamed:@"grid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [gridBtn addTarget:self action:@selector(didClickGridBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *aligmentLineBtn = [[UIButton alloc] init];
    [aligmentLineBtn setImage:[[UIImage imageNamed:@"center"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [aligmentLineBtn addTarget:self action:@selector(didClickAligmentLineBtn) forControlEvents:UIControlEventTouchUpInside];

    
    //
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setImage:[[UIImage imageNamed:@"clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(didClickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *lineBtn = [[UIButton alloc] init];
    [lineBtn setImage:[[UIImage imageNamed:@"line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [lineBtn addTarget:self action:@selector(didClickLineBtn) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *circleBtn = [[UIButton alloc] init];
    [circleBtn setImage:[[UIImage imageNamed:@"circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(didClickCircleBtn) forControlEvents:UIControlEventTouchUpInside];


    //
    UIButton *fingerBtn = [[UIButton alloc] init];
    [fingerBtn setImage:[[UIImage imageNamed:@"finger_mode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [fingerBtn setImage:[[UIImage imageNamed:@"finger_mode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [fingerBtn addTarget:self action:@selector(didClickFingerBtn:) forControlEvents:UIControlEventTouchUpInside];

    //
    UIButton *flipHBtn = [[UIButton alloc] init];
    [flipHBtn setImage:[[UIImage imageNamed:@"flipH"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [flipHBtn addTarget:self action:@selector(didClickflipHBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *flipVBtn = [[UIButton alloc] init];
    [flipVBtn setImage:[[UIImage imageNamed:@"flipV"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [flipVBtn addTarget:self action:@selector(didClickflipVBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *rotateBtn = [[UIButton alloc] init];
    [rotateBtn setImage:[[UIImage imageNamed:@"rotate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rotateBtn addTarget:self action:@selector(didClickRotateBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *mirrorBtn = [[UIButton alloc] init];
    [mirrorBtn setImage:[[UIImage imageNamed:@"mirror"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [mirrorBtn setImage:[[UIImage imageNamed:@"mirror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];

    [mirrorBtn addTarget:self action:@selector(didClickMirrorBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    //
    UIButton *pasteBtn = [[UIButton alloc] init];
    [pasteBtn setImage:[[UIImage imageNamed:@"paste"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [pasteBtn addTarget:self action:@selector(didClickPasteBtn) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *copyBtn = [[UIButton alloc] init];
    [copyBtn setImage:[[UIImage imageNamed:@"copy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [copyBtn addTarget:self action:@selector(didClickCopyBtn) forControlEvents:UIControlEventTouchUpInside];


    _toolsBar.btns = [@[penBtn, eraserBtn, fillBtn, moveBtn, lineBtn, circleBtn,fingerBtn,copyBtn, pasteBtn, flipHBtn, flipVBtn, rotateBtn,mirrorBtn, clearBtn,gridBtn, aligmentLineBtn] mutableCopy];
    
}


-(void)initColorBar
{
    _colors = [[NSMutableArray alloc] init];
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<16; i++) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //读取颜色
        NSInteger colorData = [userDefaults integerForKey:[NSString stringWithFormat:@"color%ld",i]];
        UIColor *color;
        if (colorData == 0) {
            CGFloat red = arc4random() % 255 / 255.0;
            CGFloat blue = arc4random() % 255 / 255.0;
            CGFloat green = arc4random() % 255 / 255.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        }else{
            color = [UIColor colorWithInt:colorData];
        }
        
        [_colors addObject:color];
        
        
        UIControl *btn = [[UIControl alloc] init];
        btn.tag = i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor blackColor].CGColor;

        
        [btn setBackgroundColor:color];
        [btn addTarget:self action:@selector(didSlectedColor:) forControlEvents:UIControlEventTouchUpInside];
        [arrM addObject:btn];
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEnterColorPicker:)];
        gr.numberOfTapsRequired = 2;
//        gr.delaysTouchesBegan = NO;
        [btn addGestureRecognizer:gr];
    }
    
    
    _colorBar = [[AYSwipeToolBarView alloc] init];
    _colorBar.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_colorBar belowSubview:_toolsBar];
    
    [_colorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(_toolsBar.mas_top);
    }];
    
    _colorBar.btns = arrM;
    
    //选中第一个颜色
    [self didSlectedColor:[arrM objectAtIndex:0]];

}


- (void)initMovePanel
{
    _movePanel = [[UIControl alloc] init];
    _movePanel.alpha = 0;
    _movePanel.backgroundColor = [UIColor blackColor];
    [_movePanel addTarget:self action:@selector(dismissMovePanel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_movePanel];
    [_movePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_drawBoard);
        make.center.equalTo(_drawBoard);
    }];
    
    
    UIButton *upBtn = [[UIButton alloc] init];
    upBtn.tag = 0;
    [_movePanel addSubview:upBtn];
    [upBtn setImage:[[UIImage imageNamed:@"up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [upBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(_drawBoard);
        make.top.equalTo(_drawBoard.mas_top).offset(20);
    }];
    
    
    UIButton *downBtn = [[UIButton alloc] init];
    downBtn.tag = 1;
    [_movePanel addSubview:downBtn];
    [downBtn setImage:[[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(_drawBoard);
        make.bottom.equalTo(_drawBoard.mas_bottom).offset(-20);
    }];
    
    
    
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.tag = 2;
    [_movePanel addSubview:leftBtn];
    [leftBtn setImage:[[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerY.mas_equalTo(_drawBoard);
        make.left.equalTo(_drawBoard.mas_left).offset(20);
    }];

    
    
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = 3;
    [_movePanel addSubview:rightBtn];
    [rightBtn setImage:[[UIImage imageNamed:@"right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(didClickMove:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerY.mas_equalTo(_drawBoard);
        make.right.equalTo(_drawBoard.mas_right).offset(-20);
    }];
    
    
    
}

-(void)resetLayer
{
    
    
    

//    for (int i=0; i<self.layerAdapters.count; i++) {
//        AYPixelAdapter *adapter = [self.layerAdapters objectAtIndex:i];
//
//        if (i == self.editIndex) {
//            _drawView.adapter = adapter;
//            _drawView.layerAdapters = self.layerAdapters;
//            _drawView.layerBlendMode = YES;
//        }else{
//            if (adapter.visible == NO) {
//                break;
//            }
//            AYCanvas *layer = [[AYCanvas alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) andSize:32];
//            layer.adapter = adapter;
//            layer.backgroundColor = [UIColor clearColor];
//            layer.showExtendedContent = NO;
//            
//            //上
//            if (i > self.editIndex) {
//                [_drawBoard insertSubview:layer atIndex:0];
//                //下
//            }else if(i < self.editIndex){
//                [_drawView addSubview:layer];
//            }
//        }
//    }

}



-(void)didClickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)didClickSaveBtn
{
    UIImage *image = [self.drawView exportImage];
    UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:ac animated:YES completion:NULL];
}

-(void)didClickUndoBtn
{
    [self.drawView undo];
    [self refreshPreviewView];
}

-(void)didClickPenBtn
{
    self.drawView.currentType = PEN;
}

-(void)didClickEraserBtn
{
    //TODO: eraser
    self.drawView.currentType = ERASER;
}

-(void)didClickClearBtn
{
    [self.drawView clearCanvas];
    [self refreshPreviewView];

}

-(void)didClickRedoBtn
{
    [self.drawView redo];
    [self refreshPreviewView];
}

-(void)didClickCircleBtn
{
    self.drawView.currentType = CIRCLE;
}

-(void)didClickBucketBtn
{
    [self.drawView setCurrentType:BUCKET];
}

-(void)didClickLineBtn
{
    [self.drawView setCurrentType:LINE];
}

-(void)didTapButtonDown:(UIButton*)sender
{
    sender.alpha = 0.95;
    [self.drawView touchDown];
}

-(void)didTapButtonUp:(UIButton*)sender
{
    sender.alpha = 1;
    [self.drawView touchUp];
}


-(AYLayerEditorView *)layerEditor
{
    if (_layerEditor == nil) {
        AYLayerEditorView *v = [[AYLayerEditorView alloc] initWithEditIndex:self.editIndex andAdapters:self.layerAdapters];
        
        v.delegate = self;
        v.size = self.size;

        [self.view addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, -150, 0, -150));
            
        }];
        [v layoutIfNeeded];
        
        _layerEditor = v;
    }
    return _layerEditor;
}

-(void)didClickLayerBtn
{
    
    self.layerEditor.editIndex = self.editIndex;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.layerEditor mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.layerEditor layoutIfNeeded];
    }];
    
    
}

-(void)didClickGridBtn
{
    self.drawView.showGrid = !self.drawView.showGrid;
}

-(void)didClickAligmentLineBtn
{
    self.drawView.showAlignmentLine = !self.drawView.showAlignmentLine;
}

-(void)didClickMoveBtn
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

-(void)didClickFingerBtn:(UIButton*)sender;
{
    self.drawView.fingerMode = !self.drawView.fingerMode;
    if (self.drawView.fingerMode) {
        [sender setSelected:YES];
    }else{
        [sender setSelected:NO];
    }
}


-(void)didSlectedColor:(UIView*)sender
{
    [self unSelectAllColor];
    UIColor *color = self.colors[sender.tag];
    self.drawView.slectedColor = color;
    sender.layer.borderWidth = 2;
    //TODO: ssss
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissMovePanel
{
    [UIView animateWithDuration:0.2 animations:^{
        self.movePanel.alpha = 0;
    }];
    _isMovePanelExpanded = NO;
    
    if (self.drawView.isInPaste) {
        [self.drawView pasteShape];
    }
}

-(void)didClickMove:(UIControl*)c
{
    switch (c.tag) {
        case 0:
            if (self.drawView.isInPaste) {
                [self.drawView moveSlectedPixels:MOVE_UP];
            }else{
                [self.drawView move:MOVE_UP];
            }
            break;
        case 1:
            if (self.drawView.isInPaste) {
                [self.drawView moveSlectedPixels:MOVE_DOWN];
            }else{
                [self.drawView move:MOVE_DOWN];
            }
            break;
        case 2:
            if (self.drawView.isInPaste) {
                [self.drawView moveSlectedPixels:MOVE_LEFT];
            }else{
                [self.drawView move:MOVE_LEFT];
            }
            break;
        case 3:
            if (self.drawView.isInPaste) {
                [self.drawView moveSlectedPixels:MOVE_RIGHT];
            }else{
                [self.drawView move:MOVE_RIGHT];
            }
            break;
        default:
            break;
    }
    [self refreshPreviewView];
}

//代理。。修改了visible属性需要刷新显示！
-(void)didChangedVisible
{
    [self.drawView setNeedsDisplay];
    [self refreshPreviewView];
}

//绘图控件的代理方法，，撤销时adpter是深拷贝的，，所以要复制过来，，
-(void)drawViewChangeAdapter:(AYPixelAdapter *)adapter
{
    adapter.visible = [self.layerAdapters objectAtIndex:self.editIndex];
    [self.layerAdapters replaceObjectAtIndex:self.editIndex withObject:adapter];
}

//代理，，layer侧滑关闭时需要修改绘图控件的编辑层
-(void)didChangedEditIndex:(NSInteger)index
{
    self.editIndex = index;
    _drawView.adapter = [self.layerAdapters objectAtIndex:self.editIndex];
}

//delegate
-(void)drawViewHasRefreshContent
{
    [self refreshPreviewView];
}

-(void)colorPickerDidSlectedColor:(UIColor *)color
{
    _drawView.slectedColor = color;
}

-(void)didClickRotateBtn:(UIButton*)sender
{
    [self.drawView rotate90];
    [self refreshPreviewView];

}


-(void)didClickflipHBtn:(UIButton*)sender
{
    [self.drawView flipHorizontal];
    [self refreshPreviewView];

}


-(void)didClickflipVBtn:(UIButton*)sender
{
    [self.drawView flipVertical];
    [self refreshPreviewView];

}

-(void)didClickMirrorBtn:(UIButton*)sender
{
    [self.drawView setMirrorMode:!self.drawView.mirrorMode];
    if (self.drawView.mirrorMode) {
        [sender setSelected:YES];
    }else{
        [sender setSelected:NO];
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

-(void)refreshPreviewView
{
    self.previewView.layer.contents = _drawView.layer.contents;
    [self.previewView.layer display];
}

-(void)unSelectAllColor
{
    
    for (UIView *v in [_colorBar allViews]) {
        v.layer.borderWidth = 0;
    }
}

-(void)willEnterColorPicker:(UIGestureRecognizer*)gr
{
    NSInteger index = gr.view.tag;
    AYColorPickerViewController *vc = [[AYColorPickerViewController alloc] init];
    vc.colors = self.colors;
    vc.index = index;
    vc.btn = gr.view;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)pasteSlectPixels
{
    [UIView animateWithDuration:0.2 animations:^{
        self.movePanel.alpha = 0.7;
    }];
    _isMovePanelExpanded = YES;
    self.drawView.isInPaste = YES;

}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [_drawView layoutIfNeeded];
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [_drawView superview];
}

-(void)didClickPasteBtn
{
    if (self.drawView.isInPaste) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.movePanel.alpha = 0.7;
    }];
    _isMovePanelExpanded = YES;
    self.drawView.isInPaste = YES;
    [self.drawView setNeedsDisplay];
    
    [self showToastWithMessage:@"移动复制的内容" andDelay:1];

}

-(void)didClickCopyBtn
{
    if (self.drawView.currentType == COPY) {
        return;
    }
    self.drawView.currentType = COPY;
    [self showToastWithMessage:@"涂画要复制的内容" andDelay:1];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
