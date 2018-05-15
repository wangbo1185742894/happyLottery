//
//  PersonCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "HotFollowSchemeViewCell.h"
#import "PersonCenterCell.h"
#import "PersonCenterModel.h"

#define KHotFollowSchemeViewCell  @"HotFollowSchemeViewCell"
#define KPersonCenterCell  @"PersonCenterCell"

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,PersonCenterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTabelView;
@property (nonatomic,strong) NSMutableArray <HotSchemeModel *> * personArray;
@property(assign,nonatomic)NSInteger page;
@end

@implementation PersonCenterViewController{
    PersonCenterModel *model;
    BOOL isAttend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [UITableView refreshHelperWithScrollView:self.personTabelView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    _page = 1;
    [self initTabelView];
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    [self showLoadingViewWithText:@"正在加载"];
    NSDictionary *dic = @{@"cardCode":self.cardCode};
    [self.lotteryMan getInitiateInfo:dic];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabelView {
    self.personTabelView.delegate = self;
    self.personTabelView.dataSource = self;
    [self.personTabelView registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];
    [self.personTabelView registerNib:[UINib nibWithNibName:KPersonCenterCell bundle:nil] forCellReuseIdentifier:KPersonCenterCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 196;
    }
    return 208;
}


- (void) gotisAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    isAttend = [diction boolValue];
    [self loadNewData];
}

- (void) gotInitiateInfo:(NSDictionary *)diction  errorMsg:(NSString *)msg
{
    model = [[PersonCenterModel alloc]initWith:diction];
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
    [self.lotteryMan isAttent:dic];
    
}

-(void)loadNewData{
    _page = 1;
    NSDictionary *parc;
    if (model.nickName != nil) {
        parc = @{@"nickName":model.nickName,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
    }else{
        parc = @{@"nickName":model.cardCode,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
    }
    [self.lotteryMan getFollowSchemeByNickName:parc];
}

-(void)loadMoreData{
    _page ++;
    NSDictionary *parc;
    if (model.nickName != nil) {
        parc = @{@"nickName":model.nickName,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
    }
    [self.lotteryMan getFollowSchemeByNickName:parc];
}

-(void)getHotFollowScheme:(NSArray *)personList errorMsg:(NSString *)msg{
    [self.personTabelView tableViewEndRefreshCurPageCount:personList.count];
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    if (_page == 1) {
        [self.personArray removeAllObjects];
    }
    for (NSDictionary *dic in personList) {
        [self.personArray addObject:[[HotSchemeModel alloc]initWith:dic]];
    }
    [self.personTabelView  reloadData];
    [self hideLoadingView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:KPersonCenterCell];
        cell.delegate = self;
        [cell reloadCell:model isAttend:isAttend];
        return cell;
    }
    HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
    if (self.personArray .count >0) {
        HotSchemeModel *model = [self.personArray objectAtIndex:indexPath.row - 1];
        [cell loadDataWithModel:model];
    }

    return cell;
}

- (void)addOrReliefAttend {
    if (isAttend) {
        //取消关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan reliefAttent:dic];
    }
    else {
        //添加关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan attentMember:dic];
    }
}

- (void) gotAttentMember:(NSString *)diction  errorMsg:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:2.0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (diction) {
        isAttend = YES;
        [self.personTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showPromptText:@"添加关注成功" hideAfterDelay:2.0];
    }
}

- (void) gotReliefAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:2.0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (diction) {
        isAttend = NO;
        [self.personTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showPromptText:@"取消关注成功" hideAfterDelay:2.0];
    }
}

@end
