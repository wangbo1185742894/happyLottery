//
//  LotteryWinNumHistoryViewController.m
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryWinNumHistoryViewController.h"
#import "LotteryExtrendViewController.h"
#import "LotteryWinHistoryCell.h"
#import "LotteryManager.h"
#import "LotteryRound.h"
#import "LotteryWinHistoryHeadView.h"
#import "AppDelegate.h"
#import "LotteryPhaseInfoView.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "DltOpenResult.h"

#define CellH 90
#define PageNumber 20
//lc
#define TABLEBOTTOM 51

@interface LotteryWinNumHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,LotteryManagerDelegate>{
    LotteryManager * lotteryMan;
    NSMutableArray * sourceArray;
    __weak IBOutlet UITableView *soureTableView;
    NSMutableArray *results;
    
    
    __weak IBOutlet UIView *btnView;
    __weak IBOutlet NSLayoutConstraint *tableBottom;
    //上缩74
    __weak IBOutlet UIButton *buyNowBtn;
    
   
    IBOutletCollection(NSLayoutConstraint) NSArray *sepHeightArr;

    __weak IBOutlet UILabel *downLine;
    int page;
    NSString * viewDistributRatio;
}

@end

@implementation LotteryWinNumHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    results = [NSMutableArray arrayWithCapacity:0];
    if ([self.lottery.identifier  isEqualToString:@"SX115"]) {
        self.viewControllerNo = @"A311";
    }else if  ([self.lottery.identifier  isEqualToString:@"SD115"]) {
        self.viewControllerNo = @"A311";
    }else if ([self.lottery.identifier isEqualToString:@"DLT"]){
        self.viewControllerNo = @"A314";
    }
    
    self.title = LotteryWinHistory;
    self.lotteryMan.delegate = self;
    for (NSLayoutConstraint *sepHeight in sepHeightArr) {
        sepHeight.constant = 0.5;
    }
    page =0;
    
    
    NSDictionary * config = @{@"dlt":@"2,3,1.5",@"SX115":@"2,3",@"SD115":@"2,3"};
    viewDistributRatio = config[_lottery.identifier];
    [UITableView refreshHelperWithScrollView:soureTableView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    [self loadNewData];
    soureTableView.backgroundColor = COLORBACKGROUND;
    
    if (_isFromOpenLottery) {
        NSLog(@"lc 现在应该添加 投注 按钮 和 nav右侧的趋势按钮。");
        tableBottom.constant = TABLEBOTTOM ;
        
        [buyNowBtn setTitleColor:TextCharColor forState:UIControlStateNormal];
        [buyNowBtn setTitleColor:TextOrangeColor forState:UIControlStateHighlighted];
        btnView.hidden = NO;
        [self addNavRightBtn];
    }else{
        tableBottom.constant = 0 ;
        btnView.hidden = YES;
    }
}

-(void)loadNewData{
    page = 0;
    [self getHisIssue];
}
-(void)loadMoreData{
    page ++ ;
    [self getHisIssue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self useBackButton:NO];
    
  
    //lc  修改header  下面方法加l
//    LotteryWinHistoryHeadView * headView = [[LotteryWinHistoryHeadView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
//    LotteryWinHistoryHeadView * headView = [[[NSBundle mainBundle] loadNibNamed:@"LotteryWinHistoryHeadView" owner:nil options:nil] lastObject];
//    [headView lsetUpWithLottey:_lottery withViewRatio:viewDistributRatio];
//    //lc   增加边界 10像素
//    headView.frame = CGRectMake(10, 64, CGRectGetWidth([UIScreen mainScreen].bounds)-10*2, 40);
//    NSLog(@"33244%@",headView);
    //无需header
//    [self.view addSubview:headView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)getHisIssue{
    [self.lotteryMan getListHisPageIssue:@{@"lottery":@"DLT",@"page":@(page),@"size":@(KpageSize)}];
}
-(void) gotListHisPageIssue:(NSArray *)infoDic errorMsg:(NSString *)msg{
    [soureTableView tableViewEndRefreshCurPageCount:infoDic.count];
    if(infoDic.count == 0 || infoDic == nil){
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    if(page == 0){
        [results removeAllObjects];
    }

    for (NSDictionary *dic in infoDic) {
        DltOpenResult *model = [[DltOpenResult alloc]initWith:dic];
        [results addObject:model];
    }
    [soureTableView reloadData];

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
//   
//    
//
//}
#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return results.count;
}
-(LotteryWinHistoryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIdentify = @"cellIdentify";
    LotteryWinHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        //lc 修改cell 下面方法加l
//        cell = [[LotteryWinHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LotteryWinHistoryCell" owner:nil options:nil] lastObject];
        [cell lsetUpWithLottery:_lottery cellHeight:CellH withSizeRatio:viewDistributRatio];
    }
    //lc  无需背景色
//    if (indexPath.row % 2==0) {
//        cell.backgroundColor = RGBCOLOR(220, 220, 220);
//    }else{
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    
    DltOpenResult * round = results[indexPath.row];
    [cell lcellFillInfo:round];
    {
        UIView *view;
        if ([cell subviews].count > 1) {
            view = [cell subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine_ = [[UILabel alloc] init];
        downLine_.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine_.frame = downLineFrame;
        [cell addSubview:downLine_];
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cell addSubview:upLine];
            
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
    }
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellH;
}
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma LotteryManagerDelegate methods
- (void)gotLotteryRounds:(NSArray *)rounds{
    [self hideLoadingView];
    [sourceArray removeAllObjects];
    if (nil == sourceArray) {
        sourceArray = [NSMutableArray array];
    }
    if (rounds) {
        for (NSDictionary * dic in rounds) {
            if ([sourceArray containsObject:dic]) {
                return;
            } else {
                [sourceArray addObject:dic];
            }
        }

    } else {
       [soureTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [soureTableView reloadData];
   
}

//#pragma UITableViewDragLoadDelegate methods
//
//- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
//{
//    page ++;
//    [self getLotteryHistory];
//}
//- (void)dragTableDidTriggerRefresh:(UITableView *)tableView{
//    page =1;
//    [self getLotteryHistory];
//}

//lc
#pragma mark - 添加导航栏上的开奖趋势按钮
- (void)addNavRightBtn{
    UIButton *trendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    trendBtn.frame=CGRectMake(0, 0, 60, 44);
    trendBtn.titleLabel.font  = [UIFont systemFontOfSize:13];
    [trendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [trendBtn addTarget:self action:@selector(showTrend:) forControlEvents:UIControlEventTouchUpInside];
    [trendBtn setTitle:@"开奖走势" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:trendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}
- (void)showTrend:(UIButton *)sender{
    
    
    {
        LotteryExtrendViewController * extrendViewCtr = [[LotteryExtrendViewController alloc] initWithNibName:@"LotteryExtrendViewController" bundle:nil];
        
        
        extrendViewCtr.lottery = _lottery;
//        [lotteryMan loadLotteryProfiles:_lottery];
        extrendViewCtr.title = @"大乐透走势图";
        //    时间显示(暂不做)
        LotteryPhaseInfoView *phaseInfoView = [[LotteryPhaseInfoView alloc] initWithFrame: CGRectZero];
        
        [phaseInfoView drawWithLottery: self.lottery];
        
        extrendViewCtr.timeString = [phaseInfoView timeSting];
        //    UINavigationController * navCtr = [[UINavigationController alloc] initWithRootViewController:extrendViewCtr];
        //
        //    CATransition *animation = [CATransition animation];
        //    animation.duration = 0.3;
        //    animation.type = kCATransitionPush;
        //    animation.subtype = kCATransitionFromRight;
        //    [self.view.window.layer addAnimation:animation forKey:nil];
        
        
        //    [self presentViewController:navCtr animated:NO completion:^{
        //    }];
        //    self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:extrendViewCtr animated:YES];
        //    self.hidesBottomBarWhenPushed = NO;
    }
}
#pragma mark - 立即投注
- (IBAction)buyNow:(id)sender {
    //在这进行页面跳转（等待购彩页面完成）
    [self hideLoadingView];
    
    
    if ([self.lottery.identifier isEqualToString:@"PL3"] || [self.lottery.identifier isEqualToString:@"PL5"]) {
        
//        [lotteryMan getLotteryCurRoundInfo:_lottery];
        
        
    }else if ([self.lottery.identifier isEqualToString:@"SSQ"]){
        SSQPlayViewController *playVC = [[SSQPlayViewController alloc] initWithNibName: @"DLTPlayViewController" bundle: nil];
        playVC.hidesBottomBarWhenPushed = YES;
        //    _lottery.currentRound = round;
        playVC.lottery = _lottery;
        [self.navigationController pushViewController: playVC animated: YES];
        
    }
    else{
        DLTPlayViewController *playVC = [[DLTPlayViewController alloc] initWithNibName: @"DLTPlayViewController" bundle: nil];
        playVC.hidesBottomBarWhenPushed = YES;
        //    _lottery.currentRound = round;
        playVC.lottery = _lottery;
    
        [self.navigationController pushViewController: playVC animated: YES];
    
    }
}

@end
