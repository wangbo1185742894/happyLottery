
//
//  LotteryPlayViewController.m
//  Lottery
//
//  Created by AMP on 5/23/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "DLTPlayViewController.h"
#import "LotteryBet.h"
#import "OptionSelectedView.h"
#import "NumberSelectView.h"
#import "LotteryManager.h"
#import "ExprieRoundView.h"
#import "LotteryExtrendViewController.h"
#import "LotteryInstructionViewController.h"
#import "DLTTouZhuViewController.h"
#import "DltOpenResult.h"
//lc
#import "LotteryInstructionDetailViewController.h"

//
#import "Lottery.h"
#import "LotteryXHView.h"
#import "LotteryBetsPopView.h"
//#import "TouZhuViewController.h"
#import "LotteryPhaseInfoView.h"
#import "LotteryWinNumHistoryViewController.h"
#import "ZLAlertView.h"

//跳转到查遗漏的界面

#define BackAlertTag 20

#define DltInvalidAlertTag  300

@interface DLTPlayViewController() <LotteryXHViewDelegate, UIActionSheetDelegate, LotteryBetsPopViewDelegate, UIScrollViewDelegate, LotteryPhaseInfoViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,LotteryManagerDelegate,OptionSelectedViewDelegate>


{
    __weak IBOutlet UILabel *labLimitNumInfo;
    NSTimer * timerForcurRound;
    __weak IBOutlet UILabel *flagLable;
    __weak IBOutlet UIView *viewContent_;
    UIScrollView *scrollViewContent_;
    UILabel *sepLine;
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
    __weak IBOutlet UIView *viewBadgeSuperView_;
    
    // 展示以往奖期
    CGFloat scrollViewContentOffset;
    CGFloat expireTablveHeight;
    
    
    IBOutletCollection(NSLayoutConstraint) NSArray *sepHeight;


    BOOL isShowFLag;
    
}

@property(nonatomic,strong)User *curUser;

@property(nonatomic,strong)GlobalInstance *instance;

@property (nonatomic , strong) NSString * touzhuErrorString;
//查遗漏按钮
@property (nonatomic, strong) UIButton * qmitBtn;
@property (nonatomic, strong) UILabel * labQmit;
@property (nonatomic, strong) UIImageView *fengeImage;
@end

@implementation DLTPlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.lotteryMan.delegate = self;
    self.viewControllerNo = @"A004";
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    self.instance = [GlobalInstance instance];
    
    pageLoaded = NO;
    for (NSLayoutConstraint *sepH in sepHeight) {
        sepH.constant = SEPHEIGHT;
    }
    
    labelSummary_.textColor = TEXTGRAYCOLOR;

    buttonSubmit_ .titleLabel.font = [UIFont systemFontOfSize:15];
    
    [buttonSubmit_ setTitle: @"预约投注" forState: UIControlStateNormal];
    [buttonSubmit_ setTitle: @"预约投注" forState: UIControlStateHighlighted];
    [buttonSubmit_ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    
    buttonSubmit_.backgroundColor = [UIColor whiteColor];


    self.title = self.lottery.name;

    
    UIButton *optionButton = [UIButton buttonWithType: UIButtonTypeCustom];
    optionButton.frame = CGRectMake(0, 0, 64, 44);
    
    [optionButton setTitle:@" 助手" forState:UIControlStateNormal];
    [optionButton setImage:[UIImage imageNamed:@"helper.png"] forState:UIControlStateNormal];
    optionButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [optionButton addTarget: self action: @selector(optionRightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: optionButton];
    
    if (nil == _lotteryTransaction) {
        _lotteryTransaction = [[LotteryTransaction alloc] init];
        _lotteryTransaction.needZhuiJia = NO;
        _lotteryTransaction.beiTouCount = 1;
        _lotteryTransaction.qiShuCount = 1;
        _lotteryTransaction.lottery = self.lottery;
    }
    
    if (self.lottery.activeProfile ==nil ) {
        NSDictionary *lotteryDetailDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfigdlt" ofType: @"plist"]];
        NSArray *profilesArray = lotteryDetailDic[[NSString stringWithFormat:@"%d", _lottery.type]];
        
        if ([profilesArray isKindOfClass: [NSArray class]] && profilesArray.count > 0) {
            NSArray *profiles = [self lotteryProfilesFromData: profilesArray];
            _lottery.activeProfile = profiles[0];
        }
    }
    
    [self currentBet:nil];
    [self getHisIssue];
}

-(void)getHisIssue{
    [self.lotteryMan getListHisIssue:@{@"lottery":@"DLT",@"size":@10}];
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

- (NSArray *) lotteryProfilesFromData: (NSArray *) profilesArray {
    NSMutableArray *profiles = [NSMutableArray arrayWithCapacity: profilesArray.count];
    for (NSDictionary *profileDic in profilesArray) {
        LotteryXHProfile *profile = [[LotteryXHProfile alloc] init];
        NSArray *allKeys = [profileDic allKeys];
        for (NSString *key in allKeys) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat: @"set%@:", key]);
            if ([profile respondsToSelector: selector]) {
                [profile performSelector: selector withObject: profileDic[key]];
            } else {
                if ([key isEqualToString: @"LotteryData"]) {
                    profile.details = [self lotterySectionsFromData: profileDic[key]];
                }
            }
        }
        [profiles addObject: profile];
    }
    return profiles;
}


- (NSArray *) lotterySectionsFromData: (NSArray *) detailDataArray {
    NSMutableArray *details = nil;
    if ([detailDataArray isKindOfClass: [NSArray class]]) {
        details = [NSMutableArray arrayWithCapacity: detailDataArray.count];
        for (NSDictionary *detail in detailDataArray) {
            LotteryXHSection *lxh = [[LotteryXHSection alloc] init];
            NSArray *allKeys = [detail allKeys];
            for (NSString *key in allKeys) {
                SEL selector = NSSelectorFromString([NSString stringWithFormat: @"set%@:", key]);
                if ([lxh respondsToSelector: selector]) {
                    [lxh performSelector: selector withObject: detail[key]];
                }
            }
            [details addObject: lxh];
        }
    }
    return details;
}

#pragma mark  玩法介绍
- (void) showPlayMethod{
    //2  dlt ,0 x115,1  jczq;
     NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[2];;
   
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
    
    
    
//    LotteryInstructionViewController *instruceVC = [[LotteryInstructionViewController alloc]init];
//    [instruceVC toDetailVC:1 andTarget:self];
//    
//    [self.navigationController pushViewController:instruceVC animated:YES];
    
    
}


//-(void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//
//    
//}

-(void)actionNotificationRandomeFive:(NSNotification*)notification{
    if (!self.lottery.currentRound) {
        [self getCurrentRound];
    }

    for (int i = 0; i < 5 ; i ++ ) {
        [self addRandomBet];
    }
    DLTTouZhuViewController *touzhuVC = [[DLTTouZhuViewController alloc] initWithNibName: @"DLTTouZhuViewController" bundle: nil];
    touzhuVC.lottery = self.lottery;

    NSLog(@"yaoguoqule%@",timerForcurRound);
    touzhuVC.timerForcurRound = timerForcurRound;
    touzhuVC.transaction = _lotteryTransaction;

    touzhuVC.delegate = self;
    touzhuVC.rand = @"5";

    [self.navigationController pushViewController: touzhuVC animated: YES];
    
    
    NSString *obj = notification.object;
    NSLog(@"%@",obj);
    
}

- (IBAction) clearAllSelection {
    
    switch (_lottery.type) {
        case LotteryTypeDaLeTou:
        case LotteryTypeShiYiXuanWu:{
            [self newBet];
            [lotteryXHView clearAllSelection];
            break;
        }
  
        default:
            break;
    }
   
}
- (IBAction)currentBet:(id)sender{
    
    if ([_lotteryTransaction betCount] > 0 || _lotteryTransaction.allBets.count >1) {
        //            return nil;
        for (LotteryXHProfile * lottery in self.lottery.profiles) {
            if ([lottery.title isEqualToString: self.rebuyTitle]) {
                self.lottery.activeProfile = lottery;
                break;
            }
        }
        DLTTouZhuViewController *touzhuVC = [[DLTTouZhuViewController alloc] initWithNibName: @"DLTTouZhuViewController" bundle: nil];
        touzhuVC.lottery = self.lottery;
        if (!self.lottery.currentRound) {
            [self getCurrentRound];
        }
        NSLog(@"yaoguoqule%@",timerForcurRound);
        touzhuVC.timerForcurRound = timerForcurRound;
        touzhuVC.transaction = _lotteryTransaction;

        touzhuVC.delegate = self;
        if (nil==sender) {
            [self.navigationController pushViewController: touzhuVC animated: YES];

        }else{
            [self.navigationController pushViewController: touzhuVC animated: YES];
        }
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
    
    [self getCurrentRound];
    self.curUser = [[GlobalInstance instance] curUser];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tabBarController.tabBar.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotificationRandomeFive:) name:@"NSNotificationRandomeFive" object:nil];
  
    
    
    [lotteryBetsPopView_ refreshBetListView: _lotteryTransaction];//刷新号码篮
    if([_lotteryTransaction allBets].count == 0)
    {
        myDelegate.betlistcount = 0;
    }
    if(myDelegate.betlistcount == 0)
    {
        [lotteryBetsPopView_ hideMe];
    }
    
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
         [self loadUI];
    }
    
    
    if (self.isReBuy == YES) {
        [self newBet];
         
        [lotteryXHView rebuyDLTnum:self.selectedNumber];
        self.selectedNumber = nil;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
     AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [super viewWillDisappear: animated];
    
    if ([timerForcurRound isValid]) {
        [timerForcurRound setFireDate:[NSDate distantFuture]];
        NSLog(@"tinrle");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationRandomeFive" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //  temp for appStore
    if (isShowFLag) {
        [self.view bringSubviewToFront:flagLable];
    }else{
//        [self updateNavigationTitle];
    }
    
    //提示用户，下拉可以显示往期开奖结果；
    if (![_lottery.identifier isEqualToString:@"JCZQ"]) {
        [self showPromptText:@"下拉可以显示往期开奖结果哟..." hideAfterDelay:1];
    }
    //zwl 12-29 大乐透功能开启测试
//    if ([_lottery.identifier isEqualToString:@"DLT"]) {
//        // 大乐透暂停销售
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:DLTInvalidAlert delegate:self cancelButtonTitle:TitleYes otherButtonTitles:nil, nil];
//        alert.tag = DltInvalidAlertTag;
//        [alert show];
//    }
    
    [timerForcurRound setFireDate:[NSDate date]];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
 
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
    //load title view if needed
    [self hideLoadingView];
    [self loadData];
}

- (void)loadData{
    NSString * lotteryIdentify = _lottery.identifier;
    if ([lotteryIdentify isEqualToString:@"JCZQ"]){
        [self showLoadingViewWithText:TextLoading];
    }
}

- (void)loadConentView:(float)curY{
 
    NSString * lotteryIdentify = _lottery.identifier;
    //add this phase information
    //期号: 054   距截止还有 1天5小时
    if ([lotteryIdentify isEqualToString:@"DLT"]) {
        CGRect phaseSectionFrame = CGRectMake(0, 0, KscreenWidth, 0);
        phaseSectionFrame.origin.y = curY;
        phaseSectionFrame.size.height = PhaseInfoHeight * 2;
        phaseInfoView = [[LotteryPhaseInfoView alloc] initWithFrame: phaseSectionFrame];
        phaseInfoView.delegate = self;
        [phaseInfoView drawWithLottery: self.lottery];
        [viewContent_ addSubview: phaseInfoView];
        
        if (!_lottery.currentRound) {
            [self beginTimerForCurRound];
        }
        if (scrollViewContent_ != nil) {
            NSArray * array = [scrollViewContent_ subviews];
            for (UIView * view in array){
                if (![view isKindOfClass:[ExprieRoundView class]]) {
                    [view removeFromSuperview];
                }
            }
        }else{
            scrollViewContent_ = [[UIScrollView alloc] initWithFrame: CGRectMake(0, PhaseInfoHeight * 2, KscreenWidth, viewContent_.bounds.size.height-PhaseInfoHeight*2)];
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
            instructionSectionFrame.origin.y = curY;
            instructionSectionFrame.origin.x = LEFTPADDING;
            instructionSectionFrame.size.width -= 10;
            instructionSectionFrame.size.height = 40;
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
            if (KscreenHeight > 667) {
                CGSize contentSize = scrollViewContent_.frame.size;
                contentSize.height = maxHeight - scrollViewContent_.frame.origin.x+65 + 1000;
                scrollViewContent_.contentSize = contentSize;
            }else{
                CGSize contentSize = scrollViewContent_.frame.size;
                contentSize.height = maxHeight - scrollViewContent_.frame.origin.x+65;
                scrollViewContent_.contentSize = contentSize;
            }
       
        }else{
            if (KscreenHeight > 667) {
                     scrollViewContent_.contentSize = CGSizeMake(CGRectGetWidth(scrollViewContent_.frame), CGRectGetHeight(scrollViewContent_.frame)+200);
            }else{
                     scrollViewContent_.contentSize = CGSizeMake(CGRectGetWidth(scrollViewContent_.frame), CGRectGetHeight(scrollViewContent_.frame)+20);
            }
       
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTimerForCurRound) name:@"RoundTimeDownFinish" object:nil];


    }
}

- (void) newBet {
    switch (_lottery.type) {
        case LotteryTypeDaLeTou:
        case LotteryTypeShiYiXuanWu:{
            lotteryBet = [[LotteryBet alloc] init];
            //    lotteryBet.lotteryDetails = self.lottery.activeProfile.details;
            lotteryBet.betXHProfile = self.lottery.activeProfile;
            lotteryBet.betLotteryIdentifier = self.lottery.identifier;
            lotteryBet.betLotteryType = self.lottery.type;
            
            lotteryBet.sectionDataLinkSymbol = self.lottery.dateSectionLinkSymbol == nil?@";":self.lottery.dateSectionLinkSymbol;
            lotteryXHView.lotteryBet = lotteryBet;
            [self betInfoUpdated];
            break;
        }
        
        default:
            break;
    }
}

- (void) optionRightButtonAction {
    if (isShowFLag) {
        return;
    }

    NSArray *titleArr;
   
    
    switch (_lottery.type) {
        case LotteryTypeDaLeTou:
        case LotteryTypeShiYiXuanWu:{
            
            titleArr = @[@" 走势图  ",
                                  @" 开奖详情",
                                  @" 玩法规则"];
            
            
//            optionActionSheet= [[UIActionSheet alloc] initWithTitle: nil
//                                                           delegate: self
//                                                  cancelButtonTitle: TextDimiss
//                                             destructiveButtonTitle: nil
//                                                  otherButtonTitles: TextPlayMethodInd,
//                                TextLotteryWinTrend,
//                                TextLotteryWinHistory, nil];
            break;
        }
        
        default:
            break;
    }
    
    
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    OptionSelectedView *optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, 64, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
    

    
//    [optionActionSheet showInView: self.tabBarController.view];
}

- (IBAction)showNumberBasket:(id)sender {
    if ([_lotteryTransaction betCount] > 0) {
        //show basket
        lotteryXHView.randomStatus = RandomBetStatusAdd;
        [lotteryBetsPopView_ refreshBetListView: _lotteryTransaction];
        [self.view bringSubviewToFront: lotteryBetsPopView_];
    } else {
        //show error prompt
        [self showPromptText: TextNoBetInBasket hideAfterDelay: 1.7];
    }
}

- (void) addBetToBasket {
    [_lotteryTransaction addBet: lotteryBet];
    
    
    [self betTransactionUpdated];
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
    if ([_lottery.identifier isEqualToString:@"X115"] || [_lottery.identifier isEqualToString:@"DLT"]) {
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
        
//        if ([_lotteryTransaction betCount] > 0) {
//            return nil;
//        }
        return TextNotEnoughBet;
    }
    return @"";
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
    
//    if (!_lottery.currentRound||[_lottery.currentRound isExpire]) {
//        [self showPromptText:ErrorWrongRoundExpird hideAfterDelay:1.7];
//        return;
//    }
    LotteryXHSection *section = lotteryBet.lotteryDetails[0];
//    if ([section.needDanHao integerValue]==1&&section.numbersSelected.count == 0) {
//        [self showPromptText: @"至少选择一个胆码" hideAfterDelay: 1.7];
//        return;
//    }
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
    
    DLTTouZhuViewController *touzhuVC = [[DLTTouZhuViewController alloc] initWithNibName: @"DLTTouZhuViewController" bundle: nil];
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
    if ([self.lottery.currentRound isExpire]) {
        timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:2000 target:self selector:@selector(getCurrentRound) userInfo:nil repeats:YES];
    }
    [timerForcurRound fire];
}

- (void) getCurrentRound{
    NSLog(@"开始请求奖期。");
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
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

- (void) betInfoUpdated {
    NSMutableAttributedString *betInfoString = [[NSMutableAttributedString alloc] init];
    
    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    textAttrsDictionary[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryTotal attributes: textAttrsDictionary]];
    
    NSMutableDictionary *numberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    numberAttrsDictionary[NSForegroundColorAttributeName] = SystemGreen;
    
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
    
    NSString *selectStr = [lotteryBet numDescrption:[UIFont systemFontOfSize:14]].string;
 
    labelSummary.attributedText = betInfoString;
    //[self sureQmitButtonIsHidden];
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
    switch (_lottery.type) {
        case LotteryTypeDaLeTou:
        case LotteryTypeShiYiXuanWu:{
            if (buttonIndex == 0) {
                [self showExtrendViewCtr];
                
            }else if (buttonIndex == 1){
                [self showWinHistoryViewCtr];
            }else if (buttonIndex == 2){
                [self showPlayMethod];
            }
            break;
        }

        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate methods
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//   
//    switch (_lottery.type) {
//        case LotteryTypeDaLeTou:
//        case LotteryTypeShiYiXuanWu:{
//            if (buttonIndex == 0) {
//                //clear selection
//                [self showPlayMethod];
//            }else if (buttonIndex == 1){
//                [self showExtrendViewCtr];
//            }else if (buttonIndex == 2){
//                [self showWinHistoryViewCtr];
//            }
//            break;
//        }
//        case LotteryTypeJingCaiFootBall:{
//            if (buttonIndex == 0) {
////                LotteryInstructionViewController *instruceVC = [[LotteryInstructionViewController alloc]init];
////                [instruceVC toDetailVC:1 andTarget:self];
//                
////                //lc
//                [self showPlayMethod];
//                
//            }else if(buttonIndex == 1){
//                JingCaiWinHistoryViewController * historyViewCtr = [[JingCaiWinHistoryViewController alloc] initWithNibName:@"JingCaiWinHistoryViewController" bundle:nil];
//                historyViewCtr.lottery = _lottery;
//                [self.navigationController pushViewController:historyViewCtr animated:YES];
////                UINavigationController * navCtr = [[UINavigationController alloc] initWithRootViewController:historyViewCtr];
////                [self presentViewController:navCtr animated:YES completion:^{
////                }];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)showExtrendViewCtr{
    {
        LotteryExtrendViewController * extrendViewCtr = [[LotteryExtrendViewController alloc] initWithNibName:@"LotteryExtrendViewController" bundle:nil];
        extrendViewCtr.lottery = _lottery;
        extrendViewCtr.timeString = [phaseInfoView timeSting];
        [self.navigationController pushViewController:extrendViewCtr animated:YES];
    }
    
    
}

- (void) showWinHistoryViewCtr{
    LotteryWinNumHistoryViewController * historyViewCtr = [[LotteryWinNumHistoryViewController alloc] initWithNibName:@"LotteryWinNumHistoryViewController" bundle:nil];
    historyViewCtr.lottery = _lottery;
//    UINavigationController * navCtr = [[UINavigationController alloc] initWithRootViewController:historyViewCtr];
//    [self presentViewController:navCtr animated:YES completion:^{
//    }];
    [self.navigationController pushViewController:historyViewCtr animated:YES];

}

#pragma mark - LotteryBetsPopViewDelegate
- (void) betTransactionUpdated {
    
}

- (void) betListPopViewHide {
    lotteryXHView.randomStatus = RandomBetStatusShow;
}
- (void) touzhuSureAction {
    
//    TouZhuViewController *touzhuVC = [[TouZhuViewController alloc] initWithNibName: @"TouZhuViewController" bundle: nil];
//    touzhuVC.lottery = self.lottery;
//    touzhuVC.transaction = _lotteryTransaction;
//    touzhuVC.timerForcurRound = timerForcurRound;
//    touzhuVC.isFromTogeVC = self.isFromTogeVC;
//    touzhuVC.delegate = self;
//    [self.navigationController pushViewController: touzhuVC animated: YES];
    
//    [self touZhuAction:nil];
}



#pragma mark - LotteryProfileSelectViewDelegate methods
- (void) userDidSelectLotteryProfile {
    
    NSLog(@"10109 %@ ",_lottery.activeProfile.profileID );
    if (expireTableView) {
        NSLog(@"11235  刷新 记录！");
        [expireTableView refreshWithProfileID:[_lottery.activeProfile.profileID integerValue]];
    }
    
    [self loadConentView:0];
}

#pragma mark - TouZhuViewController methods
- (void) addRandomBet {
    [self newBet];
    [lotteryXHView addRandomBet];
    [self addBetToBasket];
    [self clearAllSelection];
}


#pragma mark - LotteryPhaseInfoViewDelegate methods

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
#pragma mark - LotteryManagerDelegate methods

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

- (void)showAlertForNotMoreMatchToSelect{
    [self showPromptText:AlertForMotMoreMatchToChoose hideAfterDelay:1.2];
}

- (void)showAlertForMatchCannotToSelect{
    [self showPromptText:AlertForMatchCannotSelect hideAfterDelay:1.2];
}


- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
}
//- (void)removeTimer{
//    if (timerForcurRound) {
//        [timerForcurRound invalidate];
//        timerForcurRound = nil;
//        NSLog(@"remove timer");
//    }
//}
- (void)removeTimer{
    [timerForcurRound invalidate];
    timerForcurRound = nil;
    //    [timeCountDownView.updataTimer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoundTimeDownFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderPaySuccessNotification object:nil];
}

- (void)dealloc{
    [phaseInfoView.timeCountdownView.updataTimer invalidate];
    NSLog(@"sile");
}
@end
