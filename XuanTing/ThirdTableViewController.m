//
//  ThirdTableViewController.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "Help.h"

@interface ThirdTableViewController ()

@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    //如果当前tableview无法滚动，那么外面大的tableView就能滚动
    //    NSLog(@"FirstTableViewController conteny y = %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<=0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopName object:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第三页————这是第 %@ 行",@(indexPath.row)];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
