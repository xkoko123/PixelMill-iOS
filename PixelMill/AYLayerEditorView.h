//
//  AYLayerEditorView.h
//  PixelMill
//
//  Created by GoGo on 21/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LayerEditorViewDelegate<NSObject>

@optional
- (void) didChangedVisibleOrEditIndex:(NSInteger)index;

@end


@interface AYLayerEditorView : UIView


@property (nonatomic, weak) id delegate;

@property (nonatomic,weak) NSMutableArray *layerAdapters;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign)NSInteger editIndex;



-(instancetype)initWithEditIndex:(NSInteger)index andAdapters:(NSMutableArray*)adapters;


@end
