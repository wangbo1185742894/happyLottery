//
//  NewsViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewsViewController.h"

#import "NewsTableViewCell.h"

#define KNewsTableViewCell @"NewsTableViewCell"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tabNewListView;
    
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewController];
    [self setTableView];
}
-(void)setViewController{
    
    self.title = @"竞彩资讯";
    
}

-(void)setTableView{
    
    tabNewListView.delegate = self;
    tabNewListView.dataSource = self;
    [tabNewListView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:KNewsTableViewCell];
    tabNewListView.rowHeight = 102;
    [tabNewListView reloadData];
}

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KNewsTableViewCell];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
