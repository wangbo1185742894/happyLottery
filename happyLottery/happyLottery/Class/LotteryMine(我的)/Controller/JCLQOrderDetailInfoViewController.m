//
//  JCLQOrderDetailInfoViewController.m
//  Lottery
//
//  Created by 王博 on 16/10/13 lala.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQOrderDetailInfoViewController.h"
#import "JCLQOrderDetailViewCell.h"

#define JCLQOrderCell @"JCLQOrderDetailViewCell"

@interface JCLQOrderDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labTotalNumbe;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UIImageView *imgLotteryIcon;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labIsWon;

@end

@implementation JCLQOrderDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";

    self.page = 0;
    self.tabListDetail.dataSource = self;
    self.tabListDetail.delegate = self;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.tabListDetail registerClass:[JCLQOrderDetailViewCell class] forCellReuseIdentifier:JCLQOrderCell];
    
    
    self.lotteryMan.delegate = self;
    
    self.tabListDetail.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        self.page = 0;
        [self loadData];
        [self.tabListDetail.mj_header endRefreshing];
    }];
    
    self.tabListDetail.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadData];
        [self.tabListDetail.mj_footer endRefreshing];
    }];
    
    [self loadData];
}

-(void)loadData{
    [self.lotteryMan getJczqTicketOrderDetail:@{@"schemeNo":self.schemeNO}];
}

-(void)gotJczqTicketOrderDetail:(NSArray *)infoArray errorMsg:(NSString *)msg{
    if (infoArray == nil || infoArray .count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    self.dataArray = infoArray;
    [self.tabListDetail reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JCLQOrderDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JCLQOrderCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell reloadData:dic];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
   JCLQOrderDetailViewCell *cell = [[JCLQOrderDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JCLQOrderCell];
    
    return [cell getCellHeight:dic]+35;

}

- (void) gotJCLQOrderInfoDetail:(NSArray *)dataArray{

    if (self.page == 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:dataArray];;
    
    [self.tabListDetail reloadData];
}

@end
