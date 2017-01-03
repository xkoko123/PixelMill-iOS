//
//  AYMessageViewController.m
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYMessageViewController.h"
#import "AYMessage.h"

@interface AYMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AYMessageViewController
{
    UITableView *_tableView;
    NSMutableArray *_messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height+20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
