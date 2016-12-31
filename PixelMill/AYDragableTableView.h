//
//  AYDragableTableView.h
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYDragableTableViewDelegate <NSObject>

@required
//在这里把数据源的数据也要交换
- (void)dragableTableViewDidMoveAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)toIndexPath;
- (BOOL)dragableTableViewShouldDragAtIndexPath:(NSIndexPath*)indexpath;
@end


@interface AYDragableTableView : UITableView

@property (nonatomic, weak)id delegate;

@end
