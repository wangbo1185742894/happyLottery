//
//  PayOrderViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PaySuccessViewController.h"
#import "ChannelModel.h"
#define KPayTypeListCell @"PayTypeListCell"
@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,MemberManagerDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
}
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labOrderCost;
@property (weak, nonatomic) IBOutlet UILabel *labBanlance;
@property (weak, nonatomic) IBOutlet UITableView *tabPayTypeList;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhuRule;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectRule;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;
@property (weak, nonatomic) IBOutlet UILabel *labZheKou;
@property (weak, nonatomic) IBOutlet UILabel *labNeedInfo;
@property (weak, nonatomic) IBOutlet UILabel *labBanlenceInfo;
@property (weak, nonatomic) IBOutlet UIView *viewPaychannalInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightIViewJinE;
@property (weak, nonatomic) IBOutlet UILabel *labYouhuifangan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewPayList;

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约支付";
    [self setTableView];
    
    self.memberMan.delegate = self;
    [self.memberMan getMemberByCardCode:@{@"cardCode":self.curUser.cardCode}];
    [self showLoadingText:@"正在提交订单"];
    self.lotteryMan.delegate = self;
    
    [self getListByChannel];
}
-(void)gotMemberByCardCode:(NSDictionary *)userInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
    User *user = [[User alloc]initWith:userInfo];
    self.curUser.balance = user.balance;
    self.curUser.sendBalance = user.sendBalance;
    self.curUser.score = user.score;
    
    if (self.cashPayMemt.costType == CostTypeCASH) {
        self.labBanlance.text = [NSString stringWithFormat:@"%@ 元",self.curUser.balance] ;
        self.labOrderCost.text = [NSString stringWithFormat:@"%ld 元",self.cashPayMemt.realSubscribed] ;
        self.heightIViewJinE.constant = 176;
        self.labYouhuifangan.hidden = NO;
    }else{
        self.cashPayMemt.realSubscribed  = self.cashPayMemt.realSubscribed  * 100;
        self.cashPayMemt.subscribed = self.cashPayMemt.subscribed * 100;
        self.viewPaychannalInfo.hidden = YES;
        self.labNeedInfo.text = @"所需积分";
        self.labBanlenceInfo.text = @"剩余积分";
        self.labYouhuifangan.hidden = YES;
        self.labBanlance.text = [NSString stringWithFormat:@"%@ 积分",self.curUser.score] ;
        self.labOrderCost.text = [NSString stringWithFormat:@"%ld 积分",self.cashPayMemt.realSubscribed] ;
        self.heightIViewJinE.constant = 143;
    }
}

-(void)setTableView{
    self.tabPayTypeList .dataSource =self;
    self.tabPayTypeList.delegate = self;
    self.tabPayTypeList.rowHeight = 60;
    [self.tabPayTypeList registerClass:[PayTypeListCell class] forCellReuseIdentifier:KPayTypeListCell];
}

-(void)navigationBackToLastPage{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认退出支付？你可在投注信息里对此订单继续支付？"];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [alert showAlertWithSender:self];
}

#pragma LotteryManagerDelegate

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return channelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPayTypeListCell];
    [cell loadDataWithModel:channelList[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)actionTouzhu:(id)sender {
    
    
    
    if (self.cashPayMemt.costType == CostTypeCASH) {
        
        if (self.cashPayMemt.realSubscribed > [self.curUser.balance integerValue]) {
            [self showPromptText:@"余额不足" hideAfterDelay:1.7];
            return;
        }
        
        [self.lotteryMan schemeCashPayment:@{@"cardCode":self.cashPayMemt.cardCode,
                                             @"schemeNo":self.cashPayMemt.schemeNo,
                                             @"subCopies":@(self.cashPayMemt.subCopies),
                                             @"subscribed":@(self.cashPayMemt.subscribed),
                                             @"realSubscribed":@(self.cashPayMemt.realSubscribed),
                                             @"isSponsor":@(true)
                                             }];
    }else{
        [self.lotteryMan schemeScorePayment:@{@"cardCode":self.cashPayMemt.cardCode,
                                             @"schemeNo":self.cashPayMemt.schemeNo,
                                             @"subCopies":@(self.cashPayMemt.subCopies),
                                             @"subscribed":@(self.cashPayMemt.subscribed),
                                             @"realSubscribed":@(self.cashPayMemt.realSubscribed),
                                             @"isSponsor":@(true)
                                             }];
        if (self.cashPayMemt.realSubscribed > [self.curUser.score integerValue]) {
            [self showPromptText:@"积分不足" hideAfterDelay:1.7];
            return;
        }
    }
}

-(void)paySuccess{
    PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc]init];
    paySuccessVC.schemeNO = self.cashPayMemt.schemeNo;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(void)gotSchemeCashPayment:(BOOL)isSuccess errorMsg:(NSString *)msg{
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
    
}

-(void)gotSchemeScorePayment:(BOOL)isSuccess  errorMsg:(NSString *)msg{
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}



-(void)getListByChannel{
    
    [self.lotteryMan listByRechargeChannel:@{@"channelCode":CHANNEL_CODE}];
}

-(void)gotListByRechargeChannel:(NSArray *)infoArray errorMsg:(NSString *)msg{
    channelList = [NSMutableArray arrayWithCapacity:0];
    self.tabPayTypeList.bounces = NO;
    ChannelModel *model = [[ChannelModel alloc]init];
    model.channel = @"YUE";
    model.channelTitle = @"余额支付";
    model.channelIcon = @"icon_yue";
    model.isSelect = YES;
    model.descValue = [NSString stringWithFormat:@"可用余额为：%@",self.curUser.balance];
    [channelList addObject:model];
    
    if (infoArray == nil || infoArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7 ];
        [self.tabPayTypeList reloadData];
        self.viewPayList.constant = channelList.count * self.tabPayTypeList.rowHeight;
        return;
    }
    
    for (NSDictionary *itemDic in infoArray) {
        ChannelModel *model = [[ChannelModel alloc]initWith:itemDic];
        if ([model.channelValue boolValue] == YES) {
            [channelList addObject:model];
        }
    }
    self.viewPayList.constant = channelList.count * self.tabPayTypeList.rowHeight;
    [self.tabPayTypeList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (ChannelModel *model in channelList) {
        model.isSelect = NO;
    }
    channelList[indexPath.row].isSelect = YES;
    [self.tabPayTypeList reloadData];
}

@end
