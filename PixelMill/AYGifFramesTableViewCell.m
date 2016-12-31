//
//  AYGifFramesTableViewCell.m
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYGifFramesTableViewCell.h"
#import "AYPixelAdapter.h"
#import "AYCanvas.h"
#import "AYGifFramesView.h"
#import "AYDragableTableView.h"

@implementation AYGifFramesTableViewCell
{
    UIImageView *_imageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, height-10, height-10)];
        
        [self.contentView addSubview:_imageView];
        
    }
    return self;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andAdapter:(AYPixelAdapter*)adapter
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}



-(void)setImage:(UIImage *)image
{
    _image = image;
    [_imageView setImage:image];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(deleteCell:));
}

-(void)deleteCell:(UIMenuController*)sender
{
    AYGifFramesView *view;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[AYGifFramesView class]]) {
            view = (AYGifFramesView*)nextResponder;
        }
    }
    
    [view removeFramesAtIndex:self.tag];
}




@end
