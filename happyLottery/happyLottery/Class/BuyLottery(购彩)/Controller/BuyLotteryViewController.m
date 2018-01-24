//
//  BuyLotteryViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BuyLotteryViewController.h"
#import "DiscoverViewController.h"
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
#import "LoadData.h"
#import "NewsModel.h"
#import "ADSModel.h"
#import "WebShowViewController.h"
#import "RedPacket.h"
#import "OpenRedPopView.h"
#import "MyRedPacketViewController.h"
#define KNewsListCell @"NewsListCell"
#define AnimationDur 0.3


@interface BuyLotteryViewController ()<WBAdsImgViewDelegate,HomeMenuItemViewDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,NewsListCellDelegate,OpenRedPopViewDelegate,MemberManagerDelegate>
{
    NSMutableArray  <JczqShortcutModel *>*JczqShortcutList;
    NSMutableArray  <JczqShortcutModel *>*colloectList;
    __weak IBOutlet UIView *viewNews;
    __weak IBOutlet UIView *scrContentView;
    __weak IBOutlet NSLayoutConstraint *homeViewHeight;
    WBAdsImgView *adsView;
    UIView  *menuView;

     NSMutableArray *listUseRedPacketArray;
     RedPacket *r;
     int j;
    UIButton  *redPacketbutton;
    RedPacket *red ;
    __weak IBOutlet UIView *viewNewDefault;
    CGFloat curY;
    __weak IBOutlet NSLayoutConstraint *newsViewMarginTop;
    __weak IBOutlet NSLayoutConstraint *tabForecastListHeight;
    __weak IBOutlet UITableView *tabForecaseList;
    LoadData *singleLoad;
    NewsModel *newsModel;
    NSMutableArray <ADSModel *>*adsArray;
    __weak IBOutlet UIImageView *imgNewIcon;
    __weak IBOutlet UILabel *labNewTitle;
    __weak IBOutlet UILabel *labLookNum;
    __weak IBOutlet UILabel *labNewDate;
    
    
    __weak IBOutlet NSLayoutConstraint *yucViewDisTop;
}
@end

@implementation BuyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
          listUseRedPacketArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemClick:) name:@"NSNotificationBuyVCJump" object:nil];
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
    [self setTableView];
    [self initRedButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getJczqShortcut];
    [adsView setImageUrlArray:nil];
    [self loadAdsImg];
    
    [self loadNews];
    [self getJczqShortcut];
    self.navigationController.navigationBar.hidden = YES;
    if (self.curUser.isLogin==YES) {
           [self getRedPacketByStateClient:@"true"];
    }
  
    
}

-(void)notificationJump:(NSNotification*)notif{
    NSInteger index = [notif.object integerValue];
    [self itemClick:index];
}

-(void)loadAdsImg{
    adsArray = [NSMutableArray arrayWithCapacity:0];
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/banner/byChannel?usageChannel=3",ServerAddress];
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

-(void)loadNews{
   
    
    NSString *strUlr = [NSString stringWithFormat:@"%@/app/news/showNews?usageChannel=3",ServerAddress];
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
        height = curY  + tabForecaseList.rowHeight * JczqShortcutList.count + 20;
    }else{
        height = curY  + tabForecaseList.rowHeight * JczqShortcutList.count;
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
    curY +=151;
    tabForecaseList.delegate = self;
    tabForecaseList.dataSource = self;
    [tabForecaseList registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    tabForecaseList.rowHeight = 117;
    [tabForecaseList reloadData];
    tabForecastListHeight.constant = tabForecaseList.rowHeight * 3;
    CGFloat height = 0;
    if ([self isIphoneX]) {
        height = curY  + tabForecaseList.rowHeight * 3 + 20;
    }else{
        height = curY  + tabForecaseList.rowHeight * 3;
    }
    homeViewHeight.constant = height;
    tabForecaseList.bounces = NO;
}

-(void)setNewsView{
    newsViewMarginTop.constant = curY;
    
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
        adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,[self isIphoneX]?20:0, KscreenWidth, 175.0/375 * KscreenWidth)];
        adsView.delegate = self;
        [scrContentView addSubview:adsView];
    }

}

-(void)goToYunshiWithInfo:(ADSModel *)itemIndex{
    NSString *keyStr = itemIndex.thumbnailCode;
    
    if (keyStr == nil) {
        return;
    }
    
    if([keyStr isEqualToString:@"A401"]){
        self.tabBarController.selectedIndex = 2;
        return;
    }else if([keyStr isEqualToString:@"A402"]){
        self.tabBarController.selectedIndex = 1;
        return;
    }else if ([keyStr isEqualToString:@"A403"]){
        self.tabBarController.selectedIndex = 2;
        UINavigationController *discoverNavVC = self.tabBarController.viewControllers[2];
        DiscoverViewController *disVC = [discoverNavVC.viewControllers firstObject];
        if (self.curUser.isLogin == YES && self.curUser.cardCode != nil) {
            disVC.pageUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,self.curUser.cardCode];
        }
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
    
    [self.navigationController pushViewController:baseVC animated:YES];
}


-(void)adsImgViewClick:(ADSModel *)itemIndex{
    NSString *jumpType;
    
    
    if (itemIndex.imageContentType != nil) {
        jumpType = [NSString stringWithFormat:@"%@",itemIndex.imageContentType];
    }else{
        jumpType = @"";
    }
    
    if ([jumpType isEqualToString:@"NOJUMP"]) {
        return;
    }else if ([jumpType isEqualToString:@"APP"]) {//内部视图跳转
        
        [self goToYunshiWithInfo:itemIndex];
        
    }else if([jumpType isEqualToString:@"EDITOR"]||[jumpType isEqualToString:@"H5PAGE"]){
        HomeJumpViewController *jumpVC = [[HomeJumpViewController alloc] initWithNibName:@"HomeJumpViewController" bundle:nil];

        jumpVC.infoModel = itemIndex;
        jumpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma HomeMenuItemViewDelegate
-(void)itemClick:(NSInteger)index{
    if (index == 1000) {
        JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }
    
    if (index == 1001) {
        WBHomeJCYCViewController *playVC = [[WBHomeJCYCViewController alloc]init];
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    if (index == 1002) {
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
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
     
        float width = redPacketbutton.mj_w/2;
       
        red = [[RedPacket alloc]initWith:redPacketInfo];
        NSString *redPacketType = red.redPacketType;
        NSString *sourecs;
        if ([redPacketType isEqualToString:@"彩金红包"]) {
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@元",red.redPacketContent];
        } else if ([redPacketType isEqualToString:@"积分红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@积分",red.redPacketContent];
        }else if ([redPacketType isEqualToString:@"优惠券红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@张优惠券",red.redPacketContent];
        }else{
            sourecs = @"恭喜您获得了红包！";
            
        }
        
        [self rotation360repeatCount:2 view:redPacketbutton andHalf:width andCaijin:sourecs];
       
        
    
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
        redPacketbutton.hidden=YES;
    }
    
}

-(void)BtnClick{
    if (listUseRedPacketArray.count>1) {
        [redPacketbutton removeFromSuperview];
        MyRedPacketViewController * pcVC = [[MyRedPacketViewController alloc]init];
        pcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pcVC animated:YES];
    }else if (listUseRedPacketArray.count==1) {
        r =listUseRedPacketArray[0];
           [self openRedPacketClient];
    }
  
    
  
  

}

-(void)rotation360repeatCount:(int)repeatCount view:(UIView *)view andHalf:(float)width andCaijin:(NSString *)caijin{
    
    if (repeatCount == 0) {
        [UIView animateWithDuration:AnimationDur animations:^{
            view.mj_x += width;
            view.mj_w = 0;
            
        } completion:^(BOOL finished) {
            //[redPacketbutton removeFromSuperview];
            redPacketbutton.hidden=YES;
            OpenRedPopView *popView = [[OpenRedPopView alloc]initWithFrame:self.view.frame];
            popView.delegate = self;
            popView.labJiangjin.text =caijin;
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
        [UIView animateWithDuration:AnimationDur animations:^{
            view.mj_x += width;
            view.mj_w = 0;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:AnimationDur animations:^{
                view.mj_x-= width;
                view.mj_w = 210;
            } completion:^(BOOL finished) {
                
                [self rotation360repeatCount:repeatCount view:view andHalf:width andCaijin:caijin];
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
        Info = nil;
    } @finally {
        [self.memberMan getRedPacketByStateSms:Info];
    }
    
}

-(void)initRedButton{
    redPacketbutton= [[UIButton alloc]init];
    [redPacketbutton setBackgroundImage:[UIImage imageNamed:@"redpacket"] forState:UIControlStateNormal];
    [redPacketbutton addTarget: self action: @selector(BtnClick) forControlEvents: UIControlEventTouchUpInside];
    redPacketbutton.frame  = CGRectMake(self.view.mj_w/2-105, 200, 210,294);
    [self.view addSubview:redPacketbutton];
    redPacketbutton.hidden=YES;
}

-(void)openRedPacketClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = r._id;
        Info = @{@"id":cardCode
                 };
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan openRedPacketSms:Info];
    }
    
}

-(void)getRedPacketByStateSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
           [listUseRedPacketArray removeAllObjects];
        NSEnumerator *enumerator = [redPacketInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil) {
            NSArray *array = redPacketInfo;
            
            
        
                        for (int i=0; i<array.count; i++) {
                            
                            RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            NSString *redPacketStatus = redPacket.redPacketStatus;
                          if ([redPacketStatus isEqualToString:@"解锁"]) {
                                  [listUseRedPacketArray addObject:redPacket];
                            }
                            
           }
            if (listUseRedPacketArray.count>0) {
                redPacketbutton.hidden=NO;
            }
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}
-(void)openReadPacket{
//    r = listUseRedPacketArray[j] ;
//    NSString *redPacketStatus = r.redPacketStatus;
//    if ([redPacketStatus isEqualToString:@"锁定"]) {
//        r = listUseRedPacketArray[j++] ;
//        [self openReadPacket];
//    } else  if ([redPacketStatus isEqualToString:@"解锁"]) {
//        [self openRedPacketClient];
//    }
    
}

@end
