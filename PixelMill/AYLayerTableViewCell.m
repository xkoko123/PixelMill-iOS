//
//  AYLayerTableViewCell.m
//  PixelMill
//
//  Created by GoGo on 21/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//
#import <Masonry.h>
#import "AYLayerTableViewCell.h"
#import "AYCanvas.h"
#import "AYPixelAdapter.h"
@implementation AYLayerTableViewCell
{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andSize:(NSInteger)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _canvas = [[AYCanvas alloc] initWithFrame:CGRectMake(0, 0, 148, 148) andSize:size];
        [self.contentView addSubview:_canvas];
        _canvas.backgroundColor = [UIColor whiteColor];
        _canvas.showExtendedContent = NO;
        [_canvas mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(148, 148));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(1);
        }];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1].CGColor;
        layer.frame = _canvas.frame;
        [_canvas.layer addSublayer:layer];
        
        _visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_visibleBtn];
        [_visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_canvas).offset(2);
            make.left.equalTo(_canvas).offset(2);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_visibleBtn setBackgroundImage:[[UIImage imageNamed:@"layer_hide"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        
        [_visibleBtn addTarget:self action:@selector(didClickVisibleBtn) forControlEvents:UIControlEventTouchUpInside];
        [_visibleBtn setBackgroundImage:[[UIImage imageNamed:@"layer_hide"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        
        
        _editingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editingBtn];
        [_editingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_canvas).offset(-8);
            make.left.equalTo(_canvas).offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _editingBtn.userInteractionEnabled = NO;
        [_editingBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
//        [_editingBtn addTarget:self action:@selector(didClickEditingBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_canvas).offset(2);
            make.right.equalTo(_canvas).offset(-2);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_deleteBtn setBackgroundImage:[[UIImage imageNamed:@"layer_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_deleteBtn setTintColor:[UIColor redColor]];
        [_deleteBtn addTarget:self action:@selector(didClickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return self;


}
//选中编辑 自动选中显示
//已选中编辑的项目 不能取消显示



-(void)didClickVisibleBtn
{
    //已选中编辑的项目 不能取消显示
    if (self.editingBtn.isHidden == NO) {
        self.canvas.adapter.visible = YES;
    }else{
        self.canvas.adapter.visible = !self.canvas.adapter.visible;
    }
    
    if([self.delegate respondsToSelector:@selector(layerCellchangedData)]){
        [self.delegate layerCellchangedData];
    }
}

//-(void)didClickEditingBtn
//{
//    //选中编辑 自动选中显示
//    self.canvas.adapter.visible = YES;
//    
//    if([self.delegate respondsToSelector:@selector(layerCellDidChangeEditingCellAt:)]){
//        [self.delegate layerCellDidChangeEditingCellAt:self.tag];
//    }
//}


-(void)didClickDeleteBtn
{
    if ([self.delegate respondsToSelector:@selector(layerCellRemoveCellAtRow:)]) {
        [self.delegate layerCellRemoveCellAtRow:self.tag];
    }
}
@end
