//
//  WBHomeJCYCViewController.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "WBHomeJCYCViewController.h"
#import "WBHomeYuceListCell.h"
#import "UMChongZhiViewController.h"
#import "HomeYCModel.h"
#import "WBLoopProgressView.h"
//#import "WBYCMatchDetailViewController.h"
//#import "JCZQScoreZhibo.h"
//#import "JCLQScoreZhibo.h"

@interface WBHomeJCYCViewController ()<UITableViewDelegate,UITableViewDataSource ,LotteryManagerDelegate,WBHomeYuceListCellDelegate>
{
    UIButton *_btnBendian;
    UIButton *_btnZongbiao;
    WBLoopProgressView *progressView;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *btnZuixinYuce;
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
@property (weak, nonatomic) IBOutlet UIButton *btnLishiYuce;
@property (weak, nonatomic) IBOutlet UITableView *tabYuceList;
@property(strong,nonatomic)NSString *lotteryTpey;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (strong,nonatomic)NSMutableArray <WBSelectDateButtom *> * dateButtons;

@property(nonatomic,strong)NSMutableArray <HomeYCModel *> *dataArray;
@property(nonatomic,strong)NSMutableArray *scoreArray;
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;

@property(assign,nonatomic)BOOL isHis;

@end

@implementation WBHomeJCYCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A119";
    self.dateButtons = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    self.scoreArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.arrayTableSectionIsOpen = [NSMutableArray arrayWithCapacity:0];
    _isHis = NO;
    self.title = @"预测战绩";
    [self setTableView];
    [self createWeekView];
    NSDate* curDate = [NSDate  dateWithTimeIntervalSinceNow:0];
    NSString *dateTtile = [Utility timeStringFromFormat:@"yyyy-MM-dd" withDate:curDate];
    [self loadData:dateTtile];
    
    progressView = [[WBLoopProgressView alloc]initWithFrame:CGRectMake(20,40, 150, 150)];
    progressView.color1 = [UIColor whiteColor];
    progressView.progress = 0.5;
    progressView.color2 = SystemLightGray;
    
    
    [self.viewHeader addSubview:progressView];
    
}

-(void)setTableView{
    [self.tabYuceList registerClass:[WBHomeYuceListCell class] forCellReuseIdentifier:@"WBHomeYuceListCell"];
    self.tabYuceList.delegate = self;
    self.scrollViewContent.delegate = self;
    self.tabYuceList.dataSource = self;
    self.tabYuceList.bounces = NO;
    
    self.tabYuceList.rowHeight = 130;
    self.tabYuceList.tableFooterView = [[UIView alloc]init];
    
    
}

/**
 * 获取最新预测列表
 * @param params {"lotteryCode":"jczq"}
 * @return JcForecastCache 的json
 * @throws CheckException
 */
//String listByForecast(@WebParam(name = "arg1") String params) throws CheckException;
-(void)loadData:(NSString *)date{
    [self showLoadingViewWithText:@"正在加载"];
    [self.lotteryMan listByForecast:@{@"lotteryCode":@"jczq",@"screenTime":date} isHis:YES];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tabYuceList) {
        if (self.scrollViewContent.contentSize.height>KscreenHeight) {
          
        }
    }else{
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - KscreenHeight-5) {
            [self.tabYuceList setValue:@(YES) forKey:@"scrollEnabled"];
        }
        if (scrollView.contentOffset.y <= -60) {
            [self.tabYuceList setValue:@(NO) forKey:@"scrollEnabled"];
        }
    }
}


-(void)gotlistByForecast:(NSArray *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    [self.dataArray removeAllObjects];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
    
   

    for (NSDictionary *itemDic in infoArray) {

        HomeYCModel *model = [[HomeYCModel alloc]initWithDic:itemDic];
        [self.dataArray addObject:model];
    }

    if (self.dataArray.count * 130 + 175 + 66 >KscreenHeight) {
        if (self.dataArray.count * 130 + 175 + 66 - KscreenHeight > 175) {
            self.scrollViewHeight.constant = 175 - 64;
        }else{
            self.scrollViewHeight.constant =self.dataArray.count * 130 + 175 + 66 - KscreenHeight - 64;
        }
        [self.tabYuceList setValue:@(NO) forKey:@"scrollEnabled"];
        
        
    }else{
        self.scrollViewHeight.constant = -64;
    }
    [self.tabYuceList reloadData];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBHomeYuceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WBHomeYuceListCell"];
    [cell refreshCellWithModel:self.dataArray[indexPath.row] isZuiXin:!self.isHis];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    matchDetailVC.model = self.dataArray[indexPath.row];
//    if ([matchDetailVC.model.spfSingle boolValue] == NO) {
//         matchDetailVC.isHis = YES;
//    }else{
//
//        
//    }

    matchDetailVC.isHis = self.isHis;
    matchDetailVC.curPlayType = self.lotteryTpey;
    [self.navigationController pushViewController:matchDetailVC animated:YES];
    
}



-(void)homeYuceListCellSelectMatchType:(id)para{

//    WBYCListViewController *yclistVC = [[WBYCListViewController alloc]init];
//    yclistVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:yclistVC animated:YES];
}

-(void)homeYuceListTouzhu:(HomeYCModel *)model{

    for (JcForecastOptions *ops in model.predict) {
        if ([ops.sp doubleValue] == 0) {

            [self showPromptText:@"该赛事暂不支持胜平负玩法" hideAfterDelay:1.7];
            return;

        }
    }

//    WBYCMatchDetailViewController *detailVC = [[WBYCMatchDetailViewController alloc]init];
//    detailVC.isFromYC = YES;
//    detailVC.curPlayType = self.lotteryTpey;
//    detailVC.isFromjcycVC = self.isFromjcycVC;
//    detailVC.model = [model jCZQScoreZhiboToJcForecastOptions];
//    [self.navigationController pushViewController:detailVC animated:YES];

}

-(void)createWeekView{
    float curX = 24;
    float width = (KscreenWidth - 48) /7;
    
    for (int i = 0; i < 7; i ++ ) {
        
        
        NSDate* curDate = [NSDate  dateWithTimeIntervalSinceNow:-(6-i) * 24 * 60 *60];
        NSString *dateTtile = [Utility timeStringFromFormat:@"dd" withDate:curDate];
        NSString *week = [Utility weekDayGetForTimeDate:curDate];
        WBSelectDateButtom *itemDate = [[WBSelectDateButtom alloc]initWithFrame:CGRectMake(curX, 0, width, self.selectDateView.mj_h - 1 )];
        itemDate.tag = 100+(6-i);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
        [itemDate addGestureRecognizer:tapGesture];
        
        [itemDate setTitle:dateTtile week:week];
        [self.dateButtons addObject:itemDate];
        [self.selectDateView addSubview:itemDate];
        if (i == 6) {
            [itemDate setIsSelect: YES];
        }
        curX += width;
    }
}

-(void)selectDate:(UIPanGestureRecognizer  *)gesture{

    for (WBSelectDateButtom *item in self.dateButtons) {
        [item setIsSelect: NO];
    }
   
   WBSelectDateButtom *itemDate = (WBSelectDateButtom *)gesture.view;
    NSDate* curDate = [NSDate  dateWithTimeIntervalSinceNow:(100 - itemDate.tag) * 24 * 60 *60];
    NSString *dateTtile = [Utility timeStringFromFormat:@"yyyy-MM-dd" withDate:curDate];
    [self loadData:dateTtile];
    [itemDate setIsSelect:!itemDate.isSelect];
}

@end
