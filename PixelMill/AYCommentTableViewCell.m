//
//  AYCommentTableViewCell.m
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYCommentTableViewCell.h"
#import <Masonry.h>
#import <YYWebImage.h>
#import "AYComment.h"
@implementation AYCommentTableViewCell
{
    UIImageView *_avatarImage;
    UILabel *_nameLabel;
    UILabel *_textLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _avatarImage = [[UIImageView alloc] init];
    [self addSubview:_avatarImage];
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(44));
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(20);
    }];
    _avatarImage.layer.cornerRadius = 22;
    _avatarImage.layer.masksToBounds = YES;
    
    _nameLabel = [[UILabel alloc] init];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImage.mas_right).offset(10);
        make.height.equalTo(@(20));
        make.top.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-10);
    }];
    [_nameLabel setTextColor:[UIColor colorWithRed:140/255.0 green:150/255.0 blue:151/255.0 alpha:1]];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = -1;
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImage.mas_right).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(12);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    _textLabel.font = [UIFont systemFontOfSize:14];
    [_textLabel setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];

    
    [_avatarImage setBackgroundColor:[UIColor redColor]];
}

-(void)setComment:(AYComment *)comment
{
    _comment = comment;
    _nameLabel.text = comment.from_user;
//    _textLabel.text = comment.text;
    [self setTextxxx:comment.text];
    _avatarImage.yy_imageURL = [NSURL URLWithString:[@"http://182.92.84.1:8000" stringByAppendingString:comment.from_user_avatar]];
}


-(void)setTextxxx:(NSString *)str
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];

    NSError *error;
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@" (@[\\w]+) " options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [reg matchesInString:str
                                    options:0
                                      range:NSMakeRange(0, str.length)];
    // 遍历匹配后的每一条记录
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *mStr = [str substringWithRange:range];
        NSLog(@"===%@===", mStr);
        NSRange newRange = NSMakeRange(range.location+1, range.length-2);
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:166/255.0 green:171/255.0 blue:184/255.0 alpha:1] range:newRange];
        [attrStr addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:14 weight:1] range:newRange];
    }
    
    [_textLabel setAttributedText:attrStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
