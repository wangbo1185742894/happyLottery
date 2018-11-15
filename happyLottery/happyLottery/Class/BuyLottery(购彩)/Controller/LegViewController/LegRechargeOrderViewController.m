//
//  TopUpsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LegRechargeOrderViewController.h"
#import "WXApi.h"
#import "WebShowViewController.h"
#import "ChongZhiRulePopView.h"
#import "DiscoverViewController.h"
#import "ZhiFubaoWeixinErcodeController.h"
#import "YinLanPayManage.h"
#import "PaySuccessViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "UMChongZhiViewController.h"
#import "JCLQPlayController.h"
#import "JCZQPlayViewController.h"
#import "LotteryPlayViewController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "FollowSendViewController.h"
#import "OffLineView.h"
#define KPayTypeListCell @"PayTypeListCell"

@interface LegRechargeOrderViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,UITextFieldDelegate,UIWebViewDelegate,ChongZhiRulePopViewDelegate,OffLineViewDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
    ChannelModel *itemModel;
    NSMutableArray <RechargeModel *> *rechList;
    YinLanPayManage * yinlanManage;
    RechargeModel *selectRech;
    NSString *orderNO;
    ZLAlertView *itemAlert;
    OffLineView *offLineView;
    NSString *dateStr;
}
@property (weak, nonatomic) IBOutlet UILabel *realCost;
@property (weak, nonatomic) IBOutlet UILabel *legYueE;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labBanlence;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITableView *tabChannelList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabPayListHeight;
@property (weak, nonatomic) IBOutlet UIWebView *payWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;
@property (weak, nonatomic) IBOutlet UILabel *infoAletLab;
@property(nonatomic,strong)NSString *aliPayMinBouns;
@end

@implementation LegRechargeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aliPayMinBouns = @"0";
    self.title = @"转账";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkSchemePayState:) name:@"UPPaymentControlFinishNotification" object:nil];
    rechList = [NSMutableArray arrayWithCapacity:0];
    self.viewControllerNo = @"A105";
    self.payWebView.delegate = self;
    self.memberMan.delegate = self;
    self.lotteryMan.delegate =self;
    self.labBanlence.text = [NSString stringWithFormat:@"%.2f元",[self.orderCost doubleValue]];
    _legYueE.text = [NSString stringWithFormat:@"%.2f元",[self.postModel.totalBalance doubleValue]];
    _realCost.text = [NSString stringWithFormat:@"%.2f元",[self.orderCost doubleValue] - [self.postModel.totalBalance doubleValue]];
    [self setTableView];
    if ([self isIphoneX]) {
        self.consHeight.constant = 50+34;
    }else{
        self.consHeight.constant = 50;
    }
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    [self getListByChannel];
    [self.lotteryMan getDeadLine:@{@"schemeNo":self.schemeNo}];
    [self.lotteryMan getCommonSetValue:@{@"typeCode":@"recharge",@"commonCode":@"hawkeye_ali"}];
}


- (void)getDeadLineDelegate:(NSString *)resultStr  errorMsg:(NSString *)msg{
    if (resultStr != nil) {
        dateStr = resultStr;
        self.infoAletLab.text = [NSString stringWithFormat:@"%@已接单，请在%@前完成支付", self.postModel.postboyName,[dateStr substringWithRange:NSMakeRange(5, 11)]];
    } else {
        self.infoAletLab.text = [NSString stringWithFormat:@"%@已接单，请尽快支付", self.postModel.postboyName];
    }
}

-(void)gotCommonSetValue:(NSString *)strUrl{
    if (strUrl == nil) {
        self.aliPayMinBouns = @"0";
    }else {
        self.aliPayMinBouns = strUrl;
    }
}

-(void)setTableView{
    self.tabChannelList.dataSource =self;
    self.tabChannelList.delegate = self;
    self.tabChannelList.rowHeight = 60;
    [self.tabChannelList registerClass:[PayTypeListCell class] forCellReuseIdentifier:KPayTypeListCell];
}

-(void)rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg{
    
    if (success) {
        if ([itemModel.channel isEqualToString:@"SDALI"]) {
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"qrCode"]]]];
            orderNO = payInfo[@"orderNo"];
        }else if ([itemModel.channel isEqualToString:@"WFTWX"] || [itemModel.channel isEqualToString:@"HAWKEYE_ALI"]){
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"payInfo"]]]];
            orderNO = payInfo[@"orderNo"];
        }else if([itemModel.channel isEqualToString:@"UNION"]){
            orderNO = payInfo[@"orderNo"];
            [self  actionYinLianChongZhi: payInfo[@"tn"]];
        }else if ([itemModel.channel isEqualToString:@"YUN_WX_XCX"]) {
            orderNO =payInfo[@"orderNo"];
            NSDictionary * itemDic = [Utility objFromJson:payInfo[@"payInfo"]];
            NSString *original_id = itemDic[@"original_id"];
            NSString *app_id = itemDic[@"app_id"];
            NSString *prepay_id = itemDic[@"prepay_id"];
            if (original_id == nil || app_id == nil || prepay_id == nil) {
                [self showPromptText:@"充值失败" hideAfterDelay:2];
                return;
            }
            [self sendReqAppId:app_id prepayId:prepay_id orginalId:original_id];
        }else if([itemModel.channel isEqualToString:@"SDWX"]){
            [self hideLoadingView];
            orderNO = payInfo;
            ZhiFubaoWeixinErcodeController * zhifubaoVC = [[ZhiFubaoWeixinErcodeController alloc]init];
            zhifubaoVC.orderNo = orderNO;
            zhifubaoVC.chongzhitype = @"weixin";
            [self.navigationController pushViewController:zhifubaoVC animated:YES];
        }else if ([itemModel.channel isEqualToString:@"OFFLINE"]){
            [self hideLoadingView];
            orderNO = payInfo;
            offLineView = [[OffLineView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            offLineView.orderNo = orderNO;
            offLineView.weiXianCode = self.postModel.wechatId;
            offLineView.telephone = self.postModel.mobile;
            offLineView.delegate = self;
            offLineView.liShiLsb.text =  @"注意：1.在向小哥转账时，将此充值订单号一并发给小哥\n2.在小哥未确认订单前，建议不要关闭此页面，以免影响发单";
            [offLineView loadDate];
            [self.view addSubview:offLineView];
        }else if ([itemModel.channel isEqualToString:@"BILLS_ALI"]){
            NSString *urlStr = [NSString stringWithFormat:@"alipays://platformapi/startapp?saId=10000007&qrcode=%@",payInfo[@"qrCode"]];
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
            orderNO = payInfo[@"orderNo"];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (void)alreadyRechare{
    [self.memberMan queryRecharge:@{@"channel":itemModel.channel, @"orderNo":orderNO}];
}

- (IBAction)memberDetail:(id)sender{
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tbz_recharge" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"会员充值说明";
    [self.navigationController pushViewController:webShow animated:YES];
}


- (IBAction)commitBtnClick:(id)sender {
    [self commitClient];
}
//params - String cardCode 会员卡号, RechargeChannel channel 充值渠道, BigDecimal amounts 充值金额
-(void)commitClient{
 
    NSDictionary *rechargeInfo;
    for (ChannelModel *model in channelList) {
        if (model.isSelect == YES) {
            itemModel= model;
            break;
        }
    }
    if (itemModel == nil) {
        [self showPromptText:@"请选择支付方式" hideAfterDelay:1.7];
        return;
    }
    
    if ([itemModel.channel isEqualToString:@"HAWKEYE_ALI"] ) {
        if ([self.orderCost doubleValue] < [self.aliPayMinBouns doubleValue]) {
            [self showPromptText:[NSString stringWithFormat:@"%@充值最少充%@元",itemModel.channelTitle,self.aliPayMinBouns] hideAfterDelay:1.7];
            return;
        }
    }
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *checkCode = self.realCost.text;
        
      
        rechargeInfo = @{@"cardCode":cardCode,
                          @"channel":itemModel.channel,
                          @"amounts":@([checkCode doubleValue]),
                          @"schemeSub":self.cashPayMemt.submitParaDicScheme,
                          @"postboyId":self.postModel._id
                        };
    } @catch (NSException *exception) {
       return;
    }
    [self showLoadingText:@"正在提交订单"];
    
    if ([itemModel.channel isEqualToString:@"OFFLINE"]) { //线下支付
        [self.memberMan rechargeOffline:rechargeInfo];
    } else {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSchemePayState:) name:@"NSNotificationapplicationWillEnterForeground" object:nil];
        [self.memberMan rechargeSms:rechargeInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取充值方式
-(void)getListByChannel{
    
    [self.lotteryMan listByRechargeChannel:@{@"channelCode":CHANNEL_CODE}];
}

-(void)gotListByRechargeChannel:(NSArray *)infoArray errorMsg:(NSString *)msg{
    channelList = [NSMutableArray arrayWithCapacity:0];
    self.tabChannelList.bounces = NO;
    
    if (infoArray == nil || infoArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7 ];
        self.tabPayListHeight.constant = channelList.count * self.tabChannelList.rowHeight;
        return;
    }
    
    for (NSInteger i = 0 ; i < infoArray.count ; i ++ ) {
        NSDictionary *itemDic = infoArray[i];
        ChannelModel *model = [[ChannelModel alloc]initWith:itemDic];
        if ([model.channelValue boolValue] == YES || [model.channelValue isEqualToString:@"open"]||[model.channelValue isEqualToString:@"open_new"]||[model.channelValue isEqualToString:@"open_"]) {
            [channelList insertObject:model atIndex:0];
         }
    }
    
    self.viewHeight.constant = 420 + channelList.count * 60;

    [channelList firstObject].isSelect = YES;
    self.tabPayListHeight.constant = channelList.count * self.tabChannelList.rowHeight;
    [self.tabChannelList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return channelList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPayTypeListCell];
    [cell chongzhiLoadDataWithModel:channelList[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (ChannelModel *model in channelList) {
        model.isSelect = NO;
    }
    channelList[indexPath.row].isSelect = YES;
    [self.tabChannelList reloadData];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([strUrl hasPrefix:@"alipays"]) {
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay://"]] == YES) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }else{
            [self showPromptText:@"您未安装支付宝客服端，请先安装！" hideAfterDelay:1.7];
        }
    }

    if ([strUrl hasPrefix:@"weixin"]) {
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"weixin://"]] == YES) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (([itemModel.channel isEqualToString:@"UNION"] || [itemModel.channel isEqualToString:@"SDWX"]) && orderNO .length > 0 ) {
        [[NSNotificationCenter defaultCenter ]postNotificationName:@"UPPaymentControlFinishNotification" object:orderNO];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NSNotificationapplicationWillEnterForeground" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NSNotificationapplicationWillEnterForeground" object:nil];
}

-(void)checkSchemePayState:(NSNotification *)notification{

    if (orderNO == nil) {
        [self showPromptText:@"支付失败" hideAfterDelay:1.6];
        return;
    }
    [self showLoadingText:@"正在查询充值结果，请稍等"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.memberMan queryRecharge:@{@"channel":itemModel.channel, @"orderNo":orderNO}];
    });
}

-(void)queryRecharge:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (success == YES) {
        if ([itemModel.channel isEqualToString:@"OFFLINE"]) {
            [offLineView closeView];
        }
        [self showPromptText:@"支付成功" hideAfterDelay:1.7];
        [self paySuccess];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}


- (void)paySuccess
{
    PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc]init];
    paySuccessVC.schemetype = self.schemetype;
    
    if(([self.lotteryName isEqualToString:@"竞彩足球"] ||[self.lotteryName isEqualToString:@"竞彩篮球"]) &&  self.cashPayMemt.subscribed > 10 && self.isYouhua == NO){
        paySuccessVC.isShowFaDan = YES;
    }else{
        paySuccessVC.isShowFaDan = NO;
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YuCeSchemeCreateViewController class]]||[controller isKindOfClass:[UMChongZhiViewController class]]) {
            paySuccessVC.isShowFaDan = NO;
        }
    }
    paySuccessVC.lotteryName = self.lotteryName;
    paySuccessVC.schemeNO = self.cashPayMemt.schemeNo;
    paySuccessVC.isMoni = self.cashPayMemt.costType == CostTypeSCORE;
//    double canjinban= [self.curUser.sendBalance doubleValue] - self.cashPayMemt.realSubscribed;
//    if (canjinban > 0) {
//        paySuccessVC.orderCost = [NSString stringWithFormat:@"%.2f", [self.curUser.balance  doubleValue]+ [self.curUser.notCash doubleValue]];
//    }else{
//        paySuccessVC.orderCost = [NSString stringWithFormat:@"%.2f",canjinban + [self.curUser.balance  doubleValue]+ [self.curUser.notCash doubleValue]];
//    }
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

//- (void)navigationBackToLastPage{
//
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[DiscoverViewController class]]) {
//            self.tabBarController.selectedIndex = 3;
//            [self.navigationController popViewControllerAnimated:YES];
//            return;
//        }
//    }
//    [super navigationBackToLastPage];
//}

- (void)showPlayRec{
    ChongZhiRulePopView *rulePopView = [[ChongZhiRulePopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    rulePopView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:rulePopView];
}

-(void)actionYinLianChongZhi:(NSString *)orderNo{
    NSString * tn = orderNo;
    if (tn) {
        if (!yinlanManage) {
            yinlanManage = [[YinLanPayManage alloc] init];
        }
        [yinlanManage yanlianPay:tn viewController:self];
    }
}
- (void)showRuleBtnPage{
    
    [self memberDetail:nil];
}


-(void)navigationBackToLastPageitem{
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认退出支付？你可在投注信息里对此订单继续支付？"];
    itemAlert  = alert;
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        for (BaseViewController *baseVC in self.navigationController.viewControllers) {
            if ([baseVC isKindOfClass:[DiscoverViewController class]]) {
                self.tabBarController.selectedIndex = 3;
                [self.navigationController popToViewController:baseVC animated:YES];
                return ;
            }
            if ([baseVC isKindOfClass:[JCLQPlayController class]]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                [self.navigationController popToViewController:baseVC animated:YES];
                return ;
            }
            if ([baseVC isKindOfClass: [JCZQPlayViewController class]]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            if ([baseVC isKindOfClass: [LotteryPlayViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            if ([baseVC isKindOfClass: [DLTPlayViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            if ([baseVC isKindOfClass: [SSQPlayViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            if ([baseVC isKindOfClass:[FollowSendViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return ;
            }
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert showAlertWithSender:(UIViewController *)[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark -----拉起微信支付-----
-(void)sendReqAppId:(NSString *)appId prepayId:(NSString*)prepayId orginalId:(NSString *)orginalId
{
    NSString *path=  [NSString stringWithFormat:@"pages/index/index?appId=%@&prepayId=%@",appId,prepayId];
    //"pages/index/index"+"?appId=" + appId +"&prepayId="+prepayId;
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = orginalId;
    launchMiniProgramReq.path = path;
    launchMiniProgramReq.miniProgramType = 0; //正式版
    [WXApi sendReq:launchMiniProgramReq]; //拉起微信支付
}


- (void)navigationBackToLastPage{
    [self navigationBackToLastPageitem];
}

@end
