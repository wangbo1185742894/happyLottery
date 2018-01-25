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
    NSMutableArray <JCZQSchemeItem *> *dataArray;
    NSInteger page;
}

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A204";
    dataArray = [NSMutableArray arrayWithCapacity:0];
    self.title = @"我的彩票";
    page = 1;
    curSchemeType = CostTypeCASH;
    [self setTableViewLoadRefresh];
    [self setTableView];
    [self loadData];
}
- (IBAction)actionCostTypeSelect:(UISegmentedControl *)sender {
    page = 1;
    if (sender.selectedSegmentIndex == 0) {
        curSchemeType = CostTypeCASH;
    }else if (sender.selectedSegmentIndex == 1){
        curSchemeType = CostTypeSCORE;
    }
    [self loadData];
}

-(void)setTableViewLoadRefresh{
    
    tabSchemeList.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        page ++ ;
        [self loadData];
        [tabSchemeList reloadData];
    }];
    
    tabSchemeList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
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

    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchemListCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemListCell];
    [cell refreshData:dataArray[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)loadData{
    NSString *costType = @"CASH";
    if (curSchemeType == CostTypeCASH) {
        costType = @"CASH";
    }else if(curSchemeType == CostTypeSCORE){
        costType  = @"SCORE";
    }
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(10),@"costType":costType}];
}

-(void)gotSchemeRecord:(NSArray *)infoDic errorMsg:(NSString *)msg{
    [tabSchemeList.mj_header endRefreshing];
    [tabSchemeList.mj_footer endRefreshing];
    if (infoDic == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    if (page == 1) {
         [dataArray removeAllObjects];
//        NSString *costType = @"CASH";
//        if (curSchemeType == CostTypeCASH) {
//            costType = @"CASH";
//        }else if(curSchemeType == CostTypeSCORE){
//            costType  = @"SCORE";
//        }
//       JCZQSchemeItem *item = [dataArray firstObject];
//        if ([item.costType isEqualToString:costType]) {
//
//        }
        
    }
    
    for (NSDictionary *itemDic in infoDic) {
        JCZQSchemeItem *model = [[JCZQSchemeItem alloc]initWith:itemDic];
        [dataArray addObject:model];
    }
    [tabSchemeList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
    schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
    [self.navigationController pushViewController:schemeVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

@end
