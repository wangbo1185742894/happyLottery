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
#import "ZhanWeiTuScheme.h"

#define KRecommendViewCell @"RecommendViewCell"
#define KHotFollowSchemeViewCell @"HotFollowSchemeViewCell"
#define KHomeTabTopAdsViewCell @"HomeTabTopAdsViewCell"
#define KZhanWeiTuScheme @"ZhanWeiTuScheme"
@interface FollowSendViewController ()<OptionSelectedViewDelegate,UITableViewDelegate,UITableViewDataSource,FollowHeaderDelegate,LotteryManagerDelegate,HomeMenuItemViewDelegate,RecommendViewCellDelegate,HomeTabTopAdsViewDelegate,ToPersonViewDelegate>
{
    NSMutableArray <ADSModel *>*adsArray;
        OptionSelectedView *optionView;
    NSArray *topMenuList;
    NSArray *eightList;
    NSMutableArray <HotSchemeModel *> * schemeList;
    __weak IBOutlet UITableView *tabFollewView;
    
    __weak IBOutlet NSLayoutConstraint *bottomCons;
    NSInteger page;
}

@end

@implementation FollowSendViewController{
    BuyLotteryViewController *buyVc;
    HomeTabTopAdsViewCell *cell;
    BOOL placeImageHidden;
    FollowHeaderView *headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A416";
    schemeList = [NSMutableArray arrayWithCapacity:0];
   
    self.lotteryMan.delegate = self;
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    } 
    if ([self isIphone5s]) {
        bottomCons.constant = 44;
    }else {
        bottomCons.constant = 0;
    }
    [self getTopViewData];
    [self setRightBarItems];
    [self setSearchButtonItems];
    
    [self setTableView];
//    self.title = @"跟单";
    buyVc = [[BuyLotteryViewController alloc]init];
     [UITableView refreshHelperWithScrollView:tabFollewView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    headerView = [[FollowHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
}

-(void)loadNewData{
    [self loadEightPerosn];
    [self loadAdsImg];
}

-(void)loadMoreData{
    if (headerView.btnNotice.selected) {
        return;
    }
    page ++;
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)};
    [self.lotteryMan getAttentFollowScheme:dic];
}

//刷新数据
- (void)refreshView {
    headerView.btnGenDan.selected = YES;
    headerView.btnNotice.selected = NO;
    [self loadNewData];
    [tabFollewView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

//由二级页面返回，不刷新数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    placeImageHidden = YES;

    [self setNavigationBa];
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
    [tabFollewView tableViewEndRefreshCurPageCount:personList.count];
    if (personList == nil||personList.count == 0) {
        placeImageHidden = NO;
        [self showPromptText:msg hideAfterDelay:1.8];
        [tabFollewView reloadData];
        return;
    }else{
        [schemeList removeAllObjects];
    }
    for (NSDictionary *dic in personList) {
        [schemeList addObject:[[HotSchemeModel alloc]initWith:dic]];
    }
    [UIView performWithoutAnimation:^{
        [self->tabFollewView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

-(void)loadEightPerosn{
    [self.lotteryMan listGreatFollow:nil];
}

-(void)listGreatFollow:(NSArray *)personList errorMsg:(NSString *)msg{
    if (headerView.btnGenDan.selected) {
        [self actionToGD];
    }
    else {
        [self actionToNotice];
    }
    if (personList == nil) {
        eightList = nil;
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
        [tabFollewView reloadData];
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    eightList = personList;
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
   
    [tabFollewView reloadData];
//    [tabFollewView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
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
    [tabFollewView registerNib:[UINib nibWithNibName:KZhanWeiTuScheme bundle:nil] forCellReuseIdentifier:KZhanWeiTuScheme];
    
    [tabFollewView reloadData];
    
}

-(void)itemClickToPerson:(NSString *)carcode{
    PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
    viewContr.cardCode = carcode;
    viewContr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewContr animated:YES];
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
        if(schemeList.count == 0){
            return 1;
        }
        if ([self.curUser.whitelist boolValue] == NO) {
             return 0;
        }else{
             return schemeList.count;
        }
       
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
        if (schemeList.count == 0) {
            ZhanWeiTuScheme *cell = [tableView dequeueReusableCellWithIdentifier:KZhanWeiTuScheme];
            [cell reloadDateInFollow];
            cell.hidden = placeImageHidden;
            return cell;
        }
        HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
        [cell loadDataWithModelInDaT:schemeList[indexPath.row]];
        cell.delegate = self;
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
        return 170;
    }else   if(indexPath.section == 3){
        if (schemeList.count == 0) {
            return (tabFollewView.bounds.size.height - [tabFollewView rectForSection:3].origin.y-40-44);
        }
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

//搜索框添加
-(void)setSearchButtonItems{
    UIButton *tfSearchKey = [UIButton buttonWithType:UIButtonTypeCustom];
    tfSearchKey.frame = CGRectMake(0, 25,KscreenWidth - 110, 30);
    tfSearchKey.backgroundColor = RGBCOLOR(146, 229, 205);
    tfSearchKey.layer.cornerRadius = 12;
    tfSearchKey.layer.masksToBounds = YES;
    [tfSearchKey setTitle:@"搜索大神" forState:UIControlStateNormal];
    tfSearchKey.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [tfSearchKey setImage:[UIImage imageNamed:@"sousuo"] forState:0];
    tfSearchKey.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    tfSearchKey.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    tfSearchKey.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:tfSearchKey];
    self.navigationItem.leftBarButtonItem = barItem;
    [tfSearchKey addTarget:self action:@selector(actionToSearchView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionToSearchView {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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

- (void)actionToGD {
    placeImageHidden = YES;
    [schemeList removeAllObjects];
    [self getHotFollowScheme];
}

- (void)actionToNotice {
    placeImageHidden = YES;
    [schemeList removeAllObjects];
    page = 1;
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)};
    [self.lotteryMan getAttentFollowScheme:dic];
}


- (void) gotAttentFollowScheme:(NSArray  *)personList  errorMsg:(NSString *)msg{
    [tabFollewView tableViewEndRefreshCurPageCount:personList.count];
    if (personList.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.0];
        placeImageHidden = NO;
        [UIView performWithoutAnimation:^{
            [self->tabFollewView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        return;
    }
    if (page == 1) {
        [schemeList removeAllObjects];
    }
    
    //添加数据
    for (NSDictionary *dic in personList) {
        HotSchemeModel *model = [[HotSchemeModel alloc]initWith:dic];
        [schemeList addObject:model];
    }
    
    [UIView performWithoutAnimation:^{
        [self->tabFollewView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

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
    }else if (index == 3){  // 个人中心
        if (self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
        PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
        viewContr.cardCode = self.curUser.cardCode;
        viewContr.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewContr animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowDetailViewController *followVC = [[FollowDetailViewController alloc]init];
    if (schemeList.count == 0) {
        return;
    }
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
        [tabFollewView reloadData];
//        [tabFollewView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)recommendViewCellClick:(NSIndexPath *)indexpath andTabIndex:(NSInteger)index{
    if (self.curUser.whitelist == NO) {
        return;
    }
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
