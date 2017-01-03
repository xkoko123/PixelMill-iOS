//
//  AYExploreController.m
//  PixelMill
//
//  Created by GoGo on 15/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYExploreController.h"
#import "AYLoginViewController.h"
#import "AYPaint.h"
#import "AYPixelAdapter.h"
#import "AYCanvas.h"
#import "UIColor+colorWithInt.h"
#import "AYNetManager.h"
#import "AYPaintCollectionViewCell.h"
#import "MJRefresh.h"
#import "AYNetManager.h"
#import "AYNetworkHelper.h"
#import "AYPaintDetailViewController.h"
#import "AYCollectionCarouselView.h"

@interface AYExploreController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AYCollectionCarouselViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *paints;

@property (nonatomic,assign)NetGetPaintType currentType;
@end

@implementation AYExploreController
{
    CGFloat _cellWidth;
    NSInteger _currentPage;
    NSInteger _maxPage;
    BOOL _net;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentType = NEW;
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    _paints = [[NSMutableArray alloc] init];
    _cellWidth = (self.view.frame.size.width-20)/2;
    _currentPage = 1;
    [self refreshData];
}

-(void)setCurrentType:(NetGetPaintType)currentType
{
    _currentType = currentType;
    _currentPage = 1;
    [self refreshData];
}

-(void)initView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width-6)/2, (self.view.frame.size.width-6)/2 + 64);
    //    flowLayout.headerReferenceSize = CGSizeMake(XCFScreenWidth, self.authorDetail.headerHeight+40);
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 6;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[AYPaintCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[AYCollectionCarouselView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"header"];

    [self.view addSubview:_collectionView];

    
    //下拉
    _collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [self.collectionView.mj_header  beginRefreshing];
        [self refreshNet];
        [[AYNetManager shareManager] getPaintTimeLineAtPage:1 type:_currentType
                                                    success:^(id responseObject){
                                                        if (_net) {
                                                            _currentPage = 1;
                                                            _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                            NSArray *array = [responseObject objectForKey:@"paints"];
                                                            self.paints = [AYPaint paintsWithArray:array];
                                                            [self.collectionView reloadData];
                                                            [self.collectionView.mj_header   endRefreshing];

                                                        }
                                                    }
                                                    failure:^(NSError *error) {
                                                        [self.collectionView.mj_header   endRefreshing];
                                                    }responseCache:^(id responseObject) {
                                                        if (!_net) {
                                                            _currentPage = 1;
                                                            _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                            NSArray *array = [responseObject objectForKey:@"paints"];
                                                            self.paints = [AYPaint paintsWithArray:array];
                                                            [self.collectionView reloadData];
                                                            [self.collectionView.mj_header   endRefreshing];
                                                        }
                                                    }
         ];
        
        
    }];
    
    
    //上拉
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer  beginRefreshing];
        
        [self refreshNet];
        if (_currentPage < _maxPage) {
            [[AYNetManager shareManager] getPaintTimeLineAtPage:_currentPage+1 type:_currentType
                                                        success:^(id responseObject){
                                                            if (_net) {
                                                                _currentPage += 1;
                                                                _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                                NSArray *array = [responseObject objectForKey:@"paints"];
                                                                [self.paints addObjectsFromArray:[AYPaint paintsWithArray:array]];
                                                                [self.collectionView reloadData];
                                                                [self.collectionView.mj_footer  endRefreshing];
                                                            }
                                                        }
                                                        failure:^(NSError *error) {
                                                            [self.collectionView.mj_footer  endRefreshing];
                                                        }responseCache:^(id responseObject) {
                                                            if (!_net) {
                                                                _currentPage +=1;
                                                                _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                                NSArray *array = [responseObject objectForKey:@"paints"];
                                                                [self.paints addObjectsFromArray:[AYPaint paintsWithArray:array]];
                                                                [self.collectionView reloadData];
                                                                [self.collectionView.mj_footer  endRefreshing];
                                                                
                                                            }
                                                        }
             ];
        }else{
            [self.collectionView.mj_footer  endRefreshing];
        }

        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.paints.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AYPaintCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    AYPaint *paint = [self.paints objectAtIndex:(indexPath.row)];
    cell.paintModel = paint;
    return cell;
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AYPaint *paint = [self.paints objectAtIndex:(indexPath.row)];
    AYPaintDetailViewController *vc = [[AYPaintDetailViewController alloc] initWithPaintModel:paint];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AYCollectionCarouselView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView setImageArr:@[@"http://192.168.1.103:8000/media/2016-12-312306370.gif",@"http://192.168.1.103:8000/media/2016-12-302315110.png"] AndImageClickBlock:^(NSInteger index) {
            NSLog(@"clickAt %ld",index);
            [self showToastWithMessage:[NSString stringWithFormat:@"Click at %ld",index] andDelay:1 andView:nil];
        }];
        headerView.delegate = self;
        
        reuseView = headerView;
    }
    return reuseView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 338);
}



-(void)refreshData
{
    [self refreshNet];
    //这个刷新默认从缓存获得，如果服务器数据有变化才使用网络的数据，，
    [[AYNetManager shareManager] getPaintTimeLineAtPage:1 type:_currentType
                                                success:^(id responseObject){
                                                    NSArray *array = [responseObject objectForKey:@"paints"];
                                                    if (_net) {
                                                        _currentPage =1;
                                                        _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                        self.paints = [AYPaint paintsWithArray:array];
                                                        [self.collectionView reloadData];
                                                    }
                                                }
                                                failure:^(NSError *error) {
                                                } responseCache:^(id responseObject) {
                                                    _currentPage =1;
                                                    _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                    NSArray *array = [responseObject objectForKey:@"paints"];
                                                    self.paints = [AYPaint paintsWithArray:array];
                                                    [self.collectionView reloadData];
                                                }
     ];

    
    
    
}

-(void)refreshNet
{
    [AYNetworkHelper networkStatusWithBlock:^(AYNetworkStatus networkStatus) {
        
        switch (networkStatus) {
            case AYNetworkStatusUnknown:
            case AYNetworkStatusNotReachable: {
                _net = NO;
                break;
            }
                
            case AYNetworkStatusReachableViaWWAN:
            case AYNetworkStatusReachableViaWiFi: {
                _net = YES;
                break;
            }
        }
        
    }];
    

}



-(void)carouselViewDidClickAtIndex:(NSInteger)index
{
    //1 关注人
    //2 最新
    //3 热门
    //4 挑战
    [AYNetworkHelper cancelAllRequest];
    switch (index) {
        case 1:
            self.currentType = NEW;
            break;
        case 2:
            self.currentType = FOLLOW;
            break;
        case 3:
            self.currentType = HOT;
            break;
        case 4:
        {
            [self showToastWithMessage:@"正在加工" andDelay:2 andView:nil];
        }
            break;
        default:
            break;
    }
    
    
}



@end
