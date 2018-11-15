//
//  PayOrderLegViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PayOrderLegViewController.h"
#import "TabObaListCell.h"
#import "LegWordModel.h"
#import "JCZQPlayViewController.h"
#import "JCLQPlayController.h"
#import "AESUtility.h"
#import "PayOrderYouhunViewController.h"
#import "LotteryPlayViewController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "MyCouponViewController.h"
#import "LegSelectViewController.h"
#import "WebShowViewController.h"
#import "LegRechargeOrderViewController.h"
#import "LegOrderDetailViewController.h"
#import "PostboyAccountModel.h"
#import "PaySuccessViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "ZhuiHaoInfoViewController.h"
#import "SetPayPWDViewController.h"
#import "WBInputPopView.h"
#define KPayTypeListCell @"PayTypeListCell"

#define KTabObaListCell @"TabObaListCell"
@interface PayOrderLegViewController ()<LotteryManagerDelegate,MemberManagerDelegate,PostboyManagerDelegate,SelectModelDelegate,WBInputPopViewDelegate>
{
    LotteryShopDto* selectShopModel;
    
    __weak IBOutlet UILabel *labCostInfo;
    
    __weak IBOutlet NSLayoutConstraint *topViewCons;
    __weak IBOutlet UILabel *selectLegLab;
    
    ZLAlertView *itemAlert;
    __weak IBOutlet UILabel *labCanUseYouhuiquan;
    __weak IBOutlet UIButton *rechargeBtn;
    __weak IBOutlet UILabel *lotteryNameLab;
    
    __weak IBOutlet UIButton *btnSelected;
    WBInputPopView *passInput;
    __weak IBOutlet NSLayoutConstraint *youHuiHeight;
}

@property(assign,nonatomic)BOOL isShowOba;
@property (weak, nonatomic) IBOutlet UIView *youHuiQuanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;
@property (weak, nonatomic) IBOutlet UIView *payTypeView;
@property (weak, nonatomic) IBOutlet UILabel *labOrderCost;
@property (weak, nonatomic) IBOutlet UILabel *labRealCost;
@property (weak, nonatomic) IBOutlet UILabel *labZheKou;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;

@property(strong,nonatomic)NSMutableArray <Coupon *> *couponList;
@property (weak, nonatomic) IBOutlet UILabel *sendBalanceLab;
@property (nonatomic,strong)PostboyAccountModel *curModel;
@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;
@property(nonatomic,strong)NSString *youHuiZhi;

@end

@implementation PayOrderLegViewController


/**
     iphoneX 界面适配
     显示明细：彩票店出票钱数+跑腿费（选中的快递小哥跑腿费，无选中默认为0）
     合计金额 = 明细金额和
     优惠券抵扣（无优惠券，有优惠券）
     彩金抵扣：方案使用彩金情况，优先使用彩金
     实付金额：合计-优惠券-彩金
     支付方式：已选快递小哥，显示快递小哥信息，否则选默认文字
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    topViewCons.constant = NaviHeight;
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 8;
    if (self.schemetype == SchemeTypeZhuihao) { //追号不能使用优惠券
        youHuiHeight.constant = 0;
        _youHuiQuanView.hidden = YES;
    } else {
        youHuiHeight.constant = 61;
        _youHuiQuanView.hidden = NO;
    }
    if ([self isIphoneX]) {
        self.bottomHeightCons.constant = 50+34;
    }else{
        self.bottomHeightCons.constant = 50;
    }
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // 莫名其妙  contentOffset.y 成-64了
    }
    self.title = @"预约支付";
    lotteryNameLab.text = self.lotteryName;
    UITapGestureRecognizer *youHuiViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionToYouHuiQuan)];
    [self.youHuiQuanView addGestureRecognizer:youHuiViewTapGestureRecognizer];
    
    UITapGestureRecognizer *legListViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionToSelectLeg)];
    [self.payTypeView addGestureRecognizer:legListViewTapGestureRecognizer];
    
    self.memberMan.delegate = self;
    
    self.lotteryMan.delegate = self;
    
    self.postboyMan.delegate = self;
    self.couponList = [NSMutableArray arrayWithCapacity:0];

    
    [self.memberMan getMemberByCardCode:@{@"cardCode":self.curUser.cardCode}];
    
    [self showLoadingText:@"正在提交订单"];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showCoupon];
}


- (void)alreadySelectModel:(PostboyAccountModel *)selectModel{
    self.curModel = selectModel;
    [self upDateLegInfo:self.curModel];
}

- (void)upDateLegInfo:(PostboyAccountModel *)postModel {
    if (postModel != nil) {
        selectLegLab.text = [NSString stringWithFormat:@"%@代付(余额 %.2f)",postModel.postboyName,[postModel.totalBalance doubleValue]];
        if (postModel.cost.length == 0) {
            labCostInfo.text = [NSString stringWithFormat:@"明细：彩票店出票%.2f + 跑腿费%@元",self.subscribed,@"0"];
        }
        else {
            labCostInfo.text = [NSString stringWithFormat:@"明细：彩票店出票%.2f + 跑腿费%@元",self.subscribed,postModel.cost];
        }
        if (([postModel.totalBalance doubleValue] - [self.labRealCost.text doubleValue]) >= 0) {
            [rechargeBtn setTitle:@"确认支付" forState:0];
        }else {
            [rechargeBtn setTitle:@"转账给代买小哥" forState:0];
        }
        rechargeBtn.userInteractionEnabled=YES;
        rechargeBtn.alpha=1.0f;
    }else {
        selectLegLab.text = @"请选择代买小哥代付";
        labCostInfo.text = [NSString stringWithFormat:@"明细：彩票店出票%.2f + 跑腿费%@元",self.subscribed,@"0"];
        rechargeBtn.userInteractionEnabled=NO;
        rechargeBtn.alpha=0.4f;
    }
}

-(void )recentPostboyAccountdelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self hideLoadingView];
    [self reloadLegInfo:param andSuccess:success errorMsg:msg];
}

- (void)reloadLegInfo:(NSDictionary *)param andSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        [self upDateLegInfo:nil];
        self.curModel = nil;
        return;
    }
    if (param != nil) {
        PostboyAccountModel *model = [[PostboyAccountModel alloc]initWith:param];
        [self upDateLegInfo:model];
        self.curModel = model;
    } else {
        [self upDateLegInfo:nil];
        self.curModel = nil;
    }
}

-(void )getMemberPostboyAccountdelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self reloadLegInfo:param andSuccess:success errorMsg:msg];
}


/**
 获取可用优惠券
 
 @param success 返回成功
 @param payInfo 优惠券信息
 @param msg 错误信息描述
 */
-(void)gotAvailableCoupon:(BOOL)success andPayInfo:(NSArray *)payInfo errorMsg:(NSString *)msg{
    //请求小哥信息
    ///
    if (self.schemeNo == nil) {
        [self.postboyMan recentPostboyAccount:@{@"cardCode":self.curUser.cardCode}];
    }else {
        [self.postboyMan getMemberPostboyAccount:@{@"cardCode":self.curUser.cardCode,@"postboyId":self.postBoyId}];
    }
    [self hideLoadingView];
    if (success == NO || payInfo == nil ) {
        [self showPromptText:msg hideAfterDelay:1.7];
        labCanUseYouhuiquan.text = @"暂无可用优惠券";
        return;
    }
    if (payInfo.count ==0) {
         labCanUseYouhuiquan.text = @"暂无可用优惠券";
    }else{
         labCanUseYouhuiquan.text = [NSString stringWithFormat:@"%lu张可用优惠券",(unsigned long)payInfo.count];
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

-(void)showCoupon{
    if(self.couponList.count == 0){
        labCanUseYouhuiquan.text = [NSString stringWithFormat:@"暂无可用优惠券"];
        self.labZheKou.text = [NSString stringWithFormat:@"-0.00 元"];
        self.labZheKou.textColor = SystemGray;
        //彩金金额大于订单金额，彩金抵扣显示订单金额
         [self MoneyLabSetNotWithYouHui];
    }else {
        if (self.curSelectCoupon != nil) {
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"￥%@元优惠券",self.curSelectCoupon.deduction];
            self.labZheKou.text = [NSString stringWithFormat:@"-%.2f 元",[self.curSelectCoupon.deduction doubleValue]];
            self.labZheKou.textColor = SystemRed;
            [self MoneyLabSetWithYouHui];
        }else{
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"%lu张可用优惠券",(unsigned long)self.couponList.count];
            self.labZheKou.text = [NSString stringWithFormat:@"-0.00 元"];
            self.labZheKou.textColor = SystemGray;
            [self MoneyLabSetNotWithYouHui];
        }
    }
}

- (void)MoneyLabSetNotWithYouHui{
    if (self.subscribed <= [self.curUser.sendBalance doubleValue]) {
        self.sendBalanceLab.text = [NSString stringWithFormat:@"%.2f",self.subscribed];
    } else {
        self.sendBalanceLab.text = [NSString stringWithFormat:@"%.2f",[self.curUser.sendBalance doubleValue]];
    }
    self.labRealCost.text = [NSString stringWithFormat:@"%.2f",self.subscribed - [self.sendBalanceLab.text doubleValue]];
}

- (void)MoneyLabSetWithYouHui{
    //有优惠券，所需彩金  订单金额-优惠券
    double banlanceLab = self.subscribed-[self.curSelectCoupon.deduction doubleValue];
    if (banlanceLab <= [self.curUser.sendBalance doubleValue]) {
        self.sendBalanceLab.text =  [NSString stringWithFormat:@"%.2f",banlanceLab];
    } else {
        self.sendBalanceLab.text =  [NSString stringWithFormat:@"%.2f",[self.curUser.sendBalance doubleValue]];
    }
    //实付金额 = 订单金额 - 优惠券金额 - 彩金金额
    self.labRealCost.text = [NSString stringWithFormat:@"%.2f",self.subscribed - [self.curSelectCoupon.deduction doubleValue] - [self.sendBalanceLab.text doubleValue]];
}

/**
 根据当前卡号，从服务器请求用户信息
 */
-(void)gotMemberByCardCode:(NSDictionary *)userInfo errorMsg:(NSString *)msg{
    User *user = [[User alloc]initWith:userInfo];
    self.curUser.balance = user.balance;
    self.curUser.sendBalance = user.sendBalance;
    self.curUser.score = user.score;
    self.labOrderCost.text = [NSString stringWithFormat:@"%.2f",self.subscribed];
    if (self.schemetype == SchemeTypeZhuihao) {
        self.curSelectCoupon = nil;
        if (self.schemeNo == nil) {
            [self.postboyMan recentPostboyAccount:@{@"cardCode":self.curUser.cardCode}];
        }else {
            [self.postboyMan getMemberPostboyAccount:@{@"cardCode":self.curUser.cardCode,@"postboyId":self.postBoyId}];
        }
    }else {
        [self.memberMan getAvailableCoupon:@{@"cardCode":self.curUser.cardCode,@"amount":
                                                 @(self.subscribed)
                                             }];
        [self MoneyLabSetWithYouHui];
    }
}



#pragma LotteryManagerDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NSNotificationapplicationWillEnterForeground" object:nil];
}

- (void)actionToYouHuiQuan {
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

- (void)actionToSelectLeg {
    if (self.schemeNo == nil) {
        LegSelectViewController *legSelectVC = [[LegSelectViewController alloc]init];
        legSelectVC.delegate = self;
        legSelectVC.titleName = @"选择代买小哥";
        legSelectVC.curModel = self.curModel;
        legSelectVC.realCost = self.labRealCost.text;
        [self.navigationController pushViewController:legSelectVC animated:YES];
    }
    else {
       [self showPromptText:@"订单已与此小哥进行绑定，\n如更改小哥请重新提交订单" hideAfterDelay:1.7];
    }
}

- (IBAction)actionToAgree:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)showRuler:(UIButton *)sender {
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"postboy_agreement" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"代买服务协议";
    [self.navigationController pushViewController:webShow animated:YES];
}


/**
 schemeNo  是否为空  不为空  如果余额足  直接支付 否则跳入转账支付页面
                    为空   发送方案 领取方案号  如果余额足  直接支付 否则跳入转账支付页面
 @param sender sender description
 */
- (IBAction)actionToRechage:(id)sender {
    if (!btnSelected.selected) {
        [self showPromptViewWithText:@"请选择同意《代跑腿服务协议》" hideAfter:1.7];
        return;
    }
    if (self.schemeNo == nil) {
        if (self.schemetype == SchemeTypeZhuihao) {
            if ([rechargeBtn.titleLabel.text isEqualToString:@"转账给代买小哥"]) {
                [self showPromptViewWithText:@"追号方案仅支持小哥余额支付" hideAfter:1.7];
                return;
            }
            //免密支付验证
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
            [self rechargeZhuiHao];  //追号支付
           
        } else if(self.schemetype == SchemeTypeGenDan){
            if ([rechargeBtn.titleLabel.text isEqualToString:@"转账给代买小哥"] &&![_curModel.overline boolValue]) {
                [self showPromptViewWithText:@"该小哥已离线，请选择其他小哥转账" hideAfter:1.7];
                return;
            }
            NSDictionary *paraDic= @{@"schemeNo":self.diction[@"schemeNo"], @"cardCode":self.diction[@"cardCode"],@"multiple":self.diction[@"multiple"],@"postboyId":self.curModel._id};
            [self.lotteryMan followScheme:paraDic];
        } else {
            if ([rechargeBtn.titleLabel.text isEqualToString:@"转账给代买小哥"] && ![_curModel.overline boolValue]) {
                [self showPromptViewWithText:@"该小哥已离线，请选择其他小哥转账" hideAfter:1.7];
                return;
            }
            if (self.isYouhua) {
                [self.lotteryMan betLotteryScheme:self.basetransction andBetContentArray:self.contentArray andPostboyId:self.curModel._id];
            } else {
                [self.lotteryMan betLotteryScheme:self.basetransction andPostboyId:self.curModel._id];
            }
        }
    }else {
        if ([rechargeBtn.titleLabel.text isEqualToString:@"转账给代买小哥"] && ![_curModel.overline boolValue]) {
            [self showPromptViewWithText:@"该小哥已离线,不能转账,请重新下单" hideAfter:1.7];
            return;
        }
        [self rechareSchemeWithSchemeNo];
    }
}


//追号
-(void)betedChaseScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (schemeNO == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    ZhuiHaoInfoViewController * betInfoViewCtr = [[ZhuiHaoInfoViewController alloc] initWithNibName:@"ZhuiHaoInfoViewController" bundle:nil];
    betInfoViewCtr.from = YES;
    [self.navigationController pushViewController:betInfoViewCtr animated:YES];
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


-(void)findPayPwd{
    [self forgetPayPwd];
}


-(void)forgetPayPwd{
    SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
    spvc.titleStr = @"忘记支付密码";
    spvc.isForeget = YES;
    [self.navigationController pushViewController:spvc animated:YES];
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if (success == YES) {
        if (self.schemeNo != nil) {
            [self rechargeSchemeByNo:self.schemeNo];
        }else {
            [self rechargeZhuiHao];
        }
        
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (void)rechareSchemeWithSchemeNo{
    if ([rechargeBtn.titleLabel.text isEqualToString:@"确认支付"]) {
        //免密支付验证
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
        [self rechargeSchemeByNo:self.schemeNo];
        return;
    }
    [self hideLoadingView];
    if (self.schemetype != SchemeTypeGenDan) {
        self.schemetype = self.basetransction.schemeType;
    }
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo = self.schemeNo;
    schemeCashModel.subCopies = 1;
    schemeCashModel.couponCode = self.curSelectCoupon.couponCode;
    schemeCashModel.subscribed = self.subscribed;
    NSString *str = [NSString stringWithFormat:@"%.2f",self.subscribed - [self.curSelectCoupon.deduction doubleValue]];
    schemeCashModel.realSubscribed = [str doubleValue]; //实付金额
    LegRechargeOrderViewController *legRechargrVC = [[LegRechargeOrderViewController alloc]init];
    legRechargrVC.postModel = self.curModel;
    legRechargrVC.schemeNo = self.schemeNo;
    legRechargrVC.orderCost = self.labRealCost.text;
    legRechargrVC.cashPayMemt = schemeCashModel;
    legRechargrVC.isYouhua = self.isYouhua;
    legRechargrVC.lotteryName = self.lotteryName;
    legRechargrVC.schemeSource = self.schemeSource;
    [self.navigationController pushViewController:legRechargrVC animated:YES];
}

//购彩
- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    self.schemeNo = schemeNO;
    [self rechareSchemeWithSchemeNo];
}

-(void)followScheme:(NSString *)result errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (result == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    self.schemeNo = result;
    [self rechareSchemeWithSchemeNo];
}



- (void)rechargeSchemeByNo:(NSString *)schemeNo{
    [self.lotteryMan schemeCashPayment:[self getTouzhuParams:self.curSelectCoupon != nil andSchemeNo:schemeNo]];
}


- (void)rechargeZhuiHao {
    if ([self.lotteryName isEqualToString:@"大乐透"]||[self.lotteryName isEqualToString:@"双色球"]) {
        //大乐透追号
        [self.lotteryMan betChaseScheme:(LotteryTransaction *)self.basetransction andPostboyId:self.curModel._id];
    } else if ([self.lotteryName isEqualToString:@"陕西11选5"]) {
        //11选5追号
        [self.lotteryMan betChaseSchemeZhineng:(LotteryTransaction *)self.basetransction andchaseList:self.zhuiArray andpostboyId:self.curModel._id];
    }
}


-(void)gotSchemeCashPayment:(BOOL)isSuccess errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (void)paySuccess
{
    PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc]init];
    paySuccessVC.schemetype = self.schemetype;
    if(([self.lotteryName isEqualToString:@"竞彩足球"] ||[self.lotteryName isEqualToString:@"竞彩篮球"]) && self.subscribed > 10 && self.isYouhua == NO && (self.schemeSource == nil || [self.schemeSource isEqualToString:@"BET"])){
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
    paySuccessVC.schemeNO = self.schemeNo;
//    paySuccessVC.isMoni = self.cashPayMemt.costType == CostTypeSCORE;
    double canjinban= [self.curUser.sendBalance doubleValue] - [self.labRealCost.text doubleValue] ;
    if (canjinban > 0) {
        paySuccessVC.orderCost = [NSString stringWithFormat:@"%.2f", [self.curUser.balance  doubleValue]+ [self.curUser.notCash doubleValue]];
    }else{
        paySuccessVC.orderCost = [NSString stringWithFormat:@"%.2f",canjinban + [self.curUser.balance  doubleValue]+ [self.curUser.notCash doubleValue]];
    }
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(NSDictionary *)getTouzhuParams:(BOOL)isCoupon andSchemeNo:(NSString *)schemeNo{
    //实付金额 = 订单金额 - 优惠券金额
    NSString *str = [NSString stringWithFormat:@"%.2f",self.subscribed - [self.curSelectCoupon.deduction doubleValue]];
    if (isCoupon) {
        return @{@"cardCode":self.curUser.cardCode,
                 @"schemeNo":schemeNo,
                 @"subCopies":@(1),
                 @"subscribed":@(self.subscribed),
                 @"realSubscribed":str,
                 @"isSponsor":@(true),
                 @"couponCode":self.curSelectCoupon.couponCode
                 };
    }else{
        return @{@"cardCode":self.curUser.cardCode,
                 @"schemeNo":schemeNo,
                 @"subCopies":@(1),
                 @"subscribed":@(self.subscribed),
                 @"realSubscribed":str,
                 @"isSponsor":@(true)
                 };
    }
}


@end
