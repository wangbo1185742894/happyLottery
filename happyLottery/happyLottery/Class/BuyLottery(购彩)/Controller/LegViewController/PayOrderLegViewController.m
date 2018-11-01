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

#define KPayTypeListCell @"PayTypeListCell"

#define KTabObaListCell @"TabObaListCell"
@interface PayOrderLegViewController ()<LotteryManagerDelegate,MemberManagerDelegate>
{
    LotteryShopDto* selectShopModel;
    
    __weak IBOutlet UILabel *labCostInfo;
    
    __weak IBOutlet NSLayoutConstraint *topViewCons;
    __weak IBOutlet UILabel *selectLegLab;
    
    ZLAlertView *itemAlert;
    __weak IBOutlet UILabel *labCanUseYouhuiquan;
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
    if ([self isIphoneX]) {
        self.bottomHeightCons.constant = 50+34;
    }else{
        self.bottomHeightCons.constant = 50;
    }
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // 莫名其妙  contentOffset.y 成-64了
    }
    self.title = @"预约支付";
    
    UITapGestureRecognizer *youHuiViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionToYouHuiQuan)];
    [self.youHuiQuanView addGestureRecognizer:youHuiViewTapGestureRecognizer];
    
    UITapGestureRecognizer *legListViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionToSelectLeg)];
    [self.payTypeView addGestureRecognizer:legListViewTapGestureRecognizer];
    
    self.memberMan.delegate = self;
    
    self.lotteryMan.delegate = self;
    
   
    self.couponList = [NSMutableArray arrayWithCapacity:0];
    
    //请求小哥信息
    ///
    labCostInfo.text = [NSString stringWithFormat:@"明细：彩票店出票%.2f + 跑腿费%@元",self.cashPayMemt.subscribed,@"0"];
    ///
    
    [self.memberMan getMemberByCardCode:@{@"cardCode":self.curUser.cardCode}];
    
    [self showLoadingText:@"正在提交订单"];
    
    [self.memberMan getAvailableCoupon:@{@"cardCode":self.curUser.cardCode,@"amount":@(self.cashPayMemt.realSubscribed)}];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showCoupon];
}


/**
 获取可用优惠券
 
 @param success 返回成功
 @param payInfo 优惠券信息
 @param msg 错误信息描述
 */
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

-(void)showCoupon{
    if(self.couponList.count == 0){
        labCanUseYouhuiquan.text = [NSString stringWithFormat:@"暂无可用优惠券"];
        self.labZheKou.text = [NSString stringWithFormat:@"-0.00 元"];
        self.labZheKou.textColor = SystemGray;
        self.labRealCost.text = [NSString stringWithFormat:@"%.2f",self.cashPayMemt.realSubscribed - [self.curUser.sendBalance doubleValue]] ;
    }else {
        if (self.curSelectCoupon != nil) {
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"￥%@元优惠券",self.curSelectCoupon.deduction];
            self.labZheKou.text = [NSString stringWithFormat:@"-%.2f 元",[self.curSelectCoupon.deduction doubleValue]];
            self.labZheKou.textColor = SystemRed;
            self.labRealCost.text = [NSString stringWithFormat:@"%.2f",self.cashPayMemt.realSubscribed - [self.curSelectCoupon.deduction doubleValue] - [self.curUser.sendBalance doubleValue]] ;
        }else{
            labCanUseYouhuiquan.text = [NSString stringWithFormat:@"%ld张可用优惠券",self.couponList.count];
            self.labZheKou.text = [NSString stringWithFormat:@"-0.00 元"];
            self.labZheKou.textColor = SystemGray;
            self.labRealCost.text = [NSString stringWithFormat:@"%.2f",self.cashPayMemt.realSubscribed - [self.curUser.sendBalance doubleValue]] ;
        }
    }
}


/**
 根据当前卡号，从服务器请求用户信息
 */
-(void)gotMemberByCardCode:(NSDictionary *)userInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
    User *user = [[User alloc]initWith:userInfo];
    self.curUser.balance = user.balance;
    self.curUser.sendBalance = user.sendBalance;
    self.curUser.score = user.score;
    self.sendBalanceLab.text = [NSString stringWithFormat:@"-%.2f 元",[self.curUser.sendBalance doubleValue]];
    self.labOrderCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed];
    self.labRealCost.text = [NSString stringWithFormat:@"%.2f 元",self.cashPayMemt.realSubscribed - [self.curSelectCoupon.deduction doubleValue] - [self.curUser.sendBalance doubleValue]] ;
    
}

-(void)navigationBackToLastPageitem{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"确认退出支付？你可在投注信息里对此订单继续支付？"];
    itemAlert  = alert;
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        for (BaseViewController *baseVC in self.navigationController.viewControllers) {
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
            } if ([baseVC isKindOfClass: [SSQPlayViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                return;
            }
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert showAlertWithSender:(UIViewController *)[UIApplication sharedApplication].keyWindow];
    
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
    LegSelectViewController *legSelectVC = [[LegSelectViewController alloc]init];
    legSelectVC.titleName = @"选择代买小哥";
    [self.navigationController pushViewController:legSelectVC animated:YES];
}

- (IBAction)showRuler:(UIButton *)sender {
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tbz_useragreement" ofType:@"html"]];
    WebShowViewController *webShow = [[WebShowViewController alloc]init];
    webShow.pageUrl = pathUrl;
    webShow.title = @"用户服务协议";
    [self.navigationController pushViewController:webShow animated:YES];
}

- (IBAction)actionToRechage:(id)sender {
    LegRechargeOrderViewController *legRechargrVC = [[LegRechargeOrderViewController alloc]init];
    legRechargrVC.orderCost = self.labRealCost.text;
    [self.navigationController pushViewController:legRechargrVC animated:YES];
}


- (void)navigationBackToLastPage{
    [self navigationBackToLastPageitem];
}

@end
