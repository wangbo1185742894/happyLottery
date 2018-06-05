//
//  ZhuangZhangListVC.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ZhuangZhangListVC.h"
#import "AgentTransferModel.h"
#import "CashAndIntegrationWaterTableViewCell.h"
#define  KCashAndIntegrationWaterTableViewCell @"CashAndIntegrationWaterTableViewCell"
@interface ZhuangZhangListVC ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabRuzhangList;
@property (nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray <AgentTransferModel *> *transferList;

@end

@implementation ZhuangZhangListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"转账记录";
    self.agentMan.delegate = self;
    [self setTableView];
    self.transferList = [NSMutableArray arrayWithCapacity:0];
    [UITableView refreshHelperWithScrollView:self.tabRuzhangList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
}

-(void)loadNewData{
    _page = 0;
    [self loadData];
}
-(void)loadMoreData{
    _page  ++;
    [self loadData];
}
-(void)loadData{
    [self.agentMan listMyTransfer: @{@"agentId":self.model._id,@"page":@(_page),@"pageSize":@(KpageSize) }];
}

-(void)listMyTransferdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self .tabRuzhangList tableViewEndRefreshCurPageCount:array.count];
    if (_page ==0 ) {
        [self.transferList removeAllObjects];
    }
    if (success == NO) {
        [self  showPromptViewWithText:msg hideAfter:1.8];
        return;
    }else{
        if (array .count == 0) {
            [self showPromptViewWithText:@"暂无流水" hideAfter:1.8];
            return;
        }
    }
    
    for (NSDictionary *itemDic in array) {
        AgentTransferModel *mdoel = [[AgentTransferModel alloc]initWith:itemDic];
        [self.transferList addObject:mdoel];
    }
    
    [self.tabRuzhangList reloadData];
}

-(void)setTableView{
    self.tabRuzhangList.delegate = self;
    self.tabRuzhangList.dataSource = self;
    [self.tabRuzhangList registerNib:[UINib nibWithNibName:KCashAndIntegrationWaterTableViewCell bundle:nil] forCellReuseIdentifier:KCashAndIntegrationWaterTableViewCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transferList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashAndIntegrationWaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCashAndIntegrationWaterTableViewCell];
    [cell loadData:self.transferList[indexPath.row]];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}
@end
