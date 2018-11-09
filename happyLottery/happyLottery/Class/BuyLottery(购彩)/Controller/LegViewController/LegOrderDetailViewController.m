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

#define KLegOrderStatusTableViewCell    @"LegOrderStatusTableViewCell"
#define KLegOrderMoneyTableViewCell   @"LegOrderMoneyTableViewCell"
#define KLegOrderIntroTableViewCell    @"LegOrderIntroTableViewCell"
#define KLegOrderStatueWaitTableViewCell  @"LegOrderStatueWaitTableViewCell"



#define OrderTijiao @"您提交了订单"
#define OrderTijiaoTouZhu @"您提交了投注单"
#define OrderYiJie(Name)     [NSString stringWithFormat:@"%@已接单",Name];
#define OrderYiZhiFu(Name)     [NSString stringWithFormat:@"订单已支付成功，%@将在5分钟内替您到线下彩票站出票",Name];
#define OrderYiDaoChuPiao(Name)   [NSString stringWithFormat:@"%@已到达彩票站，并成功出票",Name];

#define OrderYiDaoChuPiaoBuFen(Name,Money)   [NSString stringWithFormat:@"%@已到达彩票站，并部分出票，未出票部分共计%@元将在30分钟内退还到您的小哥余额中。",Name,Money];

#define OrderChaoshiWeiChuPiao(Money)   [NSString stringWithFormat:@"超时未出票，订单取消，平台将在10分钟内返还%@元给您",Money];

#define OrderXianHaoChuPiaoShiBai(Money)   [NSString stringWithFormat:@"限号导致订单失败，平台将在10分钟内返还%@元给您",Money];

#define OrderShiBai(Money)   [NSString stringWithFormat:@"订单失败，平台将在10分钟内返还%@元给您",Money];

#define DingDanWin(Name) [NSString stringWithFormat:@"订单已中奖！%@将在2小时内兑奖",Name];

#define DingDanFanHuan(Money) [NSString stringWithFormat:@"已将%@元返还至您在该账户的存款中，请查收",Money];

#define OrderWeiWin   @"订单未中奖"

#define OrderFanJiang(Name,Money) [NSString stringWithFormat:@"%@已将奖金%@元返还至您在该账户的存款中，请查收",Name,Money];

#define OrderZhuiHaoQingKuang(Name,zhuiQi,zongQi) [NSString stringWithFormat:@"%@已到达彩票站，已开始追号%@/%@.",Name,zhuiQi,zongQi];

#define OrderZhuiHaoJiXu(zhuiQi,Name) [NSString stringWithFormat:@"在追第%@期中奖，继续追号。%@将在2小时内兑奖",zhuiQi,Name];

#define OrderZhuiHaoJieShu @"追号已结束，订单未中奖"

#define OrderZhuiTingZhi(zhuiQi,Name) [NSString stringWithFormat:@"在追第%@期中奖，已停止追号。%@将在2小时内兑奖",zhuiQi,Name];

#define OrderZhuiTingFanJiang(Name,Money) [NSString stringWithFormat:@"追号已结束，%@已将奖金%@元返还至您在该账户的存款中，请查收",Name,Money];

@interface LegOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic , strong) NSMutableArray<NSDictionary *> *infoArray;
@property (nonatomic , strong) NSString *stateStr;

@end

@implementation LegOrderDetailViewController{
    LegDetailHeaderView *headerView;
    JCZQSchemeItem *schemeDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看订单";
    [self setTableView];
    self.lotteryMan.delegate = self;
    [self loadNewDate];
    self.infoArray = [NSMutableArray arrayWithCapacity:0];
    headerView = [[LegDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    // Do any additional setup after loading the view from its nib.
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

- (void)loadNewDate {
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNo}];
}

- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    [self.infoArray removeAllObjects];
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) { //待支付状态
        [self loadInfoWhenWait];
        [self.detailTableView reloadData];
        self.stateStr = @"待支付";
    } else { //已支付
        [self reloadInfo];
        [self.detailTableView reloadData];
    }
}


- (void)loadInfoWhenWait {
    NSString *legName;
    NSDictionary *dic;
    dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":OrderTijiao};
    [self.infoArray insertObject:dic atIndex:0];
    
    legName = OrderYiJie(schemeDetail.legName);
    dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":legName};
    [self.infoArray insertObject:dic atIndex:0];
}

- (void)refreshState {
    NSString *legName;
    NSDictionary *dic;
    if ([schemeDetail.ticketStatus isEqualToString:@"SUC_TICKET"]) { //出票成功
        self.stateStr = @"已出票";
        legName = OrderYiDaoChuPiao(schemeDetail.legName);
        dic = @{@"timeLab":schemeDetail.commitTime,@"infoLab":legName};
        [self.infoArray insertObject:dic atIndex:0];
        if ([schemeDetail.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {//待开奖
            self.stateStr = @"待开奖";
        } else {
            if ([schemeDetail.won boolValue]) { //已中奖
                legName = DingDanWin(schemeDetail.legName);
                dic = @{@"timeLab":@"schemeDetail.drawTime",@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
                if([schemeDetail.winningStatus isEqualToString:@"BIG_GAIN_TICKET"]){  //大奖方案已取票
                    
                }else if([schemeDetail.winningStatus isEqualToString:@"SEND_PRIZE"])  {//已派奖
                    self.stateStr = @"已派奖";
                    legName = OrderFanJiang(schemeDetail.legName,schemeDetail.bonus);
                    dic = @{@"timeLab":@"schemeDetail.prizeTime",@"infoLab":legName};
                    [self.infoArray insertObject:dic atIndex:0];
                }else if([schemeDetail.winningStatus isEqualToString:@"BIG_PRIZE"]){ //大奖方案未派奖
    
                }else { //未派奖
                    self.stateStr = @"派奖中";
                }
            } else {  //未中奖
                self.stateStr = @"未中奖";
                legName = OrderWeiWin;
                dic = @{@"timeLab":@"schemeDetail.drawTime",@"infoLab":legName};
                [self.infoArray insertObject:dic atIndex:0];
            }
        }
       
    } else if ([schemeDetail.ticketStatus isEqualToString:@"FAIL_TICKET"]){//出票失败
        
    }
}

- (void)reloadInfo{
    
    NSString *legName;
    NSDictionary *dic;
    dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":OrderTijiao};
    [self.infoArray insertObject:dic atIndex:0];

    legName = OrderYiJie(schemeDetail.legName);
    dic = @{@"timeLab":schemeDetail.createTime,@"infoLab":legName};
    [self.infoArray insertObject:dic atIndex:0];
    
    legName = OrderYiZhiFu(schemeDetail.legName);
    dic = @{@"timeLab":schemeDetail.ticketTime,@"infoLab":legName};
    [self.infoArray insertObject:dic atIndex:0];
    self.stateStr = @"已支付";
    [self refreshState];
}

#pragma mark  tableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *footer =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
        footer.backgroundColor = [UIColor whiteColor];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but addTarget:self action:@selector(loadNewDate) forControlEvents:UIControlEventTouchUpInside];
        but.frame = CGRectMake((KscreenWidth-70)/2, 5, 90, 30);
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        [but setTitle:@"刷新订单状态" forState:0];
        [but setTitleColor:SystemGreen forState:0];
        [footer addSubview:but];
        return footer;
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
        return 40;
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
            return cell;
        }
        LegOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderStatusTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadNewDate:self.stateStr]; 
        return cell;
    }
    if (indexPath.section == 1) {
        LegOrderMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderMoneyTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadNewDate:schemeDetail andStatus:self.stateStr];
        return cell;
    }
    LegOrderIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderIntroTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadDate:self.infoArray[indexPath.row]];
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

