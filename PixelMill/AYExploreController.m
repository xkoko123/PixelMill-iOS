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

@interface AYExploreController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *paints;

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
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    _paints = [[NSMutableArray alloc] init];
    _cellWidth = (self.view.frame.size.width-20)/2;
    _currentPage = 1;
    [self refreshData];
}

-(void)initView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[AYPaintCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];

    
    //下拉
    _collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [self.collectionView.mj_header  beginRefreshing];
        [self refreshNet];
        [[AYNetManager shareManager] getPaintTimeLineAtPage:1
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
            [[AYNetManager shareManager] getPaintTimeLineAtPage:_currentPage+1
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
    return ceil(self.paints.count / 2.0f);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.paints.count % 2 == 0) {
        return 2;
    }else{
        if (section == ceil(self.paints.count / 2.0f)-1) {
            return 1;
        }else{
            return 2;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AYPaintCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    AYPaint *paint = [self.paints objectAtIndex:(indexPath.section * 2 + indexPath.row)];
    cell.paintModel = paint;
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(_cellWidth, _cellWidth + 64);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AYPaint *paint = [self.paints objectAtIndex:(indexPath.section * 2 + indexPath.row)];
    AYPaintDetailViewController *vc = [[AYPaintDetailViewController alloc] initWithPaintModel:paint];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)refreshData
{
    [self refreshNet];
    [[AYNetManager shareManager] getPaintTimeLineAtPage:1
                                                success:^(id responseObject){
                                                    if (_net) {
                                                        _currentPage =1;
                                                        _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                        NSArray *array = [responseObject objectForKey:@"paints"];
                                                        self.paints = [AYPaint paintsWithArray:array];
                                                        [self.collectionView reloadData];
                                                    }
                                                }
                                                failure:^(NSError *error) {
                                                } responseCache:^(id responseObject) {
                                                    if (!_net) {
                                                        _currentPage =1;
                                                        _maxPage = [[responseObject objectForKey:@"num_pages"] integerValue];
                                                        NSArray *array = [responseObject objectForKey:@"paints"];
                                                        self.paints = [AYPaint paintsWithArray:array];
                                                        [self.collectionView reloadData];
                                                    }
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





@end
