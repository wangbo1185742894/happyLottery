//
//  YongjinListViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "YongjinListViewController.h"
#import "AgentCommissionModel.h"
#import "YongjinCell.h"

#define KYongjinCell @"YongjinCell"
@interface YongjinListViewController ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabyongjinList;
@property (nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray <AgentCommissionModel *> *transferList;

@end

@implementation YongjinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金查询";
    self.transferList = [NSMutableArray arrayWithCapacity:0];
    self.agentMan.delegate = self;
    [self setTableView];
    
    [UITableView refreshHelperWithScrollView:self.tabyongjinList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
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
    
    [self.agentMan listMyCommission: @{@"agentId":self.model._id,@"page":@(_page),@"pageSize":@(KpageSize) }];
}

-(void)listMyCommissiondelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg {
    [self .tabyongjinList tableViewEndRefreshCurPageCount:array.count];
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
        AgentCommissionModel *mdoel = [[AgentCommissionModel alloc]initWith:itemDic];
        [self.transferList addObject:mdoel];
    }
    
    [self.tabyongjinList reloadData];
}

-(void)setTableView{
    self.tabyongjinList.delegate  = self;
    self.tabyongjinList.dataSource = self;
    [self .tabyongjinList registerNib:[UINib nibWithNibName:KYongjinCell bundle:nil] forCellReuseIdentifier:KYongjinCell];
    self.tabyongjinList.rowHeight = 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transferList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YongjinCell *cell = [tableView dequeueReusableCellWithIdentifier:KYongjinCell];
    [cell loadData:self.transferList[indexPath.row]];
    return cell;
}



@end
