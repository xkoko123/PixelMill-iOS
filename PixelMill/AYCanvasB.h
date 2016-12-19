//
//  AYCanvasB.h
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYBaseCanvasView.h"

@interface AYCanvasB : AYBaseCanvasView
@property (nonatomic,assign) BOOL isPress;



-(void)touchDown;

-(void)touchUp;

-(void)longPress;

-(void)fillUp;
@end
