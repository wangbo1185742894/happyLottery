//
//  LegOrderDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderDetailViewController.h"
#import "LegOrderStatusTableViewCell.h"
#import "LegOrderMoneyTableViewCell.h"
#import "LegOrderIntroTableViewCell.h"
#import "LegOrderStatueWaitTableViewCell.h"
#import "LegDetailHeaderView.h"
#import "JCZQSchemeModel.h"
#import "DLTChaseSchemeDetail.h"
#import "PostboyAccountModel.h"
#import "ZHDetailViewController.h"
#import "FASSchemeDetailViewController.h"
#import "CTZQSchemeDetailViewController.h"
#import "DLTSchemeDetailViewController.h"
#import "GYJSchemeDetailViewController.h"
#import "SchemeDetailViewController.h"
#import "JCLQSchemeDetailViewController.h"
#import "LegDetailFooterView.h"
#import "PayOrderLegViewController.h"
#import "WebShowViewController.h"
#import "PaySuccessViewController.h"

#define KLegOrderStatusTableViewCell    @"LegOrderStatusTableViewCell"
#define KLegOrderMoneyTableViewCell   @"LegOrderMoneyTableViewCell"
#define KLegOrderIntroTableViewCell    @"LegOrderIntroTableViewCell"
#define KLegOrderStatueWaitTableViewCell  @"LegOrderStatueWaitTableViewCell"



#define OrderTijiao @"您提交了订单"
#define OrderYiJie(Name)     [NSString stringWithFormat:@"%@已接单",Name];
#define OrderYiZhiFu(Name)     [NSString stringWithFormat:@"订单已支付成功，%@将在5分钟内替您到线下彩票站出票",Name];
#define OrderYiZhiFuZhuiHao(Name)     [NSString stringWithFormat:@"订单已支付成功，%@将在5分钟内替您到线下彩票站出票追号",Name];
#define OrderYiDaoChuPiao(Name)   [NSString stringWithFormat:@"%@已到达彩票站，并成功出票",Name];

#define OrderYiDaoChuPiaoBuFen(Name)   [NSString stringWithFormat:@"%@已到达彩票站，并部分出票，未出票部分将在30分钟内退还至您在该账户的存款中。",Name];


#define OrderShiBai   @"订单出票失败，小哥将在10分钟内返还金额给您";

#define DingDanWin(Name) [NSString stringWithFormat:@"订单已中奖！%@将在2小时内兑奖",Name];

#define DingDanFanHuan @"已将退款返还至您在该账户的存款中，请查收";

#define OrderWeiWin   @"订单未中奖"


#define OrderZhuiHaoQingKuang(Name) [NSString stringWithFormat:@"%@已到达彩票站，已开始追号",Name];

#define OrderZhuiHaoJiXu(zhuiQi) [NSString stringWithFormat:@"在追第%@期中奖，继续追号。",zhuiQi];

#define OrderZhuiHaoJieShu @"追号已结束，订单未中奖"

#define OrderZhuiTingZhi(zhuiQi) [NSString stringWithFormat:@"在追第%@期中奖。",zhuiQi];


@interface LegOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,PostboyManagerDelegate,OrderDetailDelegate,LegDetailDelegate,LegOrderStatueWaitDelegate,LegDetailFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic , strong) NSMutableArray<NSDictionary *> *infoArray;
@property (nonatomic , strong) NSString *stateStr;
@property (nonatomic , strong) NSMutableArray<OrderProfile *> *dateArray;
@property (nonatomic, strong) NSString *zhuiHaoPostBoyNam;
@property (nonatomic, strong) NSString *postBoyTel;
@property (nonatomic, strong) NSString *zhuiHaoState;
@property (nonatomic, strong) NSString *waitTime;
@end

@implementation LegOrderDetailViewController{
    LegDetailHeaderView *headerView;
    JCZQSchemeItem *schemeDetail;
    DLTChaseSchemeDetail *zhuiHaoDetail; //追号详情
    NSString *zhuihaoWon;
    LegDetailFooterView *footView;
    NSString *dateStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看订单";
    [self setTableView];
    self.lotteryMan.delegate = self;
    self.postboyMan.delegate = self;
    headerView = [[LegDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    headerView.delegate = self;
    if (self.schemeNo != nil) {
         [self loadNewDate];
    } else{
        [self loadZhuiHaoDate];
    }
    self.infoArray = [NSMutableArray arrayWithCapacity:0];
    self.dateArray = [NSMutableArray arrayWithCapacity:0];
    footView = [[LegDetailFooterView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 130)];
    footView.delegate =self;
    if (self.schemeNo == nil) {//追号详情没有刷新按钮
        footView.refreshBtn.hidden = YES;
        footView.refreshBtn.userInteractionEnabled = NO;
    } else {
        footView.refreshBtn.hidden = NO;
        footView.refreshBtn.userInteractionEnabled = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)actionToTele{
    if (self.postBoyTel.length == 0) {
        [self showPromptText:@"暂未上传手机号" hideAfterDelay:1.7];
        return;
    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.postBoyTel]]];
}

-(void)setTableView{
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderStatusTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderStatusTableViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderMoneyTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderMoneyTableViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderIntroTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderIntroTableViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderStatueWaitTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderStatueWaitTableViewCell];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)showOrderDetail{
    if (self.schemeNo == 0) {
        ZHDetailViewController *zhdetailViewCtr = [[ZHDetailViewController alloc]initWithNibName:@"ZHDetailViewController" bundle:nil];
//        zhdetailViewCtr.delegate = self;
        zhdetailViewCtr.order = self.orderPro;
        [self.navigationController pushViewController:zhdetailViewCtr animated:YES];
    }else {
        if (self.schemetype == SchemeTypeGenDan) {
          FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
          detailCV.schemeNo = self.schemeNo;
          detailCV.schemeType = @"BUY_FOLLOW";
          detailCV.deadLineTime = dateStr;
          [self.navigationController pushViewController:detailCV animated:YES];
        }else if ( self.schemetype == SchemeTypeFaqiGenDan){
          FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
          detailCV.schemeNo = self.schemeNo;
          detailCV.deadLineTime = dateStr;
          detailCV.schemeType = @"BUY_INITIATE";
        [self.navigationController pushViewController:detailCV animated:YES];
            }else{
                if ([self.lotteryName isEqualToString:@"胜负14场"] || [self.lotteryName isEqualToString:@"任选9场"]) {
                    CTZQSchemeDetailViewController *schemeVC = [[CTZQSchemeDetailViewController alloc]init];
                    schemeVC.deadLineTime = dateStr; 
                    schemeVC.schemeNO = self.schemeNo;
                    [self.navigationController pushViewController:schemeVC animated:YES];
                }else if([self.lotteryName isEqualToString:@"大乐透"]||[self.lotteryName isEqualToString:@"双色球"] || [self.lotteryName isEqualToString:@"陕西11选5"] || [self.lotteryName isEqualToString:@"山东11选5"]){
                    DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
                    schemeVC.schemeNO = self.schemeNo;
                    schemeVC.deadLineTime = dateStr;
                    [self.navigationController pushViewController:schemeVC animated:YES];
                }else if ([self.lotteryName isEqualToString:@"冠军"] || [self.lotteryName isEqualToString:@"冠亚军"]){
                    GYJSchemeDetailViewController *schemeVC = [[GYJSchemeDetailViewController alloc]init];
                    schemeVC.schemeNO = self.schemeNo;
                    schemeVC.deadLineTime = dateStr;
                    [self.navigationController pushViewController:schemeVC animated:YES];
                }else if ([self.lotteryName isEqualToString:@"竞彩篮球"]){
                    JCLQSchemeDetailViewController *schemeVC = [[JCLQSchemeDetailViewController alloc]init];
                    schemeVC.schemeNO = self.schemeNo;
                    schemeVC.deadLineTime = dateStr;
                    [self.navigationController pushViewController:schemeVC animated:YES];
                }else{
                    SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
                    schemeVC.schemeNO = self.schemeNo;
                    schemeVC.deadLineTime = dateStr;
                    [self.navigationController pushViewController:schemeVC animated:YES];
                }
        
            }
    }
    
}

- (void)navigationBackToLastPage{
    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
        if ([baseVC isKindOfClass:[PaySuccessViewController class]]) {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            return ;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 购彩
- (void)loadNewDate {
    [self showLoadingText:@"正在加载"];
    if (self.schemeNo != nil) {
        [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNo}];
    }
}

- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    [self.infoArray removeAllObjects];
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    if (schemeDetail.postboyId.length != 0) {
        [headerView.LegBtn setTitle:schemeDetail.legName forState:0];
        headerView.LegBtn.hidden = NO;
        headerView.LegBtn.userInteractionEnabled = YES;
        self.postBoyTel = schemeDetail.legMobile;
    }else {
        headerView.LegBtn.hidden = YES;
        headerView.LegBtn.userInteractionEnabled = NO;
        self.postBoyTel = nil;
    }
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) { //待支付状态
        [self loadInfoWhenWait];
        self.stateStr = @"待支付";
        if (self.schemeNo != nil) {
             [self.lotteryMan getDeadLine:@{@"schemeNo":self.schemeNo}];
        }
    } else { //已支付
        [self reloadInfo];
        [self.detailTableView reloadData];
    }
}


- (void)getDeadLineDelegate:(NSString *)resultStr  errorMsg:(NSString *)msg{
    if (resultStr != nil) {
        dateStr = resultStr;
        self.waitTime = [NSString stringWithFormat:@"请于%@前完成支付",[dateStr substringWithRange:NSMakeRange(5,11)]];
    } else {
        self.waitTime = [NSString stringWithFormat:@"请尽快支付"];
    }
    [self.detailTableView reloadData];
}


- (void)loadInfoWhenWait{
    NSString *legName;
    NSDictionary *dic;
    if (schemeDetail.createTime.length != 0) {
        dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":OrderTijiao};
        [self.infoArray insertObject:dic atIndex:0];
    }
    if (schemeDetail.createTime.length != 0) {
        legName = OrderYiJie(schemeDetail.legName);
        dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
    }
    
}


- (void)refreshState {
    NSString *legName;
    NSDictionary *dic;
    if (schemeDetail.legName.length == 0) {
        schemeDetail.legName = @"";
    }
    if ([schemeDetail.ticketStatus isEqualToString:@"SUC_TICKET"]) { //出票成功
        
        if (schemeDetail.printCount == schemeDetail.ticketCount) { //全部出票
            self.stateStr = @"已出票";
            if (schemeDetail.commitTime.length != 0) {
                legName = OrderYiDaoChuPiao(schemeDetail.legName);
                dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            
        } else {//部分出票
            self.stateStr = @"部分出票";
            if (schemeDetail.commitTime.length != 0) {
                legName = OrderYiDaoChuPiaoBuFen(schemeDetail.legName);
                dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            } else if (schemeDetail.sellEndTime.length != 0) {
                legName = OrderYiDaoChuPiaoBuFen(schemeDetail.legName);
                dic = @{@"timeLab":schemeDetail.sellEndTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            if (schemeDetail.commitTime.length != 0) { //退款
                legName = DingDanFanHuan;
                dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            } else if (schemeDetail.sellEndTime.length != 0){
                legName = DingDanFanHuan;
                dic = @{@"timeLab":schemeDetail.sellEndTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
        }
        if ([schemeDetail.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {//待开奖
            self.stateStr = @"待开奖";
        } else {
            if ([schemeDetail.won boolValue]) { //已中奖
                self.stateStr = @"已中奖";
                if (schemeDetail.drawTime.length != 0) {
                    legName = DingDanWin(schemeDetail.legName);
                    dic = @{@"timeLab":schemeDetail.drawTime,@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }
            } else {  //未中奖
                self.stateStr = @"未中奖";
                if (schemeDetail.drawTime.length != 0) {
                    legName = OrderWeiWin;
                    dic = @{@"timeLab":schemeDetail.drawTime,@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }
            }
        }
        
    } else if ([schemeDetail.schemeStatus isEqualToString:@"REPEAL"]|| [schemeDetail.ticketStatus isEqualToString:@"TICKET_FAILED"]){//出票失败
        self.stateStr = @"出票失败";
        if (schemeDetail.commitTime.length != 0) {
            legName = OrderShiBai;
            dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
            [self.infoArray insertObject:dic atIndex:0];
        } else if (schemeDetail.sellEndTime.length != 0) {
            legName = OrderShiBai;
            dic = @{@"timeLab":schemeDetail.sellEndTime,@"infoLab":legName};
            [self.infoArray insertObject:dic atIndex:0];
        }
        
        if ([schemeDetail.schemeStatus isEqualToString:@"REPEAL"]) { //退款
            self.stateStr = @"已退款";
            if (schemeDetail.commitTime.length != 0) {
                legName = DingDanFanHuan;
                dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            } else if (schemeDetail.sellEndTime.length != 0){
                legName = DingDanFanHuan;
                dic = @{@"timeLab":schemeDetail.sellEndTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            
        }
    }
}

- (void)reloadInfo{
    if (schemeDetail.legName.length == 0) {
        schemeDetail.legName = @"";
    }
    NSString *legName;
    NSDictionary *dic;
    if (schemeDetail.createTime.length != 0) {
        dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":OrderTijiao};
        [self.infoArray insertObject:dic atIndex:0];
    }
    if (schemeDetail.createTime.length != 0) {
        legName = OrderYiJie(schemeDetail.legName);
        dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
    }
    
    if (schemeDetail.ticketTime != nil) {
        legName = OrderYiZhiFu(schemeDetail.legName);
        dic = @{@"timeLab":schemeDetail.ticketTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
    }
    self.stateStr = @"已支付";
    [self refreshState];
}

#pragma mark 追号

- (void)loadZhuiHaoDate {
    [self showLoadingText:@"正在加载"];
    if (_orderPro.postboyId.length == 0) {
        self.zhuiHaoPostBoyNam = @"";
        headerView.LegBtn.hidden = YES;
        headerView.LegBtn.userInteractionEnabled = NO;
        self.postBoyTel = nil;
        [self.lotteryMan getChaseDetailForApp:@{@"chaseSchemeNo":_orderPro.chaseSchemeNo}];
    } else {
        [self.postboyMan getPostboyInfoById:@{@"postboyId":_orderPro.postboyId}];
    }
    
}


-(void )getPostboyInfoByIddelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (param == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PostboyModel * postBoy= [[PostboyModel alloc]initWith:param];
    if (postBoy.postboyName.length == 0) {
        self.zhuiHaoPostBoyNam = @"";
        self.postBoyTel = nil;
        headerView.LegBtn.hidden = YES;
        headerView.LegBtn.userInteractionEnabled = NO;
    } else {
        self.zhuiHaoPostBoyNam = postBoy.postboyName;
        self.postBoyTel = postBoy.mobile;
        [headerView.LegBtn setTitle:postBoy.postboyName forState:0];
        headerView.LegBtn.hidden = NO;
        headerView.LegBtn.userInteractionEnabled = YES;
    }
    //追号订单详情
    [self.lotteryMan getChaseDetailForApp:@{@"chaseSchemeNo":_orderPro.chaseSchemeNo}];
}


-(void)gotChaseDetailForApp:(NSDictionary *)info errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (info == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    [self.infoArray removeAllObjects];
    zhuiHaoDetail = [[DLTChaseSchemeDetail alloc]initWith:info];
    for (NSDictionary *itemDic in info[@"tempList"][@"rows"]) {
        OrderProfile *profile = [[OrderProfile alloc]initWith:itemDic];
        [self.dateArray addObject:profile];
    }
    [self reloadZhuiHaoInfo];
    [self.detailTableView reloadData];
}


- (void)reloadZhuiHaoInfo{
    NSString *legName;
    NSDictionary *dic;
    if (self.orderPro.createTime.length != 0) {
        dic = @{@"timeLab":self.orderPro.createTime,@"infoLab":OrderTijiao};
        [self.infoArray insertObject:dic atIndex:0];
        
        legName = OrderYiJie(self.zhuiHaoPostBoyNam);
        dic = @{@"timeLab":self.orderPro.createTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
        
        legName = OrderYiZhiFuZhuiHao(self.zhuiHaoPostBoyNam);
        dic = @{@"timeLab":self.orderPro.createTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
    }
    
    self.stateStr = @"已支付";
    [self refreshStateZhuiHao];
}

- (void)refreshStateZhuiHao{
    NSString *legName;
    NSDictionary *dic;
    for (OrderProfile *profile in self.dateArray) {
        if ([profile.trOrderStatus isEqualToString:@"出票成功"]) {
            if (profile.commitTime.length != 0) {
                legName = OrderZhuiHaoQingKuang(self.zhuiHaoPostBoyNam);
                dic = @{@"timeLab":[self timeTransaction:profile.commitTime],@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            break;
        }
    }
    if ([self.orderPro.chaseStatus isEqualToString:@"追号结束"]||[self.orderPro.chaseStatus isEqualToString:@"已停追"]||[self.orderPro.chaseStatus isEqualToString:@"撤销追号"]) {  //追号结束
        self.zhuiHaoState = self.orderPro.chaseStatus;
        BOOL chupiaoSuccess = NO;
        for (OrderProfile *profile in self.dateArray) {
            if ([profile.trOrderStatus isEqualToString:@"出票成功"] || [profile.trOrderStatus isEqualToString:@"出票中"]) {
                chupiaoSuccess = YES;
                break;
            }
        }
        if (!chupiaoSuccess) {
            self.zhuiHaoState = @"出票失败";
        }
        if (!chupiaoSuccess) {
            if (self.orderPro.lastModifyTime.length != 0) {
                legName = [NSString stringWithFormat:@"追号结束，已将退款返还至您在该账户的存款中，请查收"];
                dic = @{@"timeLab":self.orderPro.lastModifyTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            return;
        } 
        if ([self.orderPro.winStatus isEqualToString:@"NOT_LOTTERY"]) {//未中奖
            zhuihaoWon = @"未中";
            if (self.orderPro.completeTime.length!= 0) {
                legName = OrderZhuiHaoJieShu;
                dic = @{@"timeLab":self.orderPro.completeTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
        }else if ([self.orderPro.winStatus isEqualToString:@"WAIT_LOTTERY"]){
            zhuihaoWon = @"待开";
            if (self.orderPro.completeTime.length!= 0) {
                legName = [NSString stringWithFormat:@"%@",self.orderPro.chaseStatus];
                dic = @{@"timeLab":self.orderPro.completeTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
            BOOL wonStatue = NO;
            for (int i = 0; i < self.dateArray.count; i++) {
                OrderProfile *profile = self.dateArray[i];
                if ([profile.trOrderStatus isEqualToString:@"出票中"]) {  //有未出票状态
                    wonStatue = YES;
                    break;
                }
                if ([profile.trOrderStatus isEqualToString:@"出票成功"] && profile.trOpenResult.length == 0) {  //有未开奖状态
                    wonStatue = YES;
                    break;
                }
                if ([profile.trBonus doubleValue] > 0) {
                    wonStatue = YES;
                    break;
                }
            }
            if (!wonStatue) {
                zhuihaoWon = @"未中";
                if (self.orderPro.completeTime.length!= 0) {
                    legName = OrderZhuiHaoJieShu;
                    dic = @{@"timeLab":self.orderPro.completeTime,@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }
            }
        }else { //已中奖
            for (int i = 0; i < self.dateArray.count; i++) {
                OrderProfile *profile = self.dateArray[i];
                if ([profile.trBonus doubleValue]> 0) {
                    zhuihaoWon = @"已中";
                    if (profile.drawTime.length != 0) {
                        if (i == self.dateArray.count - 1) {  //最后一期
                            legName = [NSString stringWithFormat:@"在追第%@期中奖。",profile.catchIndex];
                        } else if ([self.orderPro.winStopStatus isEqualToString:@"NOTSTOP"]) {//中奖不停追
                            legName = OrderZhuiHaoJiXu(profile.catchIndex);
                        } else {
                            legName = OrderZhuiTingZhi(profile.catchIndex);
                        }
                        dic = @{@"timeLab":[self timeTransaction:profile.drawTime],@"infoLab":legName};
                        [self.infoArray insertObject:dic atIndex:0];
                    }
                }
            }
            if (self.orderPro.completeTime.length != 0) {
                legName = [NSString stringWithFormat:@"%@,订单已中奖！%@将在2小时内兑奖",self.orderPro.chaseStatus,self.zhuiHaoPostBoyNam];
                dic = @{@"timeLab":self.orderPro.completeTime,@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
        }
        
    } else {
        self.zhuiHaoState = @"追号中";
        for (OrderProfile *profile in self.dateArray) {
            if ([profile.trBonus doubleValue] > 0) {
                zhuihaoWon = @"已中";
                if (profile.drawTime.length != 0) {
                    legName = OrderZhuiHaoJiXu(profile.catchIndex);
                    dic = @{@"timeLab":[self timeTransaction:profile.drawTime],@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }
                if (profile.completeTime.length != 0) {
                    legName = [NSString stringWithFormat:@"已将奖金%@元返还至您在该账户的存款中,请查收",profile.trBonus];
                    dic = @{@"timeLab":[self timeTransaction:profile.completeTime],@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }
            }
        }
    }
}

- (NSString *)timeTransaction:(NSString *)time {
    CGFloat timeFloat = [time doubleValue] / 1000;
    return  [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withTI:timeFloat];
}

#pragma mark  tableview delegate

- (void)reloadDateRefresh{
    if (self.schemeNo) {
        [self loadNewDate];
    } else {
        [self loadZhuiHaoDate];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return footView;
    }
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 1;
    }
    if (section == 2) {
        return 130;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 74;
    }
    if (indexPath.section == 1) {
        return 121;
    }
    return 68;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.infoArray.count;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.stateStr isEqualToString:@"待支付"]) {
            LegOrderStatueWaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderStatueWaitTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.timeLab.text = self.waitTime;
            cell.delegate = self;
            cell.timeStr = dateStr;
            return cell;
        }
        LegOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderStatusTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.stateStr) {
            if (self.schemeNo != nil) {
                [cell loadNewDate:self.stateStr];
            }else {
                [cell loadZhuiHaoNewDate:self.zhuiHaoState andWon:zhuihaoWon];
            }
            
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        LegOrderMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderMoneyTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (self.stateStr) {
            if (self.schemeNo != nil) {
                [cell loadNewDate:schemeDetail andStatus:self.stateStr];
            }
            else {
                [cell loadZhuiHaoNewDate:self.orderPro andStatus:self.zhuiHaoState andName:self.zhuiHaoPostBoyNam andWon:zhuihaoWon];
            }
        }
        return cell;
    }
    LegOrderIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderIntroTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.infoArray.count - 1) {
        cell.labTiao.hidden = YES;
    }else {
        cell.labTiao.hidden = NO;
    }
    [cell reloadDate:self.infoArray[indexPath.row]];
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)actionToRecharge{
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.schemeNo = schemeDetail.schemeNO;
    payVC.subscribed = [schemeDetail.betCost doubleValue];
    payVC.postBoyId = schemeDetail.postboyId;
    payVC.lotteryName = self.lotteryName;
    payVC.schemeSource = schemeDetail.schemeSource;
    if ([schemeDetail.schemeType isEqualToString:@"BUY_INITIATE"]) {
        payVC.schemetype = SchemeTypeFaqiGenDan;
    } else if ([schemeDetail.schemeType isEqualToString:@"BUY_FOLLOW"]){
        payVC.schemetype = SchemeTypeGenDan;
    } else if([schemeDetail.schemeType isEqualToString:@"BUY_SELF"]){
        payVC.schemetype = SchemeTypeZigou;
    }
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)refreshDetail{
    [self reloadDateRefresh];
}

- (void)lookLegDelegate{
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"postboy_agreement" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"代买服务协议";
    [self.navigationController pushViewController:webShow animated:YES];
}


@end

