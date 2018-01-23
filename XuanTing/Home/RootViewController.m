//
//  RootViewController.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "RootViewController.h"
#import "XTHomeTableViewDataSource.h"

@interface RootViewController ()
@property (nonatomic,strong) XTHomeTableViewDataSource* dataSource;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联动Demo";
    [self dataSource];
}

-(XTHomeTableViewDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[XTHomeTableViewDataSource alloc]initWithTableView:self.tableView];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
