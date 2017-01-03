//
//  AYPaintCollectionViewCell.m
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYPaintCollectionViewCell.h"
#import <YYWebImage.h>
#import <Masonry.h>
#import "AYPaint.h"
@implementation AYPaintCollectionViewCell
{
    YYAnimatedImageView *_imageView;
    UILabel *_descLabel;
    UILabel *_nameLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _imageView = [[YYAnimatedImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(self.mas_width).offset(-2);
            make.top.equalTo(self.mas_top).offset(1);
            make.centerX.equalTo(self);
        }];
        _imageView.backgroundColor = [UIColor lightGrayColor];

        
        UIView *infoBar = [[UIView alloc] init];
        [self.contentView addSubview:infoBar];
        [infoBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(1);
            make.width.equalTo(self).offset(-2);
            make.top.equalTo(_imageView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
        }];
        infoBar.backgroundColor = [UIColor whiteColor];
        
        
        _nameLabel = [[UILabel alloc] init];
        [infoBar addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoBar.mas_top).offset(4);
            make.left.equalTo(infoBar.mas_left).offset(6);
            make.height.mas_equalTo(14);
        }];
        [_nameLabel setText:@"@BaKaYsyls"];
        [_nameLabel setFont:[UIFont systemFontOfSize:13 weight:1]];
        
        
        _descLabel = [[UILabel alloc] init];
        [infoBar addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom);
            make.left.equalTo(infoBar.mas_left).offset(6);
            make.right.equalTo(infoBar.mas_right).offset(-6);
            make.bottom.equalTo(infoBar.mas_bottom).offset(-1);
        }];
        
        _descLabel.numberOfLines = -1;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [_descLabel setFont:[UIFont systemFontOfSize:12]];
        [_descLabel setTextColor:[UIColor grayColor]];
        [_descLabel setText:@"heiheihahahhfsdfdgdsfghgfgdfsdsfgdssdfdffdsfdfdahhaixinba"];
        
    }
    return self;
}

-(void)setPaintModel:(AYPaint *)paintModel
{
    _paintModel = paintModel;

    NSString *urlString = [@"http://192.168.1.103:8000" stringByAppendingString:paintModel.image];
    _imageView.yy_imageURL = [NSURL URLWithString:urlString];
    _nameLabel.text = [@"@" stringByAppendingString: paintModel.author];
    _descLabel.text = paintModel.describe;
}

@end
