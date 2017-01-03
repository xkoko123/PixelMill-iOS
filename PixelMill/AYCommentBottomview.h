//
//  AYCommentBottomview.h
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCommentBottomViewDelegate <NSObject>

@optional
-(void)commentBottomViewDidClickSend:(NSString*)text;

@end


@interface AYCommentBottomview : UIView
@property (nonatomic,assign)id delegate;

-(void)setPlaceHolder:(NSString*)text;
-(void)clearText;

@end
