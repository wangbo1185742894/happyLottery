//
//  TopUpsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LegRechargeViewController.h"
#import "WXApi.h"
#import "WebShowViewController.h"
#import "ChongZhiRulePopView.h"
#import "DiscoverViewController.h"
#import "ZhiFubaoWeixinErcodeController.h"
#import "YinLanPayManage.h"
#define KPayTypeListCell @"PayTypeListCell"

@interface LegRechargeViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,UITextFieldDelegate,UIWebViewDelegate,ChongZhiRulePopViewDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
    ChannelModel *itemModel;
    NSMutableArray <RechargeModel *> *rechList;
    YinLanPayManage * yinlanManage;
    RechargeModel *selectRech;
    NSString *orderNO;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labBanlence;
@property (weak, nonatomic) IBOutlet UITextField *txtChongZhiJIne;
@property (weak, nonatomic) IBOutlet UIButton *haveReadBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITableView *tabChannelList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chongZhiSelectItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabPayListHeight;
@property (weak, nonatomic) IBOutlet UIWebView *payWebView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labCaijin;
@property (weak, nonatomic) IBOutlet UIButton *btnChongzhi;
@property(nonatomic,strong)NSString *aliPayMinBouns;
@end

@implementation LegRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aliPayMinBouns = @"0";
    self.title = @"转账";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkSchemePayState:) name:@"UPPaymentControlFinishNotification" object:nil];
    rechList = [NSMutableArray arrayWithCapacity:0];
    [self setRightBarButtonItem];
    self.viewControllerNo = @"A105";
    self.payWebView.delegate = self;
    self.memberMan.delegate = self;
    self.lotteryMan.delegate =self;
    self.labBanlence.text = [NSString stringWithFormat:@"%@元",self.curUser.totalBanlece];
    [self setTableView];
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    self.txtChongZhiJIne.delegate = self;
    [self getListByChannel];
    
    for (UIButton *selectItem in _chongZhiSelectItem) {
        selectItem.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (selectItem.tag == 100) {
             [self setItem:selectItem];
        }
    }
    for (UILabel *lab in self.labCaijin) {
        lab.layer.cornerRadius = 3;
        lab.layer.masksToBounds = YES;
    }
    
    [self.lotteryMan getCommonSetValue:@{@"typeCode":@"recharge",@"commonCode":@"hawkeye_ali"}];
}

-(void)gotCommonSetValue:(NSString *)strUrl{
    if (strUrl == nil) {
        self.aliPayMinBouns = @"0";
    }else {
        self.aliPayMinBouns = strUrl;
    }
}

-(void)listRechargeHandsel:(NSArray *)lotteryList errorMsg:(NSString *)msg{
    if (lotteryList == nil) {
        [self showPromptViewWithText:msg hideAfter:1.7];
        
        return;
    }
  
    for (NSDictionary *itemDic in lotteryList) {
        RechargeModel *model = [[RechargeModel alloc] initWith:itemDic];
        [rechList addObject:model];
    }
    [self reloadRechargeCost:[self getRechList]];
}

-(NSArray *)getRechList{
    NSMutableArray *itemrechList = [NSMutableArray arrayWithCapacity:0];
    NSString *strChannal;
    for (ChannelModel *model in channelList) {
        if (model.isSelect == YES) {
            strChannal = model.channel;
            break;
        }
    }
    for (RechargeModel *model in rechList) {
        if ([model.rechargeChannel isEqualToString:strChannal]) {
            model.isSelect = NO;
            [itemrechList addObject:model];
        }
    }
    //充值渠道没有匹配的值时，显示默认值
    if (itemrechList.count == 0) {
        for (int i = 0; i < 6 ; i++) {
            RechargeModel *model = [[RechargeModel alloc]init];
            model.rechargeChannel = strChannal;
            switch (i) {
                case 0:
                    model.recharge = @"100";
                    break;
                case 1:
                    model.recharge = @"200";
                    break;
                case 2:
                    model.recharge = @"500";
                    break;
                case 3:
                    model.recharge = @"1000";
                    break;
                case 4:
                    model.recharge = @"5000";
                    break;
                default:
                    model.recharge = @"10000";
                    break;
            }
            [itemrechList addObject:model];
        }
    }
    [itemrechList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RechargeModel * r1 = obj1;
        RechargeModel * r2 = obj2;
        return  [r1.recharge doubleValue] > [r2.recharge doubleValue];
    }];
    RechargeModel *model = [itemrechList  firstObject];
    model.isSelect = YES;
    return itemrechList;
}

//显示充几送几
-(void)reloadRechargeCost:(NSArray *)rechList{
    int i = 0;
    for (RechargeModel  *model in rechList) {
        
        
        if (model.isSelect == YES) {
            self.txtChongZhiJIne.text = model.recharge;
            selectRech = model;
        }
        
        for (UIButton *itemDic in self.chongZhiSelectItem) {
            
//                itemDic.layer.borderColor = SystemGreen.CGColor;
//                [itemDic setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
//                [itemDic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//
//                itemDic.layer.borderColor = TFBorderColor.CGColor;
//                [itemDic setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
//                [itemDic setTitleColor:SystemLightGray forState:UIControlStateNormal];
            
            if (itemDic.tag == 100 + i) {
                itemDic.selected = model.isSelect;
                if (itemDic.selected == YES) {
                    [self setItem:itemDic];
                }
                [itemDic setTitle: [NSString stringWithFormat:@"￥%.2f",[model.recharge doubleValue]] forState:0];
            }
        }
        
        for (UILabel *itemDic in self.labCaijin) {
            if (itemDic.tag == 200 + i) {
                if ([model.handsel doubleValue] == 0) {
                    itemDic.hidden = YES;
                }else{
                    itemDic.text = [NSString stringWithFormat:@"送 %.1f",[model.handsel doubleValue]];
                    itemDic.hidden = NO;
                }
                
            }
        }
        i ++;
    }
}

-(void)setTableView{
    self.tabChannelList.dataSource =self;
    self.tabChannelList.delegate = self;
    self.tabChannelList.rowHeight = 60;
    [self.tabChannelList registerClass:[PayTypeListCell class] forCellReuseIdentifier:KPayTypeListCell];
}

-(void)setItem:(UIButton *)sender{
    
    for (UIButton *item in self.chongZhiSelectItem) {
        
        item.selected = NO;
    }
  
    sender.selected = !sender.selected;
    for (RechargeModel *model in [self getRechList]) {
        if ([sender.currentTitle isEqualToString:[NSString stringWithFormat:@"￥%.2f",[model.recharge doubleValue]]]) {
            model.isSelect = sender.selected;
            if (model.isSelect == YES) {
                selectRech = model;
            }else{
                selectRech = nil;
            }
        }else{
            model.isSelect = NO;
        }
        
    }
    for (UIButton *item in self.chongZhiSelectItem) {
        
        if (sender.selected == YES) {
            self.txtChongZhiJIne.text = [NSString stringWithFormat:@"%.2f",[selectRech.recharge doubleValue]];
        }
        
        if (item.selected == YES) {
            item.layer.borderColor = SystemGreen.CGColor;
            [item setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        }else{
            item.layer.borderColor = TFBorderColor.CGColor;
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [item setTitleColor:SystemLightGray forState:UIControlStateNormal];
        }
        item.layer.borderWidth = 1;
        item.layer.cornerRadius = 4;
        item.layer.masksToBounds = YES;
    }
    if ([selectRech.handsel doubleValue] == 0) {
        [_btnChongzhi setTitle:[NSString stringWithFormat:@"实际到账%.2f元",[selectRech.recharge doubleValue]] forState:0];
    }else {
        [_btnChongzhi setTitle:[NSString stringWithFormat:@"实际到账%.2f+%.2f元",[selectRech.recharge doubleValue] ,[selectRech.handsel doubleValue]] forState:0];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    BOOL flag = NO;
    double cost = [textField.text doubleValue];
    for (NSInteger i = [self getRechList].count; i -- ; i >= 0) {
        RechargeModel *model = [self getRechList][i];
        
        if ( cost >= [model.recharge doubleValue]) {
            if ([model.handsel doubleValue] == 0) {
                [_btnChongzhi setTitle:[NSString stringWithFormat:@"实际到账%.2f元",cost] forState:0];
            }else{
                [_btnChongzhi setTitle:[NSString stringWithFormat:@"实际到账%.2f+%.2f元",cost ,[model.handsel doubleValue]] forState:0];
            }
            flag = YES;
            break;
        }
    }
    if (flag == NO) {
            [_btnChongzhi setTitle:[NSString stringWithFormat:@"实际到账%.2f元",cost] forState:0];
    }
}

-(void)rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
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
            orderNO = payInfo;
            ZhiFubaoWeixinErcodeController * zhifubaoVC = [[ZhiFubaoWeixinErcodeController alloc]init];
            zhifubaoVC.orderNo = orderNO;
            zhifubaoVC.chongzhitype = @"weixin";
            [self.navigationController pushViewController:zhifubaoVC animated:YES];
    
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (IBAction)haveead:(id)sender {
    
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
    
    if ([self.txtChongZhiJIne.text doubleValue] <= 0) {
        [self showPromptText:@"请输入合法的金额" hideAfterDelay:1.7];
        return;
    }
    
    if ([itemModel.channel isEqualToString:@"HAWKEYE_ALI"] ) {
        if ([self.txtChongZhiJIne.text doubleValue] < [self.aliPayMinBouns doubleValue]) {
            [self showPromptText:[NSString stringWithFormat:@"%@充值最少充%@元",itemModel.channelTitle,self.aliPayMinBouns] hideAfterDelay:1.7];
            return;
        }
    }
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *checkCode = self.txtChongZhiJIne.text;
        
      
        rechargeInfo = @{@"cardCode":cardCode,
                          @"channel":itemModel.channel,
                          @"amounts":checkCode,
                        };
    } @catch (NSException *exception) {
       return;
    }
    [self showLoadingText:@"正在提交订单"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSchemePayState:) name:@"NSNotificationapplicationWillEnterForeground" object:nil];
    [self.memberMan rechargeSms:rechargeInfo];
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
//            if ([model.channelTitle containsString:@"微信支付"]) {
                [channelList insertObject:model atIndex:0];
//            } else {
//                [channelList addObject:model];
//            }
         }
    }
    
    self.viewHeight.constant = 420 + channelList.count * 60;

    [channelList firstObject].isSelect = YES;
    self.tabPayListHeight.constant = channelList.count * self.tabChannelList.rowHeight;
    [self.tabChannelList reloadData];
    [self .lotteryMan listRechargeHandsel];
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
    [self reloadRechargeCost:[self getRechList]];
    [self.tabChannelList reloadData];
}
- (IBAction)actionSelectItem:(UIButton *)sender {
    [self setItem:sender];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self setItem:nil];
    if (range.location == 10) {
        return NO;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    regex = @"^[0-9.]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (isMatch) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL isMatch1 = [pred1 evaluateWithObject:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        
        return isMatch1;
    }else{

        return NO;
    }

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
//    object    NSTaggedPointerString *    @"cancel"    0xa006c65636e61636
//    if ([itemModel.channel isEqualToString:@"UNION"]) {
//        if (![notification.object isEqualToString:@"success"]) {
//            [self showPromptText:@"支付失败" hideAfterDelay:1.6];
//            return;
//        }
//    }

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
        [self showPromptText:@"充值成功" hideAfterDelay:1.7];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
//        if ([itemModel.channel isEqualToString:@"SDWX"]) {
//            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"请检查是否完成充值"];
//            [alert addBtnTitle:@"未完成" action:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//            [alert addBtnTitle:@"完成" action:^{
//                [self showLoadingText:@"正在查询充值结果，请稍等"];
//                 [self.memberMan queryRecharge:@{@"channel":itemModel.channel, @"orderNo":orderNO}];
//            }];
//            [alert showAlertWithSender:self];
//            return;
//        }
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (void)navigationBackToLastPage{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DiscoverViewController class]]) {
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [super navigationBackToLastPage];
}

- (void)showPlayRec{
    ChongZhiRulePopView *rulePopView = [[ChongZhiRulePopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    rulePopView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:rulePopView];
}

-(void)setRightBarButtonItem{
    
    UIButton *rightBtnRec = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtnRec.frame = CGRectMake(0, 0, 30, 30);
    [rightBtnRec addTarget:self action:@selector(showPlayRec) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnRec setImage:[UIImage imageNamed:@"redpacketrule"] forState:UIControlStateNormal];
    UIBarButtonItem *barRedPacketRec = [[UIBarButtonItem alloc]initWithCustomView:rightBtnRec];
    self.navigationItem.rightBarButtonItem  = barRedPacketRec;
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




@end
