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
#import "YCSchemeViewCell.h"

#define KYCSchemeViewCell @"YCSchemeViewCell"

@interface WBHomeJCYCViewController ()<UITableViewDelegate,UITableViewDataSource ,LotteryManagerDelegate,WBHomeYuceListCellDelegate>
{
    UIButton *_btnBendian;
    UIButton *_btnZongbiao;
    WBLoopProgressView *progressView;
    
    __weak IBOutlet UIButton *tabNoDataImg;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *btnZuixinYuce;
@property (strong, nonatomic) UIView *selectDateView;
@property (weak, nonatomic) IBOutlet UIButton *btnLishiYuce;


@property (weak, nonatomic) IBOutlet UITableView *tabYuceList;
@property(strong,nonatomic)NSString *lotteryTpey;


@property (strong,nonatomic)NSMutableArray <WBSelectDateButtom *> * dateButtons;

@property(nonatomic,strong)NSMutableArray <HomeYCModel *> *dataArray;
@property(nonatomic,strong)NSMutableArray *scoreArray;
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;

@property(nonatomic,strong)NSDictionary *infoDic;

@property(assign,nonatomic)BOOL isHis;

@end

@implementation WBHomeJCYCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabNoDataImg.adjustsImageWhenHighlighted = YES;
    tabNoDataImg.userInteractionEnabled = NO;
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
    [self getForecastTotal];
    
}

-(void)getForecastTotal{
    [self.lotteryMan getForecastTotal:nil];
}

-(void)gotForecastTotal:(NSDictionary *)infoDic errorMsg:(NSString *)msg{
    if (infoDic == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    
    self.infoDic = infoDic;
    [self .tabYuceList reloadData];
}

-(void)setTableView{
    [self.tabYuceList registerClass:[WBHomeYuceListCell class] forCellReuseIdentifier:@"WBHomeYuceListCell"];
    [self.tabYuceList registerClass:[YCSchemeViewCell class] forCellReuseIdentifier:KYCSchemeViewCell];
    
    self.tabYuceList.delegate = self;
    self.scrollViewContent.delegate = self;
    self.tabYuceList.dataSource = self;
    

    self.tabYuceList.tableFooterView = [[UIView alloc]init];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return  self.tabYuceList.rowHeight = 180;
    }else{
        
      return   self.tabYuceList.rowHeight = 130;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 80;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [self createWeekView];
    }else{
        return [[UIView alloc]init];
    }
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

    
    tabNoDataImg.hidden = !(self.dataArray.count == 0);
    if (self.dataArray.count == 0) {
        self.tabYuceList.bounces = NO;
    }else{
        self.tabYuceList.bounces = YES;
    }
   
    
    [self.tabYuceList reloadData];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YCSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KYCSchemeViewCell];
        if (self.infoDic != nil) {
            
            [cell loadData:self.infoDic];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        WBHomeYuceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WBHomeYuceListCell"];
        [cell refreshCellWithModel:self.dataArray[indexPath.row] isZuiXin:!self.isHis];
        [cell setMatchResult:self.dataArray[indexPath.row].matchResult];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
        return self.dataArray.count;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
        matchDetailVC.model = self.dataArray[indexPath.row];
        matchDetailVC.isHis = YES;
        matchDetailVC.curPlayType = self.lotteryTpey;
        [self.navigationController pushViewController:matchDetailVC animated:YES];
        
    }

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

-(UIView *)createWeekView{
    float curX = 24;
    float width = (KscreenWidth - 48) /7;
    if (self.selectDateView == nil) {
        self.selectDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 80)];
        self.selectDateView .backgroundColor = [UIColor whiteColor];
        
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
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 79, KscreenWidth, 1)];
        lab.backgroundColor = TFBorderColor;
        [self.selectDateView addSubview:lab];
    }

    return self.selectDateView;
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
