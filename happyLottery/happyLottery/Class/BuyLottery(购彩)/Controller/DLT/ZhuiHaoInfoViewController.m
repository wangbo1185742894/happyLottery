//
//  OrderInfoViewController.m
//  Lottery
//
//  Created by only on 16/2/2.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "ZhuiHaoInfoViewController.h"
#import "LotteryManager.h"
#import "OrderTableViewCell.h"
#import "OrderProfile.h"
#import "OrderLotteryCateChooseView.h"
#import "OrderDatePickerView.h"

#import "ZHDetailViewController.h"

typedef enum {
    
    TouzhuItemBtTagIndexPuTongTZ = 1000,
    TouzhuItemBtTagIndexWoDeZH = 1001,
    TouzhuItemBtTagIndexCanYuHM,
    TouzhuItemBtTagIndexFaQiHM,
    
}TouzhuItemBtTagIndex;

@interface ZhuiHaoInfoViewController ()<LotteryManagerDelegate,UITableViewDataSource,UITableViewDelegate,OrderLotteryCateChooseViewDelegate,OrderDatePickerViewDelegate,ZHDetailViewControllerDelegate>{
    
    UINib *cellNib;
    IBOutletCollection(UIButton) NSArray *touzhuItemCollection;
    LotteryManager *lotteryMan;
    __weak IBOutlet UITableView *orderTableView;
    
    OrderLotteryCateChooseView * stateCateChooseView;
    OrderDatePickerView * timePickerView;
    
    __weak IBOutlet UIButton *orderTimeChooseBt;
    UIButton *lotteryTypeChooseBt;
    //    将状态分出来。。
    __weak IBOutlet UIButton *orderStateChooseBt;
    __weak IBOutlet NSLayoutConstraint *sepBackHeight;
}
@property (nonatomic , strong) NSMutableArray * ordersArray;

@property (nonatomic , strong) NSDictionary * orderStateDic;
@property (nonatomic , strong) NSDictionary * lotteryChoosedDic;
//10.26
@property (nonatomic , strong) NSDictionary * zhorderStateDic;
@property (nonatomic , strong) NSDictionary *zhcatchStateDic;
@property (nonatomic , strong) NSString * zhorderSt;
@property (nonatomic , strong) NSString * zhcatchSt;


@property (nonatomic , strong) UIButton * curTouZhuItemBt;
@property (nonatomic , strong) NSDate * orderBeginTime;
@property (nonatomic , strong) NSDate * orderEndTime;
@property (nonatomic , strong) NSString * orderStatus;
@property (nonatomic , strong) NSString * lotteryType;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectedButtons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLeading;
@property (nonatomic) int page;
@property (nonatomic,assign) BOOL isChange;
@end

@implementation ZhuiHaoInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    self.viewControllerNo = @"A205";
    [self hideLoadingView];
    self.page = 1;
    self.orderStatus = @"ALL";
    
    self.title = TextZhuiHaoInfo;


    self.lotteryMan.delegate = self;
    [UITableView refreshHelperWithScrollView:orderTableView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
    [self loadNewData];


    UIButton *btn = (UIButton*)_selectedButtons[0];
    btn.selected = YES;
    _isChange = YES;
    
}

-(void)loadNewData{
    _page = 1;
    [self getOrdersDataSource];
}

-(void)loadMoreData{
    _page ++;
    [self getOrdersDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)navigationBackToLastPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getOrdersDataSource{
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];
    if([_orderStatus isEqualToString:@"ALL"])
    {
        paraDic[@"chaseSchemeStatus"] = nil;
        paraDic[@"winStatus"] = nil;
    }
    else if([_orderStatus isEqualToString:@"NOT_LOTTERY"] ||[_orderStatus isEqualToString:@"LOTTERY"])
    {
        //@"ALL"->nil;若为所有订单，则不传
        paraDic[@"chaseSchemeStatus"] = nil;
        /*增加参数winstatus*/
        paraDic[@"winStatus"] = _orderStatus;
    }
    else
    {
        paraDic[@"chaseSchemeStatus"] = _orderStatus;
        /*增加参数winstatus*/
        
        paraDic[@"winStatus"] = nil;
    }
    
    paraDic[@"lottery"] = _lotteryType?_lotteryType:nil;
    paraDic[@"cardCode"] = [GlobalInstance instance].curUser.cardCode;
    paraDic[@"page"]= @(self.page);
    [self .lotteryMan listChaseSchemeForApp:paraDic];
}




- (NSDate *) dateFromThreeMonthBefor:(NSDate *)pointTime{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-3];
    [adcomps setDay:0];
    NSDate * date = [calendar dateByAddingComponents:adcomps toDate:pointTime options:0];
    return date;
}

#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ordersArray.count;
}
-(OrderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentify = @"orderCell";
    
    OrderTableViewCell *cell = (OrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentify];
    if (!cell) {
        if (cellNib == nil) {
            cellNib = [UINib nibWithNibName: @"OrderTableViewCell" bundle: nil];
        }
        cell = (OrderTableViewCell*)([cellNib instantiateWithOwner: nil options: 0][0]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    OrderProfile * order = _ordersArray[indexPath.row];
    [cell orderInforZhuihao:order];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderProfile * order = _ordersArray[indexPath.row];
    
    ZHDetailViewController *zhdetailViewCtr = [[ZHDetailViewController alloc]initWithNibName:@"ZHDetailViewController" bundle:nil];

            zhdetailViewCtr.delegate = self;
            zhdetailViewCtr.order = order;
            [self.navigationController pushViewController:zhdetailViewCtr animated:YES];
}

#pragma LotteryManagerDelegate methods

-(void)listChaseSchemeForApp:(NSArray *)infoDic errorMsg:(NSString *)msg{
    [self hideLoadingView];
    [orderTableView tableViewEndRefreshCurPageCount:10];
    if (nil == _ordersArray) {
        self.ordersArray = [NSMutableArray array];
    }
    
    if(self.page == 1)
    {
        [_ordersArray removeAllObjects];
    }
    
    if (infoDic != nil && infoDic.count != 0) {
        for (NSDictionary *itemDic in infoDic) {
            OrderProfile * order = [[OrderProfile alloc]initWith:itemDic];
            
            [_ordersArray addObject:order];
        }
        if (self.from == YES) {
            [self showPromptText:PaySuccessAlert hideAfterDelay:1.7];
            self.from = NO;
        }
    }
    [orderTableView reloadData];
}




#pragma OrderLotteryCateChooseViewDelegate methods
-(void)orderStateChoosed:(NSDictionary *)orderStateInfo{
    if(nil == orderStateInfo){
        return;
    }
    self.orderStateDic = orderStateInfo;
    [orderStateChooseBt setTitle:orderStateInfo[@"appearStr"] forState:UIControlStateNormal];
    [stateCateChooseView hide];
    self.orderStatus = orderStateInfo[@"value"];
    [self loadNewData];
}
//10.26
-(void)zhStateChoose:(NSDictionary *)state{
    if (nil == state) {
        return;
    }
    self.zhorderStateDic = state;
    [orderStateChooseBt setTitle:state[@"appearStr"] forState:UIControlStateNormal];
    [stateCateChooseView hide];
    NSString *str = state[@"value"];
    if([str isEqualToString:@"ALL"])
    {
        str = nil;
    }
    self.zhorderSt = state[@"value"];
    [self loadNewData];
}
-(void)zhCatchChoose:(NSDictionary *)catchState
{
    if (nil == catchState) {
        return;
    }
    self.zhcatchStateDic = catchState;
    [orderTimeChooseBt setTitle:catchState[@"appearStr"] forState:UIControlStateNormal];
    [stateCateChooseView hide];
    self.zhcatchSt = catchState[@"value"];
    [self loadNewData];
}
-(void)lotteryCateChoosed:(NSDictionary *)lotteryInfo{
    if(nil == lotteryInfo){
        return;
    }
    self.lotteryChoosedDic = lotteryInfo;
    [lotteryTypeChooseBt setTitle:_lotteryChoosedDic[@"Name"] forState:UIControlStateNormal];
    [stateCateChooseView hide];
    self.lotteryType = lotteryInfo[@"Identifier"];
    [self loadNewData];
}

#pragma OrderDatePickerViewDelegate methods

-(void)orderDateTimeChooseFinish{
    
    self.orderBeginTime = [timePickerView startTime];
    self.orderEndTime = [timePickerView endTime];
    NSString * timeDesc = @"自定义时间";
    [orderTimeChooseBt setTitle:timeDesc forState:UIControlStateNormal];
    
    [self loadNewData];
}


#pragma OrderDetailViewControllerDelegate  methods
-(void)cancelOrderSuccess:(OrderProfile *)order{
    [_ordersArray removeObject:order];
    [orderTableView reloadData];
}
-(void) showText
{
    [self showPromptText:TextDeleteSuc hideAfterDelay:2.5];
}
- (IBAction)lcChooseLotteytype:(UIButton *)sender {
    if (nil == stateCateChooseView) {
        stateCateChooseView = [[OrderLotteryCateChooseView alloc] initWithFrame:self.navigationController.view.bounds];
        stateCateChooseView.delegate = self;
    }
    stateCateChooseView.curSelectLotteryInfo = _lotteryChoosedDic;
    [stateCateChooseView show:self.navigationController.view withType:TableShowZHRightStateChoose];
    _isChange = YES;
    
}
- (IBAction)lcChooseOrderState:(UIButton *)sender {
    NSString *value;
    for (UIButton *btn in _selectedButtons) {
        if ([[sender titleForState:UIControlStateNormal] isEqualToString:[btn titleForState:UIControlStateNormal]]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"所有订单"]) {
        value = @"ALL";
    }
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"追号中"]) {
        value = @"CATCHING";
    }
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"已中奖"]) {
        value = @"LOTTERY";
    }
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"未中奖"]) {
        value = @"NOT_LOTTERY";
    }

    CGFloat downLineLeading = sender.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        _downLeading.constant = downLineLeading;
        [self.view layoutIfNeeded];
    }];
    
    self.orderStatus = value;
    [self loadNewData];
    _isChange = YES;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}



@end
