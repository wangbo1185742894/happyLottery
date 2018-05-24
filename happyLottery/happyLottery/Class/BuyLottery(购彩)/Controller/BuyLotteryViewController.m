//
//  BuyLotteryViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BuyLotteryViewController.h"
#import "WebShowViewController.h"
#import "WebCTZQHisViewController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "CTZQPlayViewController.h"
#import "DiscoverViewController.h"
#import "TopUpsViewController.h"
#import "WBAdsImgView.h"
#import "JCZQPlayViewController.h"
#import "HomeMenuItemView.h"
#import "NewsListCell.h"
#import "NewsViewController.h"
#import "ForecastViewController.h"
#import "JCZQPlayViewController.h"
#import "JczqShortcutModel.h"
#import "YuCeSchemeCreateViewController.h"
#import "WBHomeJCYCViewController.h"
#import "WBBifenZhiboViewController.h"
#import "HomeJumpViewController.h"
#import "UMChongZhiViewController.h"
#import "MyCouponViewController.h"
#import "AppSignModel.h"
#import "LoadData.h"
#import "NewsModel.h"
#import "ADSModel.h"
#import "WebShowViewController.h"
#import "GYJPlayViewController.h"
#import "RedPacket.h"
#import "OpenRedPopView.h"
#import "MyRedPacketViewController.h"
#import "LotteryAreaViewController.h"
#import "ActivityInfoView.h"
#import "WebViewController.h"
#import "LotteryCollectionView.h"
#import "LotteryAreaViewCell.h"
#define KNewsListCell @"NewsListCell"
#define AnimationDur 0.3
#define KAppSignModelShow @"appSignModelShow"
#define KAppSignModelUrl @"appSignModelUrl"

static NSString *ID = @"LotteryAreaViewCell";

@interface BuyLotteryViewController ()<WBAdsImgViewDelegate,HomeMenuItemViewDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,NewsListCellDelegate,OpenRedPopViewDelegate,MemberManagerDelegate,VersionUpdatingPopViewDelegate,NetWorkingHelperDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray  <JczqShortcutModel *>*JczqShortcutList;
    NSMutableArray  <JczqShortcutModel *>*colloectList;
    ActivityInfoView *activityInfoView;
    __weak IBOutlet UIView *viewNews;
    __weak IBOutlet UIView *scrContentView;
    __weak IBOutlet NSLayoutConstraint *homeViewHeight;
    WBAdsImgView *adsView;
    UIView  *menuView;
    AppSignModel *appSignModel;

    __weak IBOutlet UICollectionView *lotteryPlayView;
    __weak IBOutlet NSLayoutConstraint *btnGyjHeight;
    OpenRedPopView *popView;
    __weak IBOutlet NSLayoutConstraint *spaceBtnGyj;
    __weak IBOutlet NSLayoutConstraint *contentViewDisTop;
    NSMutableArray *listUseRedPacketArray;
     RedPacket *r;
     int j;
    RedPacket *red ;
    __weak IBOutlet UIView *viewNewDefault;
    CGFloat curY;
    __weak IBOutlet NSLayoutConstraint *newsViewMarginTop;
    __weak IBOutlet NSLayoutConstraint *tabForecastListHeight;
    __weak IBOutlet UITableView *tabForecaseList;
    __weak IBOutlet NSLayoutConstraint *gyjMarginTop;
    LoadData *singleLoad;
    NewsModel *newsModel;
    NSMutableArray <ADSModel *>*adsArray;
    __weak IBOutlet UIImageView *imgNewIcon;
    __weak IBOutlet UILabel *labNewTitle;
    __weak IBOutlet UILabel *labLookNum;
    __weak IBOutlet UILabel *labNewDate;
    
    
    __weak IBOutlet UIView *redPacketContent;
    __weak IBOutlet NSLayoutConstraint *redPacketWidth;
    __weak IBOutlet NSLayoutConstraint *yucViewDisTop;
    
    __weak IBOutlet UIView *redpacketView;

    __weak IBOutlet UIButton *openRedpacketButton;
    
    __weak IBOutlet UIButton *redpacketCancel;
    
    __weak IBOutlet NSLayoutConstraint *disBottom;
    __weak IBOutlet UILabel *redpacketLab;
    __weak IBOutlet UIButton *goRedPacket;

    __weak IBOutlet UIButton *gyjButton;
    BOOL showGJbtn;
}
@property(nonatomic,strong)Lottery *lottery;
@end

@implementation BuyLotteryViewController{
   UINavigationController *navGationCotr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat bottomheight;
    
    if ([self isIphoneX]) {
        bottomheight = 83;
    }else{
        bottomheight = 49;
    }
    activityInfoView = [[ActivityInfoView alloc ]initWithFrame:CGRectMake(0, KscreenHeight - bottomheight - 70, KscreenWidth, 70)];
    activityInfoView.frame = CGRectMake(0, KscreenHeight - bottomheight - 70, KscreenWidth, 70);
    [activityInfoView setStartBtnTarget:self andAction:@selector(startActivity)];

    activityInfoView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToPlayVC:) name:@"NSNotificationJumpToPlayVC" object:nil];
#ifdef APPSTORE
    [self appStoreUpadata];
#else
    [self checkUpdateNetWork];
#endif
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemNotification:) name:@"NSNotificationBuyVCJump" object:nil];
    JczqShortcutList = [NSMutableArray arrayWithCapacity:0];
    colloectList = [NSMutableArray arrayWithCapacity:0];
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.memberMan.delegate =  self;
    j=0;
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
     singleLoad = [LoadData singleLoadData];
    [self setViewFeature];
    [self setADSUI];
    [self setMenu];
    [self setNewsView];
    [self gyjButtonView];
    [self setDLTCTZQView];
    [self .lotteryMan getAppSign:nil];
    [self setTableView];
        openRedpacketButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [lotteryPlayView registerNib:[UINib nibWithNibName:@"LotteryAreaViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [lotteryPlayView setCollectionViewLayout:layout];
    lotteryPlayView.delegate = self;
    lotteryPlayView.dataSource = self;
    
//    [self.view bringSubviewToFront:redpacketView];
//    [self.view insertSubview:redpacketView aboveSubview:self.tabBarController.tabBar];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KscreenWidth/4,90);
    
//        return CGSizeMake(125, 115);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  8;
    
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LotteryAreaViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.lotteryName.text = @"逗你玩";
    return cell;
}

-(void)gotAppSign:(NSDictionary *)personList errorMsg:(NSString *)msg{
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
//        activityInfoView.hidden = YES;
        return;
    }
    BOOL isNotShow =[[[NSUserDefaults standardUserDefaults] objectForKey:KAppSignModelShow] boolValue];
    NSString * modelUrl =[[NSUserDefaults standardUserDefaults] objectForKey:KAppSignModelUrl];
    appSignModel = [[AppSignModel alloc]initWith:personList];
    
    activityInfoView.labActivityInfo.text = appSignModel.describe;
    if (modelUrl == nil) {
        activityInfoView.hidden = NO;
    }else{
//        [[NSUserDefaults standardUserDefaults] setValue:@0  forKey:KAppSignModelShow];
//        bug修改(目前杀掉进程后的第一次打开悬浮窗不显示，再杀进程再打开时，悬浮窗又出现了),如有新问题改回  lyw
        if ([modelUrl isEqualToString:appSignModel.skipUrl]) {
            [[NSUserDefaults standardUserDefaults] setValue:@(isNotShow)  forKey:KAppSignModelShow];
            activityInfoView.hidden =  isNotShow;
        }else{
            activityInfoView.hidden = NO;
            //bug修改同上
            [[NSUserDefaults standardUserDefaults] setValue:@0  forKey:KAppSignModelShow];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KAppSignModelShow] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@0  forKey:KAppSignModelShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setValue:appSignModel.skipUrl forKey:KAppSignModelUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [activityInfoView.imgRedIcon sd_setImageWithURL:[NSURL URLWithString:appSignModel.imageUrl]];
}

-(void)startActivity{
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.pageUrl = appSignModel.skipUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

//修改，，，，，，，，，，
- (void)gyjButtonHiddenOrNot{
    showGJbtn = YES;
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":@"JCGJ"}];
}

//奖期不在售时，服务器返回"[]"
-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    LotteryRound * currentRound = [infoDic firstObject];
    if ([currentRound isExpire] ||![currentRound.sellStatus isEqualToString:@"ING_SELL"]||currentRound == nil) {
//        [currentRound.lotteryCode isEqualToString:@"JCGJ"]
        if (showGJbtn == YES) {
            showGJbtn = NO;
            [self.lotteryMan getSellIssueList:@{@"lotteryCode":@"JCGYJ"}];
        }
    } else {
        showGJbtn = YES;
        btnGyjHeight.constant = 67;
        spaceBtnGyj.constant = 10;
    }
}

-(void)itemNotification:(NSNotification *)notification{
    NSInteger index = [notification.object integerValue];
    [self itemClick:index];
}

-(void)notificationJump:(NSNotification*)notif{
    NSInteger index = [notif.object integerValue];
    [self itemClick:index];
}

-(void)loadAdsImg{
    adsArray = [NSMutableArray arrayWithCapacity:0];
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/banner/byChannel?usageChannel=3",[GlobalInstance instance].homeUrl];
    [singleLoad RequestWithString:strUlr isPost:NO andPara:nil andComplete:^(id data, BOOL isSuccess) {
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

        [adsView setImageUrlArray:adsArray];
        
    }];
}

-(void)setDLTCTZQView{
    curY =  lotteryPlayView.mj_y;
}
-(void)loadNews{
   
    
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/news/showNews?usageChannel=3",[GlobalInstance instance].homeUrl];
    [singleLoad RequestWithString:strUlr isPost:NO andPara:nil andComplete:^(id data, BOOL isSuccess) {
        
        if (isSuccess == NO || data == nil) {
            [self isHideNewView:YES];
            return ;
        }
        NSString *resultStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicItem = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if (dicItem[@"result"] == nil) {
                [self isHideNewView:YES];
                return;
        }
        [self isHideNewView:NO];
        newsModel = [[NewsModel alloc]initWith: dicItem[@"result"]];

        [self showNew];
    }];
    
}

-(void)isHideNewView:(BOOL )isHide{
    if (isHide) {
        
        viewNewDefault.hidden = NO;
    }else{
        viewNewDefault.hidden = YES;
        
    }
}

-(void)showNew{
    
    [imgNewIcon sd_setImageWithURL:[NSURL URLWithString:newsModel.titleImgUrl]];
    labNewTitle.text = newsModel.title;
    labNewDate.text = [[newsModel.newsTime componentsSeparatedByString:@" "] firstObject];
    labLookNum.text = [NSString stringWithFormat:@"%@浏览",newsModel.visitNum];
}

-(void)getJczqShortcut{
   
    self.lotteryMan.delegate = self ;
    [self.lotteryMan getJczqShortcut];
}

-(void)gotJczqShortcut:(NSArray *)dataArray errorMsg:(NSString *)msg{
    
   
    
    if (dataArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    [JczqShortcutList removeAllObjects];
    for (NSDictionary* infoDic in dataArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [JczqShortcutList addObject:model];
    }
    
    CGFloat height;
    if ([self isIphoneX]) {
        height = tabForecaseList.mj_y  + tabForecaseList.rowHeight * JczqShortcutList.count + 20;
    }else{
//        if (KscreenHeight > 667) {
             height = tabForecaseList.mj_y  + tabForecaseList.rowHeight * JczqShortcutList.count + 70;
//        }else{
//                height = tabForecaseList.mj_y  + tabForecaseList.rowHeight * JczqShortcutList.count;
//        }
  
    }
    
    homeViewHeight.constant = height;
    tabForecastListHeight.constant = tabForecaseList.rowHeight * JczqShortcutList.count;
    if (self.curUser.isLogin) {
        [self getCollected];
    }else{
        [tabForecaseList reloadData];
    }
}

-(void)setTableView{
    curY +=442;
    tabForecaseList.delegate = self;
    tabForecaseList.dataSource = self;
    [tabForecaseList registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    tabForecaseList.rowHeight = 117;
    [tabForecaseList reloadData];
    tabForecastListHeight.constant = tabForecaseList.rowHeight * 1;
    CGFloat height = 0;
    if ([self isIphoneX]) {
        height = curY  + tabForecaseList.rowHeight * 1 + 20;
    }else{
        height = curY  + tabForecaseList.rowHeight * 1;
    }
    homeViewHeight.constant = height;
    tabForecaseList.bounces = NO;
}

-(void)setNewsView{
    newsViewMarginTop.constant = curY;
}

-(void)gyjButtonView{
    gyjMarginTop.constant = curY;
}

-(void)setViewFeature{
    scrContentView.backgroundColor = MAINBGC;
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)setMenu{
    curY = adsView.mj_y + adsView.mj_h ;
    if (menuView != nil) {
        return;
    }
    menuView = [[UIView alloc]initWithFrame:CGRectMake(0, curY, KscreenWidth, 83)];
    [scrContentView addSubview:menuView];
    
    NSArray *items = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"HomeMenuItemsConfig" ofType: @"plist"]];
    NSInteger width = KscreenWidth/items.count;
    NSInteger height = menuView.mj_h;
    for (int i = 0; i<items.count; i++) {
        NSDictionary *itemdic = items[i];
        HomeMenuItemView *menuItem = [[HomeMenuItemView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        [menuItem setItemIcom:[UIImage imageNamed:itemdic[@"itemImage"]] title:itemdic[@"itemTitle"] setTag:1000+i];
        
        menuItem.delegate = self;
        menuView.backgroundColor = [UIColor whiteColor];
        [menuView addSubview:menuItem];
    }
     curY = menuView.mj_h + menuView.mj_y + 10;
}

-(void)setADSUI{
    if (adsView == nil) {
        adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,[self isIphoneX]?-44:-20, KscreenWidth, 175.0/375 * KscreenWidth)];
        adsView.delegate = self;
        [scrContentView addSubview:adsView];
    }

}

-(void)goToYunshiWithInfo:(ADSModel *)itemIndex navigation:(UINavigationController *)navgC{
    navGationCotr = navgC;
    NSString *keyStr = itemIndex.thumbnailCode;
    
    if (keyStr == nil) {
        return;
    }
    if ([keyStr isEqualToString:@"A000"]) {
        return;
    }
    
    if([keyStr isEqualToString:@"A401"]){
        if (navgC == nil) {
           self.tabBarController.selectedIndex = 3;
        }
        else {
           navgC.tabBarController.selectedIndex = 3;
        }
        return;
    }else if([keyStr isEqualToString:@"A402"]){
        if (navgC == nil) {
            self.tabBarController.selectedIndex = 2;
        }
        else {
            navgC.tabBarController.selectedIndex = 2;
        }
        return;
    }else if([keyStr isEqualToString:@"A201"]){
        if (navgC == nil) {
            self.tabBarController.selectedIndex = 4;
        }
        else {
            navgC.tabBarController.selectedIndex = 4;
        }
        return;
    }else if ([keyStr isEqualToString:@"A403"]){
        HomeJumpViewController *disVC = [[HomeJumpViewController alloc]init];
        ADSModel *model = [[ADSModel alloc]init];
        if (self.curUser.isLogin == YES && self.curUser.cardCode != nil) {
          
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,self.curUser.cardCode];
            
        }else{
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,@""];
        }
        disVC.infoModel = model;
        disVC.hidesBottomBarWhenPushed = YES;
        disVC.isNeedBack = YES;
        if (navgC == nil) {
            [self.navigationController pushViewController:disVC animated:YES];
        }
        else {
            [navgC pushViewController:disVC animated:YES];
        }
        return;
    }else if ([keyStr isEqualToString:@"A414"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/dltOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        if (navgC == nil) {
            [self.navigationController pushViewController:playViewVC animated:YES];
        }
        else {
            [navgC pushViewController:playViewVC animated:YES];
        }
        return;
    }else if ([keyStr isEqualToString:@"A415"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/sfcOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        if (navgC == nil) {
            [self.navigationController pushViewController:playViewVC animated:YES];
        }
        else {
            [navgC pushViewController:playViewVC animated:YES];
        }
        return;
    }else if ([keyStr isEqualToString:@"A412"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/jzOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        if (navgC == nil) {
            [self.navigationController pushViewController:playViewVC animated:YES];
        }
        else {
            [navgC pushViewController:playViewVC animated:YES];
        }
        return;
    }else if ([keyStr isEqualToString:@"A009"]){
        [self actionJcgyj:nil];
        return;
    }else if ([keyStr isEqualToString:@"A006"]){
        
        [self actionSFC:@"SFC"];
        return;
    }else if ([keyStr isEqualToString:@"A005"]){
        [self actionSFC:@"RJC"];
        return;
    }else if ([keyStr isEqualToString:@"A004"]){
        [self actionDLT:nil];
        return;
    }else if ([keyStr isEqualToString:@"A007"]){
        [self actionSSQ:nil];
        return;
    }
    
    if (itemIndex.trLoadStatus!= nil) {
        if ([itemIndex.trLoadStatus isEqualToString:@"ENABLE"] && self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
    }
    BaseViewController *baseVC;
    NSDictionary * vcDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pageCodeConfig" ofType:@"plist"]];
    if (keyStr == nil || [keyStr isEqualToString:@""]) {
        return;
    }
    NSString *vcName = vcDic[keyStr];
    if (vcName==nil) {
        return;
    }
    Class class = NSClassFromString(vcName);
    
    baseVC =[[class alloc] init];
    
    
    baseVC.hidesBottomBarWhenPushed = YES;
    if (navgC == nil) {
        [self.navigationController pushViewController:baseVC animated:YES];
    } else {
        [navgC pushViewController:baseVC animated:YES];
    }
//    UINavigationController *curNavVC = self.tabBarController.viewControllers[self.tabBarController.selectedIndex];
//    [curNavVC pushViewController:baseVC animated:YES];
}

-(void)adsImgViewClick:(ADSModel *)itemIndex navigation:(UINavigationController *)navgC{
    NSString *jumpType;
    navGationCotr = navgC;
    if (itemIndex.imageContentType != nil) {
        jumpType = [NSString stringWithFormat:@"%@",itemIndex.imageContentType];
    }else{
        jumpType = @"";
    }
    
    if ([jumpType isEqualToString:@"NOJUMP"]) {
        return;
    }else if ([jumpType isEqualToString:@"APP"]) {//内部视图跳转
        
        [self goToYunshiWithInfo:itemIndex navigation:navgC];
        
    }else if([jumpType isEqualToString:@"EDITOR"]||[jumpType isEqualToString:@"H5PAGE"]){
        HomeJumpViewController *jumpVC = [[HomeJumpViewController alloc] initWithNibName:@"HomeJumpViewController" bundle:nil];

        jumpVC.infoModel = itemIndex;
        jumpVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:jumpVC animated:YES];
        if (navgC == nil) {
            [self.navigationController pushViewController:jumpVC animated:YES];
        } else {
            [navgC pushViewController:jumpVC animated:YES];
        }
//        UINavigationController *curNavVC = self.tabBarController.viewControllers[self.tabBarController.selectedIndex];
//        [curNavVC pushViewController:jumpVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    activityInfoView.hidden = YES;
    [self.view addSubview:activityInfoView];
    self.navigationController.navigationBar.hidden = YES;
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
    [self getJczqShortcut];
    
    [adsView setImageUrlArray:nil];
    [self loadAdsImg];
    
    [self loadNews];
    [self getJczqShortcut];
    
    if (self.curUser.isLogin==YES) {
        [self getRedPacketByStateClient:@"true"];
    }else{
        redpacketView.hidden = YES;
    }
    [self gyjButtonHiddenOrNot];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma HomeMenuItemViewDelegate
-(void)itemClick:(NSInteger)index{
    if (index == 1000) {
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/openAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }
    
    if (index == 1002) {
        WBHomeJCYCViewController *playVC = [[WBHomeJCYCViewController alloc]init];
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    if (index == 1001) {
        YuCeSchemeCreateViewController *playVC = [[YuCeSchemeCreateViewController alloc]init];
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    if (index == 1003) {
        WBBifenZhiboViewController * wbBifenVC = [[WBBifenZhiboViewController alloc]init];
        wbBifenVC.title = @"比分直播";
        wbBifenVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wbBifenVC animated:YES];
    }
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return JczqShortcutList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelect = NO;
    
    if (self.curUser .isLogin == YES) {
        
            for (JczqShortcutModel *model in colloectList) {
                if ([model.matchKey isEqualToString:JczqShortcutList[indexPath.row].matchKey]) {
                    isSelect = YES;
                    break;
                }
            }
    }
    
    [cell refreshData:JczqShortcutList[indexPath.row] andSelect:isSelect];
    cell.delegate = self;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > JczqShortcutList.count) {
        return;
    }
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    JczqShortcutModel * model =JczqShortcutList[indexPath.row];

    matchDetailVC.model = model ;//[model jCZQScoreZhiboToJcForecastOptions];
//    if ([matchDetailVC.model.spfSingle boolValue] == YES) {
//        matchDetailVC.isHis = YES;
//    }else{
//        
//       
//    }
     matchDetailVC.isHis = NO;
    matchDetailVC.hidesBottomBarWhenPushed = YES;
    matchDetailVC.curPlayType =@"jczq";
    [self.navigationController pushViewController:matchDetailVC animated:YES];
    
}

- (IBAction)actionMoreNews:(UIButton *)sender {
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}
- (IBAction)actionMoreForeCast:(UIButton *)sender {
    ForecastViewController *forecastVC = [[ForecastViewController alloc]init];
    forecastVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forecastVC animated:YES];
}

- (IBAction)actionNewDetail:(id)sender {
    WebShowViewController *showViewVC = [[WebShowViewController alloc]init];
    showViewVC.title = @"资讯详情";
    showViewVC.pageUrl = [NSURL URLWithString:newsModel.linkUrl];
    showViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showViewVC animated:YES];
}


- (IBAction)actionToMoreLottery:(id)sender {
    LotteryAreaViewController *lotteryAreVc = [[LotteryAreaViewController alloc]init];
    lotteryAreVc.hidesBottomBarWhenPushed = YES;
    lotteryAreVc.title = @"购彩专区";
    lotteryAreVc.lotteryDS = [self.lotteryMan getAllLottery];
    [self.navigationController pushViewController:lotteryAreVc   animated:YES];
}

//进入冠亚军竞猜
- (IBAction)actionJcgyj:(id)sender {
    GYJPlayViewController *gyjPlayVc = [[GYJPlayViewController alloc]init];
    gyjPlayVc.hidesBottomBarWhenPushed = YES;
    gyjPlayVc.navigationController.navigationBar.hidden = YES;
    if (navGationCotr == nil) {
        [self.navigationController pushViewController:gyjPlayVc animated:YES];
    }
    else {
        [navGationCotr pushViewController:gyjPlayVc animated:YES];
    }
}

//"cardCode":"xxx","matchId":"x","isCollect":"x"
-(void)newScollectMatch:(JczqShortcutModel *)model andIsSelect:(BOOL)isSelect{
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    [self.lotteryMan collectMatch:@{@"cardCode":self.curUser.cardCode,@"matchKey":model.matchKey,@"isCollect":@(isSelect)}];
}

-(void)collectedMatch:(BOOL)isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect{
    if (isSuccess) {
        if (isSelect) {
            [self showPromptText:@"收藏成功" hideAfterDelay:1.7];

        }else{
            [self showPromptText:@"已取消收藏" hideAfterDelay:1.7];
            
        }
    }
    [self getCollected];
}


-(void)getCollected{
    [self.lotteryMan getCollectedMatchList:@{@"cardCode":self.curUser.cardCode,@"page":@(1),@"pageSize":@"100"}];
}

-(void)gotCollectedMatchList:(NSArray *)infoArray errorMsg:(NSString *)msg{

    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    [colloectList removeAllObjects];

    for (NSDictionary* infoDic in infoArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [colloectList addObject:model];
    }
    [tabForecaseList reloadData];
}

#pragma 打开红包
-(void)openRedPacketSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    openRedpacketButton.mj_w = 147;
    openRedpacketButton.hidden = NO;
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
     
        float width = openRedpacketButton.mj_w/2;
       
        red = [[RedPacket alloc]initWith:redPacketInfo];
        NSString *redPacketType = red.redPacketType;
        NSString *sourecs;
        NSString *subSource;
        if ([redPacketType isEqualToString:@"彩金红包"]) {
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@元",red.redPacketContent];
            subSource= @"红包已存入我的余额";
        } else if ([redPacketType isEqualToString:@"积分红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@积分",red.redPacketContent];
            subSource= @"红包已存入我的积分";
        }else if ([redPacketType isEqualToString:@"优惠券红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@张优惠券",red.redPacketContent];
            subSource= @"红包已存入我的优惠券";
        }else{
            sourecs = @"恭喜您获得了红包！";
            subSource= @"红包已存入我的账户";
            
        }
        
        
        [self rotation360repeatCount:2 view:openRedpacketButton andHalf:width andCaijin:sourecs andSubTitle:subSource];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
        redpacketView.hidden=YES;
    }
    
}


-(void)rotation360repeatCount:(int)repeatCount view:(UIView *)view andHalf:(float)width andCaijin:(NSString *)caijin andSubTitle:(NSString*)subTitle{
    
    if (repeatCount == 0) {
         [redpacketView layoutIfNeeded];
        [UIView animateWithDuration:AnimationDur animations:^{
           
            view.mj_x += width;
            openRedpacketButton.mj_w = 0;

            
        } completion:^(BOOL finished) {
            //[redPacketbutton removeFromSuperview];
            
            redpacketView.hidden=YES;
            popView = [[OpenRedPopView alloc]initWithFrame:self.view.frame];
            popView.delegate = self;
            popView.labJiangjin.text =caijin;
            popView.labRedPacketInfo.adjustsFontSizeToFitWidth = YES;
            popView.labRedPacketInfo.text = subTitle;
            popView.alpha = 0.2;
            popView.layer.cornerRadius = 10;
            popView.layer.masksToBounds = YES;
            // redPacketbutton.hidden=YES;
            [self.view addSubview:popView];
            [UIView animateWithDuration:AnimationDur animations:^{
                
                popView.alpha = 1.0;
            }];
            
        }];
        
    }else{
        
        repeatCount --;
        [redpacketView layoutIfNeeded];
        [UIView animateWithDuration:AnimationDur animations:^{
            view.mj_x += width;
            openRedpacketButton.mj_w = 0;
            goRedPacket.alpha = 0;
            
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:AnimationDur animations:^{
                view.mj_x-= width;
                goRedPacket.alpha = 1;
                openRedpacketButton.mj_w = 148;
            } completion:^(BOOL finished) {
                
                [self rotation360repeatCount:repeatCount view:view andHalf:width andCaijin:caijin andSubTitle:subTitle];
            }];
        }];
    }
    
}

-(void)getRedPacketByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":@"1",
                 @"pageSize":@"10"
                 };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan getRedPacketByStateSms:Info];
    
    
}

//-(void)initRedButton{
//    redPacketbutton= [[UIButton alloc]init];
//    [redPacketbutton setBackgroundImage:[UIImage imageNamed:@"redpacket"] forState:UIControlStateNormal];
//    [redPacketbutton addTarget: self action: @selector(BtnClick) forControlEvents: UIControlEventTouchUpInside];
//    redPacketbutton.frame  = CGRectMake(self.view.mj_w/2-105, 200, 210,294);
//    [self.view addSubview:redPacketbutton];
//    redPacketbutton.hidden=YES;
//}

-(void)openRedPacketClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = r._id;
        Info = @{@"id":cardCode
                 };
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan openRedPacketSms:Info];
    
    
}

-(void)getRedPacketByStateSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
           [listUseRedPacketArray removeAllObjects];
            NSArray *array = redPacketInfo;
            
            
        
                        for (int i=0; i<array.count; i++) {
                            
                            RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            NSString *redPacketStatus = redPacket.redPacketStatus;
                            if ([redPacketStatus isEqualToString:@"解锁"]) {
                                  [listUseRedPacketArray addObject:redPacket];
                            }
                            
           }
            if (listUseRedPacketArray.count>0) {
                if (popView != nil) {
                    [popView removeFromSuperview];
                }
                openRedpacketButton.hidden = NO;
                openRedpacketButton.mj_x = 0;
                openRedpacketButton.mj_w = 147;
                redpacketView.hidden=NO;
                if (listUseRedPacketArray.count>1) {
                    [openRedpacketButton setTitle:@"" forState:0];
                    disBottom.constant = 16;
                    [openRedpacketButton setBackgroundImage:[UIImage imageNamed:@"redpacketKong.png"] forState:UIControlStateNormal];
                    goRedPacket.hidden=NO;
                    redpacketLab.hidden=NO;
                    NSString *s=[NSString stringWithFormat:@"%lu",(unsigned long)listUseRedPacketArray.count ];
                     redpacketLab.text=[NSString stringWithFormat:@"恭喜您获得%@个红包！",s];
                }else if (listUseRedPacketArray.count==1) {
                    
                    
                    
                    [openRedpacketButton setBackgroundImage:[UIImage imageNamed:@"one_redpacket.png"] forState:UIControlStateNormal];
                    disBottom.constant = 45;
                    goRedPacket.hidden=YES;
                    redpacketLab.hidden = YES;
                    [openRedpacketButton setTitle:@"恭喜您获得1个红包！" forState:0];
//                    redpacketLab.text=@"恭喜您获得1个红包！";
                    r =listUseRedPacketArray[0];
                   
                }
            }else{
                redpacketView .hidden = YES;
            }
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
        redpacketView .hidden = YES;
    }
}

- (IBAction)goRedpacketClick:(id)sender {
     redpacketView.hidden=YES;
    MyRedPacketViewController * pcVC = [[MyRedPacketViewController alloc]init];
    pcVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pcVC animated:YES];
}
- (IBAction)openRedPacketClick:(id)sender {
     [self openRedPacketClient];
}

- (IBAction)cancelRedpacketClick:(id)sender {
    redpacketView.hidden=YES;

}


#pragma  mark - checkUpdateNetWork
- (void)checkUpdateNetWork {
    NSString *subversion = @"release";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *curVerSion = version;
    NSString * string = [NSString stringWithFormat:@"http://ct.11max.com//ClientVersion/CheckUpdate?versionCode=%@&mobileos=ios&appname=com.xaonly.tbz.ios&subversion=%@",curVerSion,subversion];
    netWorkHelper *helper = [[netWorkHelper alloc] init];
    [helper getRequestMethodWithUrlstring:string parameter:nil];
    helper.delegate = self;
}

-(void)appStoreUpadata{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[LoadData singleLoadData]RequestWithString:@"https://itunes.apple.com/cn/lookup" isPost:YES andPara:@{@"id":@"1334494277"} andComplete:^(id data, BOOL isSuccess) {
        if (isSuccess) {
            NSString*string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *resultDic = [Utility objFromJson:string];
            NSString *resultCount = resultDic[@"resultCount"];
            if ([resultCount integerValue]>=1) {
                
                NSDictionary *results =[resultDic[@"results"] firstObject];
                NSString *lastVersion = results[@"version"];
                NSString *updataInfo = results[@"releaseNotes"];
                
                if ([lastVersion doubleValue] > [app_Version doubleValue]) {
                    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"更新提示" message:updataInfo];
                    [alert addBtnTitle:@"立即更新" action:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUPDATAURL]];
                    }];
                    [alert addBtnTitle:@"以后再说" action:^{
                        
                    }];
                    [alert showAlertWithSender:self];
                }
            }
        }
    }];
}

#pragma mark - netWorkHelperDelegate
-(void)passValueWithDic:(NSDictionary *)value{
    if([value isKindOfClass:[NSDictionary class]])
    {
        if ([value[@"ForceUpgrade"] isEqualToString:@"true"]) {
            
            VersionUpdatingPopView *vuView = [[VersionUpdatingPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            vuView.delegate = self;
            vuView.guanbibtn.userInteractionEnabled = NO;
            vuView.xiaochachaBtn.hidden = YES;
            vuView.content.text = value[@"VersionDesc"];
            [[UIApplication sharedApplication].keyWindow addSubview:vuView];
        }else
        {
            
            VersionUpdatingPopView *vuView = [[VersionUpdatingPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            vuView.delegate = self;
            vuView.content.text = value[@"VersionDesc"];
            [[UIApplication sharedApplication].keyWindow addSubview:vuView];
        }
    }
}

- (void)lijigenxin{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUPDATAURL]];
}

- (IBAction)actionDLT:(id)sender {
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    NSArray * lotteryDS = [self.lotteryMan getAllLottery];
    
    DLTPlayViewController *playVC = [[DLTPlayViewController alloc] init];
    playVC.hidesBottomBarWhenPushed = YES;
    //    _lotterySelected.currentRound = round;
    playVC.lottery = lotteryDS[1];
    if (navGationCotr == nil) {
        [self.navigationController pushViewController:playVC animated:YES];
    }
    else {
        [navGationCotr pushViewController:playVC animated:YES];
    }
    
}

//双色球
- (IBAction)actionSSQ:(id)sender {
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    NSArray * lotteryDS = [self.lotteryMan getAllLottery];
    SSQPlayViewController *playVC = [[SSQPlayViewController alloc] init];
    playVC.hidesBottomBarWhenPushed = YES;
    playVC.lottery = lotteryDS[10];
    if (navGationCotr == nil) {
        [self.navigationController pushViewController:playVC animated:YES];
    }
    else {
        [navGationCotr pushViewController:playVC animated:YES];
    }
}


- (IBAction)actionSFC:(id)sender {
    if (self.lotteryMan == nil) {
       self.lotteryMan = [[LotteryManager alloc]init];
    }
    NSArray * lotteryDS = [self.lotteryMan getAllLottery];
    CTZQPlayViewController *playVC = [[CTZQPlayViewController alloc] init];
    if ([sender isKindOfClass:[NSString class]]) {
        if ([sender isEqualToString:@"SFC"]) {
            playVC.playType = CTZQPlayTypeShiSi;
        }else{
            playVC.playType = CTZQPlayTypeRenjiu;
        }
    }
    playVC.hidesBottomBarWhenPushed = YES;
    playVC.lottery = lotteryDS[7];
    if (navGationCotr == nil) {
        [self.navigationController pushViewController:playVC animated:YES];
    }
    else {
        [navGationCotr pushViewController:playVC animated:YES];
    }
}
- (IBAction)actionJCLQ:(UIButton *)sender {
    JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}

- (IBAction)actionJCZQ:(id)sender {
    JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}

-(void)jumpToPlayVC:(NSNotification *)notifi{
    if (self.tabBarController.selectedIndex != 0) {
        self.tabBarController.selectedIndex = 0;
    }
    
    NSString *playType = notifi.object;
    if ([playType isEqualToString:@"RJC"] || [playType isEqualToString:@"SFC"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionSFC:nil];
        });
    }
    if ([playType isEqualToString:@"DLT"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionDLT:nil];
        });
    }
    if ([playType isEqualToString:@"JCZQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionJCZQ:nil];
        });
    }
    //添加双色球(开奖记录页面-->投注-->进入购买页面) lyw
    if ([playType isEqualToString:@"SSQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionSSQ:nil];
        });
    }
    //添加双色球(开奖记录页面-->投注-->进入购买页面) lyw
    if ([playType isEqualToString:@"JCLQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self actionJCLQ:nil];
        });
    }
    if ([playType isEqualToString:@"YHQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyCouponViewController *couponVC = [[MyCouponViewController alloc]init];
            [self .navigationController pushViewController:couponVC animated:YES];
        });
    }

    if ([playType isEqualToString:@"CZ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TopUpsViewController *topUpsVC = [[TopUpsViewController alloc]init];
            [self.navigationController pushViewController:topUpsVC animated:YES];
        });
    }

    
}



@end
