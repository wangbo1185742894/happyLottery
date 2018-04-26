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
#import "JCZQSchemeModel.h"
#import "WBInputPopView.h"
#import "AESUtility.h"
#import "PayOrderYouhunViewController.h"
#import "WebShowViewController.h"
#import "SetPayPWDViewController.h"
#define KPayTypeListCell @"PayTypeListCell"
@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,MemberManagerDelegate,UIWebViewDelegate,WBInputPopViewDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
    ChannelModel *itemModel;
    WBInputPopView *passInput;
    JCZQSchemeItem * schemeDetail;
    __weak IBOutlet UILabel *labCanUseYouhuiquan;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *payWebView;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labOrderCost;
@property (weak, nonatomic) IBOutlet UILabel *labRealCost;
@property (weak, nonatomic) IBOutlet UITableView *tabPayTypeList;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhuRule;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectRule;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;
@property (weak, nonatomic) IBOutlet UILabel *labZheKou;

@property (weak, nonatomic) IBOutlet UILabel *labBanlenceInfo;
@property (weak, nonatomic) IBOutlet UIView *viewPaychannalInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightIViewJinE;
@property (weak, nonatomic) IBOutlet UILabel *labYouhuifangan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewPayList;

@property(strong,nonatomic)NSMutableArray <Coupon *> *couponList;

@property (weak, nonatomic) IBOutlet UIView *labScoreInfoContent;

@property (weak, nonatomic) IBOutlet UILabel *labScoreBanlence;
@property (weak, nonatomic) IBOutlet UILabel *labScoreNeed;
@property (weak, nonatomic) IBOutlet UILabel *labScoreBanlenceNum;
@property (weak, nonatomic) IBOutlet UILabel *labSocreNeedNum;

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.viewDisTop.constant = 88;
        self.viewDisBottom.constant = 34;
    }else{
        self.viewDisBottom.constant = 0;
        self.viewDisTop.constant = 64;
    }
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    if (self.cashPayMemt.costType == CostTypeCASH) {
        self.labScoreInfoContent.hidden = YES;
        
    }else{
        self.labScoreInfoContent.hidden = NO;
    }
    
    self.labLotteryName.text = self.cashPayMemt.lotteryName;
    
    self.couponList = [NSMutableArray arrayWithCapacity:0];
    self.title = @"预约支付";
    [self setTableView];
    self.payWebView.delegate = self;
    self.memberMan.delegate = self;
    [self.memberMan getMemberByCardCode:@{@"cardCode":self.curUser.cardCode}];
    [self showLoadingText:@"正在提交订单"];
    self.lotteryMan.delegate = self;
    [self.memberMan getAvailableCoupon:@{@"cardCode":self.curUser.cardCode,@"amount":@(self.cashPayMemt.realSubscribed)}];
    [self getListByChannel];
}

-(void)showCoupon{
    if(self.couponList.count == 0){
        labCanUseYouhuiquan.text = [NSString stringWithFormat:@"暂无可用优惠券"];
        self.labZheKou.text = [NSString stringWithFormat:@"-0.00元"];
        self.labZheKou.textColor = SystemGray;
        self.labRealCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed] ;
    }else {
        if (self.curSelectCoupon != nil) {
            //
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"￥%@元优惠券",self.curSelectCoupon.deduction];
            self.labZheKou.text = [NSString stringWithFormat:@"-%.2f元",[self.curSelectCoupon.deduction doubleValue]];
            self.labZheKou.textColor = SystemRed;
            self.labRealCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed - [self.curSelectCoupon.deduction doubleValue]] ;
        }else{
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"%ld张可用优惠券",self.couponList.count];
            self.labZheKou.text = [NSString stringWithFormat:@"-0.00元"];
            self.labZheKou.textColor = SystemGray;
            self.labRealCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed] ;
        }
    }
    if (self.cashPayMemt.costType == CostTypeCASH) {
        [self.btnTouzhu setTitle:[NSString stringWithFormat:@"确认支付 ￥%.2f",self.cashPayMemt.realSubscribed - [self.curSelectCoupon.deduction doubleValue]] forState:0];
    }else{
        [self.btnTouzhu setTitle:@"预约支付" forState:0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showCoupon];
}

-(void)gotAvailableCoupon:(BOOL)success andPayInfo:(NSArray *)payInfo errorMsg:(NSString *)msg{
    if (success == NO || payInfo == nil ) {
        [self showPromptText:msg hideAfterDelay:1.7];
        labCanUseYouhuiquan.text = @"暂无可用优惠券";
        return;
    }
    if (payInfo.count ==0) {
         labCanUseYouhuiquan.text = @"暂无可用优惠券";
    }else{
         labCanUseYouhuiquan.text = [NSString stringWithFormat:@"%ld张可用优惠券",payInfo.count];
    }
   
    for (NSDictionary *itemDic in payInfo) {
        Coupon *model = [[Coupon alloc]initWith:itemDic];
        [self.couponList addObject:model];
    }
    _curSelectCoupon = [self getMaxCoupon];
    [self showCoupon];
}

-(Coupon *)getMaxCoupon{
    Coupon *curMaxCoupon  = [self.couponList firstObject];
    for (Coupon *model in self.couponList) {
        if ([model.deduction doubleValue] > [curMaxCoupon.deduction doubleValue]) {
            curMaxCoupon = model;
        }else if ([model.deduction doubleValue] == [curMaxCoupon.deduction doubleValue]){
            NSDate *curDate = [Utility dateFromDateStr:curMaxCoupon.invalidTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *mDate = [Utility dateFromDateStr:model.invalidTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            if ([mDate compare:curDate] == -1) {
                curMaxCoupon = model;
            }
        }
    }
    curMaxCoupon.isSelect = YES;
    return curMaxCoupon;
    
}

-(void)gotMemberByCardCode:(NSDictionary *)userInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
    User *user = [[User alloc]initWith:userInfo];
    self.curUser.balance = user.balance;
    self.curUser.sendBalance = user.sendBalance;
    self.curUser.score = user.score;
    
    if (self.cashPayMemt.costType == CostTypeCASH) {
        
        self.labRealCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed - [self.curSelectCoupon.deduction doubleValue]] ;
        self.labOrderCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed] ;
        self.heightIViewJinE.constant = 185;
        self.labYouhuifangan.hidden = NO;
    }else{
        
        self.cashPayMemt.realSubscribed  = self.cashPayMemt.realSubscribed  * 100;
        self.cashPayMemt.subscribed = self.cashPayMemt.subscribed * 100;
        self.labScoreNeed.text = @"订单所需积分";
        self.labScoreBanlence.text = @"剩余积分";
        self.labScoreBanlenceNum.text = [NSString stringWithFormat:@"%@ 积分",self.curUser.score];
        self.labSocreNeedNum.text = [NSString stringWithFormat:@"%.2f 积分",self.cashPayMemt.realSubscribed];
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

-(BOOL)checkPayPassword{

    if(self.curUser.payVerifyType == PayVerifyTypeAlways){
        return YES;
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanOneHundred){
        if (self.cashPayMemt.realSubscribed > 100 ) {
            return YES;
        }else{
            return NO;
        }
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanFiveHundred){
        
        if (self.cashPayMemt.realSubscribed > 500 ) {
            return YES;
        }else{
            return NO;
        }
        
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanThousand){
        if (self.cashPayMemt.realSubscribed > 1000 ) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (void)showPayPopView{
    if (nil == passInput) {
        
        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
    }

    [self.view addSubview:passInput];
    passInput.delegate = self;
    [passInput.txtInput becomeFirstResponder];
    [passInput createBlock:^(NSString *text) {
        
        if (nil == text) {
            [self showPromptText:@"请输入支付密码" hideAfterDelay:2.7];
            return;
        }

        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];
    
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if (success == YES) {
        [self actionPay];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (IBAction)actionTouzhu:(id)sender {
    
    for (ChannelModel *model in channelList) {
        if (model.isSelect == YES) {
            itemModel= model;
            break;
        }
    }

    if (self.cashPayMemt.costType == CostTypeCASH) {
         //先判断是否需要设置支付密码  如果没有设置 先设置支付密码   如果已设置  再判断是否需要输入密码
        if(self.curUser.paypwdSetting == NO) {
            SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
            spvc.titleStr = @"设置支付密码";
            [self.navigationController pushViewController:spvc animated:YES];
            return;
        }else{
            if ([self checkPayPassword]) {
                [self showPayPopView];
                return;
            }
        }
        
       
    }

    [self actionPay];
}

-(void)actionPay{
    [self showLoadingText:@"正在提交订单"];
    if (self.cashPayMemt.costType == CostTypeCASH) {
        
        if (self.curSelectCoupon != nil) {
            self.cashPayMemt.realSubscribed =self.cashPayMemt.subscribed - [self.curSelectCoupon.deduction doubleValue];
        }
        if (![itemModel.channel isEqualToString:@"YUE"]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSchemePayState:) name:@"NSNotificationapplicationWillEnterForeground" object:nil];
            [self commitClient];
            return;
        }
        
        if (self.cashPayMemt.realSubscribed > [self.curUser.balance doubleValue] + [self.curUser.notCash doubleValue] + [self.curUser.sendBalance doubleValue]) {
            [self showPromptText:@"余额不足" hideAfterDelay:1.7];
            return;
        }
        
        [self.lotteryMan schemeCashPayment:[self getTouzhuParams:self.curSelectCoupon != nil]];
    }else{
        if (self.cashPayMemt.realSubscribed > [self.curUser.score integerValue]) {
            [self showPromptText:@"积分不足" hideAfterDelay:1.7];
            return;
        }
        [self.lotteryMan schemeScorePayment:@{@"cardCode":self.cashPayMemt.cardCode,
                                              @"schemeNo":self.cashPayMemt.schemeNo,
                                              @"subCopies":@(self.cashPayMemt.subCopies),
                                              @"subscribed":@(self.cashPayMemt.subscribed),
                                              @"realSubscribed":@(self.cashPayMemt.realSubscribed),
                                              @"isSponsor":@(true)
                                              }];
      
    }
}

-(void)gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"] || [schemeDetail.schemeStatus isEqualToString:@"CANCEL"] || [schemeDetail.schemeStatus isEqualToString:@"REPEAL"]) {
        [self showPromptText:@"支付失败" hideAfterDelay:1.7];
    }else{
        [self paySuccess];
    }
}

-(void)checkSchemePayState:(NSNotification *)notification{
    [self showLoadingText:@"正在查询支付结果，请稍等"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.cashPayMemt.schemeNo}];
    });
}

-(void)paySuccess{
    PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc]init];
    paySuccessVC.lotteryName = self.cashPayMemt.lotteryName;
    paySuccessVC.schemeNO = self.cashPayMemt.schemeNo;
    paySuccessVC.isMoni = self.cashPayMemt.costType == CostTypeSCORE;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(void)gotSchemeCashPayment:(BOOL)isSuccess errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)gotSchemeScorePayment:(BOOL)isSuccess  errorMsg:(NSString *)msg{
    [self hideLoadingView];
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
    model.descValue = [NSString stringWithFormat:@"可用余额为：%@",self.curUser.totalBanlece];
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

-(void)rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg{
    
    if (success) {
        if ([itemModel.channel isEqualToString:@"SDALI"]) {
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"qrCode"]]]];
        }else if ([itemModel.channel isEqualToString:@"WFTWX"]){
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"payInfo"]]]];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

//params - String cardCode 会员卡号, RechargeChannel channel 充值渠道, BigDecimal amounts 充值金额
-(void)commitClient{
    
    NSDictionary *rechargeInfo;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSNumber *checkCode = @([[NSString stringWithFormat:@"%.2f",self.cashPayMemt.realSubscribed] doubleValue]);
        
        for (ChannelModel *model in channelList) {
            if (model.isSelect == YES) {
                itemModel= model;
                break;
            }
        }
        rechargeInfo = @{@"cardCode":cardCode,
                         @"channel":itemModel.channel,
                         @"amounts":checkCode,
                         @"schemeSub":[self getTouzhuParams:self.curSelectCoupon != nil]
                         };
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan rechargeSms:rechargeInfo];
    
}

-(NSDictionary *)getTouzhuParams:(BOOL)isCoupon{
    NSNumber *real = @([[NSString stringWithFormat:@"%.2f",self.cashPayMemt.realSubscribed] doubleValue]);
    if (isCoupon) {
        return @{@"cardCode":self.cashPayMemt.cardCode,
                 @"schemeNo":self.cashPayMemt.schemeNo,
                 @"subCopies":@(self.cashPayMemt.subCopies),
                 @"subscribed":@(self.cashPayMemt.subscribed),
                 @"realSubscribed":real,
                 @"isSponsor":@(true),
                 @"couponCode":self.curSelectCoupon.couponCode
                 };
    }else{
        return @{@"cardCode":self.cashPayMemt.cardCode,
          @"schemeNo":self.cashPayMemt.schemeNo,
          @"subCopies":@(self.cashPayMemt.subCopies),
          @"subscribed":@(self.cashPayMemt.subscribed),
          @"realSubscribed":real,
          @"isSponsor":@(true)
                 };
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([strUrl hasPrefix:@"alipays"] || [strUrl hasPrefix:@"weixin"] ) {
        [[UIApplication sharedApplication] openURL:request.URL];
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NSNotificationapplicationWillEnterForeground" object:nil];
}

-(void)findPayPwd{
    [self forgetPayPwd];
}

- (IBAction)actionShowYouHuiquan:(UIButton *)sender {
    if (self.couponList.count == 0) {
        [self showPromptText:@"暂无可用优惠券" hideAfterDelay:1.7];
        return;
    }
    PayOrderYouhunViewController *youhuanquanVC = [[PayOrderYouhunViewController alloc]init];
    youhuanquanVC.payOrderVC = self;
    youhuanquanVC.couponList = self.couponList;
    [self.navigationController pushViewController:youhuanquanVC animated:YES];
}
- (IBAction)showRuler:(UIButton *)sender {
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tbz_useragreement" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"用户服务协议";
    [self.navigationController pushViewController:webShow animated:YES];
}


@end
