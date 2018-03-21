//
//  LotteryExtrendViewController.m
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryExtrendViewController.h"
#import "ExNumContainerView.h"
#import "EXPingCeView.h"
#import "EXQiHaoView.h"
#import "LotteryManager.h"
#import "EXHeaderView.h"
#import "LotteryProfileSelectView.h"
#import "LotteryTimeCountdownView.h"
#import "AppDelegate.h"
#import "DltOpenResult.h"
#import "WBSelectView.h"
#define dltFrontSectionBaseNumMaxValue   35
#define dltAfterSectionBaseNumMaxValue   12

#define ANIMATIONTIME 0.3

//RGBCOLOR(253, 139, 82);出现次数字体颜色   254 241 235
//RGBCOLOR(137, 186, 106)；最大连出字体颜色  245 255 238
//RGBCOLOR(45, 113, 194); 最大遗漏字体颜色  240 249 255
//RGBCOLOR(228, 102, 90)； 出现概率字体颜色  240 249 255

@interface LotteryExtrendViewController ()<LotteryManagerDelegate,ExNumContainerViewDelegate,UIActionSheetDelegate,LotteryProfileSelectViewDelegate,WBSelectViewDelegate>{
    
    __weak IBOutlet UIView *timeCountDownView;
    __weak IBOutlet UIView *x115QianErZuHeadView;
    __weak IBOutlet UIView *x115QianSanZuHeadView;
    __weak IBOutlet UIView *dltHeadView;
    
    __weak IBOutlet UIView *baseContentV;
    
    __weak IBOutlet NSLayoutConstraint *flagLb_x115SpaseConstrain_qianer;
    __weak IBOutlet NSLayoutConstraint *flagLb_x115SpaceConstrain;
    __weak IBOutlet NSLayoutConstraint *flagLbHoriSpaceConstraint;
    __weak IBOutlet NSLayoutConstraint *baseViewVericalConstraint;
    
    LotteryManager * lotteryMan;
    
    IBOutletCollection(UILabel) NSArray *pingceLables;
    
    __weak IBOutlet UIScrollView *headerScrollView;
    __weak IBOutlet UIScrollView *qihaoCrollView;
    __weak IBOutlet UIScrollView *numScrollView;
    __weak IBOutlet UIScrollView *pingceScrollView;
    
    LotteryTimeCountdownView * timeView;
    
    EXHeaderView * headerView;
    EXQiHaoView * exQihaoView;
    EXPingCeView * pingceView;
    ExNumContainerView * contentV;
    
    NSInteger numberForSource;
    
    // dlt
    DltSectionType  dltSectionType;

    int baseNumMaxValue;
    
    //for x115
    
    LotteryProfileSelectView *profileSelectView;
    X115SectionType    x115SectionType;
    X115PlayType        x115PlayType;
    
    //lc
    __weak IBOutlet UILabel *QianErDownLa;
    __weak IBOutlet UILabel *QianSanDownLa;
}

@property (nonatomic , strong) LotteryXHProfile *currentProfile;
@property (nonatomic , strong) NSArray * sourceArray;
@property (nonatomic , strong) UIButton * curSelectedSectonBt;
@property(nonatomic,strong)WBSelectView* selectView;
@property(nonatomic,assign)NSInteger wbSelectViewIndex;

@end

@implementation LotteryExtrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wbSelectViewIndex = 0;
    if ([_lottery.identifier isEqualToString:@"DLT"]) {
        self.viewControllerNo = @"A011";
    }
    
    self.selectView = [[WBSelectView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    self.selectView.delegate = self;

    
    
    self.lotteryMan.delegate = self;

//    [pingceLables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        UILabel * lable = (UILabel *)obj;
//        lable.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        lable.layer.borderWidth = 0.5;
//    }];
    
    [self addOptionRighButton];

    dltSectionType = DltSectionTypeNotSet;
    self.title = [NSString stringWithFormat:@"%@ 趋势图",_lottery.name];
    
    numberForSource = 100;
    [self getLotteryRounds:numberForSource];
}
- (void) addOptionRighButton {
    
    
    UIButton *backBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backBarButton setFrame: CGRectMake(0, 0, 58, 44)];
    //lc 更改 右侧的 图标变为汉字“助手”
    [backBarButton setTitle:@"数据条数" forState:UIControlStateNormal];
    backBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    backBarButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [backBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    [backBarButton addTarget: self action: @selector(optionRightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView: backBarButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self useBackButton:NO];
    if(_lottery.currentRound == nil){
//        [lotteryMan getLotteryCurRoundInfo:_lottery];
    }
    if (timeView == nil) {
        timeView = [[LotteryTimeCountdownView alloc] initWithFrame:timeCountDownView.bounds];
        timeView.timeCutType = TimeCutTypeExtrendPage;
        timeView.curRound = _lottery.currentRound;
        timeView.timeString = _timeString;
        [timeCountDownView addSubview:timeView];
    }
    [timeView startTimeCountdown:_lottery.currentRound];
    if ([_lottery.identifier isEqualToString:@"DLT"]) {
        
        dltSectionType = DltSectionTypeFront;
        baseNumMaxValue = dltFrontSectionBaseNumMaxValue;
        [self.view bringSubviewToFront:dltHeadView];
        baseViewVericalConstraint.constant = 99;
    }else if ([_lottery.identifier isEqualToString:@"X115"]){
        
//        baseNumMaxValue = x115BaseNumMaxValue;
//        titleView = [[LotteryTitleView alloc] initWithFrame: CGRectMake(0, 0, 180, 44)];
//        titleView.delegate = self;
//        [titleView updateWithLottery: _lottery];
//        self.navigationItem.titleView = titleView;
//        x115SectionType = X115SectionTypeWan;
//        self.lottery.activeProfileForExtrend = _lottery.activeProfile;
//        [self userDidSelectLotteryProfile];
    }
}


-(void)gotLotteryCurRound:(LotteryRound *)round{
    if (timeView == nil) {
        timeView = [[LotteryTimeCountdownView alloc] initWithFrame:timeCountDownView.bounds];
        
        [timeCountDownView addSubview:timeView];
    }
    timeView.timeCutType = TimeCutTypeExtrendPage;
    NSInteger hour = round.abortDay * 24 + round.abortHour;
    NSString * timeStr = [NSString stringWithFormat:@"%ld,%ld,%ld",hour,round.abortMinute,round.abortSecond];
    timeView.timeString = timeStr;
    _lottery.currentRound = round;
    timeView.curRound = _lottery.currentRound;
    [timeView startTimeCountdown:_lottery.currentRound];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _lottery.activeProfileForExtrend = nil;
    self.tabBarController.tabBar.hidden = NO;
    
}

//- (void)navigationBackToLastPage{
//    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    
//    [self dismissViewControllerAnimated:NO completion:nil];
//}
- (void) optionRightButtonAction {
    //show options
    
    self.selectView.dataArray = @[ThirtyNumForSource,fiftyNumForSource,OneHundredForSource];
    [self.view addSubview:self.selectView];
    self.selectView.index = _wbSelectViewIndex;
    [self.selectView.tableView reloadData];
    
//    UIActionSheet *optionActionSheet = [[UIActionSheet alloc] initWithTitle: ChooseNumForSource
//                                                                   delegate: self
//                                                          cancelButtonTitle: TextDimiss
//                                                     destructiveButtonTitle: nil
//                                                          otherButtonTitles: ThirtyNumForSource,
//                                                                             fiftyNumForSource,
//                                                                             OneHundredForSource, nil];
//    [optionActionSheet showInView: self.view];
}
- (void)getLotteryRounds:(NSInteger)roundnum{
    [self.lotteryMan getListHisIssue:@{@"lottery":@"DLT",@"size":@(roundnum)}];
}

-(void) refreshNumExtrendView{
 
    if (!exQihaoView) {
        exQihaoView = [[EXQiHaoView alloc] init];
        exQihaoView.backgroundColor = MAINBGC;
        [qihaoCrollView addSubview:exQihaoView];
        
        contentV = [[ExNumContainerView alloc] init];
        contentV.delegate = self;
        contentV.backgroundColor = MAINBGC;
        [numScrollView addSubview:contentV];

        headerView = [[EXHeaderView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerScrollView addSubview:headerView];
    }
    CGSize size_header = [headerView remakerViewFram:baseNumMaxValue];
    headerView.frame = CGRectMake(0, 0, size_header.width, size_header.height);
    headerScrollView.contentSize = CGSizeMake(size_header.width, size_header.height);
    [headerView setNeedsDisplay];

    contentV.lottery  = _lottery;
    contentV.dltSectionType = dltSectionType;
    contentV.x115SectionType = x115SectionType;
    contentV.x115PlayType = x115PlayType;
    contentV.baseNumMaxValue = baseNumMaxValue;
    CGSize size= [contentV remakerViewFram:_sourceArray];
    contentV.frame = CGRectMake(0, 0, size.width, size.height);
    numScrollView.contentSize = CGSizeMake(size.width,size.height);
    [contentV setNeedsDisplay];
    
    CGSize qihaoSize = [exQihaoView remakerViewFram:_sourceArray];
    exQihaoView.frame = CGRectMake(0, 0, qihaoSize.width, qihaoSize.height);
    qihaoCrollView.contentSize = CGSizeMake(qihaoSize.width, qihaoSize.height);
    [exQihaoView setNeedsDisplay];
}


- (IBAction)sectionShift:(id)sender {

    UIButton * button = (UIButton *)sender;
    if (_curSelectedSectonBt == button) {
        return;
    }
    if (button.tag == 1000) {
        
        
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            flagLbHoriSpaceConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        baseNumMaxValue = dltFrontSectionBaseNumMaxValue;
        dltSectionType  = DltSectionTypeFront;
        
    }else{
  
     
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            flagLbHoriSpaceConstraint.constant = CGRectGetWidth(button.frame);
            [self.view layoutIfNeeded];
        }];
        baseNumMaxValue = dltAfterSectionBaseNumMaxValue;
        dltSectionType  = DltSectionTypeAfter;
    }
    [self refreshNumExtrendView];
}
- (IBAction)x115SectionShift:(id)sender {
    
    //    9 10
    NSLayoutConstraint *leading;
    CGFloat moveOffset;
    
    if ([_lottery.activeProfileForExtrend.profileID intValue] == 9) {
        leading = flagLb_x115SpaseConstrain_qianer;
        moveOffset = QianErDownLa.bounds.size.width;
    }else{
        leading = flagLb_x115SpaceConstrain;
        moveOffset = QianSanDownLa.bounds.size.width;
    }
    
    UIButton * button = (UIButton *)sender;
    if (_curSelectedSectonBt == button) {
        return;
    }
    if (button.tag == 1000) {
        NSLog(@"22345 wan");
        NSLog(@"%lf %lf",moveOffset,leading.constant);
    
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            leading.constant = moveOffset * 0;
            [self.view layoutIfNeeded];
        }];
        
            
     
       
        x115SectionType = X115SectionTypeWan;
    }else if(button.tag == 1001){
         NSLog(@"22345 qian");
        NSLog(@"%lf %lf",moveOffset,leading.constant);
        
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            leading.constant = moveOffset * 1+1;
            [self.view layoutIfNeeded];
        }];
        x115SectionType = X115SectionTypeQian;
    }else if(button.tag == 1002){
        NSLog(@"22345 bai");
        
        
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            leading.constant = moveOffset * 2+2;
            [self.view layoutIfNeeded];
        }];
        x115SectionType = X115SectionTypeBai;
    }
    
    [self refreshNumExtrendView];
}

#pragma mark - LotteryManagerDelegate methods

-(void)gotListHisIssue:(NSArray *)infoDic errorMsg:(NSString *)msg{
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary * itemDic in infoDic){
        DltOpenResult *round = [[DltOpenResult alloc]initWith:itemDic];
        [tempArray insertObject:[round transport] atIndex:0];
    }
    self.sourceArray = tempArray;
    [self refreshNumExtrendView];
}

#pragma mark - ExNumContainerViewDelegate method
- (void)nowPingceResultWithAppearTime:(NSDictionary *)appearTimeDic Lianxu:(NSDictionary *)maxLianxu yilou:(NSDictionary *)maxYilou appearPropertion:(NSDictionary *)appearPropertion{
    
    [self hideLoadingView];
    
    if (nil == pingceView) {
        pingceView = [[EXPingCeView alloc] init];
        pingceView.backgroundColor = SEPCOLOR;
        [pingceScrollView addSubview:pingceView];
    }

    pingceView.appearTimeDic = appearTimeDic;
    pingceView.maxYilouDic = maxYilou;
    pingceView.maxLianchuDic = maxLianxu;
    pingceView.appearPositinDic = appearPropertion;

    CGSize size = [pingceView remakeFram:baseNumMaxValue];
    pingceView.frame = CGRectMake(0, 0, size.width, size.height);
    [pingceView setNeedsDisplay];
    pingceScrollView.contentSize = CGSizeMake(size.width, size.height);
}
- (void)cellChoosed:(int)sourIndex{
    [exQihaoView cellChoose:sourIndex];
}
#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == qihaoCrollView) {
        CGPoint offset = numScrollView.contentOffset;
        numScrollView.contentOffset = CGPointMake(offset.x, qihaoCrollView.contentOffset.y);
    }else if(scrollView == numScrollView){
        CGPoint offset_numSV = numScrollView.contentOffset;
        CGPoint offset_pingceSV = pingceScrollView.contentOffset;
        CGPoint offset_qihaoSV = qihaoCrollView.contentOffset;
        
        qihaoCrollView.contentOffset = CGPointMake(offset_qihaoSV.x, offset_numSV.y);
        pingceScrollView.contentOffset = CGPointMake(offset_numSV.x, offset_pingceSV.y);
        headerScrollView.contentOffset = CGPointMake(offset_numSV.x, 0);
    }else if (scrollView == pingceScrollView){
        CGPoint offset_numSV = numScrollView.contentOffset;
        CGPoint offset_pingceSV = pingceScrollView.contentOffset;
        numScrollView.contentOffset = CGPointMake(offset_pingceSV.x, offset_numSV.y);
    }
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 3) {
        return;
    }
    int newNumForSource = 0;
    if (buttonIndex == 0) {
        newNumForSource = 30;
    }else if (buttonIndex == 1){
        newNumForSource = 50;
    }else if (buttonIndex == 2){
        newNumForSource = 100;
    }
    if (newNumForSource == numberForSource) {
        return;
    }else{
        numberForSource = newNumForSource;
        [self showLoadingViewWithText:TextLoading];
        [self getLotteryRounds:newNumForSource];
    }
}

-(void)didSelect:(NSIndexPath *)indexPath{
    self.wbSelectViewIndex = indexPath.row;
    NSInteger newNumForSource = indexPath.row;
    switch (newNumForSource) {
        case 0:
            newNumForSource = 30;
            break;
        case 1:
            newNumForSource = 50;
            break;
        case 2:
            newNumForSource = 100;
            break;
        default:
            break;
    }
    
    if (newNumForSource == numberForSource) {
         [self.selectView removeFromSuperview];
        return;
    }else{
        numberForSource = newNumForSource;
        [self showLoadingViewWithText:TextLoading];
        [self getLotteryRounds:newNumForSource];
    }

    [self.selectView removeFromSuperview];
}

#pragma mark - LotteryTitleViewDelegate methods


#pragma mark - LotteryProfileSelectViewDelegate methods
- (void) userDidSelectLotteryProfile {
//    [titleView updateWithLottery: self.lottery];
    
    baseViewVericalConstraint.constant = 64;
    [self.view bringSubviewToFront:baseContentV];
    switch ([_lottery.activeProfileForExtrend.profileID intValue]) {
        case 8:
            //  前一
            x115PlayType = x115PlayTypeQianYi;
            break;
        case 9:{
            //  前二
            x115PlayType = x115PlayTypeQianEr;
            x115SectionType = X115SectionTypeWan;
            [self.view bringSubviewToFront:x115QianErZuHeadView];
            baseViewVericalConstraint.constant = 99;
            break;
        }
        case 10:{
            x115PlayType = x115PlayTypeQianSan;
            x115SectionType = X115SectionTypeWan;
            [self.view bringSubviewToFront:x115QianSanZuHeadView];
            baseViewVericalConstraint.constant = 99;
            //  前三
            break;
        }
        case 11:{
            //  前二组选
            x115PlayType = x115PlayTypeQianErZu;
            
            break;
        }
        case 12:{
            //  前三年组选
            x115PlayType = x115PlayTypeQianSanZu;

            break;
        }
        default:
            x115PlayType = x115PlayTypeDefualt;
            break;
    }
    [self refreshNumExtrendView];
//    [self loadUI];
}



@end
