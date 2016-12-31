//
//  AYGifFramesTableViewCell.h
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYPixelAdapter;

@interface AYGifFramesTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImage *image;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andAdapter:(AYPixelAdapter*)adapter;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

@end
