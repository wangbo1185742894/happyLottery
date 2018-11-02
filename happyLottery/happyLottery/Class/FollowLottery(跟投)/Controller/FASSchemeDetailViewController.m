//
//  FASSchemeDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FASSchemeDetailViewController.h"
#import "MyPostSchemeViewController.h"
#import "OrderListHeaderView.h"
#import "PersonCenterViewController.h"
#import "FollowListViewController.h"
#import "SchemeInfoFollowCell.h"
#import "SchemePerFollowCell.h"
#import "SchemeContaintCell.h"
#import "SchemeBuyCell.h"
#import "SchemeOverCell.h"
#import "SchemeContainInfoCell.h"
#import "SchemeInfoBuyCell.h"
#import "JCZQSchemeModel.h"
#import "JCLQOrderDetailInfoViewController.h"
#import "SuoSchemeViewCell.h"
#import "PayOrderLegViewController.h"
#import "LegInfoViewCell.h"
#import "SchemeCashPayment.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>
#import "ShareOrderView.h"
#define KLegInfoViewCell @"LegInfoViewCell"
#define KSchemeInfoFollowCell @"SchemeInfoFollowCell"
#define KSchemePerFollowCell  @"SchemePerFollowCell"
#define KSchemeContaintCell   @"SchemeContaintCell"
#define KSchemeBuyCell        @"SchemeBuyCell"
#define KSchemeOverCell       @"SchemeOverCell"
#define KSchemeContainInfoCell  @"SchemeContainInfoCell"
#define KSchemeInfoBuyCell   @"SchemeInfoBuyCell"
#define kSuoSchemeViewCell   @"SuoSchemeViewCell"


@interface FASSchemeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,SchemeContaintCellDelegate,SchemePerFollowCellDelegate,FollowCellDelegate,BuyCellDelegate>{
    ShareOrderView *introView;
}

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *liJiZhiFuBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layHeightInfo;

@end

@implementation FASSchemeDetailViewController{
    JCZQSchemeItem *schemeDetail;
    JCLQSchemeItem *jclqSchemeDetail;
    BOOL isAttend;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"方案详情";
    self.lotteryMan.delegate = self;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self setTableView];
    [self loadData];
    self.liJiZhiFuBtn.hidden = YES;
    self.layHeightInfo.constant = 0;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setRightBarItems{
    UIBarButtonItem *itemQuery = [self creatBarItem:@"" icon:@"sharedeat" andFrame:CGRectMake(0, 10, 31, 33) andAction:@selector(sharePress)];
    self.navigationItem.rightBarButtonItems = @[itemQuery];
    NSString *  isShow = [[NSUserDefaults standardUserDefaults] objectForKey:KshareOrderIntroduce];
    if (isShow == nil) {
        introView = [[ShareOrderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow addSubview:introView];
        });
    }else{
        introView.hidden = YES;
        if(introView.superview!=nil){
            [introView removeFromSuperview];
        }
    }
}

- (void)sharePress {
    {
        NSString *url = [NSString stringWithFormat:@"%@/app/share/shareScheme?schemeNo=%@&date=%@",H5BaseAddress,schemeDetail.schemeNO,[NSDate dateWithTimeIntervalSinceNow:0]];
        //bug修改 lyw 避免url为空
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
        [shareParams SSDKSetupShareParamsByText:@"给你推荐一个方案，跟着大神买准没错。"
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:@"跟单大神，等着收米。"
                                           type:SSDKContentTypeWebPage];
        [ShareSDK showShareActionSheet:nil
                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                               
                           case SSDKResponseStateBegin:
                           {
                               //设置UI等操作
                               //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                               if (platformType == SSDKPlatformSubTypeWechatSession)
                               {
                                   break;
                               }
                               break;
                           }
                           case SSDKResponseStateSuccess:
                           {
                               
                               
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               if (platformType == SSDKPlatformSubTypeWechatTimeline)
                               {
                                
                                   
                               }
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               NSLog(@"%@",error);
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               if (userData != nil) {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                               }
                              
                               break;
                           }
                           default:
                               break;
                       }
                   }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNo}];
}

- (void)reloadZhiFuButton {
    self.liJiZhiFuBtn.hidden = NO;
    self.layHeightInfo.constant = 77;
}

- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    schemeDetail.lottery = infoArray[@"lottery"];
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) { //待支付状态
        [self reloadZhiFuButton];
    } else {
        if (![schemeDetail.schemeStatus isEqualToString:@"REPEAL"]) {
            [self setRightBarItems];
        }
    }
    NSString *content = schemeDetail.betContent;
    if ([schemeDetail.schemeSource isEqualToString:@"BONUS_OPTIMIZE"]){
        content = schemeDetail.originalContent;
    }
    for (NSDictionary *matchDic in [Utility objFromJson:content]) {
        NSArray *matchArray = [Utility objFromJson:matchDic[@"betMatches"]];
        for (int i  = 0; i < matchArray.count; i++) {
            JcBetContent *betContent = [[JcBetContent alloc]init];
            betContent.virtualSp = schemeDetail.virtualSp;
            betContent.matchInfo = matchArray[i];
            [self.dataArray addObject:betContent];
        }
    }
   
    if([self.schemeType isEqualToString:@"BUY_FOLLOW"]&&![schemeDetail.schemeStatus isEqualToString:@"INIT"]){
        if (self.curUser == nil || self.curUser.isLogin == NO) {
            [self gotisAttent:@"false" errorMsg:nil];
            return;
        }
        NSDictionary *dic;
        if (schemeDetail.initiateCardCode!=nil) {
            dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":schemeDetail.initiateCardCode,@"attentType":@"FOLLOW"};
        }
        else {
            dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":schemeDetail.cardCode,@"attentType":@"FOLLOW"};
        }
        [self.lotteryMan isAttent:dic];
    }else {
        [self.detailTableView reloadData];
    }
}

-(void)setTableView{
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.allowsSelection = NO;
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeInfoFollowCell bundle:nil] forCellReuseIdentifier:KSchemeInfoFollowCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegInfoViewCell bundle:nil] forCellReuseIdentifier:KLegInfoViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemePerFollowCell bundle:nil] forCellReuseIdentifier:KSchemePerFollowCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeContaintCell bundle:nil] forCellReuseIdentifier:KSchemeContaintCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeBuyCell bundle:nil] forCellReuseIdentifier:KSchemeBuyCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeOverCell bundle:nil] forCellReuseIdentifier:KSchemeOverCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeContainInfoCell bundle:nil] forCellReuseIdentifier:KSchemeContainInfoCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeInfoBuyCell bundle:nil] forCellReuseIdentifier:KSchemeInfoBuyCell];
     [self.detailTableView registerNib:[UINib nibWithNibName:kSuoSchemeViewCell bundle:nil] forCellReuseIdentifier:kSuoSchemeViewCell];
    
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark  tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([schemeDetail isHasLeg]) {
        if (section == 4) {
            return 30;
        }
    }
    return 0.01;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /*
     从个人中心进入,只显示方案信息与方案内容,个人中心只有发单
     */
    if ([self.schemeFromView isEqualToString:@"personCen"]) {
        return 2;
    }
    /*
     从我的跟单发单进入
     */
    else {
        if ([schemeDetail.schemeStatus isEqualToString:@"INIT"])// 未支付状态,显示方案信息，方案内容，认购信息提示语，支付按钮
        {
            return 3;
        }
    }
    if ([schemeDetail isHasLeg]) {
        return 5;
    }else{
        return 4;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.schemeFromView isEqualToString:@"personCen"]&&section == 1) {
        return 3+self.dataArray.count;
    }
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
        if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {//发单方案内容显示，订单详情按钮不显示
            if (section == 1) {
                return 3+self.dataArray.count;
            }
            else {
                return 1;
            }
        }
        else { //跟单方案内容锁，订单详情按钮不显示
            if (section == 1) {
                return 3;
            }
            else {
                return 1;
            }
        }
    }
    if ([schemeDetail.betContent isEqualToString:@"开奖后公开"]) { //截期后公开
        if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {
            if (section == 2) {
                return 3+self.dataArray.count;
            }
        }
        else {
            if (section == 2) {
                return 3;
            }
        }
    }
    if (section == 2) { //已开奖
        return 3+self.dataArray.count;
    }
    return 1;
}

//方案内容全显示
- (CGFloat)setHeightForFangan:(NSIndexPath *)indexPath {
        if (indexPath.row == 0) {
            SchemeContaintCell *cell = [[SchemeContaintCell alloc]init];
            return [cell dateHeight:schemeDetail]+32;
        }
        if (indexPath.row == 1) {
            return 38;
        }
        if (indexPath.row == 2+self.dataArray.count){
            if ([schemeDetail.schemeSource isEqualToString:@"BONUS_OPTIMIZE"]) {
                return 35;
            }
            return 79;
        }
        SchemeContainInfoCell *cell = [[SchemeContainInfoCell alloc]init];
        if ([schemeDetail.lottery isEqualToString:@"JCLQ"]) {
            return  [cell getCellJCLQHeight:self.dataArray[indexPath.row -2]];
        }else{
            return  [cell getCellHeight:self.dataArray[indexPath.row -2]];
        }
        return 138;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //个人中心
    if ([self.schemeFromView isEqualToString:@"personCen"]) {
        if (indexPath.section == 0) {
            if (![schemeDetail.cardCode isEqualToString:self.curUser.cardCode]) {
                return 168;
            }
            return 205;
        }
        if (indexPath.section == 1){
            return [self setHeightForFangan:indexPath];
        }
    }
    //未支付
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]){
        if (indexPath.section == 0) {
            return 130;
        }
        if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {
            if (indexPath.section == 1){
             return  [self setHeightForFangan:indexPath];
            }
        }
        else {
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    SchemeContaintCell *cell = [[SchemeContaintCell alloc]init];
                    return [cell dateHeight:schemeDetail]+32;
                }
                if (indexPath.row == 1) {
                    return 80;
                }
                if (indexPath.row == 2) {
                    return 79;
                }
            }
        }
        if (indexPath.section == 2){
            return 138;
        }
    }
    //支付后
    if([self.schemeType isEqualToString:@"BUY_INITIATE"]){
        if (indexPath.section == 0){
            return 205;
        }
        if (indexPath.section == 1){
            return 38;
        }
        if (indexPath.section == 2){
            return [self setHeightForFangan:indexPath];
        }
        if (indexPath.section == 4) {
            return 50;
        }
        return 138;
    }
    else {
        if (indexPath.section == 0){
            return 169;
        }
        if (indexPath.section == 1){
            return 38;
        }
        if (indexPath.section == 2) {
            if ([schemeDetail.betContent isEqualToString:@"开奖后公开"]){
                if (indexPath.row == 0) {
                    SchemeContaintCell *cell = [[SchemeContaintCell alloc]init];
                    return [cell dateHeight:schemeDetail]+32;
                }
                if (indexPath.row == 1) {
                    return 65;
                }
                if (indexPath.row == 2) {
                    return 79;
                }
            } else {
                return [self setHeightForFangan:indexPath];
            }
        }
        if (indexPath.section == 4) {
            return 50;
        }
        return 138;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForFangAnIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
        [cell reloadPassTypeDate:schemeDetail];
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == self.dataArray.count+2){
        SchemeOverCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeOverCell];
        [cell reloadDate:schemeDetail];
        return cell;
    }else{
        SchemeContainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContainInfoCell];
        JcBetContent *bet;
        if(indexPath.row == 1){
            [cell reloadDate:schemeDetail];
        }else{
            if(self.dataArray.count >0){
                bet = self.dataArray[indexPath.row-2];
                if ([schemeDetail.lottery isEqualToString:@"JCLQ"]) {
                    [cell refreshDataJCLQ:bet andResult:schemeDetail.trOpenResult];
                }else{
                    [cell refreshData:bet andResult:schemeDetail.trOpenResult];
                }
            }
        }
       return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.schemeFromView isEqualToString:@"personCen"]){
        if (indexPath.section == 0) {
            SchemeInfoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoBuyCell];
            if (![schemeDetail.cardCode isEqualToString:self.curUser.cardCode]||self.curUser.isLogin ==NO ) {
               [cell reloadDateFromPer:schemeDetail];
            }
            else {
               [cell reloadDate:schemeDetail];
            }
            cell.delegate = self;
            return cell;
        }
        else {  //section = 1;
            if (indexPath.row == 0) {
                SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
                [cell reloadPassTypeDate:schemeDetail];
                cell.delegate = self;
                return cell;
            }
           return  [self tableView:tableView cellForFangAnIndexPath:indexPath];
        }
    }
    
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]){
        if (indexPath.section == 0) {
            SchemeInfoFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoFollowCell];
            [cell reloadDate:schemeDetail];
            cell.delegate = self;
            return cell;
        }
        if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {
            if (indexPath.section == 1){
                //待支付的发单状态，没有订单详情按钮
                if (indexPath.row == 0) {
                    SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
                    [cell reloadPassTypeDate:schemeDetail];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
                 return [self tableView:tableView cellForFangAnIndexPath:indexPath];
            }
        }
        else {
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
                    [cell reloadPassTypeDate:schemeDetail];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
                if (indexPath.row == 1) {
                    SuoSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSuoSchemeViewCell];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
                if (indexPath.row == 2) {
                    SchemeOverCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeOverCell];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
            }
        }
        if (indexPath.section == 2){
            SchemeBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeBuyCell];
            [cell loadData:schemeDetail];
            return cell;
        }
    }
    
    if([self.schemeType isEqualToString:@"BUY_INITIATE"]){
        if (indexPath.section == 0){
            SchemeInfoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoBuyCell];
            [cell reloadDate:schemeDetail];
            cell.delegate = self;
            return cell;
        }
        if (indexPath.section == 1){
            SchemePerFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemePerFollowCell];
            cell.delegate = self;
            [cell reloadDate:schemeDetail schemeType:self.schemeType isAttend:isAttend];
            return cell;
        }
        if (indexPath.section == 2){
            return  [self tableView:tableView cellForFangAnIndexPath:indexPath];
        }
        if (indexPath.section == 4) {
            LegInfoViewCell *legCell = [tableView dequeueReusableCellWithIdentifier:KLegInfoViewCell];
            legCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [legCell LoadData:schemeDetail.legName legMobile:schemeDetail.legMobile legWechat:schemeDetail.legWechatId];
            return legCell;
        }
    }
    else {
        if (indexPath.section == 0){
            SchemeInfoFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoFollowCell];
            [cell reloadDate:schemeDetail];
            cell.delegate = self;
            return cell;
        }
        if (indexPath.section == 1){
            SchemePerFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemePerFollowCell];
            cell.delegate = self;
            [cell reloadDate:schemeDetail schemeType:self.schemeType isAttend:isAttend];
            return cell;
        }
        if (indexPath.section == 2) {
            if ([schemeDetail.betContent isEqualToString:@"开奖后公开"]){
                if (indexPath.row == 0) {
                    SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
                    cell.delegate = self;
                    [cell reloadDate:schemeDetail];
                    [cell reloadPassTypeDate:schemeDetail];
                    return cell;
                }
                if (indexPath.row == 1) {
                    SuoSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSuoSchemeViewCell];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
                if (indexPath.row == 2) {
                    SchemeOverCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeOverCell];
                    [cell reloadDate:schemeDetail];
                    return cell;
                }
            } else {
                 return [self tableView:tableView cellForFangAnIndexPath:indexPath];
            }
        }
        if (indexPath.section == 4) {
            LegInfoViewCell *legCell = [tableView dequeueReusableCellWithIdentifier:KLegInfoViewCell];
            legCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [legCell LoadData:schemeDetail.legName legMobile:schemeDetail.legMobile legWechat:schemeDetail.legWechatId];
            return legCell;
        }
    }

    SchemeBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeBuyCell];
    [cell loadData:schemeDetail];
    return cell;
}


-(void)goOrderList{
    JCLQOrderDetailInfoViewController *orderDetailVC =[[JCLQOrderDetailInfoViewController alloc]init];
    orderDetailVC.schemeNO = schemeDetail.schemeNO;
    orderDetailVC.lotteryCode = schemeDetail.lottery;
    orderDetailVC.fromView = @"FOLLOW_INIT";
    if ([schemeDetail.lottery isEqualToString:@"JCZQ"]) {
        orderDetailVC.trOpenResult = schemeDetail.trOpenResult;
    }else {
        orderDetailVC.lqOpenResult = (NSMutableArray <JCLQOpenResult *> *)schemeDetail.trOpenResult;
    }
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

-(void)gotoFollowList{
    if ([self.schemeType isEqualToString:@"BUY_FOLLOW"]) {
        if (self.curUser == nil || self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
        if (isAttend) {
            //取消关注
            NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":schemeDetail.initiateCardCode,@"attentType":@"FOLLOW"};
            [self.lotteryMan reliefAttent:dic];
        }
        else {
            //添加关注
            NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":schemeDetail.initiateCardCode,@"attentType":@"FOLLOW"};
            [self.lotteryMan attentMember:dic];
        }
    }else {
        FollowListViewController * followVC = [[FollowListViewController alloc]init];
        followVC.followListDtos = schemeDetail.followListDtos;
        [self.navigationController pushViewController:followVC animated:YES];
    }
}

-(void)navigationBackToLastPage{
    if (self.h5Init == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
        for (BaseViewController *baseVC in self.navigationController.viewControllers) {
            if ([baseVC isKindOfClass:[MyPostSchemeViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            if ([baseVC isKindOfClass:[PersonCenterViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
        }
    MyPostSchemeViewController *revise = [[MyPostSchemeViewController alloc]init];
    revise.hidesBottomBarWhenPushed = YES;
    if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {
        revise.isFaDan = YES;
    } else {
        revise.isFaDan = NO;
    }
    [self.navigationController pushViewController:revise animated:YES];
}

- (void) gotisAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    isAttend = [diction boolValue];
    [self.detailTableView reloadData];
}

- (void) gotAttentMember:(NSString *)diction  errorMsg:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:2.0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if (diction) {
        isAttend = YES;
        [self.detailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showPromptText:@"添加关注成功" hideAfterDelay:2.0];
    }
}

- (void) gotReliefAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:2.0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if (diction) {
        isAttend = NO;
        [self.detailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showPromptText:@"取消关注成功" hideAfterDelay:2.0];
    }
}

- (IBAction)actionToZhiFu:(id)sender {
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo =schemeDetail.schemeNO;
    schemeCashModel.subCopies = 1;
    schemeCashModel.costType = CostTypeCASH;
    schemeCashModel.subscribed = [schemeDetail.betCost integerValue];
    schemeCashModel.realSubscribed = [schemeDetail.betCost integerValue];
    if ([schemeDetail.lottery isEqualToString:@"JCZQ"]){
        schemeCashModel.lotteryName = @"竞彩足球";
    }else if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
        schemeCashModel.lotteryName = @"竞彩篮球";
    }
//    payVC.cashPayMemt = schemeCashModel;
    if ([self.schemeType isEqualToString:@"BUY_INITIATE"]) {
        payVC.schemetype = SchemeTypeFaqiGenDan;
    } else {
        payVC.schemetype = SchemeTypeGenDan;
    }
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)showAlertFromFollow{
    ZLAlertView *alert = [[ZLAlertView alloc]initWithTitle:@"" message:@"总收入=中奖-佣金(中奖金额为方案拆票中奖之和。如有拆票订单未开奖，请稍等)"];
    [alert addBtnTitle:@"确定" action:^{
        
    }];
    [alert showAlertWithSender:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([schemeDetail isHasLeg]) {
        if (section == 4) {
            OrderListHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"OrderListHeaderView" owner:nil options:nil] lastObject];
            header.backgroundColor = RGBCOLOR(253 , 252, 245);
            header.titleLa.text = @"跑腿信息";
            return header;
        }
    }
    return [UIView new];
}

- (void)showAlertFromBuy {
    ZLAlertView *alert = [[ZLAlertView alloc]initWithTitle:@"" message:@"总收入=中奖+佣金(中奖金额为方案拆票中奖之和。如有拆票订单未开奖，请稍等)"];
    [alert addBtnTitle:@"确定" action:^{
        
    }];
    [alert showAlertWithSender:self];
}
@end
