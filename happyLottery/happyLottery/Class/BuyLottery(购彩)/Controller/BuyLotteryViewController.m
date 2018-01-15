//
//  BuyLotteryViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BuyLotteryViewController.h"
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

#import "UMChongZhiViewController.h"
#import "LoadData.h"
#import "NewsModel.h"
#import "ADSModel.h"
#import "WebShowViewController.h"
#define KNewsListCell @"NewsListCell"

@interface BuyLotteryViewController ()<WBAdsImgViewDelegate,HomeMenuItemViewDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,NewsListCellDelegate>
{
    NSMutableArray  <JczqShortcutModel *>*JczqShortcutList;
    __weak IBOutlet UIView *viewNews;
    __weak IBOutlet UIView *scrContentView;
    __weak IBOutlet NSLayoutConstraint *homeViewHeight;
    WBAdsImgView *adsView;
    UIView  *menuView;
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
    JczqShortcutModel *curModel;
    
    __weak IBOutlet NSLayoutConstraint *yucViewDisTop;
}
@end

@implementation BuyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
     singleLoad = [LoadData singleLoadData];
    [self setViewFeature];
    [self setADSUI];
    [self setMenu];
    [self setNewsView];
    [self setTableView];
    [self loadAdsImg];
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
        for (NSDictionary *dic in resultDic[@"result"]) {
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
        if (resultStr .length == 0 || resultStr == nil) {
            [self isHideNewView:YES];
            return;
        }
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicItem = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        newsModel = [[NewsModel alloc]initWith: dicItem[@"result"]];
        [self showNew];
    }];
    
}

-(void)isHideNewView:(BOOL )isHide{
    if (isHide) {
        yucViewDisTop.constant = -120;
        viewNews.hidden = YES;
    }else{
        yucViewDisTop.constant = 10;
        viewNews.hidden = NO;
    }
}

-(void)showNew{
    
    [imgNewIcon sd_setImageWithURL:[NSURL URLWithString:newsModel.titleImgUrl]];
    labNewTitle.text = newsModel.title;
    labNewDate.text = [[newsModel.newsTime componentsSeparatedByString:@" "] firstObject];
    labLookNum.text = [NSString stringWithFormat:@"%@浏览",newsModel.visitNum];
}

-(void)getJczqShortcut{
    JczqShortcutList = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self ;
    [self.lotteryMan getJczqShortcut];
}

-(void)gotJczqShortcut:(NSArray *)dataArray errorMsg:(NSString *)msg{
    if (dataArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    
    for (NSDictionary* infoDic in dataArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [JczqShortcutList addObject:model];
    }
    NSInteger count = JczqShortcutList.count > 5 ?5:JczqShortcutList.count;
    CGFloat height;
    if ([self isIphoneX]) {
        height = curY  + tabForecaseList.rowHeight * count + 20;
    }else{
        height = curY  + tabForecaseList.rowHeight * count;
    }
    homeViewHeight.constant = height;
    tabForecastListHeight.constant = tabForecaseList.rowHeight * count;
    [tabForecaseList reloadData];
    
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
    adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,[self isIphoneX]?20:0, KscreenWidth, 175.0/375 * KscreenWidth)];
    adsView.delegate = self;
    [scrContentView addSubview:adsView];

}

-(void)adsImgViewClick:(NSInteger)itemIndex{
    [self showPromptText:[NSString stringWithFormat:@"点击了%ld",itemIndex] hideAfterDelay:1.9];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getJczqShortcut];
    [self loadNews];
    self.navigationController.navigationBar.hidden = YES;
    
    
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
    
    return JczqShortcutList.count > 5 ?5:JczqShortcutList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelect = NO;
    
    if (self.curUser .isLogin == YES) {
        if ([self .fmdb open]) {
            FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_collect_match"];
            do {
                if ([[result stringForColumn:@"matchKey"] isEqualToString:JczqShortcutList[indexPath.row].matchKey] && [[result stringForColumn:@"cardCode"]isEqualToString:self.curUser.cardCode]) {
                    isSelect = YES;
                    JczqShortcutList[indexPath.row].isCollect = YES;
                    break;
                }
            } while ([result next]);
            [self.fmdb close];
        }
        
    }
    
    [cell refreshData:JczqShortcutList[indexPath.row] andSelect:isSelect];
    cell.delegate = self;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    JczqShortcutModel * model =JczqShortcutList[indexPath.row];

    matchDetailVC.model = model ;//[model jCZQScoreZhiboToJcForecastOptions];
    if ([matchDetailVC.model.spfSingle boolValue] == YES) {
        matchDetailVC.isHis = YES;
    }else{
        
        matchDetailVC.isHis = NO;
    }
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
    curModel = model;
    [self.lotteryMan collectMatch:@{@"cardCode":self.curUser.cardCode,@"matchKey":model.matchKey,@"isCollect":@(isSelect)}];
}

-(void)collectedMatch:(BOOL)isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect{
    if (isSuccess) {
        if (isSelect) {
            [self showPromptText:@"收藏成功" hideAfterDelay:1.7];
        }else{
            [self showPromptText:@"已取消收藏" hideAfterDelay:1.7];
        }
        [self saveCollectMatchInfoToloaction:isSelect];
    }
}

//issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
//
//} while ([result next]);
//
//[self.fmdb executeUpdate:@"insert into t_user_info (cardCode , loginPwd , isLogin , mobile,payVerifyType) values ( ?,?,?,?,?)  ",user.cardCode,user.loginPwd,@(1),user.mobile,@(1)];

-(void)saveCollectMatchInfoToloaction:(BOOL)isSelect{
 
    BOOL issuccess;
    if ([self .fmdb open]) {
        
        if (isSelect) {
           issuccess=  [self.fmdb executeUpdate:@"insert into t_collect_match (matchKey,cardCode) values (?,?)  ",curModel.matchKey,self.curUser.cardCode];
        }else{
            FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_collect_match"];
            
            do {
                if ([[result stringForColumn:@"matchKey"] isEqualToString:curModel.matchKey] &&[[result stringForColumn:@"cardCode"]isEqualToString:self.curUser.cardCode]) {
                   issuccess= [self.fmdb executeUpdate:@"delete from t_collect_match where matchKey = ? and cardCode = ? ",curModel.matchKey,self.curUser.cardCode];
                    break;
                }
            } while ([result next]);
        }
       
    }
    if (issuccess) {
        [self.fmdb close];
    }
    [tabForecaseList reloadData];
}

@end
