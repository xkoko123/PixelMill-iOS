//
//  AYLayerEditorView.m
//  PixelMill
//
//  Created by GoGo on 21/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYLayerEditorView.h"
#import "AYCanvas.h"
#import "AYPixelAdapter.h"
#import "AYLayerTableViewCell.h"
#import <Masonry.h>


@interface AYLayerEditorView()<UITableViewDelegate, UITableViewDataSource, LayerTableViewCellDelegate>

@property (nonatomic, strong) UIControl *dismissController;
@property (nonatomic, strong) NSMutableArray *touchPoints;
@property (nonatomic, strong) UIView *toolBar;
@end
@implementation AYLayerEditorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithEditIndex:(NSInteger)index andAdapters:(NSMutableArray *)adapters
{
    self = [super init];
    if (self) {
        _touchPoints = [[NSMutableArray alloc] init];
        
        _editIndex = index;
        _layerAdapters = adapters;
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 150;
        _tableView.clipsToBounds = NO; 
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-44);
            make.width.mas_equalTo(150);
            make.left.equalTo(self.mas_left);
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self.tableView addGestureRecognizer:longPress];

        
        
        
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor yellowColor];
        [self addSubview: _toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(150);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *addLayerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        addLayerBtn.backgroundColor = [UIColor redColor];
        [_toolBar addSubview:addLayerBtn];
        [addLayerBtn addTarget:self action:@selector(didClickAddLayer) forControlEvents:UIControlEventTouchUpInside];
        [addLayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.equalTo(_toolBar.mas_right).offset(-2);
            make.centerY.equalTo(_toolBar.mas_centerY);
        }];
        
        UIButton *importImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_toolBar addSubview:importImageBtn];
        importImageBtn.backgroundColor = [UIColor redColor];
        [importImageBtn addTarget:self action:@selector(didClickImportLayer) forControlEvents:UIControlEventTouchUpInside];

        [importImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(_toolBar.mas_left).offset(2);
            make.centerY.equalTo(_toolBar.mas_centerY);
        }];
        
        

        
        
        _dismissController = [[UIControl alloc] init];
//        _dismissController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [_dismissController addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissController];
        [_dismissController mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(_tableView.mas_right);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

-(void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, -150, 0, -150));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didChangedEditIndex:)]) {
            [self.delegate didChangedEditIndex:self.editIndex];
        }
    }];
    
}

-(void)didClickAddLayer
{
    AYPixelAdapter *adapter = [[AYPixelAdapter alloc] initWithSize:self.size];
    [self.layerAdapters addObject:adapter];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.layerAdapters.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //因为一直删除只剩一行时会隐藏删除按钮，所以添加行后刷新第一行
    if (self.layerAdapters.count == 2) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:NO];
    }
    [self notifySuperViewReload];
}

-(void)didClickImportLayer
{
    
}

#pragma mark - TableView代理

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AYLayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[AYLayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andSize:self.size];
    }
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    AYPixelAdapter *adapter = [self.layerAdapters objectAtIndex:indexPath.row];
    
    cell.canvas.adapter = adapter;
    

    
    [cell.visibleBtn setSelected:adapter.visible];
    
    
    if (indexPath.row == self.editIndex) {
        [cell.editingBtn setSelected:YES];
    }else{
        [cell.editingBtn setSelected:NO];
    }
    
    if(self.layerAdapters.count <=1){
        cell.deleteBtn.hidden = YES;
    }else{
        cell.deleteBtn.hidden = NO;
    }
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.layerAdapters count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    NSInteger old = self.editIndex;
    self.editIndex = index;
    AYPixelAdapter *adapter = [self.layerAdapters objectAtIndex:index];
    adapter.visible = YES;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:old inSection:0],
                                             [NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:NO];
    [self notifySuperViewReload];

}

#pragma mark - TableView 长按拖拽
-(void)longPressed:(UILongPressGestureRecognizer*)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                // 按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
//            NSLog(@"%@---%f----%@", self.touchPoints, moveX, NSStringFromCGPoint(center));
//            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            // 是否移动了
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 更新数组中的内容
                [self.layerAdapters exchangeObjectAtIndex:
                 indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // 把cell移动至指定行
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                
                // 自己看
                if (sourceIndexPath.row == self.editIndex ) {
                    self.editIndex = indexPath.row;
                }else if (sourceIndexPath.row < self.editIndex && indexPath.row >= self.editIndex){
                    self.editIndex -= 1;
                }else if (sourceIndexPath.row > self.editIndex && indexPath.row <= self.editIndex){
                    self.editIndex += 1;
                }else if(indexPath.row == self.editIndex && sourceIndexPath.row >= self.editIndex){
                    self.editIndex += 1;
                }else if(indexPath.row == self.editIndex && sourceIndexPath.row <= self.editIndex){
                    self.editIndex = indexPath.row;
                }
                
                // 存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
                
                
                [self notifySuperViewReload];
//                [self.tableView reloadData];

            }
            break;
        }
            // 长按手势取消状态
        default: {
            // 清除操作
            // 清空数组，非常重要，不然会发生坐标突变！
            [self.touchPoints removeAllObjects];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }

}

-(UIView *)customSnapshoFromView:(UIView *)view {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
//    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}


#pragma mark - 自定义代理

-(void)notifySuperViewReload
{
    if([self.delegate respondsToSelector:@selector(didChangedVisible)]){
        [self.delegate didChangedVisible];
    }
}

//cell改变了visible属性
-(void)layerCellchangedData
{
    [self.tableView reloadData];
    [self notifySuperViewReload];
}

////cell改变了edit属性
//-(void)layerCellDidChangeEditingCellAt:(int)index
//{
//    self.editIndex = index;
//    [self.tableView reloadData];
//    [self notifySuperViewReload];
//}

-(void)layerCellRemoveCellAtRow:(NSInteger)index
{

    if (index == 0 && self.editIndex == 0) {
        self.editIndex = 0;
    }else if (self.editIndex >= index) {
        self.editIndex = self.editIndex-1;
    }
    [self.layerAdapters removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:YES];
    //因为我在cell的tag中附带了信息，所以删除后tag顺序会变乱，只能重新加载....
    [self.tableView reloadData];
    
    [self notifySuperViewReload];
}

@end
