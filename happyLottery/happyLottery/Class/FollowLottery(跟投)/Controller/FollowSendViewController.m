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
#import "FollowDetailViewController.h"
#import "LoadData.h"
#import "HotSchemeModel.h"

#import "MyNoticeViewController.h"

#import "ADSModel.h"
#import "RecomPerModel.h"
#import "PersonCenterViewController.h"
#import "BuyLotteryViewController.h"
#import "WebViewController.h"

#define KRecommendViewCell @"RecommendViewCell"
#define KHotFollowSchemeViewCell @"HotFollowSchemeViewCell"
#define KHomeTabTopAdsViewCell @"HomeTabTopAdsViewCell"
@interface FollowSendViewController ()<OptionSelectedViewDelegate,UITableViewDelegate,UITableViewDataSource,FollowHeaderDelegate,LotteryManagerDelegate,HomeMenuItemViewDelegate,RecommendViewCellDelegate,HomeTabTopAdsViewDelegate,XYTableViewDelegate>
{
    NSMutableArray <ADSModel *>*adsArray;
        OptionSelectedView *optionView;
    NSArray *topMenuList;
    NSArray *eightList;
    NSMutableArray <HotSchemeModel *> * schemeList;
    
    __weak IBOutlet UITableView *tabFollewView;
}

@end

@implementation FollowSendViewController{
    BuyLotteryViewController *buyVc;
    HomeTabTopAdsViewCell *cell;
    NSString *imageName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    schemeList = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    [self getTopViewData];
    [self setRightBarItems];
    [self setTableView];
    self.title = @"跟单";
    buyVc = [[BuyLotteryViewController alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tabFollewView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self setNavigationBa];
    [self loadEightPerosn];
    imageName = nil;
    [self getHotFollowScheme];
    [self loadAdsImg];
    [cell openTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIImage *normalImage = [[UIImage imageNamed: @"quanzi_defealt.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟投" image:normalImage tag:0];
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: SystemLightGray};
    [tabBarItem setTitleTextAttributes: normalAttributes forState:UIControlStateNormal];
    self.navigationController.navigationBar.barTintColor = SystemGreen;
    self.navigationController.tabBarItem = tabBarItem;
    [cell stopTimer];
}

- (void)setNavigationBa{
    
    UIImage *selectedImage = [[UIImage imageNamed: @"quanzi_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟投" image:selectedImage tag:0];
    NSDictionary *selectedAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: SystemGreen};
    [tabBarItem setTitleTextAttributes: selectedAttributes forState:UIControlStateNormal];
    self.navigationController.navigationBar.barTintColor = SystemGreen;
    self.navigationController.tabBarItem = tabBarItem;
}

-(void)itemClickInTop:(ADSModel *)index{
    [buyVc adsImgViewClick:index navigation:self.navigationController];
}

-(void)getHotFollowScheme{
   
    [self.lotteryMan getHotFollowScheme];
}

-(void)getHotFollowScheme:(NSArray *)personList errorMsg:(NSString *)msg{
    
    if (personList == nil||personList.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.8];
        [tabFollewView reloadData];
        imageName = @"pic_gendankongbaiye.png";
        return;
    }else{
        [schemeList removeAllObjects];
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
        eightList = nil;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
        [tabFollewView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
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

-(UIImage *)xy_noDataViewImage{
    return [UIImage imageNamed:imageName];
}

-(NSNumber *)xy_noDataViewCenterYOffset{
    NSLog(@"---------------%f+++++++++++++=",[tabFollewView rectForSection:3].origin.y-self.view.bounds.size.height * (1 - 0.618)+202* (1 - 0.618)+50);
    return @([tabFollewView rectForSection:3].origin.y-self.view.bounds.size.height * (1 - 0.618)+202* (1 - 0.618)+50);
}

-(BOOL)havData{
    if (schemeList.count == 0) {
        return NO;
    }else{
        return YES;
    }
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
        cell = [tableView dequeueReusableCellWithIdentifier:KHomeTabTopAdsViewCell];
        cell.delegate = self;
        [cell loadData:adsArray];
        return  cell;
    }else   if(indexPath.section == 2){
        RecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
        cell.delegate = self;
        [cell setCollection:2 andData:eightList];
        return cell;
    }else   if(indexPath.section == 3){
        HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
        [cell loadDataWithModelInDaT:schemeList[indexPath.row]];
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
        if (eightList.count == 0) {
            return 0;
        }
        else if (eightList.count<5){
            return 85;
        }
        return 160;
    }else   if(indexPath.section == 3){
        return 202;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        if (eightList.count == 0) {
            return 1;
        }
        return 10;
    }else if (section == 0||section == 1){
        return 0.01;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3){
        return 40;
    }if (section == 1||section == 2) {
        return 0.01;
    }
    else{
        return 1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 3){
        FollowHeaderView *headerView = [[FollowHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
        headerView.delegate = self;
        return headerView;
    }else{
        return [UIView new];
    }
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"" icon:@"guize" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(pressPlayIntroduce)];
    UIBarButtonItem *faqi = [self creatBarItem:@"" icon:@"fadan" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[itemQuery,faqi];
}

- (void)pressPlayIntroduce{
    WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.type = @"html";
    webVC.title = @"跟单玩法规则";
    webVC.htmlName = @"about_follow";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) optionRightButtonAction {
    NSArray *titleArr = @[@" 竞彩足球",
                          @" 竞彩篮球"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (optionView == nil) {
        optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth-45, DisTop, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
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
        playViewVC.fromSchemeType = SchemeTypeFaqiGenDan;
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }
}

-(void)search{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
        if (self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
        MyNoticeViewController *noticeVc = [[MyNoticeViewController alloc]init];
        noticeVc.hidesBottomBarWhenPushed = YES;
        noticeVc.curUser = self.curUser;
        [self.navigationController pushViewController:noticeVc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowDetailViewController *followVC = [[FollowDetailViewController alloc]init];
    followVC.model = schemeList[indexPath.row];
    followVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:followVC animated:YES];
    
}

-(void)loadAdsImg{
    adsArray = [NSMutableArray arrayWithCapacity:0];
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/banner/byChannel?usageChannel=4",[GlobalInstance instance].homeUrl];
    [[LoadData singleLoadData] RequestWithString:strUlr isPost:NO andPara:nil andComplete:^(id data, BOOL isSuccess) {
        if (isSuccess == NO || data == nil) {
            return ;
        }
        NSString *resultStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        if ([resultDic[@"code"] integerValue] != 0) {
            return ;
        }
        
        NSArray  *modelList = resultDic[@"result"];
        for (int i = 0; i < ( modelList.count > 5?5:modelList.count); i++) {
            NSDictionary *dic = modelList[i];
            ADSModel *model = [[ADSModel alloc]initWith:dic];
            [adsArray addObject:model];
        }
        [tabFollewView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)recommendViewCellClick:(NSIndexPath *)indexpath andTabIndex:(NSInteger)index{
    if (index == 2) {
        NSDictionary *personInfo = eightList[indexpath.row];
        RecomPerModel *model = [[RecomPerModel alloc]initWith:personInfo];
        PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
        viewContr.cardCode = model.cardCode;
        viewContr.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewContr animated:YES];
        NSLog(@"%@",personInfo);
    }
}


@end
