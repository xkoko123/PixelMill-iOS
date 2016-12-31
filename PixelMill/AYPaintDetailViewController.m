//
//  AYPaintDetailViewController.m
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYPaintDetailViewController.h"
#import <Masonry.h>
#import "AYPaint.h"
#import <YYImage.h>
#import <YYWebImage.h>
#import "AYComment.h"
#import "AYNetManager.h"
@interface AYPaintDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *commentArray;
@end

@implementation AYPaintDetailViewController
{
    YYAnimatedImageView *_imageView;
    UITableView *_tableView;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    CGFloat _headerViewHeight;
}

- (instancetype)initWithPaintModel:(AYPaint*)paintModel
{
    self = [super init];
    if (self) {
        _paintModel = paintModel;
        self.view.backgroundColor = [UIColor whiteColor];
        _commentArray = [[NSMutableArray alloc] init];
        [self initView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initView];
    // Do any additional setup after loading the view.
}


-(void)initView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeaderViewWithPaint:self.paintModel];
    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPaintModel:(AYPaint *)paintModel
{
    _paintModel = paintModel;
    NSString *urlString = [@"http://192.168.1.103:8000" stringByAppendingString:paintModel.image];
    _imageView.yy_imageURL = [NSURL URLWithString:urlString];
    _nameLabel.text = [@"@" stringByAppendingString: paintModel.author];
    _descLabel.text = paintModel.describe;
}


-(void)initHeaderViewWithPaint:(AYPaint*)paintModel;
{
    self.paintModel = _paintModel;
    CGFloat width = self.view.frame.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width + 50)];
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarBtn.frame = CGRectMake(8, 5, 40, 40);
    avatarBtn.layer.cornerRadius = 20;
    avatarBtn.layer.masksToBounds = YES;
    [topBar addSubview:avatarBtn];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, width - 56 - 100, 50)];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.text = [@"@" stringByAppendingString: paintModel.author];
    
    [topBar addSubview:_nameLabel];
    
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 76, 10, 66, 30)];
    [followBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange_bg"] forState:UIControlStateNormal];
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    
    [topBar addSubview:followBtn];
    
    
    _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 50, width, width)];
    NSString *urlString = [@"http://192.168.1.103:8000" stringByAppendingString:paintModel.image];
    _imageView.yy_imageURL = [NSURL URLWithString:urlString];
    
    NSString *str = paintModel.describe;
    CGFloat desc_height = [str boundingRectWithSize:CGSizeMake(width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, width+60, width-20, desc_height)];
    _descLabel.numberOfLines = -1;
    [_descLabel setFont:[UIFont systemFontOfSize:16]];
    _descLabel.text = paintModel.describe;
    
 

    
    
    
    [headerView addSubview:topBar];
    [headerView addSubview:_imageView];
    [headerView addSubview:_descLabel];
    
    _tableView.tableHeaderView = headerView;
    _tableView.sectionHeaderHeight = width + 60 + desc_height + 10;
    
    //
    [avatarBtn setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)refreshComment
{
    [[AYNetManager shareManager] getPaintComment:1 paintId:self.paintModel.pid success:^(id responseObject) {
        NSArray *array = [responseObject objectForKey:@"comments"];
        self.commentArray = [AYComment commentsWithArray:array];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        
    } responseCache:^(id responseObject) {
        
    }];
}

@end
