//
//  GroupFollowViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupFollowViewController.h"
#import "HotFollowSchemeViewCell.h"
#import "FollowDetailViewController.h"

#define KHotFollowSchemeViewCell  @"HotFollowSchemeViewCell"

@interface GroupFollowViewController ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property(assign,nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray <HotSchemeModel *> * personArray;

@end

@implementation GroupFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDis.constant = NaviHeight;
    self.title = @"跟投列表";
    [self initTabelView];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    if (self.agentMan == nil) {
        self.agentMan = [[AgentManager alloc]init];
    }
    self.agentMan.delegate = self;
    [UITableView refreshHelperWithScrollView:self.listTableView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//
    [self loadNewData];
}
-(void)loadNewData{
    self.page = 0;
    NSDictionary *dic = @{@"agentId":self.agentId,@"page":@(_page),@"pageSize":@(KpageSize)};
    [self.agentMan listAgentFollow:dic];
}
-(void)loadMoreData{
    self.page ++;
    NSDictionary *dic = @{@"agentId":self.agentId,@"page":@(_page),@"pageSize":@(KpageSize)};
    [self.agentMan listAgentFollow:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}


-(void )listAgentFollowdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.listTableView tableViewEndRefreshCurPageCount:array.count];
    if (!success) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    if (self.page == 0) {
        [self.personArray removeAllObjects];
    }
    //添加数据
    for (NSDictionary *dic in array) {
        HotSchemeModel *model = [[HotSchemeModel alloc]initWith:dic];
        [self.personArray addObject:model];
    }
    [self.listTableView reloadData];
    
}

- (void)initTabelView {
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.listTableView registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 202;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
    HotSchemeModel *model = [self.personArray objectAtIndex:indexPath.row];
    [cell loadDataWithModelInNotice:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowDetailViewController *followVC = [[FollowDetailViewController alloc]init];
    followVC.model = self.personArray[indexPath.row];
    followVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:followVC animated:YES];
}

@end
