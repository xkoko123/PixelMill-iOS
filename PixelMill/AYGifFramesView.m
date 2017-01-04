//
//  AYGifFramesView.m
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYGifFramesView.h"
#import "AYDragableTableView.h"
#import "AYCanvas.h"
#import "AYGifFramesTableViewCell.h"
#import "AYPixelAdapter.h"
#import "AYGifPlayView.h"
#import <YYImage.h>
@interface AYGifFramesView() <UITableViewDelegate,UITableViewDataSource,AYDragableTableViewDelegate>

@end

@implementation AYGifFramesView
{
    UIButton *addButton;
    CGFloat _height;
    YYAnimatedImageView *_imageView;
    NSMutableArray *_images;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame Frames:(NSMutableArray *)frames andBottomOffset:(CGFloat)bottomOffset Height:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _frames = frames;
        _images = [[NSMutableArray alloc] init];
        [self initImgaes];
        
        _bottomOffset = bottomOffset;
        _height = height;
        
        
        //tableview
        _tableView = [[AYDragableTableView alloc] init];
        [self addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.frame = CGRectMake((self.frame.size.width) / 2 - height/2,
                                      self.frame.size.height - bottomOffset - (self.frame.size.width)/2 - height/2,
                                      height,
                                      self.frame.size.width);
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _tableView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
        _tableView.rowHeight = height;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.frames.count+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        //画布位置
        _imageView = [[YYAnimatedImageView alloc] init];
        CGFloat width = self.frame.size.width;
        _imageView.frame = CGRectMake(0, 44, width, width);
        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageView.layer.shadowOffset = CGSizeMake(3, 3);
        _imageView.layer.shadowRadius = 3;
        _imageView.layer.shadowOpacity = 0.8;
        [self addSubview:_imageView];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.frames.count + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //add
    if (indexPath.row == self.frames.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addcell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcell"];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            cell.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _height-10, _height-10)];
            [imageView setImage:[UIImage imageNamed:@"gif_add"]];
            [cell.contentView addSubview:imageView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tag = indexPath.row;
        return cell;
        
    //play
    }else if (indexPath.row == self.frames.count+1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playcell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playcell"];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _height-10, _height-10)];
            [imageView setImage:[UIImage imageNamed:@"gif_play"]];
            [cell.contentView addSubview:imageView];


        }
        cell.tag = indexPath.row;
        return cell;
        
    //....
    }else{
        UIImage *image = [_images objectAtIndex:indexPath.row];
        
        
        AYGifFramesTableViewCell *cell = (AYGifFramesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[AYGifFramesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell" height:_height];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.image = image;
        cell.tag = indexPath.row;
        return cell;
    }
}

-(void)dragableTableViewDidMoveAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.frames exchangeObjectAtIndex:
     sourceIndexPath.row withObjectAtIndex:toIndexPath.row];
    [_images exchangeObjectAtIndex:
     sourceIndexPath.row withObjectAtIndex:toIndexPath.row];

    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.frames.count) {
        if ([self.delegate respondsToSelector:@selector(gifFrameViewDidClickAddBtn:)]) {
            [self.delegate gifFrameViewDidClickAddBtn:self];
        }
    }else if (indexPath.row == self.frames.count + 1){
        [self showGif];
    }else{
        AYGifFramesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy,  nil]];
        [menu setTargetRect:cell.bounds inView:cell];
        [menu update];
        [menu setMenuVisible:YES animated:YES];


    }
}

-(void)reloadAndScrollToRight
{
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.frames.count+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


-(BOOL)dragableTableViewShouldDragAtIndexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row == self.frames.count || indexpath.row == self.frames.count + 1) {
        return NO;
    }
    return YES;
}


-(void)showGif
{
    UIImage *image = [AYPixelAdapter getGifImageWithAdapters:self.frames Duration:0.3 reverse:NO andSize:self.frame.size.width];
    [_imageView setImage:image];
}


-(void)initImgaes
{
    for (AYPixelAdapter *adapter in self.frames) {
        UIImage *image = [adapter exportImageWithSize:self.frame.size.width];
        [_images addObject:image];
    }
}

-(void)removeFramesAtIndex:(NSInteger)index
{
    [self.frames removeObjectAtIndex:index];
    [_images removeObjectAtIndex:index];
    [self.tableView reloadData];
}

-(void)didAddedFrames
{
    AYPixelAdapter *adapter = [self.frames lastObject];
    UIImage *image = [adapter exportImageWithSize:100];
    [_images addObject:image];
}


@end
