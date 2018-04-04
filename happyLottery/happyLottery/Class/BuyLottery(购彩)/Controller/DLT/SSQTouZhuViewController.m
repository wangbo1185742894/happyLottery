//
//  TouZhuViewController.m
//  Lottery
//
//  Created by YanYan on 6/10/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "SSQTouZhuViewController.h"
#import "LotteryXHSection.h"
#import "SetPayPwdViewController.h"
#import "AESUtility.h"
#import "PayOrderViewController.h"
#import "SchemeCashPayment.h"
#import "ZhuiHaoInfoViewController.h"
#define removeall  300
#define zancuntag 10001
#define PayAlertTag  301

#define ZHAlert  301

#import "JPUSHService.h"
#import "User.h"
#import "MemberManager.h"
#import "SSQPlayViewController.h"
#import "WBInputPopView.h"

@interface SSQTouZhuViewController ()<UITextFieldDelegate,UIAlertViewDelegate,MemberManagerDelegate,WBInputPopViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    __weak IBOutlet UIButton *btnMoniTouzhu;
    __weak IBOutlet UIButton *btnZhenShiTouzhu;
    __weak IBOutlet UITextField *tfBeiCount;
    IBOutletCollection(UIButton) NSArray *qiCountItem;
    __weak IBOutlet UIView *betOptionFunView;
    
    __weak IBOutlet UITextField *tfQiCount;
    __weak IBOutlet UITableView *tableViewContent_;
    IBOutletCollection(UIButton) NSArray *buttons_;
    __weak IBOutlet NSLayoutConstraint *tableViewHeight_;

    //确认投注
    __weak IBOutlet NSLayoutConstraint *tableViewContentBottom;
    __weak IBOutlet UIButton *btnAppend;
    
    __weak IBOutlet NSLayoutConstraint *betOptionfunViewHeight;

    __weak IBOutlet UILabel *summary;
    
    __weak IBOutlet UILabel *mostBoundsLb;
    __block float betListCellHeightSum;
    float betListMaxHeight;
    float viewContentResetHeight;
    float ivBGResetHeight;
    NSArray *betsList;
    BOOL pageLoaded;
    
    
    __block NSArray *beiTouData;
    int tempBeiTouCount;
    int tempQiShuCount;

    
    User *curUser;
    BOOL removemark;
    BOOL keyboard;
    NSString* strcuriss;
    NSInteger int_units;
    NSString *appendstrqi;
    NSString *appendstrbei;
    
    float keyboardheight;
    float keyboardheight2;
    
    //11.07
    NSArray * PushData;
    
    WBInputPopView* passInput;
    
    NSString *subscristr;
    CGRect frame4;
    CGRect totalframe;
    CGRect beiqiframe;
    
    CGRect splitLineframe;
    UILabel *splitLine;
    
    IBOutletCollection(NSLayoutConstraint) NSArray *sepHeightArr;
    
    float  curBlance;
    float  curPay;
    BOOL isZhuiHao;
    NSDictionary *ZHOrderInfoTemp;
    BOOL Mark;
    BOOL isLeXuan ;
}
@property (nonatomic , assign) BOOL hasLiked;
@property (weak, nonatomic) IBOutlet UIButton *btnHemai;

//timer
@property (nonatomic , strong) NSTimer *timer;
@property(nonatomic,strong)User *curUser;
@property(nonatomic,strong)UIToolbar *toolBar;
@end

#define DataSourceTimes 20
#define MaxBeiShu   9999
#define MaxQiShu    30

@implementation SSQTouZhuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    self.navigationController.hidesBarsWhenKeyboardAppears = NO;
    
    tableViewContent_.delegate = self;
    tableViewContent_.dataSource = self;
    self.transaction.costType = CostTypeCASH;
    self.curUser = [[GlobalInstance instance] curUser];
    self.memberMan = [[MemberManager alloc] init];
    self.memberMan.delegate = self;

    self.title = @"双色球投注";
    betsList = [self.transaction allBets];
    
    self.lotteryMan = [[LotteryManager alloc] init];
    self.lotteryMan.delegate = self;
    [tableViewContent_ reloadData];
    
    tfQiCount.delegate = self;
    tfBeiCount.delegate = self;
    self.transaction.needZhuiJia = NO;
    if (self.transaction.needZhuiJia == YES) {
        btnAppend.selected = YES;
    }
    if (self.transaction.costType == CostTypeCASH) {
        [self setBtnState:btnZhenShiTouzhu];
    }else{
        [self setBtnState:btnMoniTouzhu];
    }
    [self update];
}

- (IBAction)actionMoniTouzhu:(UIButton *)sender {
    if([tfQiCount.text integerValue] >1){
        [self showPromptText:@"追号暂不支持积分投注" hideAfterDelay:1.7];
        return;
    }
    [self setBtnState:sender];
}

- (IBAction)actionZhenshiTouzhu:(UIButton *)sender {
    [self setBtnState:sender];
}

-(void)setBtnState:(UIButton *)sender{
    btnMoniTouzhu.selected = NO;
    btnZhenShiTouzhu.selected = NO;
    sender.selected = YES;
    if (btnMoniTouzhu.selected == YES) {
        self.transaction.costType = CostTypeSCORE;
    }else{
        self.transaction.costType = CostTypeCASH;
    }
    for (LotteryBet *bet in betsList) {
        bet.costType = self.transaction.costType;
        bet.needZhuiJia = self.transaction.needZhuiJia;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableViewContent_ reloadData];
    });
    [self update];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField .text integerValue] ==0){
        textField.text = @"1";
    }
    for (UIButton *item in qiCountItem) {
        item.selected = NO;
    }
    [self update];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = self.navigationController.navigationBar.mj_h;
        NSLog(@"%@",self.navigationController.navigationBar);
    });
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }

    if(textField == tfQiCount){
        for (UIButton *item in qiCountItem) {
            item.selected = NO;
        }
    }
    NSMutableString*numStr = [[NSMutableString alloc]initWithString:textField.text];
    [numStr appendString:string];
    NSInteger num = [numStr integerValue];
    NSInteger limitNum;
    
    if(textField == tfQiCount){
        if (self.transaction.lottery.currentRound == nil){
            limitNum = 99;
        }else{
            NSInteger curQI = [[self.lottery.currentRound.issueNumber substringFromIndex:2] integerValue];
            limitNum = 135 - curQI;
        }
        if (num > limitNum) {
            [self showPromptText:[NSString stringWithFormat:@"最大可追%ld期",limitNum] hideAfterDelay:1.8];
            return NO;
        }
    }else{
        if ([tfQiCount.text integerValue] == 1) {
            limitNum = 9999;
        }else{
            limitNum = 99;
        }
        if (num > limitNum) {
            [self showPromptText:[NSString stringWithFormat:@"最大可投%ld倍",limitNum] hideAfterDelay:1.8];
            return NO;
        }
        
    }
  
    
    [self performSelector:@selector(update) withObject:nil afterDelay:0.1];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    
    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"0"]) {
        return NO;
    }

    NSString * regex;
    regex = @"^[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}

-(void)update{
    
    [self updateSummary];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
    //记录投注页面投注信息是否为空betlistcount
    
    //计时器销毁
    if (self.timerForcurRound && [self.timerForcurRound isValid]) {
        [self.timerForcurRound setFireDate:[NSDate distantFuture]];
        NSLog(@"tz tingzhi");
    }
}

- (void) updateContentBGForDltOrX115: (BOOL) firstLoad {
    betListCellHeightSum = 0;
    [self updateSummary];
    [betsList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LotteryBet *bet = (LotteryBet*) obj;
        CGFloat popViewCellHeight = bet.popViewCellHeight;
        if (popViewCellHeight < 10) {
            popViewCellHeight = [BetsListPopViewCell cellHeight: bet withFrame: tableViewContent_.bounds];
            bet.popViewCellHeight = popViewCellHeight;
        }
        betListCellHeightSum += bet.popViewCellHeight;
        
        if (betListCellHeightSum > betListMaxHeight) {
            betListCellHeightSum = betListMaxHeight;
            tableViewContent_.scrollEnabled = YES;
            *stop = YES;
        } else {
            tableViewContent_.scrollEnabled = NO;
        }
    }];
}

/*
 update bet transaction summary data
 */
- (void) updateSummary {
    if ([_lottery.identifier isEqualToString:@"SSQ"]) {

        self.transaction.beiTouCount = [tfBeiCount.text intValue];
        self.transaction.qiShuCount = [tfQiCount.text intValue];
        
        if ( self.transaction.beiTouCount  == 0) {
            self.transaction.beiTouCount  = 1;
        }
        if ( self.transaction.qiShuCount  == 0) {
            self.transaction.qiShuCount  = 1;
        }
        
        mostBoundsLb.attributedText = [self.transaction getTouZhuSummaryText2];
        summary.attributedText = [self.transaction getTouZhuSummaryText1];
    }
}


- (void) removeAllBetsAction {
    self.transaction.qiShuCount = 1;
    self.transaction.beiTouCount = 1;
    [self.transaction removeAllBets];
    tableViewContent_.hidden = YES;
    
    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         [tableViewContent_ layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.delegate betTransactionUpdated];
                         
                     }];

}

- (IBAction)actionAddRandomBet:(id)sender {
    if(self.transaction.allBets.count >= 30){
        [self showPromptText:@"最多投注30组号码" hideAfterDelay:1.7];
        return;
    }
    if ([self.isOmit isEqualToString:@"YES"]) {
                
        SSQPlayViewController *playVC = self.delegate;
        playVC.lotteryTransaction = self.transaction;
    }
    [self.delegate addRandomBet];
    betsList = [self.transaction allBets];
    [tableViewContent_ reloadData];
    removemark = YES;
            
    [self updateContentBGForDltOrX115: NO];
    [self performSelector: @selector(showLastRecord) withObject: nil afterDelay: 0.5];
    [self randomRefresh];
}
- (void) showLastRecord {
    if (tableViewContent_.scrollEnabled) {
        [tableViewContent_ scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: ([betsList count] - 1) inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
}


- (IBAction)actionZhuiJia:(id)sender {
    self.transaction.needZhuiJia = !self.transaction.needZhuiJia;
    [(UIButton*) sender setSelected: self.transaction.needZhuiJia];
    for (LotteryBet *bet in betsList) {
        bet.costType = self.transaction.costType;
        bet.needZhuiJia = self.transaction.needZhuiJia;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableViewContent_ reloadData];
    });
    [self updateSummary];
}

//时间3秒
- (void) timeEnough
{
    UIButton *btn=(UIButton*)[self.view viewWithTag:33];
    btn.selected=NO;
    [_timer invalidate];
    _timer=nil;
}

-(NSInteger)getIssnum{
    return [tfQiCount.text integerValue];
}



//追号期前的判断
/*{
 "beginIssue": "100000",
 "betSource": 1,
 "cardCode": 80001002,
 "chaseContent": "betCount",
 "issueMultiple": [{
 "issueNumber": "100000",
 "multiple": 10
 },
 {
 "issueNumber": "100001",
 "multiple": 10
 }],
 "lotteryCode": "X115",
 "totalCatch": 2,
 "totalCost": 1000,
 "units": 1,
 "winStopStatus": "WINSTOP"
 }*/


//11.07
- (void)showPayPopView{
    [self hideLoadingView];
    if (nil == passInput) {
        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
    }
    
    [passInput show];
    
    [self.view addSubview:passInput];
    
    [passInput createBlock:^(NSString *text) {
        
        if (nil == text) {
            [self showPromptText:TextNoPwdAlert hideAfterDelay:1.7];
            return;
        }
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];

    }];
    
}



#pragma MemberManagerDelegate methods





- (BOOL)isExceedLimitAmount{
    
    int costTotal = 0;
    for (LotteryBet * bet in [_transaction allBets]) {
        costTotal += [bet getBetCost];
    }
    if(self.transaction.needZhuiJia)
    {
        if(((costTotal * _multiple)/2 * 3) > 300000)
        {
            return YES;
        }
    }
    else if (costTotal * _multiple> 300000) {
        return YES;
    }
    return NO;
}







#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
        return betsList.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        BetsListPopViewCell *cell = (BetsListPopViewCell*)[tableView dequeueReusableCellWithIdentifier: @"betcell"];
        if (cell == nil) {
            cell = [[BetsListPopViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"betcell"];
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
        
        LotteryBet *bet = betsList[indexPath.row];
        bet.needZhuiJia = self.transaction.needZhuiJia;
        [cell updateWithBet: bet];
        if (indexPath.row == [betsList count] - 1) {
            CGRect frame = cell.downLine.frame;
            frame.origin.x = 0;
            frame.size.width = KscreenWidth+10;
            frame.size.height = SEPHEIGHT;
            cell.downLine.backgroundColor = SEPCOLOR;
            cell.downLine.frame = frame;
        }else{
            CGRect frame = cell.downLine.frame;
            frame.origin.x = 15;
            frame.size.width = KscreenWidth - 2 * 15;
            frame.size.height = SEPHEIGHT;
            cell.downLine.frame = frame;
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        LotteryBet *bet = betsList[indexPath.row];
        CGFloat popViewCellHeight = bet.popViewCellHeight;
        if (popViewCellHeight < 10) {
            popViewCellHeight = [BetsListPopViewCell cellHeight: bet withFrame: tableView.bounds];
            bet.popViewCellHeight = popViewCellHeight;
        }
        return popViewCellHeight;
   
}

- (void) removeBetAction: (NSIndexPath *) indexPath {
    if([self.transaction allBets].count == 1){
        [self showPromptText:@"至少选择一注" hideAfterDelay:1.7];
        return;
    }
    if (indexPath.row < [self.transaction betCount]) {
        LotteryBet *bet = betsList[indexPath.row];
        [self.transaction removeBet: bet];
        
        //zwl 01-19[self.transaction betC
        if([self.transaction betCount] == 0)
        {

            _multiple = self.transaction.beiTouCount;
            _issue = self.transaction.qiShuCount;
            
            self.transaction.needZhuiJia = NO;
            [self updateSummary];//刷新投注信息
        }
        
        [tableViewContent_ deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        [self.delegate betTransactionUpdated];
        
        [self updateContentBGForDltOrX115: NO];
        [tableViewContent_ reloadData];
        //zwl
        removemark = YES;
        
    }
}
- (void)navigationBackToLastPage{
    [self removeAllBetsAlert];
}

- (void)removeAllBetsAlert{
    
    //    UIAlertView *cleanAlertView = [[UIAlertView alloc] initWithTitle: TextBackFromPlayPageAlert
    //                                                             message: nil
    //                                                            delegate: self
    //                                                   cancelButtonTitle: TextDimiss
    //                                                   otherButtonTitles: @"确定", nil];
    //    cleanAlertView.tag = removeall;
    //
    //    [cleanAlertView show];
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:TextBackFromPlayPageAlert];
    [alert addBtnTitle:TitleNotDo action:^{
        
    }];
    [alert addBtnTitle:TitleDo action:^{
        [self removeAllBetsAction];
        //        [super navigationBackToLastPage];
        
        if (nil != self.navigationController) {
        
            [self.navigationController popViewControllerAnimated: YES];
            
        }else{
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:animation forKey:nil];
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        
    }];
    [alert showAlertWithSender:self];
}

- (IBAction)actionRandomFive:(UIButton *)sender {
    for (int i = 0; i < 5 ;i ++ ) {
        [self actionAddRandomBet:sender];
    }
    [self randomRefresh];
}

-(void)randomRefresh{
    if (self.transaction.costType == CostTypeCASH) {
        [self setBtnState:btnZhenShiTouzhu];
    }else{
        [self setBtnState:btnMoniTouzhu];
    }
}

- (IBAction)actionGoonBuy:(UIButton *)sender {
    if(self.transaction.allBets.count >= 30){
        [self showPromptText:@"最多投注30组号码" hideAfterDelay:1.7];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionAppend:(UIButton*)sender {
    sender .selected = !sender.selected;
    self.transaction.needZhuiJia =sender .selected;
    
    for (LotteryBet *bet in betsList) {
        bet.costType = self.transaction.costType;
        bet.needZhuiJia = self.transaction.needZhuiJia;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableViewContent_ reloadData];
    });
    [self update];
}
- (IBAction)actionSelectQiCount:(UIButton *)sender {
    for (UIButton *item in qiCountItem) {
        item.selected = NO;
    }
    sender.selected = YES;
    tfQiCount.text = [NSString stringWithFormat:@"%ld",sender.tag];
    [self update];
}
- (IBAction)actionTouzhu:(UIButton *)sender {
    self.transaction.schemeSource = SchemeSourceBet;
    
    [self showLoadingText:@"正在提交订单"];
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
}
-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    [self hideLoadingView];
    {
        
        if (infoDic != nil && infoDic.count != 0) {
            _lottery.currentRound = [infoDic firstObject];
            _transaction.lottery.currentRound = [infoDic firstObject];
        }else{
            [self showPromptText:ErrorLotteryRounderExpire hideAfterDelay:1.7];
            [self hideLoadingView];
            return;
        }
        
        
        
        if ([tfQiCount.text integerValue] != 1) {
            
            if (self.transaction.allBets.count > 10000) {
                [self showPromptText:@"追号投注单次不能超过1万注" hideAfterDelay:1.8];
                return;
            }
            
            if (self.curUser.isLogin) {
                
                LotteryBet *bet1 = [_transaction.allBets firstObject];
                for (int i = 1 ;i< _transaction.allBets.count ;i++) {
                    
                    LotteryBet *bet = _transaction.allBets[i];
                    if ([bet.betXHProfile.profileID integerValue] != [bet1.betXHProfile.profileID integerValue]) {
                        [self showPromptText:@"系统暂不支持多种玩法的追号!" hideAfterDelay:1.7];
                        return;
                    }
                }
                
                NSArray *betslist = [self.transaction allBets];
                for(int i=0;i<betslist.count;i++)
                {
                    int intunits =[[betslist[i] valueForKey:@"betCount"] intValue];
                    if(intunits == 1){
                        if(betslist.count > 5)
                        {
                            NSString *msg =@"系统最多支持五注单式追号";
                            [self showPromptText:msg hideAfterDelay:2.7];
                            return;
                        }
                    }
                    else if(intunits != 1)
                    {
                        if(betslist.count > 1)
                        {
                            NSString *msg =@"复式追号，系统仅支持一组选号";
                            [self showPromptText:msg hideAfterDelay:2.7];
                            return;
                        }
                    }
                }
                
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
                
                [self actionZhuihao];
                return;
            }else{
                [self needLogin];
            }
        }else{
            if ([self isExceedLimitAmount]) {
                [self showPromptText:TextTouzhuExceedLimit hideAfterDelay:1.7];
                return;
            }
            
            if (self.curUser.isLogin) {
                BaseTransaction * transcation;
                transcation = self.transaction;
                self.transaction.schemeType = SchemeTypeZigou;
                
                [self.lotteryMan betLotteryScheme:self.transaction];
            } else {
                [self needLogin];
            }
        }
    }
}

-(void)actionZhuihao{
    if (self.transaction.costType == CostTypeSCORE) {
        [self showPromptText:@"模拟投注暂不支持追号" hideAfterDelay:1.9];
        return;
    }
    
    
    
    float balance = [self.curUser.totalBanlece doubleValue];
    NSString *msg = [NSString stringWithFormat:@"共追%lu期，共需%ld元,您当前余额为%.1f元,是否确定追号？",[tfQiCount.text integerValue],(long)self.transaction.betCost,balance];
    if ([tfBeiCount.text integerValue] > 99) {
        [self showPromptText:@"追号最大可投99倍" hideAfterDelay:1.8];
        return;
    }
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"追号确认" message:msg];
    [alert addBtnTitle:TitleNotDo action:^{
        [self hideLoadingView];
    }];
    [alert addBtnTitle:TitleDo action:^{
        [self zhuihao];
    }];
    [alert showAlertWithSender:self];
}

-(void)zhuihao{
    [self showLoadingText:@"正在提交"];
    self.transaction.qiShuCount = [tfQiCount.text intValue];
    
    [self.lotteryMan betChaseScheme:self.transaction];
}

-(void)betedChaseScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (schemeNO == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    ZhuiHaoInfoViewController * betInfoViewCtr = [[ZhuiHaoInfoViewController alloc] initWithNibName:@"ZhuiHaoInfoViewController" bundle:nil];
    
    //    betInfoViewCtr.ZHflag = YES;
    betInfoViewCtr.from = YES;
    [self.navigationController pushViewController:betInfoViewCtr animated:YES];
}

-(void)betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil) {
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.lotteryName = @"双色球";
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    if (btnMoniTouzhu.selected == YES) {
        schemeCashModel.costType = CostTypeSCORE;
        if (self.transaction.betCost  > 30000000) {
            [self showPromptText:@"单笔总积分不能超过3千万积分" hideAfterDelay:1.7];
            return;
        }
    }else{
        schemeCashModel.costType = CostTypeCASH;
        if (self.transaction.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    [self hideLoadingView];
    
    schemeCashModel.subscribed = self.transaction.betCost;
    schemeCashModel.realSubscribed = self.transaction.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}
-(BOOL)checkPayPassword{
    
    if(self.curUser.payVerifyType == PayVerifyTypeAlways){
        return YES;
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanOneHundred){
        if (self.transaction.betCost > 100 ) {
            return YES;
        }else{
            return NO;
        }
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanFiveHundred){
        
        if (self.transaction.betCost > 500 ) {
            return YES;
        }else{
            return NO;
        }
        
    }else if(self.curUser.payVerifyType == PayVerifyTypeLessThanThousand){
        if (self.transaction.betCost > 1000 ) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if (success == YES) {
        [self actionZhuihao];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}


@end
