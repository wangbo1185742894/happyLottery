//
//  GroupNewViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupNewViewController.h"
#import "AgentInfoModel.h"
#import "AgentInfoCell.h"
#import "GroupFollowCell.h"
#import "AgentDynamicCell.h"
#import "AgentHeaderView.h"
#import "GroupFollowViewController.h"
#import "GroupMemberVC.h"
#import "ZhanWeiTuScheme.h"
#define KAgentInfoCell @"AgentInfoCell"
#define KGroupFollowCell @"GroupFollowCell"
#define KAgentDynamicCell @"AgentDynamicCell"
#define KZhanWeiTuScheme @"ZhanWeiTuScheme"


@interface GroupNewViewController ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate,GroupFollowDelegate,AgentInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *groupTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDIs;
@property(nonatomic,strong)NSMutableArray <AgentDynamic *> * dynamicArray;

@end

@implementation GroupNewViewController{
    
    AgentInfoModel *model;
    NSString *followCount;
    AgentDynamic *dynamicModel;
    NSTimer *timer;
    BOOL placeImageHidden;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self openTimer];
    placeImageHidden = YES;
    [self.groupTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    if ([self isIphoneX]) {
        self.topDIs.constant = -44;
    }else{
        self.topDIs.constant = -20;
    }
    
    if (self.agentMan == nil) {
        self.agentMan = [[AgentManager alloc]init];
    }
    self.agentMan.delegate = self;
    self.dynamicArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode};
//    [self.agentMan listAgentDynamic:dic];
    [self.agentMan getAgentInfo:dic];
    [self showLoadingText:@"正在加载"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadAgentDynamic{
    NSDictionary *dic = @{@"agentId":model._id};
    [self.agentMan listAgentDynamic:dic];
}

- (void)stopTimer {
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)openTimer {
    [timer setFireDate:[NSDate date]];
}

-(void)setTableView{
    self.groupTableView.delegate = self;
    self.groupTableView.dataSource = self;
    [self.groupTableView registerNib:[UINib nibWithNibName:KAgentInfoCell bundle:nil] forCellReuseIdentifier:KAgentInfoCell];
    [self.groupTableView registerNib:[UINib nibWithNibName:KGroupFollowCell bundle:nil] forCellReuseIdentifier:KGroupFollowCell];
    [self.groupTableView registerNib:[UINib nibWithNibName:KAgentDynamicCell bundle:nil] forCellReuseIdentifier:KAgentDynamicCell];
     [self.groupTableView registerNib:[UINib nibWithNibName:KZhanWeiTuScheme bundle:nil] forCellReuseIdentifier:KZhanWeiTuScheme];
    
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void )getAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (!success) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    model = [[AgentInfoModel alloc]initWith:param];
    NSDictionary *dic = @{@"agentId":model._id};
    [self.agentMan getAgentFollowCount:dic];
    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(reloadAgentDynamic) userInfo:nil repeats:YES];
}



-(void )listAgentDynamicdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (!success) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    [self.dynamicArray removeAllObjects];
    if (array.count == 0) {
        if (!placeImageHidden) {
            return;
        }
        placeImageHidden = NO;
        [self.groupTableView reloadData];
        [self hideLoadingView];
        return;
    }
    //添加数据
    for (NSDictionary *dic in array) {
        AgentDynamic *model = [[AgentDynamic alloc]initWith:dic];
        [self.dynamicArray addObject:model];
    }
    [self.groupTableView reloadData];
    [self hideLoadingView];
}

-(void )getAgentFollowCountdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (!success) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    followCount = string;
    [self.groupTableView reloadData];
    NSDictionary *dic = @{@"agentId":model._id};
    [self.agentMan listAgentDynamic:dic];
}

- (void)groupFollowScheme{
    GroupFollowViewController *groupVc =  [[GroupFollowViewController alloc]init];
    groupVc.agentId= model._id;
    groupVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVc animated:YES];
}

- (void)agentMember{
    GroupMemberVC *membVc = [[GroupMemberVC alloc]init];
    membVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:membVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =====UITableView=========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AgentHeaderView *headerView = [[AgentHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
    if (section == 1) {
        [headerView.headImage setImage:[UIImage imageNamed:@"pic_quanneigendan"] forState:UIControlStateNormal];
        headerView.headTitle.text = nil;
        return headerView;
    }
    if (section == 2) {
        [headerView.headImage setImage:[UIImage imageNamed:@"pic_quanneidongtai"] forState:UIControlStateNormal];
        headerView.headTitle.text = @"实时更新圈内好友动态";
        return headerView;
    }
    UIView *view;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 278;
    }
    if (indexPath.section == 1) {
        return 165;
    }
    if (self.dynamicArray.count == 0) {
         return 200;
    }
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if (self.dynamicArray.count == 0) {
            return 1;
        }
        return self.dynamicArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AgentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KAgentInfoCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (model!=nil) {
            [cell reloadDate:model];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        GroupFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KGroupFollowCell];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model != nil) {
            [cell reloadDate:followCount];
        }
        return cell;
    }
    if (self.dynamicArray.count == 0) {
        ZhanWeiTuScheme *cell = [tableView dequeueReusableCellWithIdentifier:KZhanWeiTuScheme];
        [cell reloadDateInGroup];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hidden = placeImageHidden;
        return cell;
    }
    AgentDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:KAgentDynamicCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dynamicArray.count >0) {
        dynamicModel = [self.dynamicArray objectAtIndex:indexPath.row];
        [cell reloadDate:dynamicModel];
    }
    
    return cell;
}

@end
