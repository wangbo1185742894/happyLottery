//
//  TouZhuViewController.m
//  Lottery
//
//  Created by YanYan on 6/10/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "TouZhuViewController.h"
#import "AESUtility.h"

#import "LotteryXHSection.h"
#import "PayOrderLegViewController.h"
#import "SchemeCashPayment.h"
#define removeall  300
#define zancuntag 10001
#define PayAlertTag  301

#define ZHAlert  301
#import "JPUSHService.h"
#import "ZhuiHaoInfoViewController.h"
#import "MemberManager.h"
#import "LotteryPlayViewController.h"
#import "WBInputPopView.h"
#import "OmitEnquiriesViewController.h"

#import "SelectView.h"
#import "SetPayPWDViewController.h"
#import "X115LimitNumPopView.h"
@interface TouZhuViewController ()<UITextFieldDelegate,UIAlertViewDelegate,MemberManagerDelegate,SelectViewDelegate,WBInputPopViewDelegate,X115LimitNumPopViewDelegate,UITableViewDelegate,UITableViewDataSource,LotteryPhaseInfoViewDelegate,PayOrderLegDelegate> {
    
    __weak IBOutlet UIView *betOptionFunView;
    __weak IBOutlet UIImageView *tableViewBGIV_;
    __weak IBOutlet UITableView *tableViewContent_;
    
    __weak IBOutlet UIButton *buttonZhuiJia_;
    
    __weak IBOutlet UILabel *labelSummary_;
    __weak IBOutlet UIActivityIndicatorView *spinnerLoading_;
    __weak IBOutlet NSLayoutConstraint *tableViewHeight_;
    __weak IBOutlet UIPickerView *pickerBeiTou_;
    __weak IBOutlet UIView *viewPickerContainer_;
    __weak IBOutlet UIView *viewBeiTou_;
    
    __weak IBOutlet UITextField *tfBeiText;
    
    __weak IBOutlet UITextField *tfQiText;
    
    __weak IBOutlet NSLayoutConstraint *topDis;
    //确认投注
    __weak IBOutlet NSLayoutConstraint *tableViewContentBottom;
    __weak IBOutlet UIButton *buttonK;
    
    __weak IBOutlet NSLayoutConstraint *betOptionfunViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *lineBottom;
    __weak IBOutlet NSLayoutConstraint *tableviewBottom;
    UIButton *goOnPlayButton;
    UIButton *addRandonBetButton;
    UIButton *clearAllBetButton;
    UIButton *zhuihaoBtn;
    /*追加按钮*/
    UIButton *appendBtn;
    
    __weak IBOutlet UIButton *zhinengBtn;
    BeitouView * beitouView;
    __weak IBOutlet NSLayoutConstraint *lbSummaryBottomTraint;
    
    __weak IBOutlet UILabel *mostBoundsLb;
    __block float betListCellHeightSum;
    float betListMaxHeight;
    float viewContentResetHeight;
    float ivBGResetHeight;
    __weak IBOutlet UIButton *btnTuijian;
    NSArray *betsList;
    BOOL pageLoaded;
    
    
    __block NSArray *beiTouData;
    int tempBeiTouCount;
    int tempQiShuCount;
    
    
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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *qCountItembtn;
@property (weak, nonatomic) IBOutlet UIButton *zhSelectBtn;

//timer
@property (nonatomic , strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property (weak, nonatomic) IBOutlet UIButton *yuYueBtn;
@property(nonatomic,strong)UIToolbar *toolBar;
@end

#define DataSourceTimes 20
#define MaxBeiShu   9999
#define MaxQiShu    30

@implementation TouZhuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _zhSelectBtn.selected = self.transaction.winStopStatus;
    [self.view addSubview:self.phaseInfoView];
    if([self isIphoneX]){
        topDis.constant = 118-64 + 88 + 44;
        _bottomDis.constant = 38;
    }else{
        topDis.constant = 118 + 44;
        _bottomDis.constant = 0;
    }
    tfQiText.text = [NSString stringWithFormat:@"%d",self.transaction.qiShuCount];
    tfBeiText.text = [NSString stringWithFormat:@"%d",self.transaction.beiTouCount];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view layoutIfNeeded];
    self.lotteryMan.delegate = self;
    self.memberMan.delegate = self;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT;
    lineBottom.constant = 90;
    buttonK.tag = 33;
    //11.07
    self.yuYueBtn.layer.masksToBounds = YES;
    self.yuYueBtn.layer.cornerRadius = 4;
    tfBeiText.delegate = self;
    tfQiText.delegate = self;
    zhinengBtn.layer.cornerRadius = 4;
    zhinengBtn.layer.masksToBounds = YES;
    zhinengBtn.layer.borderWidth = 1;
    zhinengBtn.layer.borderColor = RGBCOLOR(18, 199, 146).CGColor;
    labelSummary_.adjustsFontSizeToFitWidth  = YES;
    /*zwl*/
    _FLAG = NO;
    isZhuiHao = NO;
    removemark = NO;
    keyboard = NO;
    appendstrqi = @"";
    appendstrbei = @"";
    subscristr = @"";
//    mostBoundsLb.adjustsFontSizeToFitWidth = YES;
    for (NSLayoutConstraint *sepHeight in sepHeightArr) {
        sepHeight.constant = SEPHEIGHT;
    }
    //    betOptionFunView.backgroundColor = RGBCOLOR(249, 249, 249);
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.curNavVC = self.navigationController;
    self.title = @"确认预约";

    tableViewContent_.allowsSelection = NO;
    tableViewContent_.delegate  =self;
    tableViewContent_.dataSource = self;
    tableViewContent_.layer.borderWidth = SEPHEIGHT;
    tableViewContent_.layer.borderColor = SEPCOLOR.CGColor;
    [tableViewContent_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableViewBGIV_.image = [[UIImage imageNamed: @"shoppingCartBG.png"] stretchableImageWithLeftCapWidth: 30 topCapHeight: 14];
    //    for (UIButton *button in buttons_) {
    //        button.layer.cornerRadius = 3;
    //    }
    //    viewPickerContainer_.layer.cornerRadius = 4;
    [spinnerLoading_ startAnimating];
    betsList = [self.transaction allBets];
    viewContentResetHeight = tableViewContent_.frame.size.height;
    ivBGResetHeight = tableViewBGIV_.frame.size.height;
    
    tableViewContent_.hidden = YES;
    
    pickerBeiTou_.delegate = self;
    pickerBeiTou_.dataSource = self;

    viewBeiTou_.hidden = YES;
    viewBeiTou_.alpha = 0;
    if (self.transaction.needZhuiJia) {
        buttonZhuiJia_.selected = YES;
        
    }
    self.transaction.costType = CostTypeCASH;
        CGRect frame1;
        CGRect frame2;
    self.btnHemai.hidden = YES;
    frame1= CGRectMake(40, NaviHeight + 20 + 44, (KscreenWidth-120)/2.0, 30);
    frame2= CGRectMake(40+ (KscreenWidth-120)/2.0+40, NaviHeight + 20 + 44,  (KscreenWidth-120)/2.0, 30);

        CGRect frame3= CGRectMake(60+(KscreenWidth-80)*2/3.0, NaviHeight + 20 + 44, (KscreenWidth-80)/3.0, 30);
        frame4 = CGRectMake(8,49, 85, 35);
        CGRect frame5 = CGRectMake(KscreenWidth-110, 45, 20, 20);
        
        goOnPlayButton = [[UIButton alloc]initWithFrame:frame1];
        //        goOnPlayButton.layer.cornerRadius = 3;
        //        goOnPlayButton.layer.masksToBounds = YES;
        [goOnPlayButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateNormal];
        
        [goOnPlayButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateHighlighted];
        [goOnPlayButton setImage:[UIImage imageNamed:@"encore.png"] forState:0];
        [goOnPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goOnPlayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [goOnPlayButton setTitle:@"再买1注" forState:UIControlStateNormal];
        
        [self.view addSubview:goOnPlayButton];
        addRandonBetButton = [[UIButton alloc]initWithFrame:frame2];
        betOptionfunViewHeight.constant = 121;
        
        lineBottom.constant = betOptionfunViewHeight.constant;
        tableviewBottom.constant = betOptionfunViewHeight.constant;
        tableViewContentBottom .constant = 0;
    
        [self loadzhuiqi];
        [self loadbei];
        [addRandonBetButton setTitle:@"机选1注" forState:UIControlStateNormal];
    
    goOnPlayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    goOnPlayButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [goOnPlayButton addTarget: self action: @selector(actionKeepBetting:) forControlEvents: UIControlEventTouchUpInside];
    //    addRandonBetButton.layer.cornerRadius = 3;
    //    addRandonBetButton.layer.masksToBounds = YES;
    addRandonBetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [addRandonBetButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateNormal];
    [addRandonBetButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateHighlighted];
    [addRandonBetButton setImage:[UIImage imageNamed:@"friendshake.png"] forState:0];
    [addRandonBetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addRandonBetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    addRandonBetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addRandonBetButton addTarget: self action: @selector(actionAddRandomBet:) forControlEvents: UIControlEventTouchUpInside];
    
    //    clearAllBetButton.layer.cornerRadius = 3;
    clearAllBetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearAllBetButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateNormal];
    [clearAllBetButton setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateHighlighted];
    [clearAllBetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearAllBetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [clearAllBetButton setImage:[UIImage imageNamed:@"encore.png"] forState:0];
    
    clearAllBetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearAllBetButton addTarget: self action: @selector(actionRemoveAllBets:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:addRandonBetButton];
    self.zhSelectBtn.hidden = YES;
    if ([tfQiText.text integerValue]>1) {
        self.zhSelectBtn.hidden = NO;
        self.zhSelectBtn.selected = YES;
    }
}

- (void)navigationBackToLastPage{
     [self removeAllBetsAlert];
    [super navigationBackToLastPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    //       beitouView.hidden = YES;
    [self.view becomeFirstResponder];
    [self loadUI];
    
    
    if ([self.timerForcurRound isValid]) {
        [self.timerForcurRound setFireDate:[NSDate date]];
        NSLog(@"tz kaishi");
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hasLiked = YES;
    [self initZhuiHaoBtnState];
    if (_FLAG) {
        betOptionfunViewHeight.constant = 121;
        
        lineBottom.constant = betOptionfunViewHeight.constant;
        
        tableviewBottom.constant = betOptionfunViewHeight.constant;
        tableViewContentBottom .constant = 0;
        
        
        frame4.origin.y = 49;
        
        zhuihaoBtn.frame = frame4;
        totalframe.origin.y = 48;
        beiqiframe.origin.y = 66;

        splitLineframe.origin.y = 41;
        splitLine.frame = splitLineframe;
        zhuihaoBtn.hidden = YES;
    }
    else
    {
        if(Mark == YES || isLeXuan){
            zhuihaoBtn.hidden = YES;
            Mark = NO;
            isLeXuan = NO;
        }else{
//            zhuihaoBtn.hidden = NO;
        }
    }
    [self ToolView:tfBeiText];
    [self ToolView:tfQiText];
    
}

- (IBAction)actionSelectTZ:(id)sender {
    UIButton *butt = sender;
    butt.selected = !butt.selected;
    self.transaction.winStopStatus = butt.selected;
}

-(void)ToolView:(UITextField *)textField{
    
    [textField resignFirstResponder];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIButton *submitClean = [UIButton buttonWithType:UIButtonTypeCustom];
    submitClean.mj_h = 15;
    submitClean.mj_w = 25;
    [submitClean setBackgroundImage:[UIImage imageNamed:@"keyboarddown"] forState:UIControlStateNormal];
    [submitClean setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    submitClean.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitClean addTarget:self action:@selector(actionWancheng:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemsubmit = [[UIBarButtonItem alloc]initWithCustomView:submitClean];
    
    topView.backgroundColor = RGBCOLOR(230, 230, 230);
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithCustomView:[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 30)]];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:space,itemsubmit,nil];
    
    topView.opaque = YES;
    [topView setItems:buttonsArray];
    self.toolBar = topView;
    [textField setInputAccessoryView:self.toolBar];
}

-(void)actionWancheng:(UITextField*)tv{
    
    [tfBeiText resignFirstResponder];
    [tfQiText resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
    if (self.timerForcurRound && [self.timerForcurRound isValid]) {
        [self.timerForcurRound setFireDate:[NSDate distantFuture]];
        NSLog(@"tz tingzhi");
    }
}


- (void) loadUI {
    if(removemark == NO){
        if (pageLoaded) return;
        pageLoaded = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //calculate the cell height
        
        NSMutableArray *beiTouDataTMP = [NSMutableArray array];
        //bei shu data
        NSMutableArray *beishuData = [NSMutableArray arrayWithCapacity: MaxBeiShu];
        for (int beishu=1; beishu<(MaxBeiShu+1); beishu++) {
            [beishuData addObject: [NSNumber numberWithInteger: beishu]];
        }
        [beiTouDataTMP addObject: beishuData];
        //qi shu data
        NSMutableArray *qishuData = [NSMutableArray arrayWithCapacity: MaxQiShu];
        for (int qishu=1; qishu<(MaxQiShu+1); qishu++) {
            [qishuData addObject: [NSNumber numberWithInteger: qishu]];
        }
        [beiTouDataTMP addObject: qishuData];
        beiTouData = beiTouDataTMP;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        betListMaxHeight = tableViewContent_.superview.frame.size.height - 50;
        });
        betListCellHeightSum = -10;
        dispatch_async(dispatch_get_main_queue(), ^{
            [pickerBeiTou_ reloadAllComponents];
            
            [self updateContentBGForDltOrX115: YES];
//            mostBoundsLb.hidden = YES;
//            labelSummary_.hidden = YES;
        });
    });
    
    NSArray *betList = [self.transaction allBets];
    NSInteger count = betList.count;
    Mark = NO;
    for(NSInteger i=0;i<count;i++){
        if(![[betsList[i] valueForKey:@"betTypeDesc"] isEqualToString:[betsList[0]valueForKey:@"betTypeDesc"]])
        {
            Mark = YES;
        }
        
        
    }
    isLeXuan = NO;
    for (LotteryBet *bet in betsList) {
        if (bet.betType >500) {
            isLeXuan = YES;
            break;
        }
    }
    if(Mark == YES || isLeXuan){
        zhuihaoBtn.hidden = YES;
        Mark = NO;
        isLeXuan = NO;
    }
    else if(!_FLAG){
//        zhuihaoBtn.hidden = NO;
    }
    removemark = NO;
}

- (void)initZhuiHaoBtnState{
    NSArray *betList = [self.transaction allBets];
    NSInteger count = betList.count;
    //    BOOL Mark = NO;
    for(NSInteger i=0;i<count;i++){
        if(![[betsList[i] valueForKey:@"betTypeDesc"] isEqualToString:[betsList[0]valueForKey:@"betTypeDesc"]])
        {
            Mark = YES;
        }
        
        
    }
    for (LotteryBet *bet in betsList) {
        if (bet.betType >500) {
            isLeXuan = YES;
            break;
        }
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
    if ([self.transaction betCount] > 0) {
        if (firstLoad) {
            labelSummary_.hidden = NO;
            tableViewContent_.hidden = NO;
        }
        tableViewHeight_.constant = viewContentResetHeight + betListCellHeightSum;
        [UIView animateWithDuration: 0.01
                         animations:^{
                             [self->tableViewContent_ layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (firstLoad) {
                                 tableViewContent_.delegate = self;
                                 self->tableViewContent_.dataSource = self;
                                 [tableViewContent_ reloadData];
                                 [self->spinnerLoading_ stopAnimating];
                             }
                         }];
    }
}

/*
 update bet transaction summary data
 */
- (void) updateSummary {
    self.transaction.beiTouCount = [tfBeiText.text intValue];
    self.transaction.qiShuCount = [tfQiText.text intValue];
    if ( self.transaction.beiTouCount  == 0) {
        self.transaction.beiTouCount  = 1;
    }
    if ( self.transaction.qiShuCount  == 0) {
        self.transaction.qiShuCount  = 1;
    }
    mostBoundsLb.attributedText = [self.transaction getTouZhuSummaryText1];
    labelSummary_.attributedText = [self.transaction getTouZhuSummaryText2];
    if ([tfQiText.text intValue]>1) {
        self.zhSelectBtn.hidden = NO;
        self.zhSelectBtn.selected = YES;
    } else {
        self.zhSelectBtn.hidden = YES; 
    }
}

- (void)removeAllBetsAlert{
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:TextBackFromPlayPageAlert];
    [alert addBtnTitle:TitleNotDo action:^{
        
    }];
    [alert addBtnTitle:TitleDo action:^{
        [self removeAllBetsAction];
        //        [super navigationBackToLastPage];
        
        if (nil != self.navigationController) {
            
            
            
            
            for (BaseViewController *baseVC in self.navigationController.viewControllers) {
                if ([baseVC isKindOfClass:[OmitEnquiriesViewController class]]) {
                    [self.navigationController popToViewController:baseVC animated:YES];
                    return;
                }
            }
            
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

- (void) removeAllBetsAction {
    [self.transaction removeAllBets];
    self.transaction.beiTouCount = 1;
    self.transaction.qiShuCount =1;
    self.transaction.winStopStatus = WINSTOP;
    tableViewContent_.hidden = YES;
    [UIView animateWithDuration: 0.3
                     animations:^{
                         [self->tableViewContent_ layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.delegate betTransactionUpdated];
                         [self performSelector: @selector(actionKeepBetting:) withObject: nil afterDelay: 0.1];
                     }];
}

- (IBAction)actionAddRandomBet:(id)sender {
    if([self.transaction.allBets count] >= 30){
        [self showPromptText:@"最多只能选择30组" hideAfterDelay:1.8];
        return;
    }
    if ([self.isOmit isEqualToString:@"YES"]) {
        LotteryPlayViewController *playVC = self.delegate;
        playVC.lotteryTransaction = self.transaction;
    }
    [self.delegate addRandomBet];
    betsList = [self.transaction allBets];
    [tableViewContent_ reloadData];
    removemark = YES;
    [self loadUI];
    [self updateContentBGForDltOrX115: NO];
    [self performSelector: @selector(showLastRecord) withObject: nil afterDelay: 0.5];
}

- (void) showLastRecord {
    if (tableViewContent_.scrollEnabled) {
        [tableViewContent_ scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: ([betsList count] - 1) inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
}

- (IBAction)actionBeiTouZhuiHao:(id)sender {
    tempQiShuCount = self.transaction.qiShuCount;
    tempBeiTouCount = self.transaction.beiTouCount;
    [self restPicker];
    viewBeiTou_.hidden = NO;
    [self.view bringSubviewToFront: viewBeiTou_];
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self->viewBeiTou_.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)actionZhuiJia:(id)sender {
    self.transaction.needZhuiJia = !self.transaction.needZhuiJia;
    [(UIButton*) sender setSelected: self.transaction.needZhuiJia];
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

//-(void)gotLotteryCurRound:(LotteryRound *)round{
//    [self hideLoadingView];
//    if (round) {
//        _lottery.currentRound = round;
//        _transaction.lottery.currentRound = round;
//    }else{
//        [self showPromptText:ErrorLotteryRounderExpire hideAfterDelay:1.7];
//        return;
//    }
//    if (isZhuiHao) {
//        [self zhuiHaoGo];
//        return;
//    }
//    if(appendBtn.selected)
//    {
//        _transaction.needZhuiJia = YES;
//        if ([self isExceedLimitAmount]) {
//            [self showPromptText:TextzhuijiaTouzhuExceedLimit hideAfterDelay:1.7];
//            return;
//        }
//    }
//    if(_FLAG)
//    {
//        [self setZHDic];
//        ZhuiHaoViewController *ZhuiHaoVC = [[ZhuiHaoViewController alloc] initWithNibName: @"ZhuiHaoViewController" bundle: nil];
//        ZhuiHaoVC.lottery = self.lottery;
//        ZhuiHaoVC.transaction = self.transaction;
//        ZhuiHaoVC.delegate = self;
//        ZhuiHaoVC.zhushu = int_units;
//
//        [self.navigationController pushViewController: ZhuiHaoVC animated: YES];
//    }
//    else
//    {
//        //点击只响应一次
//        if(buttonK.selected) return;
//        [buttonK setTintColor:[UIColor clearColor]];
//        buttonK.selected=YES;
//        [self performSelector:@selector(timeEnough) withObject:nil afterDelay:1.5]; //1.5秒后又可以处理点击事件了
//        //不同玩法不可追
//        BOOL isZhuiLeTou = NO;
//        if (zhuihaoBtn.hidden == YES && [JiangqiChoose.text intValue] >1) {
//            if (_transaction.allBets.count >1) {
//                LotteryBet *bet1 = [_transaction.allBets firstObject];
//                for (int i = 1 ;i< _transaction.allBets.count ;i++) {
//
//                    LotteryBet *bet = _transaction.allBets[i];
//                    if ([bet.betXHProfile.profileID integerValue] != [bet1.betXHProfile.profileID integerValue]) {
//                        [self showPromptText:@"系统暂不支持多种玩法的追号!" hideAfterDelay:1.7];
//                        isZhuiLeTou = YES;
//                        return;
//                    }
//                }
//            }else{
//                isZhuiLeTou = YES;
//            }
//        }
//        //若是由智能追号页面返回，则点击确定之后回到智能投注页面
//        if(zhuihaoBtn.hidden == YES && [self getIssnum] > 1)
//        {
//
//            if (!isZhuiLeTou) {
//                [self betzhuihao];
//                return;
//            }
//
//        }
//        /*判断购彩类型，限制是否可以追号，单式最多五注，复式仅限一注，组选仅限一组*/
//        [BeiChoose resignFirstResponder];
//        [JiangqiChoose resignFirstResponder];
//
//        if ([JiangqiChoose.text intValue] > 1) {
//            X115LimitNumPopView *popView = [[X115LimitNumPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//            
//            [popView setLabLimitInfoText:self.transaction.lottery.identifier];
//           
//            popView.delegate = self;
//            [[UIApplication sharedApplication].keyWindow addSubview:popView];
//
//        }
//
//        if([self getIssnum] > 1){
//            NSArray *betslist = [self.transaction allBets];
//            for(int i=0;i<betslist.count;i++)
//            {
//                int intunits =[[betslist[i] valueForKey:@"betCount"] intValue];
//                if(intunits == 1){
//                    if(betslist.count > 5)
//                    {
//                        NSString *msg =@"系统最多支持五注单式追号";
//                        [self showPromptText:msg hideAfterDelay:2.7];
//                        return;
//                    }
//                }
//                else if(intunits != 1)
//                {
//                    if(betslist.count > 1)
//                    {
//                        NSString *msg =@"复式追号，系统仅支持一组选号";
//                        [self showPromptText:msg hideAfterDelay:2.7];
//                        return;
//                    }
//                }
//            }
//        }
//        if ([self isExceedLimitAmount]) {
//            [self showPromptText:TextTouzhuExceedLimit hideAfterDelay:1.7];
//            return;
//        }
//
//        if (self.curUser.isLogin == YES) {
//            BaseTransaction * transcation =self.transaction;
//
//            if([self getIssnum] > 1){
//                int qi = [JiangqiChoose.text intValue];
//                int bei = [BeiChoose.text intValue];
//                //                    if (bei > 99) {
//                //                        [self showPromptText:@"追号不能大于99倍" hideAfterDelay:1.7];
//                //                        return;
//                //                    }
//                NSString *lotteryRoundDesc= [NSString stringWithFormat:@"%@ 第%@期",_lottery.name,_lottery.currentRound.issueNumber];
//                int betCount = 0;
//                NSArray * betsArray = [_transaction allBets];
//                for (LotteryBet *bet in betsArray) {
//                    betCount += [bet getBetCost];
//                }
//                if (qi == 0) {
//                    qi = 1;
//                }
//                if (bei == 0) {
//                    bei  = 1;
//                }
//                subscristr = [NSString stringWithFormat:@"%d",betCount*self.transaction.beiTouCount];
//                betCount = betCount*qi;
//                if(self.transaction.needZhuiJia)
//                {
//                    betCount += betCount/2;
//                }
//                NSDictionary * orderNeedInfo =@{@"lotteryRoundDesc":lotteryRoundDesc,@"orderCost":[NSString stringWithFormat:@"%d",betCount*self.transaction.beiTouCount]};
//                [self payJudgeWithOrderInfo:orderNeedInfo andQishu:qi];
//
//            }
//            else
//            {
//                transcation.schemeType = SchemeTypeZigou;
//                //                    if ([self.lottery.identifier isEqualToString:@"DLT"]) {
//                //                        if (self.transaction.needZhuiJia) {
//                //                            if (self.transaction.betCost / self.transaction.beiTouCount > 30000) {
//                //                                [self showPromptText:@"单倍追加金额不能超过3万" hideAfterDelay:2.0];
//                //                                return;
//                //                            }
//                //                        }else{
//                //                            if (self.transaction.betCost / self.transaction.beiTouCount > 20000) {
//                //                                [self showPromptText:@"单倍金额不能超过2万" hideAfterDelay:2.0];
//                //                                return;
//                //                            }
//                //                        }
//                //                    }
//                [lotteryMan lotteryTouZhuScheme: self.lottery transaction: transcation];
//            }
//            [self actionHideBeiTou: nil];
//        } else {
//            [self needLogin];
//        }
//    }
//}

-(BOOL)checkZhuiHaoNum{
    NSArray *betslist = [self.transaction allBets];
    if(betslist.count == 0)
    {
        NSString *msg =@"请正确追号投注";
        [self showPromptText:msg hideAfterDelay:2.7];
        return NO;
    }
    
    if ([self.lottery.activeProfile.title isEqualToString:@"前一"]) {
        if (betslist.count > 1) {
            [self showPromptText:@"前一追号仅支持单组号码" hideAfterDelay:2];
            return NO;
        }
    }
    
    for(int i=0;i<betslist.count;i++)
    {
        int intunits =[[betslist[i] valueForKey:@"betCount"] intValue];
        
        if(intunits == 1){
            if(betslist.count > 5)
            {
                NSString *msg =@"系统最多支持五注单式追号";
                [self showPromptText:msg hideAfterDelay:2.7];
                return NO;
            }
        }
        else if(intunits != 1)
        {
            if(betslist.count > 1)
            {
                NSString *msg =@"复式追号，系统仅支持一组选号";
                [self showPromptText:msg hideAfterDelay:2.7];
                return NO;
            }
        }
    }
    
    LotteryBet *bet1 = [_transaction.allBets firstObject];
    for (int i = 1 ;i< _transaction.allBets.count ;i++) {
        
        LotteryBet *bet = _transaction.allBets[i];
        if ([bet.betXHProfile.profileID integerValue] != [bet1.betXHProfile.profileID integerValue]) {
            [self showPromptText:@"系统暂不支持多种玩法的追号!" hideAfterDelay:1.7];
            return NO;
        }
    }
    return YES;
}

- (void)payForZHOrderInfo:(NSDictionary *)orderNeedInfo andQishu:(int)qi{
    
//    curBlance =  [[self.curUser totalBanlece] doubleValue];
//    if ([self.transaction getAllCost] > curBlance) {
//        [self showPromptText:[NSString stringWithFormat:@"账户余额:%.2f元,余额不足",curBlance] hideAfterDelay:2];
//        return;
//    }
    self.transaction.winStopStatus = _zhSelectBtn.selected?WINSTOP:NOTSTOP;
    NSString *msg = [NSString stringWithFormat:@"共追%@期，共需%.0f元,是否确定追号？",tfQiText.text,[self.transaction getAllCost]];
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"追号确认" message:msg];
    [alert addBtnTitle:TitleNotDo action:^{
        [self hideLoadingView];
    }];
    [alert addBtnTitle:TitleDo action:^{
        [self zhuihao];
    }];
    [alert showAlertWithSender:self];
    [self setZHDic];
}
//追号期前的判断
- (void)zhuihao{
    [self hideLoadingView];
    
    int qi = [tfQiText.text intValue];
    int bei = [tfBeiText.text intValue];
    
        if (bei > 99) {
            [self showPromptText:@"追号不能大于99倍" hideAfterDelay:1.7];
            return;
        }
    NSString *lotteryRoundDesc= [NSString stringWithFormat:@"%@ 第%@期",_lottery.name,_lottery.currentRound.issueNumber];
    int betCount = 0;
    NSArray * betsArray = [_transaction allBets];
    for (LotteryBet *bet in betsArray) {
        betCount += [bet getBetCost];
    }
    if (qi == 0) {
        qi = 1;
    }
    if (bei == 0) {
        bei  = 1;
    }
    betCount = betCount*qi;
    NSDictionary * orderNeedInfo =@{@"lotteryRoundDesc":lotteryRoundDesc,@"orderCost":[NSString stringWithFormat:@"%d",betCount]};
    [self nopayword];
}


-(void)showSetPayPasswordAlert{
    SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
    spvc.titleStr = @"设置支付密码";
    [self.navigationController pushViewController:spvc animated:YES];
}

-(NSDictionary*)getZhuiHaoInfo{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *issueMultiple = [NSMutableArray arrayWithCapacity:0];
    NSArray *catchList = myDelegate.ZHDic[@"catchList"];
    
    NSInteger cost  = curPay/catchList.count;
    @try {
        for (NSDictionary *dic in catchList) {
            NSDictionary * temp = @{@"issueNumber":dic[@"issueNumber"],
                                    @"multiple":dic[@"mutiple"],
                                    @"units":dic[@"units"],
                                    @"cost":@(cost)
                                    };
            
            [issueMultiple addObject:temp];
        }
        
        return  @{                   @"winStopStatus":myDelegate.ZHDic[@"winStopStatus"],
                                     
                                     @"playType":myDelegate.ZHDic[@"playType"],
                                     @"betType":myDelegate.ZHDic[@"betType"],
                                     
                                     @"totalCatch":myDelegate.ZHDic[@"totalCatch"],
                                     @"lottery":myDelegate.ZHDic[@"lottery"],
                                     @"chaseList":issueMultiple,
                                     @"chaseContent":myDelegate.ZHDic[@"catchContent"],
                                     @"cardCode":myDelegate.ZHDic[@"cardCode"],
                                     @"betSource":@"2",
                                     @"beginIssue":myDelegate.ZHDic[@"beginIssue"]
                                     };
    } @catch (NSException *exception) {
        return @{};
    }
}

- (void)gotLotteryCurRoundTimeout {
    
    [self hideLoadingView];
    [self showPromptText:requestTimeOut hideAfterDelay:3.0];
    return;
    
    
}

- (IBAction)actionTouzhu:(UIButton *)sender {
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    if ([tfQiText.text integerValue]>1) {
        if ([self checkZhuiHaoNum] == NO) {
            return;
        }
        
        if ([tfBeiText.text integerValue] > 99) {
            [self showPromptText:[NSString stringWithFormat:@"最大可投99倍"] hideAfterDelay:1.8];
            return;
        }
                
                    X115LimitNumPopView *popView = [[X115LimitNumPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
                    [popView setLabLimitInfoText:self.transaction.lottery.identifier];
        
                    popView.delegate = self;
                    [[UIApplication sharedApplication].keyWindow addSubview:popView];
                
        
        
        
        [self updateMemberClinet];
        return;
    }
    self.transaction.schemeSource = SchemeSourceBet;
    if(self.transaction.allBets.count > 30){
        [self showPromptText:@"投注最多30组" hideAfterDelay:2.0];
        return;
    }
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
        
        
        
        if (0) {
            
            if (self.transaction.allBets.count > 10000) {
                [self showPromptText:@"追号投注单次不能超过1万注" hideAfterDelay:1.8];
                return;
            }
            
            if (self.transaction.betCost  > 300000) {
                [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
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
                }
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
                switch (_lottery.type) {
                    case LotteryTypeDaLeTou:
                    case LotteryTypeSDShiYiXuanWu:
                    case LotteryTypeShiYiXuanWu:{
                        transcation = self.transaction;
                        break;
                    }
                    default:
                        break;
                        
                }
                self.transaction.schemeType = SchemeTypeZigou;
//                [self.lotteryMan betLotteryScheme:self.transaction];
                PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
                payVC.delegate = self;
                payVC.basetransction = transcation;
                payVC.schemetype = transcation.schemeType;
                payVC.lotteryName = self.lottery.name;
                payVC.subscribed = transcation.betCost;

                [self.navigationController pushViewController:payVC animated:YES];
            } else {
                [self needLogin];
            }
        }
    }
}



//11.07
- (void)nopayword
{
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    [myDelegate.ZHDic setObject:self.curUser.cardCode == nil?@"":self.curUser.cardCode forKey:@"cardCode"];
//    NSString *jsonStr = [Utility JsonFromId:[self getZhuiHaoInfo]];
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.basetransction = self.transaction;
    payVC.subscribed = [self.transaction getAllCost];
    payVC.schemetype = SchemeTypeZhuihao;
    payVC.delegate = self;
    payVC.zhuiArray = nil;
    if (_lottery.type == LotteryTypeSDShiYiXuanWu) {
        payVC.lotteryName = @"山东11选5";
    }else if (_lottery.type == LotteryTypeShiYiXuanWu){
        payVC.lotteryName = @"陕西11选5";
    }
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)clearSelect{
     [self.transaction removeAllBets];
     self.transaction.beiTouCount = 1;
     self.transaction.qiShuCount  = 1;
     self.transaction.winStopStatus = WINSTOP;
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
        [self showPromptText:TextSubmitForVerify hideAfterDelay:1.7];

        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if (success == YES) {
        [self nopayword];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}


#pragma MemberManagerDelegate methods

-(void) checkUserPayPasswordFinsih:(BOOL)successed  errorCode:(NSString *)errorCode{
    if (successed) {
        //校验密码成功，调用追号接口 10-08
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [myDelegate.ZHDic setObject:self.curUser.cardCode == nil ?@"":self.curUser.cardCode forKey:@"cardCode"];
        
//         [memberManage submitCatch:[Utility JsonFromId:[self getZhuiHaoInfo]]];
    }else{
        [self hideLoadingView];
        [self showPromptText:errorCode hideAfterDelay:1.7];
        //        [self errorMsgShow:errorCode];
        if(errorCode){
            [self showPromptText:errorCode hideAfterDelay:1.7];
            [self performSelector:@selector(showPayPopView) withObject:nil afterDelay:1];
        }else{
            [self showPromptText:ServiceRequestFaile hideAfterDelay:1.7];
        }
    }
}
-(void)submitCatchFinish{
    
    
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *MutableArray = [NSMutableArray arrayWithCapacity:10];
    
    MutableArray =[[myDelegate.ZHDic objectForKey:@"catchList"]valueForKey:@"issueNumber"];
    
    //  字典存储到本地
    if(myDelegate.Dic.count)
    {
        [myDelegate.userDefaultes setObject:myDelegate.Dic forKey:@"MutableDict"];
        [myDelegate.userDefaultes synchronize];
    }
    [self hideLoadingView];
    ZhuiHaoInfoViewController * betInfoViewCtr = [[ZhuiHaoInfoViewController alloc] initWithNibName:@"ZhuiHaoInfoViewController" bundle:nil];
    
    //    betInfoViewCtr.ZHflag = YES;
    betInfoViewCtr.from = YES;
    [self.navigationController pushViewController:betInfoViewCtr animated:YES];
}
- (void)submitCatcherror:(NSString *)errorMsg
{
    
    [self showPromptText:errorMsg hideAfterDelay:3];
}


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

- (IBAction)actionKeepBetting:(id)sender {
    if([self.transaction.allBets count] >= 30){
        [self showPromptText:@"最多只能选择30组" hideAfterDelay:1.8];
        return;
    }
    NSInteger numLotteryVCCount = 0;
    //从遗漏购买进入  点击再买一注时  不响应
    LotteryPlayViewController *lotteryVC;
    for (BaseViewController *baseVC  in self.navigationController.viewControllers) {
        
        if ([baseVC class] == [LotteryPlayViewController class]) {
            numLotteryVCCount ++ ;
            lotteryVC  =(LotteryPlayViewController *) baseVC;
        }
    }
    
    if (numLotteryVCCount == 1) {
        if (lotteryVC != nil && lotteryVC.lotteryTransaction != self.transaction) {
            lotteryVC.lotteryTransaction = self.transaction;
        }
    }
    
    for (BaseViewController *baseVC  in self.navigationController.viewControllers) {
        
        if ([baseVC class] == [LotteryPlayViewController class]) {
            numLotteryVCCount ++ ;
        }
        
        if ([baseVC class] == [LotteryPlayViewController class]) {
            LotteryPlayViewController *lottery = baseVC;
            
            if (lottery.lotteryTransaction != self.transaction) {
                continue;
            }
            if ([self.isOmit isEqualToString:@"YES"]) {
                LotteryPlayViewController *lottery = baseVC;
                lottery.lotteryTransaction = self.transaction;
                lottery.lottery.needSectionRandom = @1;
            }
            [self.navigationController popToViewController:baseVC animated:YES];
        }
    }
}

- (LotteryBet *) betForRow: (NSUInteger) rowIndex {
    if (rowIndex < [betsList count]) {
        return betsList[rowIndex];
    }
    return nil;
}

- (IBAction)actionAddBeiTOu:(id)sender {
    self.transaction.beiTouCount = tempBeiTouCount;
    self.transaction.qiShuCount = tempQiShuCount;
    [self updateSummary];
    [self actionHideBeiTou: nil];
}

- (IBAction)actionHideBeiTou:(id)sender {
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self->viewBeiTou_.alpha = 0;
                     } completion:^(BOOL finished) {
                         self->viewBeiTou_.hidden = YES;
                         [self.view sendSubviewToBack: self->viewBeiTou_];
                     }];
}

- (void) restPicker {
    int defaultBeiShu = MaxBeiShu*DataSourceTimes/2;
    if (self.transaction.beiTouCount > 0) {
        defaultBeiShu += self.transaction.beiTouCount - 1;
    }
    
    [pickerBeiTou_ selectRow: defaultBeiShu inComponent: 0 animated: NO];
    //  [pickerBeiTou_ selectRow: defaultQiShu inComponent: 1 animated: NO];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_lottery.type == LotteryTypeDaLeTou || _lottery.type == LotteryTypeShiYiXuanWu || _lottery.type == LotteryTypeSDShiYiXuanWu) {
        return [self.transaction allBets].count;
    }else{
        return _matchBetArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BetsListPopViewCell *cell = (BetsListPopViewCell*)[tableView dequeueReusableCellWithIdentifier: @"betcell"];
    if (cell == nil) {
        cell = [[BetsListPopViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"betcell"];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    
    LotteryBet *bet = [self betForRow: indexPath.row];
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
    LotteryBet *bet = [self betForRow: indexPath.row];
    CGFloat popViewCellHeight = bet.popViewCellHeight;
    if (popViewCellHeight < 10) {
        popViewCellHeight = [BetsListPopViewCell cellHeight: bet withFrame: tableView.bounds];
        bet.popViewCellHeight = popViewCellHeight;
    }
    return popViewCellHeight;
}


- (int) numberAtIndexPath: (NSIndexPath *) indexPath {
    NSArray *dataArray = beiTouData[indexPath.section];
    NSUInteger rowIndex = indexPath.row;
    if (rowIndex >= dataArray.count) {
        rowIndex = rowIndex%dataArray.count;
    }
    
    return [dataArray[rowIndex] intValue];
}


#pragma mark - LotteryManagerDelegate methods
- (void) removeBetAction: (NSIndexPath *) indexPath {
    if([self.transaction allBets].count <= 1){
        [self showPromptText:@"至少选择一注" hideAfterDelay:1.8];
        return;
    }
    if (indexPath.row < [self.transaction betCount]) {
        LotteryBet *bet = [self betForRow: indexPath.row];
        [self.transaction removeBet: bet];

        //zwl 01-19
        if([self.transaction betCount] == 0)
        {
            tfQiText.text = @"1";
            tfBeiText.text = @"1";
            self.transaction.qiShuCount = [tfQiText.text intValue];
            self.transaction.beiTouCount = [tfBeiText.text intValue];
            _multiple = self.transaction.beiTouCount;
            _issue = self.transaction.qiShuCount;
            
            self.transaction.needZhuiJia = NO;
            appendBtn.selected = NO;
            [appendBtn setImage:[UIImage imageNamed:@"png_btn_agree.png"] forState:UIControlStateNormal];
            [self updateSummary];//刷新投注信息
        }
        
//        [tableViewContent_ deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        [self.delegate betTransactionUpdated];
        
        [self updateContentBGForDltOrX115: NO];
        [tableViewContent_ reloadData];
        //zwl
        removemark = YES;
        [self loadUI];
    }
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    int curNum = [self numberAtIndexPath: [NSIndexPath indexPathForRow: row inSection: component]];
    return [NSString stringWithFormat: @"%d", curNum];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int count = [self numberAtIndexPath:[NSIndexPath indexPathForRow: row inSection: component]];
    if (component == 0) {
        //beishu
        tempBeiTouCount = count;
    } else {
        tempQiShuCount = count;
    }
}

#pragma mark - UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //    return 2;
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray * array = beiTouData[component];
    return [array count]*DataSourceTimes;
}


#pragma  mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
            spvc.titleStr = @"设置支付密码";
            [self.navigationController pushViewController:spvc animated:YES];
        }
        
    }
    
    if (alertView.tag == ZHAlert) {
        
        if (buttonIndex == 0) {
            return;
        }
        else
        {
            if(curPay > curBlance)
            {
                NSString *msg =@"余额不足";
                [self showPromptText:msg hideAfterDelay:2.7];
                return;
            }
            int qi = [tfQiText.text intValue];
            int bei = [tfBeiText.text intValue];
            NSString *lotteryRoundDesc= [NSString stringWithFormat:@"%@ 第%@期",_lottery.name,_lottery.currentRound.issueNumber];
            int betCount = 0;
            NSArray * betsArray = [_transaction allBets];
            for (LotteryBet *bet in betsArray) {
                betCount += [bet getBetCost];
            }
            if (qi == 0) {
                qi = 1;
            }
            if (bei == 0) {
                bei  = 1;
            }
            betCount = betCount*qi;
            NSDictionary * orderNeedInfo =@{@"lotteryRoundDesc":lotteryRoundDesc,@"orderCost":[NSString stringWithFormat:@"%d",betCount]};
            
            BOOL isNeedPayPasswordVerify = NO;
            int userVerifyType = self.curUser.payVerifyType;
            switch (userVerifyType) {
                case PayVerifyTypeAlways:{
                    isNeedPayPasswordVerify = YES;
                    break;
                }
                case PayVerifyTypeAlwaysNo:{
                    isNeedPayPasswordVerify = NO;
                    break;
                }
                case PayVerifyTypeLessThanOneHundred:{
                    if ([orderNeedInfo[@"orderCost"] intValue] > 100) {
                        isNeedPayPasswordVerify = YES;
                    }
                    break;
                }
                case PayVerifyTypeLessThanFiveHundred:{
                    if ([orderNeedInfo[@"orderCost"] intValue] > 500) {
                        isNeedPayPasswordVerify = YES;
                    }
                    break;
                }
                case PayVerifyTypeLessThanThousand:{
                    if ([orderNeedInfo[@"orderCost"] intValue] > 1000) {
                        isNeedPayPasswordVerify = YES;
                    }
                    break;
                }
                default:
                    isNeedPayPasswordVerify = YES;
                    break;
            }
            if (isNeedPayPasswordVerify) {
                if(!self.curUser.paypwdSetting){
                    [self showSetPayPasswordAlert];
                } else {
                    [self showPayPopView];
                }
            }else if(self.curUser.paypwdSetting ==NO){
                
                [self showSetPayPasswordAlert];
                
            }
            else{
                [self nopayword];
            }
            
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == removeall) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self removeAllBetsAction];
            [super navigationBackToLastPage];
        }
    }
}


#pragma mark - BeitouViewDelegate methods
- (void) betBeiTou{
    tempQiShuCount = self.transaction.qiShuCount;
    tempBeiTouCount = self.transaction.beiTouCount;
    
    NSLog(@"%d",tempBeiTouCount);
    [self restPicker];
    viewBeiTou_.hidden = NO;
    [self.view bringSubviewToFront: viewBeiTou_];
    [UIView animateWithDuration: 0.3
                     animations:^{
                         viewBeiTou_.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}
- (void) betzhuihao
{
    isZhuiHao = YES;
    if ([self checkZhuiHaoNum] == NO) {
        return;
    }
    [self zhuiHaoGo];
    
}
- (void)zhuiHaoGo{
    /*判断购彩类型，限制是否可以追号，单式最多五注，复式仅限一注，组选仅限一组*/
    [self setZHDic];
    NSArray *betslist = [self.transaction allBets];
    if(betslist.count == 0)
    {
        NSString *msg =@"请正确追号投注";
        [self showPromptText:msg hideAfterDelay:2.7];
        return;
    }
    
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
    ZhuiHaoViewController *ZhuiHaoVC = [[ZhuiHaoViewController alloc] initWithNibName: @"ZhuiHaoViewController" bundle: nil];
    ZhuiHaoVC.lottery = self.lottery;
    ZhuiHaoVC.transaction = self.transaction;
    ZhuiHaoVC.delegate = self;
    ZhuiHaoVC.zhushu = int_units;
    //    ZhuiHaoVC.issue = 10;
    [self.navigationController pushViewController: ZhuiHaoVC animated: YES];
    
}

- (void) betZhuijia:(BOOL)isZhuijia{
    self.transaction.needZhuiJia = isZhuijia;
    //    [(UIButton*) sender setSelected: self.transaction.needZhuiJia];
    [self updateSummary];
}

- (void) NumListShow:(BOOL)flag{
    _FLAG = flag;
}
-(void) setZHDic{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.ZHDic == nil) {
        myDelegate.ZHDic=  [NSMutableDictionary dictionaryWithCapacity:0];
    }

    NSString * beginIssue = [_lottery.currentRound valueForKey:@"issueNumber"];
    [myDelegate.ZHDic setObject:beginIssue forKey:@"beginIssue"];
    //选择号码内容
    NSArray *betslist = [self.transaction allBets];
    if (betslist.count == 0) {
        //        [self showPromptText:@"注数不能为0" hideAfterDelay:1.7];
        return;
    }
    
    
    NSString *Strunits ;
    NSString *catchcontent = @"";
    NSString *playtype;
    int units = 0;
    for(int i=0;i<betslist.count;i++)
    {
        //注数计算
        Strunits = [betslist[i] valueForKey:@"betCount"];
        int intstrunits = [Strunits intValue];
        NSDictionary *bettypedic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"BetType" ofType: @"plist"]];
        LotteryBet *bet =betslist[i];
        if([bet betType] == 212 || [bet betType] == 213 || [bet betType] == 214 || [bet betType] == 215 || [bet betType] == 216 || [bet betType] == 217 || [bet betType] == 222 || [bet betType] == 232)
        {
            NSNumber *num = [bettypedic objectForKey:@"Towed"];
            [myDelegate.ZHDic setObject:num forKey:@"betType"  ];
        }
        else if([bet betType] == 229 || [bet betType] == 239 )
        {
            NSNumber *num = [bettypedic objectForKey:@"Direct"];
            [myDelegate.ZHDic setObject:num forKey:@"betType" ];
        }
        //前一 201 和 任八 208 没有 复式
        else if(intstrunits > 1 && [bet betType] != 208 && [bet betType] != 201)
        {
            NSNumber *num = [bettypedic objectForKey:@"Double"];
            [myDelegate.ZHDic setObject:num forKey:@"betType" ];
        }
        else
        {
            NSNumber *num = [bettypedic objectForKey:@"Single"];
            [myDelegate.ZHDic setObject:num forKey:@"betType" ];
        }
        units += intstrunits;
        //        NSString *str = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
        NSString * str = bet.betNumbersDesc.string;
        str = [str stringByReplacingOccurrencesOfString:@"[胆:" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"#"];
        playtype = [self getPlayType:i];
        
        if([catchcontent isEqualToString:@""])
        {
            catchcontent = str;
        }
        else{
            catchcontent = [catchcontent stringByAppendingString:@";"];
            catchcontent = [catchcontent stringByAppendingString:str];
        }
    }
    [myDelegate.ZHDic setObject:catchcontent forKey:@"catchContent"];
    [myDelegate.ZHDic setObject:beginIssue forKey:@"beginIssue"];
    //playType
    NSNumber * playType;
    
    switch ([playtype intValue]) {
        case 212:
            playType = [NSNumber numberWithInt:202];
            break;
        case 213:
            playType = [NSNumber numberWithInt:203];
            break;
        case 214:
            playType = [NSNumber numberWithInt:204];
            break;
        case 215:
            playType = [NSNumber numberWithInt:205];
            break;
        case 216:
            playType = [NSNumber numberWithInt:206];
            break;
        case 217:
            playType = [NSNumber numberWithInt:207];
            break;
        case 222:
            playType = [NSNumber numberWithInt:221];
            break;
        case 232:
            playType = [NSNumber numberWithInt:231];
            break;
        case 229:
            playType = [NSNumber numberWithInt:220];
            break;
        case 239:
            playType = [NSNumber numberWithInt:230];
            break;
        default:
            playType = [NSNumber numberWithInt:[playtype intValue]];;
            break;
    }
  
    LotteryBet *betTemp = [betslist lastObject];
    if (betTemp.orderBetPlayType) {
        playType = [NSNumber numberWithInt:[betTemp.orderBetPlayType intValue]];
    }
    myDelegate.ZHDic[@"playType"] = playType;
    int surplusissue =[tfQiText.text intValue];
    if(surplusissue==0)
    {
        surplusissue = 1;
    }
    NSString *mutiple =tfBeiText.text;
    if([mutiple isEqualToString:@""])
    {
        mutiple = @"1";
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger i=0;i<surplusissue;i++)
    {
        NSString *Roundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
        NSInteger intString = [Roundnum integerValue];
        NSString *curRoundnum = [NSString stringWithFormat:@"%zd", intString+i];
        //以期号初始化字典
        NSMutableDictionary *issdic =[NSMutableDictionary dictionaryWithObjectsAndKeys:curRoundnum, @"issueNumber",nil];
        //追号状态(追号中,停追,取消)
        [issdic setObject:@"0" forKey:@"catchStatus"];
        [issdic setObject:@"0.0" forKey:@"bonus"];
        [issdic setObject:mutiple forKey:@"mutiple"];
        [issdic setObject:@"0" forKey:@"payStatus"];
        NSString *str_units = [NSString stringWithFormat:@"%d",units];
        [issdic setObject:str_units forKey:@"units"];
        int_units = units;
        [issdic setObject:@"0" forKey:@"winningStatus"];
        [issdic setObject:subscristr forKey:@"subscription"];
        [array addObject:issdic];
    }
    [myDelegate.ZHDic setObject:array forKey: @"catchList"]
    ;
    //中奖后是否停追
    if(zhuihaoBtn.selected)
    {
        [myDelegate.ZHDic setObject:@"WINSTOP"forKey:@"winStopStatus"];
    }
    else
    {
        [myDelegate.ZHDic setObject:@"NOTSTOP"forKey:@"winStopStatus"];
    }
    [myDelegate.ZHDic setObject:@"0"forKey:@"winStatus"];
    [myDelegate.ZHDic setObject:@"2"forKey:@"betSource"];
    [myDelegate.ZHDic setObject:tfQiText.text forKey:@"totalCatch"];
    [myDelegate.ZHDic setObject:tfQiText.text forKey:@"catchIndex"];
    [myDelegate.ZHDic setObject:@"0.0"forKey:@"orderbonus"];
    [myDelegate.ZHDic setObject:@"0.0"forKey:@"bonus"];
    
    [myDelegate.ZHDic setObject:@"0" forKey:@"catchStatus"];
    [myDelegate.ZHDic setObject:@"0" forKey:@"catchType"];
    NSDate * timeDate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * morelocationString=[dateformatter stringFromDate:timeDate];
    [myDelegate.ZHDic setObject:morelocationString forKey:@"modifyTime"];
    [myDelegate.ZHDic setObject:morelocationString forKey:@"createTime"];
    [myDelegate.ZHDic setObject:self.lottery.identifier forKey:@"lottery"];
}

-(NSString *)getPlayType:(int)i
{
    NSArray *betslist = [self.transaction allBets];
    NSString *betType = [betslist[i] valueForKey:@"betTypeDesc"];
    NSString *playType;
    if([betType isEqualToString:@"任选五"])
    {
        playType = @"205";
    }
    else if([betType isEqualToString:@"任选二"])
    {
        playType = @"202";
    }
    else if([betType isEqualToString:@"任选二胆托"])
    {
        playType = @"212";
    }
    else if([betType isEqualToString:@"任选五胆托"])
    {
        playType = @"215";
    }
    else if([betType isEqualToString:@"任选三"])
    {
        playType = @"203";
    }
    else if([betType isEqualToString:@"任选三胆托"])
    {
        playType = @"213";
    }
    else if([betType isEqualToString:@"任选四"])
    {
        playType = @"204";
    }
    else if([betType isEqualToString:@"任选四胆托"])
    {
        playType = @"214";
    }
    else if([betType isEqualToString:@"任选六"])
    {
        playType = @"206";
    }
    else if([betType isEqualToString:@"任选六胆托"])
    {
        playType = @"216";
    }
    else if([betType isEqualToString:@"任选七"])
    {
        playType = @"207";
    }
    else if([betType isEqualToString:@"任选七胆托"])
    {
        playType = @"217";
    }
    else if([betType isEqualToString:@"任选八"])
    {
        playType = @"208";
    }
    else if([betType isEqualToString:@"前一"])
    {
        playType = @"201";
    }
    else if([betType isEqualToString:@"前二直选"])
    {
        playType = @"220";
    }
    else if([betType isEqualToString:@"前二直选复式"])
    {
        playType = @"229";
    }
    else if([betType isEqualToString:@"前三直选"])
    {
        playType = @"230";
    }
    else if([betType isEqualToString:@"前三直选复式"])
    {
        playType = @"239";
    }
    
    else if([betType isEqualToString:@"前二组选"])
    {
        playType = @"221";
    }
    else if([betType isEqualToString:@"组二胆拖"])
    {
        playType = @"222";
    }
    
    else if([betType isEqualToString:@"前三组选"])
    {
        playType = @"231";
    }
    else if([betType isEqualToString:@"组三胆拖"])
    {
        playType = @"232";
    }
    
    else if([betType isEqualToString:@"任选二胆拖"])
    {
        playType = @"212";
    }
    else if([betType isEqualToString:@"任选三胆拖"])
    {
        playType = @"213";
    }
    else if([betType isEqualToString:@"任选四胆拖"])
    {
        playType = @"214";
    }
    else if([betType isEqualToString:@"任选五胆拖"])
    {
        playType = @"215";
    }
    else if([betType isEqualToString:@"任选六胆拖"])
    {
        playType = @"216";
    }
    else if([betType isEqualToString:@"任选七胆拖"])
    {
        playType = @"217";
    }else if ([betType isEqualToString:@"乐选二"]){
        
        playType = @"502";
    }else if ([betType isEqualToString:@"乐选三"]){
        
        playType = @"503";
    }else if ([betType isEqualToString:@"乐选四"]){
        
        playType = @"504";
    }else if ([betType isEqualToString:@"乐选五"]){
        
        playType = @"505";
    }
    return playType;
}
/*Dlt追期显示*/
-(void) loadzhuiqi
{

    if(self.transaction.allBets == 0)
    {
        _issue = 1;
        self.transaction.qiShuCount = _issue;
    }
    _issue = self.transaction.qiShuCount;
    
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)_issue];
    if(![str isEqualToString:@"(null)"]&&![str isEqualToString:@"1"])
    {
        tfQiText.text = str;
    }
    else
    {
        tfQiText.text = @"1";
    }
}
/*Dlt倍数显示*/
-(void) loadbei
{
    //zwl 16-01-12

    if(self.transaction.allBets .count == 0)
    {
        _multiple = 1;
        self.transaction.beiTouCount = _multiple;
    }
    _multiple = self.transaction.beiTouCount;
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)_multiple];
    if(![str isEqualToString:@"(null)"]&&![str isEqualToString:@"1"])
    {
        tfBeiText.text = str;
    }
    else
    {
        tfBeiText.text = @"1";
    }
}


-(void)appendbtnClick
{
    appendBtn.selected = !appendBtn.selected;
    if(appendBtn.selected)
    {
        [appendBtn setImage:[UIImage imageNamed:@"png_btn_agree_pressed.png"] forState:UIControlStateSelected];
        self.transaction.needZhuiJia = YES;
    }
    else
    {
        [appendBtn setImage:[UIImage imageNamed:@"png_btn_agree.png"] forState:UIControlStateNormal];
        self.transaction.needZhuiJia = NO;
    }
    [self updateSummary];
    [tableViewContent_ reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)actionSelectQiCount:(UIButton *)sender {
    for (UIButton *item in _qCountItembtn) {
        item.selected = NO;
    }
    sender.selected = YES;
    NSInteger num = sender.tag;
    NSString * curRoundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
    NSInteger length = [curRoundnum length];
    NSString *strcut = [curRoundnum substringFromIndex:length-2];
    unsigned long curiss = [strcut intValue];
    unsigned long count;
    if([_lottery.identifier isEqualToString:@"SX115"] )
    {
        count = MAXQI11X5 - curiss + 1;
        
    }else{
        count = MAXQISD11X5 - curiss + 1;
    }
    if(num > count)
    {
        tfQiText.text = [NSString stringWithFormat:@"%lu", count];
        [self showPromptText:[NSString stringWithFormat:@"今日最大可追%lu期，系统不支持跨日追号", count] hideAfterDelay:1.7];
        sender.selected = NO;
    }else{
        tfQiText.text = [NSString stringWithFormat:@"%ld",sender.tag];
    }
    
    [self updateSummary];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField .text integerValue] ==0){
        textField.text = @"1";
    }
    textField.text = [NSString stringWithFormat:@"%ld",[textField .text integerValue]];
    for (UIButton *item in _qCountItembtn) {
        item.selected = NO;
    }
    
    [self updateSummary];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat height = self.navigationController.navigationBar.mj_h;
//        NSLog(@"%@",self.navigationController.navigationBar);
//    });
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tfBeiText resignFirstResponder];
    [tfQiText resignFirstResponder];
}

- (int)getIssnum{
    NSString *issuNum = [NSString stringWithFormat:@"%@",tfQiText.text];
    int issnum = [issuNum intValue];
    return issnum;
}
//输入控制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_lottery.currentRound == nil) {
        [self showPromptText:@"当前时间没有奖期,请稍后进行更改" hideAfterDelay:1.7];
        return NO;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSMutableString*numStr = [[NSMutableString alloc]initWithString:textField.text];
    [numStr appendString:string];
    NSInteger num = [numStr integerValue];
    NSInteger limitNum;
    if (textField == tfBeiText) {
        if ([tfQiText.text integerValue] == 1) {
            limitNum = 9999;
        }else{
            limitNum = 99;
        }
        if (num > limitNum) {
            [self showPromptText:[NSString stringWithFormat:@"最大可投%ld倍",limitNum] hideAfterDelay:1.8];
            return NO;
        }
        self.transaction.beiTouCount =num;
    } else {
        //获得剩余奖期
        for (UIButton *item in _qCountItembtn) {
            item.selected = NO;
        }
        NSString * curRoundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
        NSInteger length = [curRoundnum length];
        NSString *strcut = [curRoundnum substringFromIndex:length-2];
        unsigned long curiss = [strcut intValue];
        unsigned long count;
        if([_lottery.identifier isEqualToString:@"SX115"] )
        {
            count = MAXQI11X5 - curiss + 1;
            
        }else{
            count = MAXQISD11X5 - curiss + 1;
        }
        if(num >count)
        {
            tfQiText.text = [NSString stringWithFormat:@"%lu", count];
            [self showPromptText:[NSString stringWithFormat:@"今日最大可追%lu期，系统不支持跨日追号", count] hideAfterDelay:1.7];
            [self performSelector:@selector(updateSummary) withObject:nil afterDelay:0.1];
            return NO;
        }
    }
    
    [self performSelector:@selector(updateSummary) withObject:nil afterDelay:0.1];
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


-(void)initediateScheme:(NSString *)schemeNO{
    
    [self hideLoadingView];
    
}
- (IBAction)actionZhiNengZH:(id)sender {
    [self betzhuihao];
}

-(void)goonBuy{
    
}


-(void)updateMemberClinet{
    
    NSDictionary *MemberInfo;
    NSString *cardCode =self.curUser.cardCode;
    if (cardCode == nil) {
        return;
    }
    MemberInfo = @{@"cardCode":cardCode
                   };
    [self.memberMan getMemberByCardCodeSms:(NSDictionary *)MemberInfo];
}
-(void)getMemberByCardCodeSms:(NSDictionary *)memberInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"memberInfo%@",memberInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        User *user = [[User alloc]initWith:memberInfo];
        
        self.curUser.notCash = user.notCash;
        self.curUser.balance = user.balance;
        self.curUser.sendBalance = user.sendBalance;
       
        [self payForZHOrderInfo:ZHOrderInfoTemp[@"orderNeedInfo"] andQishu:[ZHOrderInfoTemp[@"qi"] intValue]];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

@end
