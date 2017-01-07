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
#import "AYCommentTableViewCell.h"
#import "AYCommentBottomview.h"
#import <Masonry.h>
#import <MBProgressHUD.h>
#import "AYNetworkHelper.h"
@interface AYPaintDetailViewController ()<UITableViewDelegate,UITableViewDataSource, AYCommentBottomViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *commentArray;

@property( nonatomic,weak)UIControl *dismissControl;

@end

@implementation AYPaintDetailViewController
{
    YYAnimatedImageView *_imageView;
    UITableView *_tableView;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    CGFloat _headerViewHeight;
    AYCommentBottomview *_commentView;
    NSInteger _commentToId;
    NSString *_commentToUser;
    UIView *_topBar;
    CGFloat descCellHeight;
    BOOL _net;
}

- (instancetype)initWithPaintModel:(AYPaint*)paintModel
{
    self = [super init];
    if (self) {
        _paintModel = paintModel;
        self.view.backgroundColor = [UIColor whiteColor];
        NSLog(@"dsfasf");
        [self initView];
        _commentToId = _paintModel.author_id;
        _commentToUser = nil;
        
        [self initTopBar];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavigationBarClear];
    [self refreshComment];
    
    
    
    //键盘弹出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    return _commentArray;
}


-(void)initTopBar
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    topBar.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 24, 30, 30);
    [backButton addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"bar_share"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(self.view.frame.size.width - 50, 24, 30, 30);
    [shareButton addTarget:self action:@selector(didClickShareBtn) forControlEvents:UIControlEventTouchUpInside];

    
    [topBar addSubview:shareButton];
    
    
    _topBar = topBar;
    [self.view insertSubview:_topBar aboveSubview:_tableView];
    

    
}

-(void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self initHeaderViewWithPaint:self.paintModel];
    [self.view addSubview:_tableView];
    
    
    _commentView = [[AYCommentBottomview alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    _commentView.delegate = self;
    [self.view addSubview:_commentView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPaintModel:(AYPaint *)paintModel
{
    _paintModel = paintModel;
    NSString *urlString = [@"http://182.92.84.1:8000" stringByAppendingString:paintModel.image];
    _imageView.yy_imageURL = [NSURL URLWithString:urlString];
    _nameLabel.text = [@"@" stringByAppendingString: paintModel.author];
    _descLabel.text = paintModel.describe;
    
    _commentToId = _paintModel.author_id;
    _commentToUser = _paintModel.author;
}




-(void)initHeaderViewWithPaint:(AYPaint*)paintModel;
{
    self.paintModel = _paintModel;
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    NSString *urlString = [@"http://182.92.84.1:8000" stringByAppendingString:paintModel.image];
    _imageView.yy_imageURL = [NSURL URLWithString:urlString];
    [self.view addSubview:_imageView];
//    _tableView.tableHeaderView = headView;
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    _tableView.tableHeaderView.alpha = 0;
//    _tableView.sectionHeaderHeight = width;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
            if (c == nil) {
                c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
                c.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *pad = [[UIView alloc] init];
                [c.contentView addSubview:pad];
                [pad mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(c.contentView);
                }];
                
                NSString *str = self.paintModel.describe;
                CGFloat desc_height = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 100, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21]}
                                                        context:nil
                                       ].size.height;
                //上边距48 下边距48
                UILabel *descLabel = [[UILabel alloc] init];
                descLabel.text = str;
                [descLabel setFont:[UIFont systemFontOfSize:20]];
                [descLabel setTextColor:[UIColor colorWithRed:54/255.0 green:78/255.0 blue:74/255.0 alpha:1]];
                [descLabel setTextAlignment:NSTextAlignmentCenter];
                descLabel.numberOfLines = -1;
                [pad addSubview:descLabel];
                [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(pad).offset(48);
                    make.left.equalTo(pad.mas_left).offset(50);
                    make.right.equalTo(pad.mas_right).offset(-50);
                    make.height.mas_equalTo(desc_height);
                }];
                
                //下边距20
                UILabel *authorLabel = [[UILabel alloc] init];
                authorLabel.text = [@"by " stringByAppendingString:self.paintModel.author];
                [authorLabel setTextColor:[UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1]];
                [authorLabel setFont:[UIFont systemFontOfSize:14]];
                [authorLabel setTextAlignment:NSTextAlignmentRight];
                
                [pad addSubview:authorLabel];
                [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(descLabel.mas_bottom).offset(20);
                    make.left.equalTo(pad.mas_left).offset(20);
                    make.right.equalTo(pad.mas_right).offset(-20);
                    make.height.mas_equalTo(20);
                    
                }];
                
                
                UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [likeBtn setImage:[UIImage imageNamed:@"like_press"] forState:UIControlStateSelected];
                likeBtn.tag = 20;

                [likeBtn setTitle:@"" forState:UIControlStateNormal];
                
                [likeBtn setTitleColor:[UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1] forState:UIControlStateNormal];
                [likeBtn setTitleColor:[UIColor colorWithRed:232/255.0 green:86/255.0 blue:44/255.0 alpha:1] forState:UIControlStateSelected];
                likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [likeBtn addTarget:self action:@selector(didClickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                [pad addSubview:likeBtn];
                [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(authorLabel.mas_bottom).offset(30);
                    make.left.equalTo(pad.mas_left).offset(20);
                    make.height.mas_equalTo(26);
                    make.width.mas_equalTo(80);
                    make.bottom.equalTo(pad.mas_bottom).offset(-10);
                }];
                
                UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                followBtn.tag = 30;
                [followBtn setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
                
                [followBtn setBackgroundImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateSelected];
                
                [followBtn addTarget:self action:@selector(didClickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                [pad addSubview:followBtn];
                [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(likeBtn);
                    make.right.equalTo(pad.mas_right).offset(-20);
                    make.height.mas_equalTo(23);
                    make.width.equalTo(@70);
                }];

                
                [c.contentView addSubview:pad];
                [pad layoutIfNeeded];

                //画线
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.backgroundColor = [UIColor clearColor].CGColor;
                lineLayer.strokeColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
                lineLayer.lineWidth = 1;
                UIBezierPath *path = [UIBezierPath bezierPath];
                
                
                [path moveToPoint:CGPointMake(20,
                                              authorLabel.frame.origin.y + 40)
                 ];
                [path addLineToPoint:CGPointMake(self.view.frame.size.width - 20,
                                                 authorLabel.frame.origin.y + 40)
                 ];
                

                lineLayer.path = path.CGPath;
                
                [pad.layer addSublayer:lineLayer];
                
            }
            cell = c;
            UIButton *likeBtn = [cell viewWithTag:20];
            NSLog(@"setsetsetset");
            [likeBtn setTitle:[NSString stringWithFormat:@" %ld",self.paintModel.like_count] forState:UIControlStateNormal];
            if (self.paintModel.liked) {
                [likeBtn setSelected:YES];
            }else{
                [likeBtn setSelected:NO];
            }
            
            UIButton *followBtn = [cell viewWithTag:30];
            if (self.paintModel.followed) {
                [followBtn setSelected:YES];
            }else{
                [followBtn setSelected:NO];
            }

        }
            break;
        default:
        {
            AYComment *comment = [self.commentArray objectAtIndex:indexPath.row-1];
            
            AYCommentTableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (c == nil) {
                c = [[AYCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            c.comment = comment;
            
            cell = c;
        }
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    AYComment *comment = [self.commentArray objectAtIndex:indexPath.row-1];
    _commentToId = comment.from_user_id;
    _commentToUser = comment.from_user;
    
    [_commentView setPlaceHolder:[NSString stringWithFormat:@"@%@: ",comment.from_user]];
    [_commentView becomeFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)refreshComment
{
    [[AYNetManager shareManager] getPaintComment:1 paintId:self.paintModel.pid success:^(id responseObject) {
            NSArray *array = [responseObject objectForKey:@"comments"];
            self.commentArray = [AYComment commentsWithArray:array];
            [self.paintModel setFollowed:([responseObject[@"followed"] integerValue] == 1)];
            
            [_tableView reloadData];
    } failure:^(NSError *error) {
        
    } responseCache:^(id responseObject) {
        NSArray *array = [responseObject objectForKey:@"comments"];
        self.commentArray = [AYComment commentsWithArray:array];
        [self.paintModel setFollowed:([responseObject[@"followed"] integerValue] == 1)];
        
        [_tableView reloadData];

    }];
}


-(void)keyboardAppear:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    CGRect frameOfKeyboard = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.view.frame;
    
    CGFloat height = frame.size.height - frameOfKeyboard.origin.y;//加64是因为存在navigation导致view本身就整体下移了64个单位
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0,
                                      -height,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
    }];
    
    if (height != 0) {//expanded
        if (_dismissControl == nil) {
            UIControl *v = [[UIControl alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height - 44)
                            ];
            
            [self.view addSubview:v];
            _dismissControl = v;
            [_dismissControl addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{//folded
        _commentToId = _paintModel.author_id;
        _commentToUser = nil;
        [_commentView setPlaceHolder:@"说点什么"];
    }
}

-(void)dismissKeyboard:(UIControl*)sender
{
    NSLog(@"dsa");
    [sender removeFromSuperview];
    [_commentView resignFirstResponder];
    
}

-(void)commentBottomViewDidClickSend:(NSString *)text
{
    NSString *temp = text;
    if (_commentToUser != nil) {
        temp = [NSString stringWithFormat:@"回复 @%@ : %@",_commentToUser, text];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AYNetManager shareManager] addCommentAtPaint_id:_paintModel.pid toUser_id:_commentToId Text:temp Success:^(id responseObject) {
        [_commentView clearText];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self refreshComment];
        [self dismissKeyboard:_dismissControl];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showToastWithMessage:@"评论失败" andDelay:1 andView:nil];
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat yOffset = scrollView.contentOffset.y  ;
    if (yOffset < 0) {
        CGFloat totalOffset = width + ABS(yOffset);
        CGFloat f = totalOffset / width;
        
        _imageView.frame = CGRectMake(- (width * f - width) / 2, 0, width * f, totalOffset);
    }else{
        _imageView.frame = CGRectMake(0, -yOffset/1.5, width, width);
        
    }
    
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    
//    NSLog(@"%f",_tableView.contentOffset.y);
//    
//    //获取tableView的Y方向偏移量
//    
//    CGFloat offSet_Y = _tableView.contentOffset.y;
//    
//    //向下拖动图片时
//    if (offSet_Y < - kOriginalImageHeight) {
//        
//        //获取imageView的原始frame
//        CGRect frame = _tableView.tableHeaderView.frame;
//        
//        //修改imageView的Y值 等于offSet_Y
//        frame.origin.y = offSet_Y;
//        
//        //修改imageView的height  等于offSet_Y 的绝对值 此时偏移量为负数
//        frame.size.height =  - offSet_Y;
//        
//        //重新赋值
//        self.imageView.frame = frame;
//        
//    }
//    
//    //tableView相对于图片的偏移量
//    
//    CGFloat reOffset = offSet_Y + kOriginalImageHeight ;
//    
//    
//    
//    (kOriginalImageHeight - 64)这个数值决定了导航条在图片上滑时开始出现  alpha 从 0 ~ 0.99 变化
//    
//    当图片底部到达导航条底部时 导航条  aphla 变为1 导航条完全出现
//    
//    CGFloat alpha = reOffset/(kOriginalImageHeight - 64);
//    
//    if (alpha>=1) {
//        
//        alpha = 0.99;
//    }
//    
//    
//    // 设置导航条的背景图片 其透明度随  alpha 值 而改变
//    
//    UIImage *image = [self imageWithColor:[UIColor colorWithRed:0.227 green:0.753 blue:0.757 alpha:alpha]];
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    
//}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(velocity.y>0)
        
    {
        //hide
        
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topBar.frame = CGRectMake(0, -54, self.view.frame.size.width, 54);
        } completion:nil];
    }
    
    else
        
    {
        //show
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 54);
        } completion:nil];

//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    
}



-(void)didClickLikeBtn:(UIButton*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (sender.isSelected) {
        //dislike
        
        [[AYNetManager shareManager] dislikeAtPaintId:self.paintModel.pid success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([responseObject[@"status"] integerValue] == 1) {
                self.paintModel.liked = NO;
                self.paintModel.like_count = [responseObject[@"new_count"] integerValue];
                NSLog(@"%ld",self.paintModel.like_count);

                [sender setSelected:NO];
                [sender setTitle:[NSString stringWithFormat:@" %ld",self.paintModel.like_count] forState:UIControlStateSelected];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        //like

        [[AYNetManager shareManager] likeAtPaintId:self.paintModel.pid success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if ([responseObject[@"status"] integerValue] == 1) {
                self.paintModel.liked = YES;
                self.paintModel.like_count = [responseObject[@"new_count"] integerValue];
                NSLog(@"%ld",self.paintModel.like_count);
                [sender setSelected:YES];
                [sender setTitle:[NSString stringWithFormat:@" %ld",self.paintModel.like_count] forState:UIControlStateSelected];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }
}

-(void)didClickFollowBtn:(UIButton*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (sender.isSelected) {
        //unfollow
        [[AYNetManager shareManager] unfollowUser:self.paintModel.author_id success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([responseObject[@"status"] integerValue] == 1) {
                self.paintModel.followed = 0;
                [sender setSelected:NO];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        //followed
        
        [[AYNetManager shareManager] followUser:self.paintModel.author_id success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if ([responseObject[@"status"] integerValue] == 1) {
                [sender setSelected:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}


-(void)didClickShareBtn
{
    UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[_imageView.image.yy_imageDataRepresentation] applicationActivities:nil];
    [self presentViewController:ac animated:YES completion:NULL];

}

-(void)didClickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
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
