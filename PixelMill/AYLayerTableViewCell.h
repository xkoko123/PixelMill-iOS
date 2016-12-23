//
//  AYLayerTableViewCell.h
//  PixelMill
//
//  Created by GoGo on 21/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYCanvas;

@protocol LayerTableViewCellDelegate<NSObject>

@optional
- (void) layerCellchangedData;
- (void) layerCellRemoveCellAtRow:(NSInteger)index;
@end


@interface AYLayerTableViewCell : UITableViewCell

@property (nonatomic, strong)AYCanvas *canvas;
@property (nonatomic, strong)UIButton *editingBtn;
@property (nonatomic, strong)UIButton *visibleBtn;
@property (nonatomic, strong)UIButton *deleteBtn;


@property (nonatomic, weak) id delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andSize:(NSInteger)size;
@end
