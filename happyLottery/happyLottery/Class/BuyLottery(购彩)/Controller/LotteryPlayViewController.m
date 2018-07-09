
//
//  LotteryPlayViewController.m
//  Lottery
//
//  Created by AMP on 5/23/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryPlayViewController.h"
#import "WebCTZQHisViewController.h"
#import "OmitEnquiriesViewController.h"
#import "OptionSelectedView.h"
#import "LotteryBet.h"

#import "LotteryTransaction.h"
#import "NumberSelectView.h"
#import "LotteryManager.h"
#import "ExprieRoundView.h"
#import "LotteryExtrendViewController.h"
#import "LotteryInstructionViewController.h"
#import "LotteryInstructionDetailViewController.h"
//
#import "Lottery.h"
#import "LotteryXHView.h"
#import "LotteryBetsPopView.h"
#import "LotteryTitleView.h"
#import "TouZhuViewController.h"
#import "LotteryPhaseInfoView.h"
#import "LotteryWinNumHistoryViewController.h"
#import "X115LotteryProfileSelectView.h"
#import "DateTools.h"
#import "ZLAlertView.h"
#import "X115LimitNum.h"
//跳转到查遗漏的界面
#import "OmitEnquiriesViewController.h"
#define BackAlertTag 20

#define DltInvalidAlertTag  300

@interface LotteryPlayViewController() <LotteryXHViewDelegate, UIActionSheetDelegate, LotteryBetsPopViewDelegate, LotteryTitleViewDelegate, TouZhuViewControllerDelegate, UIScrollViewDelegate, LotteryPhaseInfoViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,LotteryManagerDelegate,OptionSelectedViewDelegate,X115LotteryProfileSelectViewDelegate>


{
    __weak IBOutlet UILabel *labLimitNumInfo;
    NSTimer * timerForcurRound;
    X115LimitNum * _model;
    OptionSelectedView*optionView ;
    NSString *sd115MissUrl;
    __weak IBOutlet UILabel *flagLable;
    __weak IBOutlet UIView *viewContent_;
    UIScrollView *scrollViewContent_;
    UILabel *sepLine;
    X115LotteryProfileSelectView *profileSelectView;
    UILabel *labelInstruction;
    __weak IBOutlet UIView *viewBottom_;
    BOOL pageLoaded;
    int _contentSVlastPosition;
    NSMutableArray *limitArray;
    LotteryXHView *lotteryXHView;
    LotteryPhaseInfoView *phaseInfoView;
    LotteryBet *lotteryBet;
    
    IBOutlet LotteryBetsPopView *lotteryBetsPopView_;
    __weak IBOutlet NumberSelectView *numberSelectView_;
    
    __weak IBOutlet UIButton *ClearXHBtn;
    __weak IBOutlet UIButton *buttonAdd_;
    __weak IBOutlet UIButton *buttonClear;
    __weak IBOutlet UILabel *labelSummary_;
    __weak IBOutlet UILabel *labelSummary;
    __weak IBOutlet UIButton *buttonSubmit;
    __weak IBOutlet UIButton *buttonSubmit_;
    
    ExprieRoundView *expireTableView;
    LotteryTitleView *titleView;
    __weak IBOutlet UIView *viewBadgeSuperView_;
    
    __block LotteryManager *lotteryMan;
    // 展示以往奖期
    CGFloat scrollViewContentOffset;
    CGFloat expireTablveHeight;
    
    IBOutletCollection(NSLayoutConstraint) NSArray *sepHeight;


    BOOL isShowFLag;
    
}

@property(nonatomic,strong)User *curUser;

@property(nonatomic,strong)GlobalInstance *instance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDlt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomDlt;


@property (nonatomic , strong) NSString * touzhuErrorString;
//查遗漏按钮
@property (nonatomic, strong) UIButton * qmitBtn;
@property (nonatomic, strong) UILabel * labQmit;
@property (nonatomic, strong) UIImageView *fengeImage;
@end

@implementation LotteryPlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self isIphoneX]){
        self.topDlt.constant = 88;
        self.BottomDlt.constant = 38;
    }else{
        self.topDlt.constant = 64;
        self.BottomDlt.constant = 0;
    }
    self.lotteryMan.delegate = self;
    if ([self.lottery.identifier isEqualToString:@"SD115"]) {
        [self.lotteryMan getCommonSetValue:@{@"typeCode":@"number_miss",  @"commonCode":@"SDX115_miss"}];
    }
   
    limitArray  = [NSMutableArray arrayWithCapacity:0];
    if (self.lottery.type == LotteryTypeSDShiYiXuanWu) {
        self.viewControllerNo = @"A426";
    }
    else {
        self.viewControllerNo = @"A003";
    }

    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.curNavVC = self.navigationController;
//    每当此页面加载的时候，将十一选五的中奖停追设置为是。
    myDelegate.iswinStop = YES;
    pageLoaded = NO;
    for (NSLayoutConstraint *sepH in sepHeight) {
        sepH.constant = SEPHEIGHT;
    }
    


    buttonSubmit.layer.masksToBounds = YES;
    buttonSubmit.layer.cornerRadius = 4;
    buttonSubmit_ .titleLabel.font = [UIFont systemFontOfSize:15];
    
    [buttonSubmit_ setTitle: @"预约投注" forState: UIControlStateNormal];
    [buttonSubmit_ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    buttonSubmit_.backgroundColor = [UIColor whiteColor];
    
    UIButton *optionButton = [UIButton buttonWithType: UIButtonTypeCustom];
    optionButton.frame = CGRectMake(0, 0, 64, 44);
    
    [optionButton setTitle:@"助手" forState:UIControlStateNormal];
    [optionButton setImage:[UIImage imageNamed:@"helper.png"] forState:UIControlStateNormal];
    optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [optionButton setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
    [optionButton addTarget: self action: @selector(optionRightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: optionButton];
    
    if (self.lottery.activeProfile ==nil ||![self.isOmit isEqualToString:@"YES"]) {
        [self.lotteryMan loadLotteryProfiles: self.lottery];
    }
    
    if (self.isReBuy == YES) {
        for (LotteryXHProfile * lottery in self.lottery.profiles) {
            if ([lottery.title isEqualToString: self.rebuyTitle]) {
                self.lottery.activeProfile = lottery;
                break;
            }
        }
    }
    if (nil == _lotteryTransaction) {
        _lotteryTransaction = [[LotteryTransaction alloc] init];
        _lotteryTransaction.needZhuiJia = NO;
        _lotteryTransaction.beiTouCount = 1;
        _lotteryTransaction.qiShuCount = 1;
        _lotteryTransaction.lottery = self.lottery;
    }
    
  
    [self getCurrentRound];

//  2016-03-18  购彩页面模拟点击 跳转投注界面。
    [self beginTimerForCurRound];
    [self getHisIssue];
    [self currentBet:nil];
}
-(void)lookOpenHis:(UIButton *)sender{
    
    if (scrollViewContent_.contentOffset.y != 0) {
        // 向上
        
        [UIView animateWithDuration:0.2 animations:^{
           scrollViewContent_.contentOffset = CGPointMake(0,0);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            scrollViewContent_.contentOffset = CGPointMake(0,-expireTablveHeight);
        }];
    }
}
-(void)gotCommonSetValue:(NSString *)strUrl{
    if (strUrl == nil || strUrl.length == 0) {
        return;
    }
    sd115MissUrl = strUrl;
    [self addQmitButton];
}
- (void) getCurrentRound{
    NSLog(@"开始请求奖期。");
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
}

-(void)getHisIssue{
    [self.lotteryMan getListHisIssue:@{@"lottery":self.lottery.identifier,@"size":@10}];
}

-(void) gotListHisIssue:(NSArray *)infoDic errorMsg:(NSString *)msg{
    
    if(infoDic.count == 0 || infoDic == nil){
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in infoDic) {
        DltOpenResult *model = [[DltOpenResult alloc]initWith:dic];
        [results addObject:model];
    }
    expireTablveHeight = ExpireTableViewCellH * 10;
    
    CGRect fram = CGRectMake(0, 0-expireTablveHeight, viewContent_.frame.size.width, expireTablveHeight);
    expireTableView = [[ExprieRoundView alloc] initWithFrame:fram];
    expireTableView.lottery = _lottery;
    
    [scrollViewContent_ addSubview:expireTableView];
    scrollViewContent_.contentInset = UIEdgeInsetsMake(expireTablveHeight, 0, 0, 0);
    expireTableView.contentOffset = CGPointMake(0, ExpireTableViewCellH * 10);
    expireTableView.rounds = results;
    [expireTableView reloadData];
}

-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    if (infoDic == nil || infoDic .count == 0) {
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    self.lottery.currentRound = [infoDic firstObject];
    self.lotteryTransaction.lottery.currentRound = [infoDic firstObject];
    
    NSLog(@"timer sile");
    if (phaseInfoView) {
        [phaseInfoView showCurRoundInfo];
    }
    
}
#pragma mark  玩法介绍
- (void) showPlayMethod{
    //2  dlt ,0 x115,1  jczq;
     NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic;
    if([self.lottery.identifier isEqualToString:@"SD115"]){
        infoDic = infoArr[11];
    }else{
        infoDic = infoArr[0];
    }
    

    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: detailVC animated: YES];
}

- (IBAction) clearAllSelection {
    [self newBet];
    [lotteryXHView clearAllSelection];
}
- (IBAction)currentBet:(id)sender{
    
    if ([_lotteryTransaction betCount] > 0 || _lotteryTransaction.allBets.count >1) {
        //            return nil;
//        for (LotteryXHProfile * lottery in self.lottery.profiles) {
//            if ([lottery.title isEqualToString: self.rebuyTitle]) {
//                self.lottery.activeProfile = lottery;
//                break;
//            }
//        }
        
        TouZhuViewController *touzhuVC = [[TouZhuViewController alloc] initWithNibName: @"TouZhuViewController" bundle: nil];
        touzhuVC.lottery = self.lottery;
        if (!self.lottery.currentRound) {
            [self getCurrentRound];
        }
        NSLog(@"yaoguoqule%@",timerForcurRound);
        touzhuVC.timerForcurRound = timerForcurRound;
        touzhuVC.transaction = _lotteryTransaction;
        
        touzhuVC.delegate = self;
        [self.navigationController pushViewController: touzhuVC animated: YES];
    }else{
        NSLog(@"nononono");
        if (nil==sender) {
            
        }else{
            [self showPromptText:TextNoBetInBasket hideAfterDelay:1.7];
        }

    }
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    

    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [lotteryBetsPopView_ refreshBetListView: _lotteryTransaction];//刷新号码篮
    if ([self.tempResource isEqualToString:@"BetPayViewController"]) {
        [self.lotteryTransaction removeAllBets];
        myDelegate.betlistcount = 0;
        self.tempResource = @"";
        [self betTransactionUpdated];
        [self clearAllSelection];
    }
    if (isShowFLag) {
        [self.view bringSubviewToFront:flagLable];
    }else{
        if (profileSelectView != nil) {
            [self.navigationController.view addSubview: profileSelectView];
            [self.navigationController.view sendSubviewToBack: profileSelectView];
        }
        if (!pageLoaded) {
            [self loadUI];
        }
    }
    
    if ([self.lottery.activeProfile.profileID isEqualToString:@"4"]) { // 默认任选五重新设置profileId
        NSUserDefaults *profileId = [NSUserDefaults standardUserDefaults];
        [profileId setInteger:0 forKey:@"profileId"];
        [profileId synchronize];
    }
    
    if (self.isReBuy == YES) {
        [self newBet];
        [lotteryXHView rebuyShowNum:self.selectedNumber];
        self.selectedNumber = nil;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    if (profileSelectView != nil) {
        [profileSelectView removeFromSuperview];
    }
    if ([timerForcurRound isValid]) {
        [timerForcurRound setFireDate:[NSDate distantFuture]];
        NSLog(@"tinrle");
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [lotteryXHView becomeFirstResponder];
    //  temp for appStore
      [self updateNavigationTitle];
    if([self.lottery.identifier isEqualToString:@"SX115"]){
    [self addQmitButton];
    }else{
        if (sd115MissUrl != nil) {
            [self addQmitButton];
        }
    }
    
    [timerForcurRound setFireDate:[NSDate date]];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    [lotteryXHView resignFirstResponder];
 
}

- (void) navigationBackToLastPage{
    [self backRemoveAllBet];
}
- (void)showBackAlert{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:TextBackFromPlayPageAlert];
    [alert addBtnTitle:TitleNo action:^{
        
    }];
    [alert addBtnTitle:TitleYes action:^{
        _lottery.allRoundsInfo = nil;
        [self removeTimer];
        [super navigationBackToLastPage];
    }];
    [alert showAlertWithSender:self];
}

- (void)backRemoveAllBet{
    if ([_lotteryTransaction allBets].count != 0) {
        [self showBackAlert];
        return;
    }

    _lottery.allRoundsInfo = nil;
    [self removeTimer];
    [super navigationBackToLastPage];
}
#define PhaseInfoHeight 20

- (void) loadUI {
//    [self showLoadingViewWithText: TextLoading];
    [self newBet];
    CGFloat curY = 0;
    [self loadConentView:curY];
    pageLoaded = YES;
    [self hideLoadingView];
}


- (void)loadConentView:(float)curY{
 
    NSString * lotteryIdentify = _lottery.identifier;
    //add this phase information
    //期号: 054   距截止还有 1天5小时
    
        CGRect phaseSectionFrame = CGRectMake(0, 0, CGRectGetWidth(viewContent_.frame), 0);
        phaseSectionFrame.origin.y = curY;
        phaseSectionFrame.size.height = PhaseInfoHeight * 2;
    if(phaseInfoView == nil){
        phaseInfoView = [[LotteryPhaseInfoView alloc] initWithFrame: phaseSectionFrame];
        phaseInfoView.delegate = self;
        [viewContent_ addSubview: phaseInfoView];
    }
    
        [phaseInfoView drawWithLottery: self.lottery];
    
        
//        if (!_lottery.currentRound) {
            [self beginTimerForCurRound];
//        }
        if (scrollViewContent_ != nil) {
            NSArray * array = [scrollViewContent_ subviews];
            for (UIView * view in array){
                if (![view isKindOfClass:[ExprieRoundView class]]) {
                    [view removeFromSuperview];
                }
            }
        }else{
            scrollViewContent_ = [[UIScrollView alloc] initWithFrame: CGRectMake(0, PhaseInfoHeight * 2, KscreenWidth, KscreenHeight-PhaseInfoHeight*2)];
            scrollViewContent_.backgroundColor = [UIColor whiteColor];
            scrollViewContent_.delegate = self;
            scrollViewContent_.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
            
            [viewContent_ addSubview: scrollViewContent_];
        }
    //        curY = CGRectGetMaxY(phaseInfoView.frame);
        //add insturction
        if ([self.lottery.activeProfile.desc length] > 0) {
            //至少选择5个前区号码，2个后区
            CGRect instructionSectionFrame = scrollViewContent_.bounds;
            CGRect sepLineFrame = instructionSectionFrame;
            sepLineFrame.origin.y = instructionSectionFrame.origin.y ;
            sepLineFrame.size.height = SEPHEIGHT;
            instructionSectionFrame.origin.y += SEPHEIGHT;
            instructionSectionFrame.size.height -= SEPHEIGHT;
            if (!sepLine) {
                sepLine = [[UILabel alloc] init];
                sepLine.backgroundColor = SEPCOLOR;
            }
            sepLine.frame = sepLineFrame;
            
            
            
            
            instructionSectionFrame.origin.x = LEFTPADDING;
            instructionSectionFrame.size.width -= 10;
            instructionSectionFrame.size.height = 40;
            if(labelInstruction == nil){
                instructionSectionFrame.origin.y = curY;
            }else{
                instructionSectionFrame.origin.y = labelInstruction.mj_y;
            }
            labelInstruction = [[UILabel alloc] initWithFrame: instructionSectionFrame];
            labelInstruction.backgroundColor = [UIColor clearColor];
            labelInstruction.font = [UIFont systemFontOfSize: 11];
            labelInstruction.textColor = TEXTGRAYCOLOR;
            labelInstruction.adjustsFontSizeToFitWidth = YES;
            
            [scrollViewContent_ addSubview: labelInstruction];
           
            labelInstruction.text = self.lottery.activeProfile.desc;
            NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:labelInstruction.text];
            NSString *temp = @"";
            for (NSInteger i =0; i<[labelInstruction.text length]; i++) {
                temp = [labelInstruction.text substringWithRange:NSMakeRange(i, 1)];
                if ([self isInt:temp] ) {
                    [attStr setAttributes:@{NSForegroundColorAttributeName:TextCharColor} range:NSMakeRange(i, 1)];
                }
            }
            labelInstruction.attributedText = attStr;
           
            
            curY = CGRectGetMaxY(labelInstruction.frame);
        }
        if (!pageLoaded) {
            //set up bet list pop view
            [lotteryBetsPopView_ initUI];
            lotteryBetsPopView_.delegate = self;
            [numberSelectView_ setup];
        }
        //add xuan hao section
        if (lotteryXHView != nil) {
            [lotteryXHView removeFromSuperview];
            lotteryXHView.delegate = nil;
            lotteryXHView = nil;
            [self newBet];
        }
        
        CGRect numberSectionFrame = scrollViewContent_.bounds;
        numberSectionFrame.origin.y = curY;
        lotteryXHView = [[LotteryXHView alloc] initWithFrame: numberSectionFrame];
        lotteryXHView.delegate = self;
        lotteryXHView.lotteryBet = lotteryBet;
        lotteryXHView.backgroundColor = [UIColor clearColor];
        lotteryXHView.numberSelectView = numberSelectView_;
        [scrollViewContent_ addSubview: lotteryXHView];
        //add shake to bet
        [lotteryXHView becomeFirstResponder];
        

        
        //draw xuanhao section
        [lotteryXHView drawWithLottery: self.lottery];
        
        CGFloat maxHeight = CGRectGetMaxY(lotteryXHView.frame);
        if (maxHeight > CGRectGetMaxY(scrollViewContent_.frame)) {
            CGSize contentSize = scrollViewContent_.frame.size;
            contentSize.height = maxHeight - scrollViewContent_.frame.origin.x+65 + 200;
            scrollViewContent_.contentSize = contentSize;
        }else{
            scrollViewContent_.contentSize = CGSizeMake(CGRectGetWidth(scrollViewContent_.frame), CGRectGetHeight(scrollViewContent_.frame)+220);
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTimerForCurRound) name:@"RoundTimeDownFinish" object:nil];
    if([self.lottery.identifier isEqualToString:@"SX115"]){
        [self addQmitButton];
    }else{
        if (sd115MissUrl != nil) {
            [self addQmitButton];
        }
    }
}

- (void) updateNavigationTitle {
        if (titleView == nil) {
            titleView = [[LotteryTitleView alloc] initWithFrame: CGRectMake(0, 0, 180, 44)];
            titleView.delegate = self;
        }
        [titleView updateWithLottery: self.lottery];
        
        if(profileSelectView == nil){
            profileSelectView = [[X115LotteryProfileSelectView alloc] initWithFrame: self.view.bounds];
            [profileSelectView initUIWithLottery: self.lottery resource:nil];
            profileSelectView.delegate = self;
            [self.navigationController.view addSubview: profileSelectView];
            [self.navigationController.view sendSubviewToBack: profileSelectView];
        }
        self.navigationItem.titleView = titleView;
}

- (void) newBet {
    lotteryBet = [[LotteryBet alloc] init];
    lotteryBet.betXHProfile = self.lottery.activeProfile;
    lotteryBet.betLotteryIdentifier = self.lottery.identifier;
    lotteryBet.betLotteryType = self.lottery.type;
    
    lotteryBet.sectionDataLinkSymbol = self.lottery.dateSectionLinkSymbol == nil?@";":self.lottery.dateSectionLinkSymbol;
    lotteryXHView.lotteryBet = lotteryBet;
    [self betInfoUpdated];
}

- (void) optionRightButtonAction {
    if (isShowFLag) {
        return;
    }
    NSArray *titleArr = @[@" 走势图  ",
                 @" 开奖详情",
                 @" 玩法规则"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
     optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, NaviHeight, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
}

- (IBAction)showNumberBasket:(id)sender {
    if ([_lotteryTransaction betCount] > 0) {
        //show basket
        lotteryXHView.randomStatus = RandomBetStatusAdd;
        [lotteryBetsPopView_ refreshBetListView: _lotteryTransaction];
        [self.view bringSubviewToFront: lotteryBetsPopView_];
    } else {
        [self showPromptText: TextNoBetInBasket hideAfterDelay: 1.7];
    }
}

- (void) addBetToBasket {
    [_lotteryTransaction addBet: lotteryBet];
    [self betTransactionUpdated];
}
- (void) betTransactionUpdated {
    
}
- (IBAction)addBetAction_:(id)sender {
    NSString * errorMsg = [_lotteryTransaction couldTouzhu];
    if (errorMsg) {
        self.touzhuErrorString = errorMsg;
//        [self showPromptText: errorMsg hideAfterDelay: 1.7];
        return;
    }
    if ([lotteryBet getBetCount] > 0) {
        //add to bet basket
        [self addBetToBasket];
        [self clearAllSelection];
    } else {
        self.touzhuErrorString = TextNotEnoughBet;
//        [self showPromptText: TextNotEnoughBet hideAfterDelay: 1.7];
    }
}
/*
 1. check if any selected
 2. check if any bet
 */
- (NSString *) couldTouZhu {
    //check current bet
    {//20160601--非单式投注注数必须大于2
        [lotteryBet updateBetInfo];
        [lotteryBet betType];
        NSString *betTypeDesc = lotteryBet.betTypeDesc;
        BOOL isNomalBet = YES;
        if ([betTypeDesc containsString:@"胆拖"]||[betTypeDesc containsString:@"复式"]) {
            isNomalBet = NO;
        }
        if (! isNomalBet &&[lotteryBet getBetCount]<2) {
            return TextNotNomalBet;
        }
    }
    if ([lotteryBet getBetCount] ) {
        //add bet
        [self addBetAction_: nil];
        return nil;
    }
    return TextNotEnoughBet;
}

//时间判断  待完成
- (BOOL)isCanBuyNow{
    
    
    return YES;
}
- (IBAction)touZhuAction:(id)sender {
    if([lotteryBet getBetCost] > 300000)
    {
        [self showPromptText:TextTouzhuExceedLimit hideAfterDelay:1.7];
        return;
    }
    
    if([lotteryBet getBetCount] > 10000)
    {
        [self showPromptText:@"单次投注注数不能超过1万注" hideAfterDelay:1.7];
        return;
    }
    
    if (!_lottery.currentRound||[_lottery.currentRound isExpire]) {
        [self showPromptText:ErrorWrongRoundExpird hideAfterDelay:1.7];
        return;
    }
    LotteryXHSection *section = lotteryBet.lotteryDetails[0];
    if ([section.needDanHao integerValue]==1&&section.numbersSelected.count == 0) {
        [self showPromptText: @"至少选择一个胆码" hideAfterDelay: 1.7];
        return;
    }
    NSString * errorMsg = [self couldTouZhu];
    if (_touzhuErrorString) {
        [self showPromptText: _touzhuErrorString hideAfterDelay: 1.7];
        self.touzhuErrorString = nil;
        return;
    }
    
    if (errorMsg) {
        [self showPromptText: errorMsg hideAfterDelay: 1.7];
        return;
    }
    
    TouZhuViewController *touzhuVC = [[TouZhuViewController alloc] initWithNibName: @"TouZhuViewController" bundle: nil];
    touzhuVC.lottery = self.lottery;
    
    
    touzhuVC.transaction = _lotteryTransaction;
    touzhuVC.timerForcurRound = timerForcurRound;
    touzhuVC.delegate = self;
    [self.navigationController pushViewController: touzhuVC animated: YES];
}

-(void)beginTimerForCurRound{
//    [timerForcurRound invalidate];//强制定时器失效
//    NSLog(@"timer sile");
//    timerForcurRound = nil;
    if (!timerForcurRound||![timerForcurRound isValid]) {
        timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getCurrentRound) userInfo:nil repeats:YES];
    }
    [timerForcurRound fire];
}

#pragma mark - LotteryXHViewDelegate methods

-(BOOL)selectArray:(NSArray *)array ContentOBJ:(NSString *)limitStr{
    for (NSString *item in array) {
        for (NSString  * itemLimit in [limitStr componentsSeparatedByString:@","]) {
            if ([item integerValue ] == [itemLimit integerValue]) {
               limitStr = [limitStr stringByReplacingOccurrencesOfString:itemLimit withString:@""];
            }
        }
    }
    limitStr = [limitStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (limitStr.length == 0) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)checkLimitNum:(NSString *)selectNum{
    BOOL preIsAbleBuy = NO;
    for (X115LimitNum *model in limitArray) {
        preIsAbleBuy = NO;
        _model = model;
        NSString *curLotteryPro;
        if ([self.lottery.activeProfile.title rangeOfString:@"胆拖"].length != 0) {
           
            curLotteryPro = [self.lottery.activeProfile.title stringByReplacingOccurrencesOfString:@"胆拖" withString:@""];
            if ([curLotteryPro isEqualToString:@"组二"]) {
                curLotteryPro = @"前二组选";
            }
            
            if ([curLotteryPro isEqualToString:@"组三"]) {
                curLotteryPro = @"前三组选";
            }
            
        }else{
            curLotteryPro = self.lottery.activeProfile.title;
        }
        if ([model.trPlayType isEqualToString:curLotteryPro] ||([model.trPlayType isEqualToString:@"任选五"] &&([curLotteryPro isEqualToString:@"任选六"] || [curLotteryPro isEqualToString:@"任选七"]||[curLotteryPro isEqualToString:@"任选八"]))) {
            if ([curLotteryPro isEqualToString:@"前三直选"] || [curLotteryPro isEqualToString:@"前二直选"] || [curLotteryPro isEqualToString:@"乐选二"] || [curLotteryPro isEqualToString:@"乐选三"]) {
                NSMutableArray *boolArray = [[NSMutableArray alloc]init];
                
                NSArray *selectArray = [selectNum componentsSeparatedByString:@"#"];
                for (NSString *items in selectArray) {
                    if (items.length == 0) {
                        return NO;
                    }
                }
                if (selectArray.count != model.limitNum.count) {
                    return NO;
                }
                
                for (int i = 0; i < model.limitNum.count ; i++) {
                    NSString* strIselect = selectArray[i];
                    [boolArray addObject:@([self selectArray:[strIselect componentsSeparatedByString:@","] ContentOBJ:model.limitNum[i]])];
                }
                
                for (NSNumber *isExit in boolArray) {
                    if ([isExit boolValue] == NO) {
                        preIsAbleBuy = NO;
                        break;
                    }else{
                        preIsAbleBuy = YES;
                    }
                }
                
                
            }else{
                selectNum = [selectNum stringByReplacingOccurrencesOfString:@"#" withString:@","];
               preIsAbleBuy = [self selectArray:[selectNum componentsSeparatedByString:@","] ContentOBJ:[model.limitNum componentsJoinedByString:@","]];
            }
            if (preIsAbleBuy == YES) {
                return YES;
            }
        }
    }
    
    return  preIsAbleBuy;
}



- (void) betInfoUpdated {
    NSMutableAttributedString *betInfoString = [[NSMutableAttributedString alloc] init];
    
    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    textAttrsDictionary[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryTotal attributes: textAttrsDictionary]];
    
    NSMutableDictionary *numberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    numberAttrsDictionary[NSForegroundColorAttributeName] = TextCharColor;
    
    //bet count string
    NSString *betCountStr = [NSString stringWithFormat: @"%d", [lotteryBet getBetCount]];
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: betCountStr attributes: numberAttrsDictionary]];
    
    //bet unit string
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@,", TextTouZhuSummaryBetUnit] attributes: textAttrsDictionary]];
    
    //bet cost string
    NSString *betCostStr = [NSString stringWithFormat: @"%d", [lotteryBet getBetCost]];
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: betCostStr attributes: numberAttrsDictionary]];
    
    //bet unit string
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: textAttrsDictionary]];
    
    NSString *selectStr = [lotteryBet numDescrption:[UIFont systemFontOfSize:12]].string;
    if (selectStr.length != 0) {
        if([self checkLimitNum:selectStr]) {
            labLimitNumInfo.hidden = NO;
            labLimitNumInfo.text = [NSString stringWithFormat:@"因限号，%@存在不能成功出票的可能，请知悉！",[_model.limitNum componentsJoinedByString:@" "]];
        }else{
            labLimitNumInfo.hidden = YES;
        }
    }else{
        labLimitNumInfo.hidden = YES;
    }
    labelSummary.attributedText = betInfoString;
    //[self sureQmitButtonIsHidden];
}
#pragma mark--确定查遗漏按钮是否显示
- (void)sureQmitButtonIsHidden
{
    NSString * string = self.lottery.activeProfile.title;
 
    if ([self.lottery.activeProfile.title isEqualToString:@"乐选二"]) {
        self.labQmit.text = @"该玩法遗漏值请参考前二直选，前二组选，任二玩法的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选三"]) {
        self.labQmit.text = @"该玩法遗漏值请参考前三直选，前三组选，任三玩法的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选四"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选三，任选四的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选五"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选五，任选四的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选二胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选二的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选三胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选三的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选四胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选四的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选五胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选五的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选六胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选六的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"任选七胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考任选七的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"组二胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考前二组选的遗漏值";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"组三胆拖"]) {
        self.labQmit.text = @"该玩法遗漏值请参考前三组选的遗漏值";
    }
    
    
}
- (void) addedNewRandomBet {
    [self addBetAction_: nil];
    if (lotteryBetsPopView_.meShown) {
        [lotteryBetsPopView_ refreshBetListView: _lotteryTransaction];
    }
}

- (BOOL)isExceedAmountLimit{
    int cost = [lotteryBet getBetCost];
    if (cost > 300000) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - OptionSelectedViewDelegate methods
- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    NSInteger buttonIndex = index;
    if (buttonIndex == 0) {
        //clear selection
        [self showExtrendViewCtr];
    }else if (buttonIndex == 1){
        [self showWinHistoryViewCtr];
    }else if (buttonIndex == 2){
        [self showPlayMethod];
    }
}

- (void)showExtrendViewCtr{

    WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/toTrend?lotteryCode=%@",H5BaseAddress,self.lottery.identifier];
    playViewVC.pageUrl = [NSURL URLWithString:strUrl];
    playViewVC.title  = [NSString stringWithFormat:@"%@开奖记录",self.lottery.name];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}

- (void) showWinHistoryViewCtr{
    WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/toHis?lotteryCode=%@",H5BaseAddress,self.lottery.identifier];
    playViewVC.pageUrl = [NSURL URLWithString:strUrl];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];

}

- (void) betListPopViewHide {
    lotteryXHView.randomStatus = RandomBetStatusShow;
}
- (void) touzhuSureAction {
    
    TouZhuViewController *touzhuVC = [[TouZhuViewController alloc] initWithNibName: @"TouZhuViewController" bundle: nil];
    touzhuVC.lottery = self.lottery;
    touzhuVC.transaction = _lotteryTransaction;
    touzhuVC.timerForcurRound = timerForcurRound;
    touzhuVC.delegate = self;
    [self.navigationController pushViewController: touzhuVC animated: YES];
    
//    [self touZhuAction:nil];
}

#pragma mark - LotteryTitleViewDelegate methods
- (void) userDidClickTitleView {
    if (profileSelectView.meShown) {
        [profileSelectView hideMe];
    } else {
        [profileSelectView showMe];
    }
}

#pragma mark - LotteryProfileSelectViewDelegate methods
- (void) userDidSelectLotteryProfile {
    [titleView updateWithLottery: self.lottery];
    
    labLimitNumInfo.hidden = YES;
    
    NSLog(@"10109 %@ ",_lottery.activeProfile.profileID );
    if (expireTableView) {
        [expireTableView refreshWithProfileID:[_lottery.activeProfile.profileID integerValue]];
    }
    
    [self loadConentView:NaviHeight - 64];
    expireTableView.lottery = _lottery;
    [expireTableView reloadData];
}

#pragma mark - TouZhuViewController methods
- (void) addRandomBet {
    [self newBet];
    [lotteryXHView addRandomBet];
    [self addBetToBasket];
    [self clearAllSelection];
}

#pragma mark--添加查遗漏按钮
- (void)addQmitButton
{
    //增加查遗漏按钮
    self.qmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.qmitBtn.backgroundColor = scrollViewContent_.backgroundColor;
    CGFloat origy = CGRectGetMaxY(lotteryXHView.frame);
    self.qmitBtn.frame = CGRectMake(KscreenWidth-70, origy, 64, 16);
    self.qmitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.qmitBtn setTitle:@"查遗漏>" forState:UIControlStateNormal];
    self.fengeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, origy + 17, KscreenWidth,10)];
    self.fengeImage.image = [UIImage imageNamed:@"fengge.png"];
    [scrollViewContent_ addSubview:self.fengeImage];
    
    
    self.labQmit = [[UILabel alloc]initWithFrame:CGRectMake(10, origy+27, KscreenWidth-20, 15)];
    self.labQmit.font = [UIFont systemFontOfSize:12];
    self.labQmit.textColor = RGBCOLOR(142,142,142);
    self.labQmit.textAlignment = NSTextAlignmentRight;
    
    self.labQmit.adjustsFontSizeToFitWidth = YES;
    [self.qmitBtn setTitleColor:SystemGreen forState:UIControlStateNormal];
    [self.qmitBtn addTarget:self action:@selector(qmitJumpNextPageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self  sureQmitButtonIsHidden];
    [scrollViewContent_ addSubview: self.labQmit];
    [scrollViewContent_ addSubview:self.qmitBtn];
}
#pragma mark--查遗漏按事件
- (void)qmitJumpNextPageClicked:(UIButton *)sender
{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];

    NSArray * chiceArray = self.lottery.activeProfile.details;
    for ( LotteryXHSection * lotteryXHSextion in chiceArray) {
        NSArray * realSelectedNumber = lotteryXHSextion.numbersSelected;
        for (LotteryNumber * number in realSelectedNumber) {
            [array addObject:number.number];
        }
    }
    OmitEnquiriesViewController * omitVC = [[OmitEnquiriesViewController alloc]init];
    omitVC.sd115MissUrl = sd115MissUrl;
    omitVC.delegate = self;
    omitVC.lottery = self.lottery;
    omitVC.lotteryTransaction = self.lotteryTransaction;
    NSString *strTitle;
    if ([self.lottery.activeProfile.title isEqualToString:@"乐选二"]) {
        
        
        strTitle = @"任选二";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选三"]) {
        
        strTitle = @"任选三";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选四"]) {
        
        strTitle = @"任选四";
    }else if ([self.lottery.activeProfile.title isEqualToString:@"乐选五"]) {
        
        strTitle = @"任选五";
    }else
    {
        strTitle =self.lottery.activeProfile.title;
    }
    
    if ([strTitle hasSuffix:@"胆拖"]) {
        [array removeAllObjects];
        if ([strTitle isEqualToString:@"组二胆拖"]) {
            strTitle = @"前二组选";
        }else if([strTitle isEqualToString:@"组三胆拖"]){
            strTitle = @"前三组选";
        }else{
            strTitle = [strTitle substringToIndex:strTitle.length -2];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (expireTableView) {
            NSLog(@"11235  刷新 记录！");
            [expireTableView refreshWithProfileID:[_lottery.activeProfile.profileID integerValue]];
        }
        [titleView updateWithLottery: self.lottery];
        [self loadConentView:0];
    });
    
    omitVC.titleString =strTitle;
    omitVC.searchCodeArray = array;
    omitVC.isQmit = YES;
    //把选的号给带过去
    [self.navigationController pushViewController:omitVC animated:YES];
    [self clearAllSelection];

}
#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == BackAlertTag) {
        if (buttonIndex == 1) {
            _lottery.allRoundsInfo = nil;
            [self removeTimer];
            [super navigationBackToLastPage];
        }
    }else if (alertView.tag == DltInvalidAlertTag) {
        [self removeTimer];
        [super navigationBackToLastPage];
    }
}
#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollViewContent_ addSubview:sepLine];
   scrollViewContentOffset  = scrollView.contentOffset.y;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView == scrollViewContent_) {
        float curOffset = scrollView.contentOffset.y;
        if (curOffset > scrollViewContentOffset && scrollView.contentInset.top == expireTablveHeight) {
            // 向上
            scrollView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        }else{
            // 向下
            if (scrollView.contentOffset.y < -80) {
                [UIView animateWithDuration:0.2 animations:^{
                                    scrollView.contentInset = UIEdgeInsetsMake(expireTablveHeight, 0, 0, 0);
                } completion:^(BOOL finished) {
                    if (finished) {
                        
                    }
                }];
            }
        }
    }
}

-(void)gotLotteryCurRound:(LotteryRound *)round{
    if (round) {
        NSLog(@"得到奖期。");
        [timerForcurRound invalidate];
        NSLog(@"timer sile");
        _lottery.currentRound = round;
        if (phaseInfoView) {
            [phaseInfoView showCurRoundInfo];
        }
        
    }else{
        NSLog(@"未得到奖期。");
    }
}
- (IBAction)cleanAction:(id)sender {
    [self userDidSelectLotteryProfile];
}
- (void)gotLotteryCurRoundTimeout {
    
    [self hideLoadingView];
    [self showPromptText:requestTimeOut hideAfterDelay:3.0];
    return;

    
}

- (void)showLoading{
    [self showLoadingViewWithText:TextLoading];
}
- (void)hideLoading{
    [self hideLoadingView];
}

- (void)refreshSummaryAppear{
    [self newBet];
}


- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
}

- (void)removeTimer{
    [timerForcurRound invalidate];
    timerForcurRound = nil;
    //    [timeCountDownView.updataTimer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoundTimeDownFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderPaySuccessNotification object:nil];
}


-(void)gotQueryX115LimitNum:(NSArray *)dataArray{
    for (NSDictionary *dic in dataArray) {
        X115LimitNum *x115Model = [[X115LimitNum alloc]initWithDic:dic];
        [limitArray addObject:x115Model];
    }
    
}
- (void)dealloc{
    [phaseInfoView.timeCountdownView.updataTimer invalidate];
    NSLog(@"sile");
}
@end
