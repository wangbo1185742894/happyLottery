//
//  LegClassListCellViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "LegClassListCellViewController.h"
#import "UserInfoDetailViewController.h"
#import "WBMenu.h"
#import "UserInfoBaseModel.h"
#import "CashAndIntegrationWaterTableViewCell.h"
#define KClassItemViewCell @"CashAndIntegrationWaterTableViewCell"
@interface LegClassListCellViewController ()<WBMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewDelegate,WBMenuViewDelegate,PostboyManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property(nonatomic,strong)NSMutableArray <UserInfoBaseModel *>*classArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation LegClassListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.postboyMan.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT + 84 + 75 +30;
    [UITableView refreshHelperWithScrollView:self.classListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    self.classArray = [NSMutableArray arrayWithCapacity:0];
    if ([self.strApiLeg isEqualToString:APIListSubscribeDetailByPostboy]) {
        [self loadNewData];
    }
}


-(Class)getCurModelClassLeg{
    NSDictionary<NSString *,Class>  *classDicLeg = @{APIListSubscribeDetailByPostboy:[SubscribeDetail class],APIGetChasePrepayOrderListByPostboy:[ChasePrepayModel class],APIListRechargeDetailByPostboy:[RechargeDetail class],APIListBonusDetailByPostboy:[BonusDetail class],APIListWithdrawDetailByPostboy:[WithdrawDetail class],APIListCommissionDetailByPostboy:[PostboyBlotterDetailModel class],APIListTransferByPostboy:[MemberPostboyTransferModel class]};
    return classDicLeg[self.strApiLeg];
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
    self.classListView.rowHeight = 75;
    self.classListView.dataSource = self;
    [self.classListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadData{
    [self.firstParaLeg setObject:@(_page) forKey:@"page"];
    [self.postboyMan getLegUserCashInfo:self.firstParaLeg andApi:_strApiLeg];
}


-(void)gotLegUserCashInfoList:(NSArray *)infoList errorMsg:(NSString *)msg{
    [self.classListView  tableViewEndRefreshCurPageCount:KpageSize];
    if (self.page == 1) {
        [self.classArray removeAllObjects];
    }
    if (infoList == nil || infoList.count == 0) {
        [self.classListView reloadData];
        
        return;
    }
    
    for (NSDictionary *itemDic in infoList) {
        
        UserInfoBaseModel *model = [[[self getCurModelClassLeg]alloc]init];
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
    [self.navVCLeg.navigationController pushViewController:detailVC animated:YES];
}

-(void)refresh{
    [self loadNewData];
}


@end
