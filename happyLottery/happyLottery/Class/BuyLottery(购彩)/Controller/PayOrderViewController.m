//
//  PayOrderViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//
#define KCheckSec 60
#import "PayOrderViewController.h"
#import "TabObaListCell.h"
#import "PaySuccessViewController.h"
#import "WXApi.h"
#import "ChannelModel.h"
#import "JCZQSchemeModel.h"
#import "WBInputPopView.h"
#import "JCZQPlayViewController.h"
#import "JCLQPlayController.h"
#import "AESUtility.h"
#import "BaseViewController.h"
#import "PayOrderYouhunViewController.h"
#import "WebShowViewController.h"
#import "SetPayPWDViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "LotteryPlayViewController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "BaseViewController.h"
#import "UMChongZhiViewController.h"
#import "YinLanPayManage.h"
#import "MyCouponViewController.h"
#define KPayTypeListCell @"PayTypeListCell"

#define KTabObaListCell @"TabObaListCell"
@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,MemberManagerDelegate,UIWebViewDelegate,WBInputPopViewDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
    __weak IBOutlet NSLayoutConstraint *heightTopView;
    ChannelModel *itemModel;
    __weak IBOutlet UIImageView *imgObaComeOn;
    __weak IBOutlet UILabel *labCostInfo;
    
    
    WBInputPopView *passInput;
    YinLanPayManage *yinlanManage;
    __weak IBOutlet UITableView *tabObaList;
    __weak IBOutlet UIView *viewImgContent;
    JCZQSchemeItem * schemeDetail;
    ZLAlertView *itemAlert;
    __weak IBOutlet UILabel *labCanUseYouhuiquan;
    NSTimer *timer;
    NSInteger checkSec;
    
    IBOutlet UIView *viewOBaList;
}
@property (strong, nonatomic) IBOutlet UIView *viewOPaComeOn;
@property (weak, nonatomic) IBOutlet UILabel *labTimer;
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
    heightTopView.constant = NaviHeight;
    checkSec = KCheckSec;
    viewOBaList.frame = [UIScreen mainScreen].bounds;
     viewOBaList.mj_x = KscreenWidth;
    [[UIApplication sharedApplication].keyWindow addSubview:viewOBaList];
   
    [UIView animateWithDuration:0.2 animations:^{
        self->viewOBaList.mj_x = 0;
    }];
    
    [self startTimer];
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
    if ([itemModel.channel isEqualToString:@"UNION"]) {
        [self checkSchemePayState:nil];
    }
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
    
    tabObaList .dataSource =self;
    tabObaList.delegate = self;
    tabObaList.rowHeight = 70;
    [tabObaList registerNib:[UINib nibWithNibName:KTabObaListCell bundle:nil] forCellReuseIdentifier:KTabObaListCell];
    tabObaList.tableFooterView = [UIView new];
    tabObaList.sectionFooterHeight = 1;
    [tabObaList reloadData];
    
}

-(void)navigationBackToLastPageitem{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认退出支付？你可在投注信息里对此订单继续支付？"];
    itemAlert  = alert;
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self->viewOBaList.mj_x = -KscreenWidth;
                [self->viewOBaList removeFromSuperview ];
                [self->timer invalidate];
            }];
        });

        for (BaseViewController *baseVC in self.navigationController.viewControllers) {
            if ([baseVC isKindOfClass:[JCLQPlayController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return ;
            }
            if ([baseVC isKindOfClass: [JCZQPlayViewController class]]) {
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
            } if ([baseVC isKindOfClass: [SSQPlayViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
//    [[UIApplication sharedApplication].keyWindow addSubview:alert];


    [alert showAlertWithSender:(UIViewController *)[UIApplication sharedApplication].keyWindow];
    
}

#pragma LotteryManagerDelegate

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tabObaList) {
        return 4;
    }
    return channelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tabObaList) {
        TabObaListCell *cell = [tableView dequeueReusableCellWithIdentifier:KTabObaListCell];
        cell.selectionStyle = 0;
        return cell;
    }else{
        PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPayTypeListCell];
        [cell loadDataWithModel:channelList[indexPath.row]];
        return cell;
    }

    
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
    paySuccessVC.schemetype = self.schemetype;
    if(([self.cashPayMemt.lotteryName isEqualToString:@"竞彩足球"] ||[self.cashPayMemt.lotteryName isEqualToString:@"竞彩篮球"]) && self.cashPayMemt.costType == CostTypeCASH && self.cashPayMemt.subscribed > 10 && self.isYouhua == NO){
        paySuccessVC.isShowFaDan = YES;
    }else{
        paySuccessVC.isShowFaDan = NO;
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YuCeSchemeCreateViewController class]]||[controller isKindOfClass:[UMChongZhiViewController class]]) {
            paySuccessVC.isShowFaDan = NO;
        }
    }
    paySuccessVC.lotteryName = self.cashPayMemt.lotteryName;
    paySuccessVC.schemeNO = self.cashPayMemt.schemeNo;
    paySuccessVC.isMoni = self.cashPayMemt.costType == CostTypeSCORE;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth , 1)];
    lab.backgroundColor = RGBCOLOR(230, 230, 230);
    
    return lab;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(void)gotSchemeCashPayment:(BOOL)isSuccess errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (isSuccess) {
        [self showObaComeView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self paySuccess];
        });
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
    
    for (NSInteger i =0  ; i < infoArray.count ; i ++) {
        NSDictionary *itemDic = infoArray[i];
        ChannelModel *model = [[ChannelModel alloc]initWith:itemDic];
        if ([model.channelValue boolValue] == YES || [model.channelValue isEqualToString:@"open"]) {
            [channelList addObject:model];
        }
    }
    self.viewPayList.constant = channelList.count * self.tabPayTypeList.rowHeight;
    [self.tabPayTypeList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tabObaList ) {
        MJWeakSelf
        [UIView animateWithDuration:0.2 animations:^{
             self->checkSec  = KCheckSec;
            weakSelf.labTimer.text = @"60";
            self->viewOBaList.mj_x = -KscreenWidth;
            [self->viewOBaList removeFromSuperview];
            [self->timer invalidate];
            
        }];
        
        return;
    }
    for (ChannelModel *model in channelList) {
        model.isSelect = NO;
    }
    channelList[indexPath.row].isSelect = YES;
    [self.tabPayTypeList reloadData];
}

-(void)rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (success) {
        if ([itemModel.channel isEqualToString:@"SDALI"]) {
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"qrCode"]]]];
        }else if ([itemModel.channel isEqualToString:@"WFTWX"] || [itemModel.channel isEqualToString:@"WFTWX_HC"]){
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"payInfo"]]]];
        }else if ([itemModel.channel isEqualToString:@"UNION"]){
            [self actionYinLianChongZhi:payInfo[@"tn"]];
        }else if ([itemModel.channel isEqualToString:@"YUN_WX_XCX"]) {
//            orderNO =payInfo[@"orderNo"];
            NSDictionary * itemDic = [Utility objFromJson:payInfo[@"payInfo"]];
            NSString *original_id = itemDic[@"original_id"];
            NSString *app_id = itemDic[@"app_id"];
            NSString *prepay_id = itemDic[@"prepay_id"];
            if (original_id == nil || app_id == nil || prepay_id == nil) {
                [self showPromptText:@"充值失败" hideAfterDelay:2];
                return;
            }
            [self sendReqAppId:app_id prepayId:prepay_id orginalId:original_id];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
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
        MyCouponViewController *MyCoupon = [[MyCouponViewController alloc]init];
        MyCoupon.fromZf = YES;
        [self.navigationController pushViewController:MyCoupon animated:YES];
        return;
    }else {
        PayOrderYouhunViewController *youhuanquanVC = [[PayOrderYouhunViewController alloc]init];
        youhuanquanVC.payOrderVC = self;
        youhuanquanVC.couponList = self.couponList;
        [self.navigationController pushViewController:youhuanquanVC animated:YES];
    }
   
}
- (IBAction)showRuler:(UIButton *)sender {
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tbz_useragreement" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"用户服务协议";
    [self.navigationController pushViewController:webShow animated:YES];
}

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

-(void)actionTimeUpdate{
    if (checkSec > 0) {
        checkSec --;
        self.labTimer.text = [NSString stringWithFormat:@"%ld",checkSec];
    }else{
        checkSec = KCheckSec;
        [timer invalidate];
        self.labTimer.text = [NSString stringWithFormat:@"%ld",checkSec];
        [UIView animateWithDuration:0.2 animations:^{
            self->viewOBaList.mj_x = -KscreenWidth;
            [self->viewOBaList removeFromSuperview];
            [self->itemAlert hidenAlert];
            
        }];
    }
}

-(void)startTimer{
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimeUpdate) userInfo:nil repeats:YES ];
}

- (void)navigationBackToLastPage{
    viewOBaList.mj_x = -KscreenWidth;
    [[UIApplication sharedApplication].keyWindow addSubview:viewOBaList];
    [UIView animateWithDuration:0.3 animations:^{
        self->viewOBaList.mj_x = 0;
        [self startTimer];
    }];
}

- (IBAction)actionBack:(id)sender {
    [self navigationBackToLastPageitem];
}

-(void)showObaComeView{
    _viewOPaComeOn.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:_viewOPaComeOn];
    
    NSArray *images = @[[UIImage imageNamed:@"oba0.png"],[UIImage imageNamed:@"oba1.png"]];
    
    imgObaComeOn.frame = CGRectMake(320/2-117/2, 150, 117, 120);
    viewImgContent.layer.cornerRadius = 8;
    viewImgContent.layer.masksToBounds = YES;
    imgObaComeOn.animationImages = images;  // 设置动画数组
    
    imgObaComeOn.animationDuration = 0.5f;  // 动画播放时间
    
    [imgObaComeOn startAnimating];          // 开始动画
    MJWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.viewOPaComeOn removeFromSuperview];
    });
}



@end
