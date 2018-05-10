//
//  FollowSendViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowSendViewController.h"
#import "OptionSelectedView.h"
#import "JCLQPlayController.h"
#import "JCZQPlayViewController.h"
#import "RecommendPerViewController.h"
#import "RecommendViewCell.h"
#import "HotFollowSchemeViewCell.h"
#import "FollowHeaderView.h"
#import "HomeTabTopAdsViewCell.h"
#import "SearchViewController.h"
#import "MenuCollectionViewCell.h"
#import "HotSchemeModel.h"
#define KRecommendViewCell @"RecommendViewCell"
#define KHotFollowSchemeViewCell @"HotFollowSchemeViewCell"
#define KHomeTabTopAdsViewCell @"HomeTabTopAdsViewCell"
@interface FollowSendViewController ()<OptionSelectedViewDelegate,UITableViewDelegate,UITableViewDataSource,FollowHeaderDelegate,LotteryManagerDelegate,HomeMenuItemViewDelegate,RecommendViewCellDelegate>
{
    
        OptionSelectedView *optionView;
    NSArray *topMenuList;
    NSArray *eightList;
    NSMutableArray <HotSchemeModel *> * schemeList;
    
    __weak IBOutlet UITableView *tabFollewView;
}

@end

@implementation FollowSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    schemeList = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    [self getTopViewData];
    [self setRightBarItems];
    [self setTableView];
    
    [self loadEightPerosn];
    
    [self getHotFollowScheme];
    
}
-(void)getHotFollowScheme{
    [self.lotteryMan getHotFollowScheme];
}

-(void)getHotFollowScheme:(NSArray *)personList errorMsg:(NSString *)msg{
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    for (NSDictionary *dic in personList) {
        [schemeList addObject:[[HotSchemeModel alloc]initWith:dic]];
    }
    [tabFollewView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadEightPerosn{
    [self.lotteryMan listGreatFollow:nil];
}

-(void)listGreatFollow:(NSArray *)personList errorMsg:(NSString *)msg{
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    eightList = personList;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
    
    
    [tabFollewView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)getTopViewData{
    
    topMenuList = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"FollowTop" ofType: @"plist"]];
}


-(void)setTableView{
    tabFollewView.delegate = self;
    tabFollewView.dataSource = self;
    [tabFollewView registerNib:[UINib nibWithNibName:KRecommendViewCell bundle:nil] forCellReuseIdentifier:KRecommendViewCell];
    [tabFollewView registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];
    [tabFollewView registerClass:[HomeTabTopAdsViewCell class] forCellReuseIdentifier:KHomeTabTopAdsViewCell];
    [tabFollewView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else   if(section == 1){
        return 1;
    }else   if(section == 2){
        return 1;
    }else   if(section == 3){
        return schemeList.count;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
        cell.delegate = self;
        [cell setCollection:0 andData:topMenuList];
        return cell;
    }else   if(indexPath.section == 1){
        HomeTabTopAdsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeTabTopAdsViewCell];
        return  cell;
    }else   if(indexPath.section == 2){
        RecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
        [cell setCollection:2 andData:eightList];
        return cell;
    }else   if(indexPath.section == 3){
        HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
        [cell loadDataWithModel:schemeList[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 85;
    }else   if(indexPath.section == 1){
        return  80;
    }else   if(indexPath.section == 2){
        
        return 170;
    }else   if(indexPath.section == 3){
        return 200;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1 || section == 2){
        return 10;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3){
        return 40;
    }else{
        return 1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 3){
        FollowHeaderView *headerView = [[FollowHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
        headerView.delegate = self;
        return headerView;
    }else{
        return [UIView new];
    }
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"发起跟投" icon:@"" andFrame:CGRectMake(0, 10, 65, 25) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[itemQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) optionRightButtonAction {
    NSArray *titleArr = @[@" 竞猜篮球",
                          @" 竞猜足球"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (optionView == nil) {
        optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, DisTop, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    }else{
        optionView.hidden = NO;
    }
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
    
}

- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    if(index == 0){
        JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        playViewVC.fromSchemeType = SchemeTypeFaqiGenDan;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }else if(index == 1){
        JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        playViewVC.fromSchemeType = SchemeTypeFaqiGenDan;
        [self.navigationController pushViewController:playViewVC animated:YES];
        
    }
}

-(void)search{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self presentViewController:searchVC animated:YES completion:nil];
}

//牛人，红人，红单榜
- (void)actionToRecommed:(NSString *)categoryCode {
    RecommendPerViewController *perVC = [[RecommendPerViewController alloc]init];
    perVC.hidesBottomBarWhenPushed = YES;
    perVC.navigationController.navigationBar.hidden = YES;
    perVC.categoryCode = categoryCode;
    [self.navigationController pushViewController:perVC animated:YES];
}


-(void)itemClick:(NSInteger)index{
    if (index == 0) {  // 牛人
        [self actionToRecommed:@"Cowman"];
    }else if (index == 1){  // 红人
        [self actionToRecommed:@"Redman"];
    }else if (index == 2){ // 红单
        [self actionToRecommed:@"RedScheme"];
    }else if (index == 3){  // 我的关注
        
    }
}


@end
