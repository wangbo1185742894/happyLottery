//
//  CTZQWinHistoryViewController.m
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQWinHistoryViewController.h"
#import "CTZQWinHistoryTableViewCell.h"
#import "CTZQOpenLotteryViewController.h"
#import "CTZQPlayViewController.h"

#define PageNumber 30
#define TABLEBOTTOM 51 
@interface CTZQWinHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,LotteryManagerDelegate>
{

    int page;
}
@property(nonatomic, strong)NSMutableArray *matchArr;
@property (weak, nonatomic) IBOutlet UITableView *matchTableView;
@property (weak, nonatomic) IBOutlet UIButton *playGoon;
@property (strong, nonatomic)LotteryManager * lotteryMan;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;

@property (weak, nonatomic) IBOutlet UIView *btnView;

@end

@implementation CTZQWinHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A315";
    page = 1;
    self.title = @"开奖记录";
//    [self setUpMatchArrWith:nil];
    [self setUpMatchTableView];
    self.matchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self refreshData];
        [self.matchTableView.mj_header endRefreshing];
    }];
    
    self.matchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        
        [self refreshData];
        
        [self.matchTableView.mj_footer endRefreshing];
    }];
    self.lotteryMan = [[LotteryManager alloc] init];
    self.lotteryMan.delegate = self;
    [self getLotteryHistory];
    
    if (_isFromOpenLottery) {
        NSLog(@"lc 现在应该添加 投注 按钮 和 nav右侧的趋势按钮。");
        _tableBottom.constant = TABLEBOTTOM ;
        
        _btnView.hidden = NO;
        
    }else{
        _tableBottom.constant = 0 ;
        _btnView.hidden = YES;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)getLotteryHistory{
    NSString *identifier = @"SFC";
    
    NSDictionary * getRoundNeedInfo = @{@"count":[NSString stringWithFormat:@"%d",page*PageNumber],@"identifier":identifier};
//    [_lotteryMan getLotteryRoundInfo:getRoundNeedInfo];
}
- (void)gotLotteryRounds:(NSArray *)rounds{
//    [self setUpMatchArrWith:rounds];
    
    [self hideLoadingView];
    [_matchArr removeAllObjects];
    if (nil == _matchArr) {
        _matchArr = [NSMutableArray array];
    }
    if (rounds) {
        for (NSDictionary * dic in rounds) {
            if ([_matchArr containsObject:dic]) {
                return;
            } else {
                [_matchArr addObject:dic];
            }
        }
        
    } else {
        [_matchTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [_matchTableView reloadData];
    
    
}

-(void)refreshData{


}

- (void)setUpMatchArrWith:(id)info{
    if (nil == _matchArr) {
        _matchArr = [[NSMutableArray alloc] init];
        
//        for (NSInteger i = 0; i<14; i++) {
//            [_matchArr addObject:@(i)];
//        }
    }
    
}

- (void)setUpMatchTableView{
    [_matchTableView registerNib:[UINib nibWithNibName:@"CTZQWinHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CTZQWinHistoryTableViewCell"];
    _matchTableView.backgroundColor = MAINBGC;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _matchArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTZQWinHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTZQWinHistoryTableViewCell" forIndexPath:indexPath];
    
    LotteryRound * round = _matchArr[indexPath.row];
    [cell cellFillInfo:round];
    
    
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
- (IBAction)actionPlayGoon:(UIButton *)sender {
    
    CTZQPlayViewController *plVC = [[CTZQPlayViewController alloc] initWithNibName:@"CTZQPlayViewController" bundle:nil];
    plVC.lottery = _lottery;
    [self.navigationController pushViewController:plVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CTZQOpenLotteryViewController *openVC = [[CTZQOpenLotteryViewController alloc]init];
    openVC.matchArray = _matchArr;
    openVC.lottery = _lottery;
    openVC.isFromOpenLottery = _isFromOpenLottery;
    LotteryRound * round = _matchArr[indexPath.row];
    openVC.issueSelected = round.issueNumber;
    openVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:openVC animated:YES];

}



@end
