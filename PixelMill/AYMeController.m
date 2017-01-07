//
//  AYMeController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYMeController.h"
#import "AYPaint.h"
#import "AYMeHeaderView.h"
#import <YYImage.h>
#import <YYWebImage.h>
#import "AYNetManager.h"
#import "AYUser.h"
#import <MJRefresh.h>
#import "AYLoginViewController.h"
#import "AYMessageController.h"
#import <MBProgressHUD.h>
@interface AYMeController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AYMeHeaderViewDelegate, UIImagePickerControllerDelegate>

@end

@implementation AYMeController
{
    UICollectionView *_collectionView;
    NSMutableArray *_collectionDataArray;
    AYUser *_user;
    NetGetPaintType _currentType;
    NSInteger _currentPage;
    NSInteger _maxPage;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentType = MYWORK;
    _currentPage = 1;
    _collectionDataArray = [[NSMutableArray alloc] init];
    
    [self setupCollectionView];
    [self refreshData];
    [self refreshUserInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width-4)/3, (self.view.frame.size.width-4)/3);
//    flowLayout.headerReferenceSize = CGSizeMake(XCFScreenWidth, self.authorDetail.headerHeight+40);
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 2;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         -20,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height + 20)
                                         collectionViewLayout:flowLayout
                       ];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentSize = self.view.bounds.size;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerClass:[AYMeHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"header"];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [_collectionView.mj_footer  beginRefreshing];
        
//        [self refreshNet];
        if (_currentPage < _maxPage) {
            [[AYNetManager shareManager] getPaintTimeLineAtPage:_currentPage+1 type:_currentType
                                                        success:^(id responseObject){
                                                            _currentPage += 1;
                                                            _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                            NSArray *array = [responseObject objectForKey:@"paints"];
                                                            [_collectionDataArray addObjectsFromArray:[AYPaint paintsWithArray:array]];
                                                            [_collectionView reloadData];
                                                            [_collectionView.mj_footer  endRefreshing];

                                                        }
                                                        failure:^(NSError *error) {
                                                            [_collectionView.mj_footer  endRefreshing];
                                                        }responseCache:^(id responseObject) {
                                                            _currentPage +=1;
                                                            _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                            NSArray *array = [responseObject objectForKey:@"paints"];
                                                            [_collectionDataArray addObjectsFromArray:[AYPaint paintsWithArray:array]];
                                                            [_collectionView reloadData];
                                                            [_collectionView.mj_footer  endRefreshing];

                                                        }
             ];
        }else{
            [_collectionView.mj_footer  endRefreshing];
        }
    }];
    
    _collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [_collectionView.mj_header  beginRefreshing];
        [self refreshData];
        [self refreshUserInfo];
    }];

    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionDataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    AYPaint *paint = [_collectionDataArray objectAtIndex:indexPath.item];
    
    NSInteger tag = 147;
    YYAnimatedImageView *imageView = [cell viewWithTag:tag];
    if (nil == imageView) {
        imageView = [[YYAnimatedImageView alloc] init];
        imageView.frame = cell.contentView.bounds;
        imageView.tag = tag;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
    }
    
    NSString *imageURL = [@"http://182.92.84.1:8000" stringByAppendingString:paint.image];
    imageView.yy_imageURL = [NSURL URLWithString:imageURL];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AYMeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (_user != nil) {
            [headerView setUser:_user];
        }
        headerView.delegate = self;
        
        reuseView = headerView;
    }
    
    return reuseView;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 230);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)refreshData
{
    [AYNetManager cancelAllRequest];
    [[AYNetManager shareManager] getPaintTimeLineAtPage:1 type:_currentType success:^(id responseObject) {
        _currentPage =1;
        _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
        
        NSArray *array = [responseObject objectForKey:@"paints"];
        _collectionDataArray = [AYPaint paintsWithArray:array];

        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        
    } responseCache:^(id responseObject) {
        _currentPage =1;
        _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
        NSArray *array = [responseObject objectForKey:@"paints"];
        _collectionDataArray = [AYPaint paintsWithArray:array];
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
    }];
}

-(void)refreshUserInfo
{

    [[AYNetManager shareManager] getMyIngoWhensuccess:^(id responseObject) {
        _user = [[AYUser alloc] initWithDict:responseObject];
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        // TODO : ......
    } responseCache:^(id responseObject) {
        _user = [[AYUser alloc] initWithDict:responseObject];
        [_collectionView reloadData];

    }];
}


-(void)meHeaderViewTappedAvatar
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate =self;
    imagePicker.allowsEditing =YES;
 
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            //UIImagePickerControllerSourceTypePhotoLibrary 照片库模式
            imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:NO completion:nil];
        }

    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 调用系统摄像头，拍照
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {               //UIImagePickerControllerSourceTypeCamera相机模式
            imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:NO completion:nil];
        }else {
            
        }

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = (UIImage *)(info[UIImagePickerControllerEditedImage]);
//    image = [_photoImagefixOrientation];
//    image = [image  scaleTo:CGSizeMake(120.0,120.0)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在上传";
    [[AYNetManager shareManager] changeAvatar:image progress:^(NSProgress *progress) {
        CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
        hud.progress = stauts;
    }  Success:^(id responseObject) {
        [hud hideAnimated:YES];
        
        [self refreshUserInfo];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [self showToastWithMessage:@"上传失败" andDelay:1 andView:nil];
    }];

}


-(void)meHeaderViewTappedLogout
{
    [[AYNetManager shareManager] logOutSuccess:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud removeObjectForKey:@"username"];
            [ud removeObjectForKey:@"password"];
            [ud synchronize];
            AYLoginViewController *vc = [[AYLoginViewController alloc] init];
            self.view.window.rootViewController = vc;
            [self.view.window makeKeyAndVisible];
        }
    } failure:^(NSError *error) {
        [self showToastWithMessage:@"失败" andDelay:1 andView:nil];
    }];
}

-(void)meHeaderViewChangedType:(NSInteger)index
{
    switch (index) {
        case 1:
            _currentType = MYWORK;
            [self refreshData];
            break;
        case 2:
            _currentType = LIKE;
            [self refreshData];
            break;
        default:
            break;
    }
}

-(void)meHeaderViewTappedMessage
{
    AYMessageController *vc = [[AYMessageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
