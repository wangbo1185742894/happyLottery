//
//  MyNoticeViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyNoticeViewController.h"
#import "HotFollowSchemeViewCell.h"
#import "FollowDetailViewController.h"

#define KHotFollowSchemeViewCell  @"HotFollowSchemeViewCell"

@interface MyNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property(assign,nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray <HotSchemeModel *> * personArray;

@end

@implementation MyNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.viewControllerNo = @"A420";
    [self initTabelView];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    [UITableView refreshHelperWithScrollView:self.listTableView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}
-(void)loadNewData{
    self.page = 0;
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"page":@(_page),@"pageSize":@(KpageSize)};
    [self.lotteryMan getAttentFollowScheme:dic];
}
-(void)loadMoreData{
    self.page ++;
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"page":@(_page),@"pageSize":@(KpageSize)};
    [self.lotteryMan getAttentFollowScheme:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gotAttentFollowScheme:(NSArray  *)personList  errorMsg:(NSString *)msg{
    [self.personArray removeAllObjects];
    //添加数据
    [self.listTableView tableViewEndRefreshCurPageCount:personList.count];
    for (NSDictionary *dic in personList) {
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
