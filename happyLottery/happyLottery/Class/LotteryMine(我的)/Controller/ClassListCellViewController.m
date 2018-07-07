//
//  ClassListCellViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassListCellViewController.h"
#import "UserInfoDetailViewController.h"
#import "WBMenu.h"
#import "UserInfoBaseModel.h"
#import "CashAndIntegrationWaterTableViewCell.h"
#define KClassItemViewCell @"CashAndIntegrationWaterTableViewCell"
@interface ClassListCellViewController ()<WBMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewDelegate,MemberManagerDelegate,WBMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property(nonatomic,strong)NSMutableArray <UserInfoBaseModel *>*classArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation ClassListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.memberMan.delegate= self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT + 84;
    [UITableView refreshHelperWithScrollView:self.classListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
    self.classArray = [NSMutableArray arrayWithCapacity:0];
    if ([self.strApi isEqualToString:API_listSubscribeDetail]) {
        [self loadNewData];
    }
}


-(Class)getCurModelClass{
    NSDictionary<NSString *,Class>  *classDic = @{API_listSubscribeDetail:[SubscribeDetail class],API_listRechargeDetail:[RechargeDetail class],API_listBonusDetail:[BonusDetail class],API_listWithdrawDetail:[WithdrawDetail class],API_listHandselDetail:[HandselDetail class],API_listFollowDetail:[FollowDetail class],API_listAgentCommissionDetail:[AgentCommissionDetail class]};
    return classDic[self.strApi];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self loadNewData];
    
}

-(void)loadNewData{
    _page = 1;
    [self loadData];
}
-(void)loadMoreData{
    _page ++;
    [self loadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 1)];
    footer.backgroundColor = RGBCOLOR(230, 230, 230);
    return  footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 1)];
    footer.backgroundColor = RGBCOLOR(230, 230, 230);
    return  footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(void)setTableView{
    self.classListView .delegate = self;
    self.classListView.rowHeight = 70;
    self.classListView.dataSource = self;
    [self.classListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{
    [self.firstPara setObject:@(_page) forKey:@"page"];
    [self.memberMan getUserCashInfo:self.firstPara andApi:_strApi];
}

-(void)gotUserCashInfoList:(NSArray *)infoList errorMsg:(NSString *)msg{
    [self.classListView  tableViewEndRefreshCurPageCount:KpageSize];
    if (self.page == 1) {
        [self.classArray removeAllObjects];
    }
    if (infoList == nil || infoList.count == 0) {
        [self.classListView reloadData];
        
        return;
    }
    
    for (NSDictionary *itemDic in infoList) {
        
        UserInfoBaseModel *model = [[[self getCurModelClass]alloc]init];
        model = [model initWith:itemDic];
        [self.classArray addObject:model];
    }
    [self.classListView reloadData];
}

-(BOOL)isRefresh{
    
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classArray.count;
}

-(BOOL)havData{
    if (self.classArray.count == 0) {
        return NO;
    }else{
        return YES;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashAndIntegrationWaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KClassItemViewCell];
    [cell loadUserInfo:self.classArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoDetailViewController *detailVC = [[UserInfoDetailViewController alloc]init];
    detailVC.model = self.classArray[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navVC.navigationController pushViewController:detailVC animated:YES];
}

-(void)refresh{
    [self loadNewData];
}


@end
