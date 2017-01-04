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
#import "AYDragableTableView.h"
#import "AYImageChoiceViewController.h"
#import "AYDrawViewController.h"
#import <Masonry.h>


@interface AYLayerEditorView()<UITableViewDelegate, UITableViewDataSource, LayerTableViewCellDelegate,AYDragableTableViewDelegate,UIImagePickerControllerDelegate>

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
        _tableView = [[AYDragableTableView alloc] init];
        _tableView.rowHeight = 150;
        _tableView.clipsToBounds = NO; 
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(40);
            make.width.mas_equalTo(150);
            make.left.equalTo(self.mas_left);
        }];
        
        _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(2, 2);
        _tableView.layer.shadowOpacity = 0.3;
        _tableView.layer.shadowRadius = 4;
        
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self addSubview: _toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(150);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(40);
        }];
        
        UIButton *addLayerBtn = [UIButton buttonWithType:UIButtonTypeSystem];

        [addLayerBtn setImage:[[UIImage imageNamed:@"addLayer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_toolBar addSubview:addLayerBtn];
        [addLayerBtn addTarget:self action:@selector(didClickAddLayer) forControlEvents:UIControlEventTouchUpInside];
        [addLayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 31));
            make.right.equalTo(_toolBar.mas_right).offset(-2);
            make.centerY.equalTo(_toolBar.mas_centerY);
        }];
        
        UIButton *importImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_toolBar addSubview:importImageBtn];
        [importImageBtn setImage:[[UIImage imageNamed:@"importimage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        [importImageBtn addTarget:self action:@selector(didClickImportLayer) forControlEvents:UIControlEventTouchUpInside];

        [importImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 31));
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
    [self.layerAdapters insertObject:adapter atIndex:0];
    
    //添加图层默认改成编辑状态，所以旧的图层要刷新
    NSInteger oldEditIndex = self.editIndex;
    self.editIndex = 0;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:oldEditIndex+1 inSection:0],] withRowAnimation:NO];

    
//    //因为只剩一行时会隐藏删除按钮，所以添加行后刷新第二行
//    if (self.layerAdapters.count == 2) {
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:NO];
//    }

    [self notifySuperViewReload];
}

-(void)didClickImportLayer
{
    AYDrawViewController *superVc = [self getSuperViewController];
    if (superVc) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing =YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                //UIImagePickerControllerSourceTypePhotoLibrary 照片库模式
                imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                [superVc presentViewController:imagePicker animated:NO completion:nil];
            }
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 调用系统摄像头，拍照
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {               //UIImagePickerControllerSourceTypeCamera相机模式
                imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                [superVc presentViewController:imagePicker animated:NO completion:nil];
            }else {
                
            }
            
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [superVc presentViewController:alert animated:YES completion:nil];

    }
    

//    UIImage *image = [UIImage imageNamed:@"logo"];
//    AYPixelAdapter *adapter = [AYPixelAdapter adapterWithUIImage:image size:self.size];
//    [self.layerAdapters addObject:adapter];
//    [self notifySuperViewReload];
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
        [cell.editingBtn setHidden:NO];
    }else{
        [cell.editingBtn setHidden:YES];
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


-(void)dragableTableViewDidMoveAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // 更新数组中的内容
    
    [self.layerAdapters exchangeObjectAtIndex:
     sourceIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    // 自己看
    if (sourceIndexPath.row == self.editIndex ) {
        self.editIndex = toIndexPath.row;
    }else if (sourceIndexPath.row < self.editIndex && toIndexPath.row >= self.editIndex){
        self.editIndex -= 1;
    }else if (sourceIndexPath.row > self.editIndex && toIndexPath.row <= self.editIndex){
        self.editIndex += 1;
    }else if(toIndexPath.row == self.editIndex && sourceIndexPath.row >= self.editIndex){
        self.editIndex += 1;
    }else if(toIndexPath.row == self.editIndex && sourceIndexPath.row <= self.editIndex){
        self.editIndex = toIndexPath.row;
    }
    [self notifySuperViewReload];

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


-(BOOL)dragableTableViewShouldDragAtIndexPath:(NSIndexPath *)indexpath
{
    return YES;
}


-(UIViewController*)getSuperViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[AYDrawViewController class]]) {
            return nextResponder;
        }
    }
    return nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = (UIImage *)(info[UIImagePickerControllerEditedImage]);
    //    image = [_photoImagefixOrientation];
    //    image = [image  scaleTo:CGSizeMake(120.0,120.0)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image) {
        [self.layerAdapters addObject:[AYPixelAdapter adapterWithUIImage:image size:self.size]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.layerAdapters.count-1 inSection:0]] withRowAnimation:YES];
        [self notifySuperViewReload];

    }
}


@end
