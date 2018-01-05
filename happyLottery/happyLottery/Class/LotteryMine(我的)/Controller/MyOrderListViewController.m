//
//  MyOrderListViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//我的订单

#import "MyOrderListViewController.h"
#import "JCZQSchemeModel.h"
#import "SchemListCell.h"
#import "SchemeDetailViewController.h"
#import "MJRefresh.h"
#define KSchemListCell @"SchemListCell"
@interface MyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

{
    CostType curSchemeType;
    __weak IBOutlet UITableView *tabSchemeList;
    JCZQSchemeModel* schemeModel;
    NSInteger page;
}

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    curSchemeType = CostTypeCASH;
    [self setTableView];
    [self loadData];
}

-(void)setTableViewLoadRefresh{
    
    tabSchemeList.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        page ++ ;
        [self loadData];
        [tabSchemeList reloadData];
    }];
    
    tabSchemeList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self loadData];
        [tabSchemeList reloadData];
    }];
}

-(void)setTableView{
    tabSchemeList.delegate = self;
    tabSchemeList.dataSource = self;
    [tabSchemeList registerClass:[ SchemListCell class] forCellReuseIdentifier:KSchemListCell];
    tabSchemeList.rowHeight = 73;
    
    self.lotteryMan.delegate =self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)actionSelectSchemeTpye:(UISegmentedControl *)sender {
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return schemeModel.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchemListCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemListCell];
    [cell refreshData:schemeModel.list[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadData{
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode}];
}

-(void)gotSchemeRecord:(NSDictionary *)infoDic errorMsg:(NSString *)msg{
    [tabSchemeList.mj_header endRefreshing];
    [tabSchemeList.mj_footer endRefreshing];
    if (infoDic == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    schemeModel = [[JCZQSchemeModel alloc]initWith:infoDic];
    [tabSchemeList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
    schemeVC.schemeNO = schemeModel.list[indexPath.row].schemeNO;
    [self.navigationController pushViewController:schemeVC animated:YES];
    
    
}

@end
