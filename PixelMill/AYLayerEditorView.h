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
//dismiss时 调用这条代理
- (void) didChangedEditIndex:(NSInteger)index;
//一修改就调用
- (void) didChangedVisible;

@end


@interface AYLayerEditorView : UIView

@property (nonatomic,assign) NSInteger size;
@property (nonatomic, weak) id delegate;

@property (nonatomic,weak) NSMutableArray *layerAdapters;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign)NSInteger editIndex;



-(instancetype)initWithEditIndex:(NSInteger)index andAdapters:(NSMutableArray*)adapters;


@end
