//
//  MyFavoriteViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//我的收藏

#import "MyFavoriteViewController.h"
#import "JczqShortcutModel.h"
#import "NewsListCell.h"
#import "UMChongZhiViewController.h"
#define KNewsListCell @"NewsListCell"
@interface MyFavoriteViewController ()<LotteryManagerDelegate,UITableViewDelegate,UITableViewDataSource,NewsListCellDelegate>
{
    NSMutableArray <JczqShortcutModel *> *JczqShortcutList;
    JczqShortcutModel *curModel;
    NSInteger page;
}
@property (weak, nonatomic) IBOutlet UITableView *tabCollectMatchList;

@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    self.title = @"我的收藏";
    JczqShortcutList = [NSMutableArray arrayWithCapacity:0];
    self.viewControllerNo = @"A212";
    [super viewDidLoad];
    page = 1;
    [self setTableView];
    [self getJczqShortcut];
    [self setTableViewLoadRefresh];
}

-(void)setTableViewLoadRefresh{
    
    _tabCollectMatchList.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        page ++ ;
        [self getJczqShortcut];
        [_tabCollectMatchList reloadData];
    }];
    
    _tabCollectMatchList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getJczqShortcut];
        [_tabCollectMatchList reloadData];
    }];
}

-(void)setTableView{
    
    _tabCollectMatchList.delegate = self;
    _tabCollectMatchList.dataSource = self;
    [_tabCollectMatchList registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    _tabCollectMatchList.rowHeight = 117;
    [_tabCollectMatchList reloadData];
}
//{"cardCode":"xxxx","page":"xxx","pageSize":"xxx"}
-(void)getJczqShortcut{
    
    self.lotteryMan.delegate = self ;
    [self.lotteryMan getCollectedMatchList:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@"10"}];
}

-(void)gotCollectedMatchList:(NSArray *)infoArray errorMsg:(NSString *)msg{
    [self.tabCollectMatchList.mj_header endRefreshing];
    [self.tabCollectMatchList.mj_footer endRefreshing];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    
    if (page == 1) {
        [JczqShortcutList removeAllObjects];
    }
    for (NSDictionary* infoDic in infoArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [JczqShortcutList addObject:model];
    }
    [self.tabCollectMatchList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return JczqShortcutList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell refreshDataCollect:JczqShortcutList[indexPath.row] andSelect:YES];
    cell.delegate = self;
    return cell;
    
}

-(void)newScollectMatch:(JczqShortcutModel *)model andIsSelect:(BOOL)isSelect{
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    curModel = model;
    page = 1;
    [self.lotteryMan collectMatch:@{@"cardCode":self.curUser.cardCode,@"matchKey":model.matchKey,@"isCollect":@(NO)}];
}

-(void)collectedMatch:(BOOL)isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect{
    if (isSuccess) {
        [self showPromptText:@"已取消收藏" hideAfterDelay:1.7];
        [self getJczqShortcut];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    JczqShortcutModel * model =JczqShortcutList[indexPath.row];
    
    matchDetailVC.model = model ;
    model.forecastOptions = model.predict;
    
    NSDate *matchDate = [Utility dateFromDateStr:model.dealLine withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *curDate= [NSDate date];
    NSInteger res = [matchDate compare:curDate];
    
    //[model jCZQScoreZhiboToJcForecastOptions];
//    if ([matchDetailVC.model.spfSingle boolValue] == YES) {
//        matchDetailVC.isHis = YES;
//    }else{
//        
//       
//    }
    if (res != 1) {
    matchDetailVC.isHis = YES;
    }else{
        matchDetailVC.isHis = NO;
    }
    
    matchDetailVC.hidesBottomBarWhenPushed = YES;
    matchDetailVC.curPlayType =@"jczq";
    [self.navigationController pushViewController:matchDetailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

@end
