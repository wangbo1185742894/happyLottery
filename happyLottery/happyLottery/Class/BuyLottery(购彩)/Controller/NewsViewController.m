//
//  NewsViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewsViewController.h"

#import "NewsTableViewCell.h"
#import "LoadData.h"
#import "NewsModel.h"
#import "WebShowViewController.h"
#define KNewsTableViewCell @"NewsTableViewCell"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tabNewListView;
    LoadData * singleLoad;
    NSMutableArray <NewsModel *> *newArray;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A017";
    [self setViewController];
    [self setTableView];
    [UITableView refreshHelperWithScrollView:tabNewListView target:self loadNewData:@selector(loadNews) loadMoreData:@selector(loadNews) isBeginRefresh:NO];
    [self loadNews];
}

-(void)loadNews{
    singleLoad = [LoadData singleLoadData];
    newArray = [NSMutableArray arrayWithCapacity:0];
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/news/moreNews?usageChannel=3",[GlobalInstance instance].homeUrl];
    [singleLoad RequestWithString:strUlr isPost:NO andPara:nil andComplete:^(id data, BOOL isSuccess) {
        [tabNewListView tableViewEndRefreshCurPageCount:100];
        if (isSuccess == NO) {
            return ;
        }
        NSDictionary *dicItem = [self transFomatJson:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        
         NSArray *itemArray = dicItem[@"result"];
        for (NSDictionary *dic in itemArray) {
            NewsModel *model = [[NewsModel alloc]initWith:dic];
            [newArray addObject:model];
        }
        [tabNewListView reloadData];
    }];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return newArray.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KNewsTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:newArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebShowViewController *showViewVC = [[WebShowViewController alloc]init];
    showViewVC.title = @"资讯详情";
    showViewVC.pageUrl = [NSURL URLWithString:newArray[indexPath.row].linkUrl];
    showViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showViewVC animated:YES];
}

@end
