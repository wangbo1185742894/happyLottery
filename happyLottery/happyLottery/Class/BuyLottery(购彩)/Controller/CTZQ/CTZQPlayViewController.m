//
//  CTZQPlayViewController.m
//  Lottery
//
//  Created by only on 16/3/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQPlayViewController.h"
#import "CTZQIssueSelectedButton.h"
#import "WebCTZQHisViewController.h"
#import "WebShowViewController.h"
#import "CTZQLotteryPlayCell.h"
#import "LotteryTitleView.h"
#import "LotteryManager.h"
#import "CTZQLotteryProfileSelectView.h"
#import "LotteryTimeCountdownView.h"
#import "OptionSelectedView.h"

#import "CTZQTouZhuViewController.h"
#import "LotteryInstructionDetailViewController.h"
#import "CTZQWinHistoryViewController.h"

#import "CTZQMatch.h"
#import "CTZQBet.h"
#import "ZLAlertView.h"
//用于控制是否显示更多信息的 BOOL 值
#define isShowMore 0
#define cellHeight 90.f
#define moreCellHeight 150.f
#define REMOVEALLTAG 12321
#define BACKTAG 12322

@interface CTZQPlayViewController ()<UITableViewDataSource,UITableViewDelegate,CTZQLotteryPlayCellDelegate,LotteryTitleViewDelegate,LotteryManagerDelegate,LotteryTitleViewDelegate,CTZQLotteryProfileSelectViewDelegate,LotteryTimeCountdownViewDelegate,UIAlertViewDelegate,OptionSelectedViewDelegate>
{
    __weak IBOutlet UILabel *labRoundInfo;
    LotteryTitleView *_titleView;
    CTZQLotteryProfileSelectView *_profileSelectView;
    LotteryTimeCountdownView *timeCountDownView0;
    AppDelegate *appDelegate;
    __weak IBOutlet UIButton *btnSelectRound;
    UIButton *btnRJC;
    UIButton *btnSSC;
    UIView *SelectPlayTypeTitleView;
    NSTimer *timerForcurRound;
    NSMutableArray *ctzqRounds;
    __weak IBOutlet UIButton *round01;
    
    __weak IBOutlet UIView *viewSelectRound;
    
    __weak IBOutlet UIButton *round02;
    __weak IBOutlet UILabel *noDataView;
}
@property (weak, nonatomic) IBOutlet UIButton *touzhuBtn;
@property (strong, nonatomic) IBOutletCollection(CTZQIssueSelectedButton) NSArray *issueBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedLaLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedLaWidth;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *sepHeightArr;
@property (weak, nonatomic) IBOutlet UITableView *CTZQPlayTableView;
@property (nonatomic, strong)NSMutableArray *CTZQMatchArr;
@property (weak, nonatomic) IBOutlet UIButton *round03;

@property (nonatomic, strong)NSMutableArray *CTZQMatchArrShow;
@property (nonatomic, strong)NSMutableArray *CTZQMatchSelectedArr;
@property (weak, nonatomic) IBOutlet UIButton *removeAllBtn;
@property (weak, nonatomic) IBOutlet UILabel *summaryLa;
@property (nonatomic, assign)BOOL isLoadFinish;
@property (nonatomic, assign)NSUInteger matchMinNeed;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;
@property(nonatomic,strong)GlobalInstance *instance;

@property (weak, nonatomic) IBOutlet UIView *jiangQiView;


@end

@implementation CTZQPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.viewDisTop.constant = 88;
        self.viewDisBottom .constant = 34;
    }else{
        self.viewDisTop.constant = 64;
        self.viewDisBottom.constant = 0;
    }
    
    if ([self.lottery.identifier isEqualToString:@"RJC"]) {
        self.viewControllerNo = @"A005";
    }else if ([self.lottery.identifier isEqualToString:@"SFC"]){
        self.viewControllerNo = @"A006";
    }
    [self creatTitleView];
    if (self.playType == CTZQPlayTypeRenjiu) {
        btnRJC.selected = YES;
    }else{
        btnSSC.selected = YES;
    }
    if (self.lottery.activeProfile ==nil ) {
        NSDictionary *lotteryDetailDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfigdlt" ofType: @"plist"]];
        NSArray *profilesArray = lotteryDetailDic[[NSString stringWithFormat:@"%d", _lottery.type]];
        
        if ([profilesArray isKindOfClass: [NSArray class]] && profilesArray.count > 0) {
            NSArray *profiles = [self lotteryProfilesFromData: profilesArray];
            _lottery.profiles = profiles;
        }
    }
    [self setUp];
    [self showLoadingViewWithText:TextLoading];
    [self setSepLine];
    [self setUpCTZQPlayTableView];
    [self setUpCTZQMatchArrWithInfo:nil];
    [self loadUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMatch:) name:KSELECTMATCHCLEAN object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueTimeCountDown:) name:@"IssueTimeCountDown" object:nil];
    [self updateSummary];
    noDataView.hidden = NO;
    _isLoadFinish = NO;
    _selectedIndex = 0;
    _jiangQiView.hidden = YES;
    [self getCurrentRound];
    _touzhuBtn.layer.cornerRadius = 5;
}


-(void)cleanMatch:(NSNotification*)notification{
    [self removeAllSelection];
}

- (void)optionRightButtonAction{
//    NSLog(@"haha");
   NSArray *titleArr = @[TextPlayMethodInd,
                 TextLotteryWinHistory,];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    OptionSelectedView *optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, DisTop, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
}
- (void)setUp{
    if (nil == _transaction) {
        _transaction = [[CTZQTransaction alloc] init];
    }
    _instance = [GlobalInstance instance];
    
    self.lotteryMan.delegate = self;
    
    if (nil == appDelegate) {
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    if (btnRJC.selected == YES) {
        self.lottery.activeProfile = self.lottery.profiles[0];
        self.transaction.ctzqPlayType = CTZQPlayTypeRenjiu;
    }else{
        self.lottery.activeProfile = self.lottery.profiles[1];
        self.transaction.ctzqPlayType = CTZQPlayTypeShiSi;
    }
 
}
- (void)loadUI{
    [self useBackButton:YES];
    [self addOptionRighButton];
    
    
}

- (void) addOptionRighButton {
    
    UIButton *backBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backBarButton setFrame: CGRectMake(0, 0, 64, 44)];
    //lc 更改 右侧的 图标变为汉字“助手”
    [backBarButton setTitle:@" 助手" forState:UIControlStateNormal];
    [backBarButton setImage:[UIImage imageNamed:@"helper.png"] forState:UIControlStateNormal];
    backBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    backBarButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [backBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    [backBarButton addTarget: self action: @selector(optionRightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView: backBarButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:@"IssueTimeCountDown" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
    if ([_transaction.isBackClean isEqualToString:@"1"]) {
        [self removeAllSelection];
        _transaction.isBackClean = @"0";
    }
    
    [_CTZQPlayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)navigationBackToLastPage{
    
    if (_CTZQMatchSelectedArr.count > 0) {
       
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:@"返回将清空所有选择，您确定返回么?"];
        [alert addBtnTitle:TitleNotDo action:^{
        }];
        
        [alert addBtnTitle:TitleDo action:^{
            [GlobalInstance instance].isFromTogeVCToThis = NO;
            [self removeAllSelection];
            [self removeTimer];
            
            [super navigationBackToLastPage];
            
        }];
        [alert showAlertWithSender:self];
    }else{
        [GlobalInstance instance].isFromTogeVCToThis = NO;
        [self removeTimer];
        [super navigationBackToLastPage];
    }
    
}

- (void)beginTimerForCurRound{
    [self showPromptText:@"奖期已经结束了" hideAfterDelay:1.7];
    
    [timerForcurRound invalidate];//强制定时器失效
    timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getCurrentRound) userInfo:nil repeats:YES];
    [timerForcurRound fire];
    NSLog(@"jiangqi end");
}
- (void)getCurrentRound{
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.activeProfile.desc}];
    
    
}

-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoDic.count == 0 || infoDic == nil) {
        [self showPromptText:@"暂无可售奖期" hideAfterDelay:2.0];
        return;
    }
    NSMutableArray *rounds = [[NSMutableArray alloc]initWithArray:infoDic];
    [rounds sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        LotteryRound *round1 = (LotteryRound*)obj1;
        LotteryRound *round2 = (LotteryRound*)obj2;
        return [round1.issueNumber integerValue]>[round2.issueNumber integerValue];
    }];
    self.lottery.currentRound = [rounds firstObject];
    
    for (LotteryRound *round in rounds) {
        [round changeServerTime];
    }
    
    if ( rounds.count >=1) {
        LotteryRound *round0 = rounds[0];

        [round01 setTitle:[NSString stringWithFormat:@"第%@期",round0.issueNumber] forState:0];
    }
    [self getMatchWithInfo:@{@"issueNumber":self.lottery.currentRound.issueNumber}];
    
    if (rounds.count >=2) {
        LotteryRound *round0 = rounds[1];
        [round02 setTitle:[NSString stringWithFormat:@"第%@期",round0.issueNumber] forState:0];
    }
    
    if (rounds.count >=3) {
        LotteryRound *round0 = rounds[2];
        [self.round03 setTitle:[NSString stringWithFormat:@"第%@期",round0.issueNumber] forState:0];
    }
    ctzqRounds = rounds;
    
//    if (timeCountDownView0 == nil) {
//        timeCountDownView0 = [[LotteryTimeCountdownView alloc] initWithFrame:labRoundInfo.frame];
//        timeCountDownView0.timeCutType = TimeCutTypePlayPage;
//        timeCountDownView0.delegate = self;
//        //        [timeCountDownView startTimeCountdown:self.lottery.currentRound];
//    }
   
    [self setRoundItemState:round01];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        labRoundInfo.text = [self.lottery.currentRound getTimeStr];
    }];
//    [timeCountDownView0 startTimeCountdown:self.lottery.currentRound];

    [self hideLoadingView];
    _jiangQiView.hidden = NO;
    [self updateSummary];
}

-(void)updateTime{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        
        NSString *timeStr = [NSString stringWithFormat:@"%ld:%ld:%ld",self.lottery.currentRound.abortHour,self.lottery.currentRound.abortMinute,self.lottery.currentRound.abortSecond];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueTimeCountDown" object:timeStr];
    });

}

#pragma mark -  赛事
- (NSMutableArray *)matchArrWithInfo:(NSArray *)infoArr{
    NSMutableArray* arrTemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *infoDic in infoArr) {
        CTZQMatch *match = [[CTZQMatch alloc] init];
        [match matchInfoWith:infoDic];
        [arrTemp addObject:match];
    }
    arrTemp = [NSMutableArray arrayWithArray:[arrTemp sortedArrayUsingSelector:@selector(compareMatch:)]];
    return arrTemp;
}
#pragma mark -
-(void)gotListZcMatchSp:(NSArray *)matchArr errorMsg:(NSString *)msg{

    for (NSInteger index = 0; index<ctzqRounds.count ;index ++) {
        LotteryRound *round = ctzqRounds[index];
        if ([round.sellStatus integerValue] == 1) {
            _selectedIndex = index;
            break;
        }
    }
    _CTZQMatchArr = [self matchArrWithInfo:matchArr];
    _CTZQMatchArrShow = _CTZQMatchArr;
    if (matchArr&&matchArr.count!=0) {

        
        NSString *matchIssueNum = [NSString stringWithFormat:@"%@",matchArr[0][@"issueNumber"]];
        
        NSInteger index = 0;
        for (LotteryRound *round in ctzqRounds) {
            if ([round.issueNumber isEqualToString:matchIssueNum]) {
                index = [ctzqRounds indexOfObject:round];
                break;
            }
        }
    
        [self reloadTable];
    }
    
}
- (void)reloadTable{
    NSLog(@"1134更新了");
    [_CTZQPlayTableView reloadData];
    [_CTZQPlayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)getMatchWithInfo:(NSDictionary *)info{
    [self.lotteryMan getListZcMatchSp:info];
    
}

- (void)gotLotteryCurRoundTimeout {
    
    [self hideLoadingView];
    self.lottery.currentRound = nil;
    [self showPromptText:requestTimeOut hideAfterDelay:3.0];
    return;
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
            }
        }
        [profiles addObject: profile];
    }
    return profiles;
}




- (void)setUpCTZQPlayTableView{
    [_CTZQPlayTableView registerNib:[UINib nibWithNibName:@"CTZQLotteryPlayCell" bundle:nil] forCellReuseIdentifier:@"CTZQLotteryPlayCell"];
}
- (void)setUpCTZQMatchArrWithInfo:(id)info{
    if (_CTZQMatchArr == nil) {
        _CTZQMatchArr = [[NSMutableArray alloc] init];
    }

    if (_CTZQMatchSelectedArr == nil) {
        _CTZQMatchSelectedArr = [[NSMutableArray alloc] init];
    }
    
    for (NSInteger i = 0; i < 14 ; i++) {
        CTZQMatch *match = [[CTZQMatch alloc] init];
    
         match.id_ = [NSString stringWithFormat:@"%zd",i];
         match.guestName = [NSString stringWithFormat:@""];    //萨克斯城竞技
         match.homeName = [NSString stringWithFormat:@""];     // 温哥华白帽
         match.hot = [NSString stringWithFormat:@""];          // 0
         match.leagueName = [NSString stringWithFormat:@""];   // 美国职业大联
        
         match.matchNum = [NSString stringWithFormat:@""];       // 周日 035
        
         match.matchDate = @"";        //
         match.matchKey = [NSString stringWithFormat:@""];     //150712035
         match.startTime = [NSString stringWithFormat:@""];    // 2015-07-13
         match.status = @"0";       // 0
        
         match.oddsS = @"";
         match.oddsP = @"";
         match.oddsF = @"";
        match.oddsSNum = @"";
        match.oddsPNum = @"";
        match.oddsFNum = @"";
        [_CTZQMatchArr addObject:match];
    }
    _CTZQMatchArrShow = _CTZQMatchArr;
}
- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    if (index == 0) {
        //clear selection
        [self showPlayMethod];
        NSLog(@"玩法");
    }else if (index == 1){
//        [self showExtrendViewCtr];
        [self showWinHistoryViewCtr];
        NSLog(@"开奖历史");
    }else if (index == 2){
//
    }
}
- (void)setSepLine{
    for (NSLayoutConstraint *sepHeight in _sepHeightArr) {
        sepHeight.constant = SEPHEIGHT;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _CTZQMatchArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowMore) {
        return moreCellHeight;
    }else{
        return cellHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTZQLotteryPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTZQLotteryPlayCell"];
    cell.delegate = self;
    [cell updateWithMatch:_CTZQMatchArrShow[indexPath.row]];
    if (![self isCanBuy]) {
        for (UIButton *btn in cell.btnArr) {
            btn.enabled = NO;
        }
    }else{
        for (UIButton *btn in cell.btnArr) {
            btn.enabled = YES;
        }
    }
    if (isShowMore) {
        cell.moreView.hidden = NO;
        cell.moreBtn.hidden = NO;
    }else{
        cell.moreView.hidden = YES;
        cell.moreBtn.hidden = YES;
    }
    
    {
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
        selectedView.backgroundColor = SEPCOLOR;
        
        CGRect frame = cell.bounds;
        frame.origin.y = 0;
        frame.size.height -= 0;
        if (indexPath.row == 0) {
            frame.origin.y = SEPHEIGHT;
            frame.size.height -= SEPHEIGHT;
        }
        UIView *selectedViewGray = [[UIView alloc] initWithFrame:frame];
        selectedViewGray.backgroundColor = CellSelectedColor;
        [selectedView addSubview:selectedViewGray];
        
        
        cell.selectedBackgroundView = selectedView;
        //        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view;
       
        if ([cell subviews].count>1) {
            view = [cell subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        
        for (UIView *view in [cell subviews]) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        }else{
            downLineFrame.origin.y = 44 - SEPHEIGHT;
        }
        
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine.frame = downLineFrame;
        [cell addSubview:downLine];
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cell addSubview:upLine];
            
        }
    }
    return cell;
}
- (void)updateSummary{
//    NSUInteger matchMinNeed = 0;
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] init];
//    if ([self.lottery.currentRound.sellStatus isEqualToString:@"END_SELL"]) {
//        [self showPromptText:@"该期已经截止销售，不能购买" hideAfterDelay:1.7];
//        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"该期已经截止销售不能购买"] attributes:@{NSForegroundColorAttributeName:TextCharColor}]];
//        _summaryLa.attributedText = attstr;
//        
//        return;
//    }else
        if (![self isCanBuy]) {
        [self showPromptText:@"该期只能查看，现在还不能购买" hideAfterDelay:1.7];
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"该期赛事无法购买"] attributes:@{NSForegroundColorAttributeName:TextCharColor}]];
        _summaryLa.attributedText = attstr;
        
        return;
    }
    if ([self.lottery.activeProfile.desc isEqualToString:@"SFC"]) {
        _matchMinNeed = 14;
    }else{
        _matchMinNeed = 9;
        
    }

    [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@"已选" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(_CTZQMatchSelectedArr.count)] attributes:@{NSForegroundColorAttributeName:TEXTGRAYOrange}]];
    [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@"场比赛" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    if (_CTZQMatchSelectedArr.count < _matchMinNeed) {
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@",还需选" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(_matchMinNeed - _CTZQMatchSelectedArr.count)] attributes:@{NSForegroundColorAttributeName:SystemGreen}]];
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@"场" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    }
    _summaryLa.attributedText = attstr;
    
}
- (void)CTZQLPCell:(CTZQLotteryPlayCell *)cell DidSelected:(CTZQWinResultType)selectedResult{
    if (![self isCanBuy]) {
        return;
    }
    
    NSIndexPath *matchIndexPath = [_CTZQPlayTableView indexPathForCell:cell];
    NSLog(@"选择了【%zd】场比赛，赛果为 【%zd】.",matchIndexPath.row,selectedResult);
    CTZQMatch *match = _CTZQMatchArrShow[matchIndexPath.row];
    NSString *selectedSPF = [NSString stringWithFormat:@"%@%@%@",match.selectedS,match.selectedP,match.selectedF];
    NSLog(@"SPF:%@",selectedSPF);
    if ([selectedSPF integerValue] == 0) {
        [_CTZQMatchSelectedArr removeObject:match];
        match.danTuo = @"0";//所有选择没有之后，胆拖没有意义，重置
    }else{
        if ([_CTZQMatchSelectedArr indexOfObject:match] == NSNotFound) {
            [_CTZQMatchSelectedArr addObject:match];
        }
    }

    [self updateSummary];
    
}


- (IBAction)userSelectedIssue:(CTZQIssueSelectedButton *)sender {
    
    for (CTZQIssueSelectedButton *btn in self.issueBtns) {
        [btn setSelected:NO];
    }
    [sender setSelected:YES];
    NSInteger issueSelected = [sender.issueNumber integerValue];
    NSLog(@"当前选择期号 ：%zd",issueSelected);
    [UIView animateWithDuration:0.3 animations:^{
        _selectedLaLeading.constant = sender.frame.origin.x;
        _selectedLaWidth.constant = sender.frame.size.width;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
        
    }];

    
    NSUInteger index = [_issueBtns indexOfObject:sender];
    _selectedIndex = index;
    if (index > ctzqRounds.count - 1 || ctzqRounds[index] == nil) {
        noDataView.hidden = NO;
        return;
    }else{
        CTZQMatch *match = _CTZQMatchArrShow[0];
        self.lottery.currentRound = ctzqRounds[index];
        if ([match.homeName isEqualToString:@""]) {
            noDataView.hidden = NO;
            return;
        }
    }
    
     [self removeAllSelection];
    
    [_CTZQPlayTableView reloadData];
    [_CTZQPlayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
   
}
#pragma mark - LotteryTitleViewDelegate methods
- (void) userDidClickTitleView {
    if (_profileSelectView.meShown) {
        [_profileSelectView hideMe];
    } else {
        [_profileSelectView showMe];
    }
}

#pragma mark - LotteryProfileSelectViewDelegate methods
- (void) userDidSelectLotteryProfile {
    [_titleView updateWithLottery: self.lottery];
    [self updateSummary];
    
    [self getCurrentRound];
    
}

- (IBAction)removeAllClick:(UIButton *)sender {
    [self removeAllSelection];
}
- (void)removeAllSelection{
    for (CTZQMatch *match in _CTZQMatchSelectedArr) {
        match.selectedS = @"0";
        match.selectedP = @"0";
        match.selectedF = @"0";
        match.danTuo = @"0";
    }
    CTZQPlayType ctzqPlayType  = _transaction.ctzqPlayType;
    NSString *playCode = _transaction.curPlayCode;
    _transaction = [[CTZQTransaction alloc] init];//换一个新的 transaction
    [_CTZQMatchSelectedArr removeAllObjects];
    _transaction.ctzqPlayType = ctzqPlayType;
    _transaction.curPlayCode = playCode;
    [_CTZQPlayTableView reloadData];
    [self updateSummary];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == REMOVEALLTAG) {
        if (buttonIndex == 1) {
            [self removeAllSelection];
        }
    }
    
    if (alertView.tag == BACKTAG) {
        if (buttonIndex == 1) {
            [self removeAllSelection];
            [self removeTimer];
            [super navigationBackToLastPage];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSubmint:(id)sender {
    NSLog(@"%@",@([_lottery.currentRound isExpire]));
    [self updateSummary];
    if([_lottery.currentRound isExpire]||_lottery.currentRound == nil){
        [self showPromptText:@"未获得有效奖期" hideAfterDelay:1.7];
        return;
    }
    
    if(_CTZQMatchSelectedArr.count < _matchMinNeed){
        [self showPromptText:[NSString stringWithFormat:@"请至少选择%@场赛事,还需选择%@场",@(_matchMinNeed),@(_matchMinNeed - _CTZQMatchSelectedArr.count)] hideAfterDelay:1.7];
        return;
    }
    NSMutableArray *betArr = [[NSMutableArray alloc] init];
    for (CTZQMatch *match in _CTZQMatchSelectedArr) {
        CTZQBet *bet = [[CTZQBet alloc] initWith:match];
        [betArr addObject:bet];
    }
    
    betArr = [[NSMutableArray alloc] initWithArray:[betArr sortedArrayUsingSelector:@selector(compareBet:)]];
    
    _transaction.cBetArray = betArr;
    _transaction.allBet = self.CTZQMatchArrShow;
    _transaction.costType = CostTypeCASH;
    _transaction.lottery = self.lottery;
    _transaction.isBackClean = @"0";
    CTZQTouZhuViewController *ctzqTouZhuVC = [[CTZQTouZhuViewController alloc]init];
    ctzqTouZhuVC.lottery = _lottery;
//    ctzqTouZhuVC.isFromTogeVC =self.isFromTogeVC;
    ctzqTouZhuVC.cTransation = _transaction;
    ctzqTouZhuVC.CTZQMatchSelectedArr = _CTZQMatchSelectedArr;
    ctzqTouZhuVC.CTZQMatchArr = _CTZQMatchArrShow;
    
    [self showLoadingViewWithText:@"正在加载"];
    [self.navigationController pushViewController:ctzqTouZhuVC animated:YES];
    [self hideLoadingView];
}
#pragma mark - 右上角跳转项目的实现
- (void)showPlayMethod{
    NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[6];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
}
- (void) showWinHistoryViewCtr{
    WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/sfcOpenAward",H5BaseAddress];
    playViewVC.pageUrl = [NSURL URLWithString:strUrl];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}
#pragma mark -
- (void)removeTimer{
    [timerForcurRound invalidate];
    timerForcurRound = nil;
//    [timeCountDownView.updataTimer invalidate];
    [timeCountDownView0 .updataTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoundTimeDownFinish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderPaySuccessNotification object:nil];
    
}
- (BOOL)isCanBuy{

    if (ctzqRounds.count ==0 || ctzqRounds == nil) {
        return NO;
    }
    LotteryRound *roundTemp = self.lottery.currentRound;
    if (roundTemp.abortDay == 0 && roundTemp.abortHour == 0 && roundTemp.abortMinute == 0 && roundTemp.abortSecond == 0) {
        _touzhuBtn.enabled = NO;
        return NO;
    }
    
    if (![roundTemp.sellStatus isEqualToString:@"ING_SELL"]) {
        _touzhuBtn.enabled = NO;
        return NO;
    }
     _touzhuBtn.enabled = YES;
    return YES;
}
- (IBAction)actionSelectRound:(id)sender {
    viewSelectRound.hidden = NO;
}
- (IBAction)actionViewSelectBackClick:(id)sender {
    viewSelectRound.hidden = YES;
}
- (IBAction)actionSelectRoundItem:(UIButton *)sender {

    self.lottery.currentRound = ctzqRounds[sender.tag -100];
    [timeCountDownView0 startTimeCountdown:self.lottery.currentRound];
    [self setRoundItemState:sender];
    [self removeAllSelection];
    viewSelectRound.hidden = YES;
}

-(void)creatTitleView{
    if(SelectPlayTypeTitleView != nil){
        return;
    }
    SelectPlayTypeTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 164, 30)];
    SelectPlayTypeTitleView.backgroundColor = SystemGreen;
    SelectPlayTypeTitleView.layer.cornerRadius = 16;
    SelectPlayTypeTitleView.layer.masksToBounds = YES;
    SelectPlayTypeTitleView.layer.borderColor = [UIColor whiteColor].CGColor;
    SelectPlayTypeTitleView.layer.borderWidth = 1;
    btnRJC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRJC.layer.cornerRadius = 11;
    btnRJC.layer.masksToBounds = YES;
    [btnRJC setTitle:@"任9场" forState:0];
    [btnRJC setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnRJC setTitleColor:[UIColor whiteColor] forState:0];
    [btnRJC setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnRJC setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnRJC setFrame: CGRectMake(4, 4, 76, 22)];
    btnRJC.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRJC addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnSSC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSSC.layer.cornerRadius = 11;
    btnSSC.layer.masksToBounds = YES;
    btnSSC.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSSC setTitle:@"14场" forState:0];
    [btnSSC setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnSSC setTitleColor:[UIColor whiteColor] forState:0];
    [btnSSC setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnSSC setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnSSC setFrame: CGRectMake(84, 4, 76, 22)];
    
    [SelectPlayTypeTitleView addSubview:btnRJC];
    [SelectPlayTypeTitleView addSubview:btnSSC];
    [btnSSC addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = SelectPlayTypeTitleView;
}

-(void)actionPlayTypeSelect:(UIButton *)sender{
    if (btnSSC.selected == YES && sender == btnSSC) {
        return;
    }
    if (btnRJC.selected == YES && sender == btnRJC) {
        return;
    }
    btnSSC.selected = NO;
    btnRJC.selected = NO;
    sender.selected = YES;
    [self updateSummary];
    [self removeAllSelection];
//    self.lottery.currentRound = ctzqRounds[0];
//    [timeCountDownView0 startTimeCountdown:self.lottery.currentRound];
//    [self setRoundItemState:round01];
    
    if (btnRJC .selected == YES) {
        self.lottery.activeProfile = self.lottery.profiles[0];
        self.transaction.ctzqPlayType = CTZQPlayTypeRenjiu;
    }else{
        self.lottery.activeProfile = self.lottery.profiles[1];
        self.transaction.ctzqPlayType = CTZQPlayTypeShiSi;
    }
    
    [self getCurrentRound];
    
}

-(void)issueTimeCountDown:(NSNotification *)notification{
    NSString *timeStr = notification.object;
    [labRoundInfo setText:[NSString stringWithFormat:@"第%@期 剩余%@",_lottery.currentRound.issueNumber,timeStr]];
}

- (void)timeCountDownView:(LotteryTimeCountdownView *)timeView didFinishTimeStr:(NSString *)timeStr{
    //    NSLog(@"%@",timeStr);
    //    NSLog(@"%@",@([_lottery.currentRound isExpire]);
    if ([timeStr isEqualToString:@"该期已停止销售"]) {
        if (timeView == timeCountDownView0) {
            [self setIssueBtnsWithInfo:timeStr :0];
        }
    }else{
        
        
        NSMutableString *curTime = [[NSMutableString alloc]initWithString:timeStr];
        
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"时"] withString:@":"];
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"分"] withString:@":"];
        
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"秒"] withString:@""];
        
        if (timeView == timeCountDownView0) {
            [self setIssueBtnsWithInfo:curTime :0];
            
        }
        if (timeView == timeCountDownView0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueTimeCountDown" object:timeStr];
            
        }
    }
    
}


- (void)setIssueBtnsWithInfo:(id)info :(NSInteger)index{
    
    //    NSInteger curentIssue = [_lottery.currentRound.issueNumber integerValue];
    NSString *curentTimeStr = @"预售";
    CTZQIssueSelectedButton *btn = self.issueBtns[index];
    if (ctzqRounds.count < index+1) {
        btn.hidden = YES;
        return;
    }
    btn.hidden = NO;
    LotteryRound *roundTemp =  ctzqRounds[index];
    if (roundTemp.abortDay == 0 && roundTemp.abortHour == 0 && roundTemp.abortMinute == 0 && roundTemp.abortSecond == 0){
        curentTimeStr = (NSString *)info;
    }else if ([roundTemp.sellStatus integerValue]  == 1) {
        curentTimeStr = [NSString stringWithFormat:@"剩余%@",info];
    }
    
    //    for (NSInteger i = 0; i < self.issueBtns.count; i++) {
    
    
    if ([roundTemp.sellStatus integerValue] == 0) {
        curentTimeStr = @"预售";
    }else if ([roundTemp.sellStatus integerValue] == 2) {
        curentTimeStr = @"停售";
    }else if ([roundTemp.sellStatus integerValue] == 3) {
        curentTimeStr = @"结束";
    }else{
        if (!_isLoadFinish) {
            btn.selected = YES;
            _isLoadFinish = YES;
        }
        
    }
    if (index <= ctzqRounds.count - 1) {
        
        
        if(roundTemp.issueNumber == nil){
            [btn setTitleIssueStr:[NSString stringWithFormat:@"正在加载"] andTimeStr:curentTimeStr];
        }else{
            btn.issueNumber = [NSString stringWithFormat:@"%@",roundTemp.issueNumber];
            [btn setTitleIssueStr:[NSString stringWithFormat:@"第%@期",roundTemp.issueNumber] andTimeStr:curentTimeStr];
        }
        
    }else{
        btn.issueNumber = [NSString stringWithFormat:@""];
        [btn setTitleIssueStr:[NSString stringWithFormat:@"未获得奖期"] andTimeStr:curentTimeStr];
    }
}

-(void)setRoundItemState:(UIButton *)sender{
    round01.selected = NO;
    round02.selected = NO;
    self.round03.selected = NO;
    sender.selected = YES;
    [btnSelectRound setTitle:[NSString stringWithFormat:@"第%@期",self.lottery.currentRound.issueNumber] forState:0];
    [self getMatchWithInfo:@{@"issueNumber":self.lottery.currentRound.issueNumber}];
}

@end
