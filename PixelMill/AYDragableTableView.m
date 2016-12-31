//
//  AYDragableTableView.m
//  PixelMill
//
//  Created by GoGo on 27/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYDragableTableView.h"

@implementation AYDragableTableView
{
    NSMutableArray *touchPoints;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        touchPoints = [[NSMutableArray alloc] init];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longPress];

    }
    return self;
}

#pragma mark - TableView 长按拖拽
-(void)longPressed:(UILongPressGestureRecognizer*)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];

    if(![self.delegate dragableTableViewShouldDragAtIndexPath:indexPath]){
        return;
    }

    
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self addSubview:snapshot];
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
            [touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (touchPoints.count > 2) {
                [touchPoints removeObjectAtIndex:0];
            }
            
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            //            NSLog(@"%@---%f----%@", self.touchPoints, moveX, NSStringFromCGPoint(center));
            //            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            // 是否移动了
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 把cell移动至指定行
                [self moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                if([self.delegate respondsToSelector:@selector(dragableTableViewDidMoveAtIndexPath:toIndexPath:)]){
                    [self.delegate dragableTableViewDidMoveAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                }
                
                // 存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
                
            }
            break;
        }
            // 长按手势取消状态
        default: {
            // 清除操作
            // 清空数组，非常重要，不然会发生坐标突变！
            [touchPoints removeAllObjects];
            UITableViewCell *cell = [self cellForRowAtIndexPath:sourceIndexPath];
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


@end
