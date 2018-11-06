//
//  SchemeDetailViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GYJSchemeDetailViewController.h"
#import "JCLQOrderDetailInfoViewController.h"
#import "WordCupHomeItem.h"
#import "LotteryXHSection.h"
#import "JCZQSchemeModel.h"
#import "PayOrderLegViewController.h"
#import "CTZQWinResultCell.h"
#import "SchemeDetailMatchViewCell.h"
#import "SchemeDetailViewCell.h"
#import "TableHeaderView.h"
#import "OrderListHeaderView.h"
#import "SchemeCashPayment.h"
#import "SchemeInfoViewCell.h"
#import "MyOrderListViewController.h"
#import "DLTPlayViewController.h"
#import "GYJSchemeViewCell.h"

#import "GYJPlayViewController.h"
#define  KSchemeDetailMatchViewCell     @"SchemeDetailMatchViewCell"
#define  KSchemeDetailViewCell          @"SchemeDetailViewCell"
#define  KTableHeaderView               @"TableHeaderView"
#define  KSchemeInfoViewCell            @"SchemeInfoViewCell"

#define  KGYJSchemeViewCell             @"GYJSchemeViewCell"
#define     KCTZQWinResultCell           @"CTZQWinResultCell"
@interface GYJSchemeDetailViewController ()<LotteryManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet NSLayoutConstraint *heightZhifuView;
    __weak IBOutlet NSLayoutConstraint *mainViewHeight;
    __weak IBOutlet NSLayoutConstraint *tabviewHeight;
    Lottery *lottery_;
    JCZQSchemeItem *schemeDetail;
    __weak IBOutlet UIImageView *imgSchemeTopView;
    __weak IBOutlet UITableView *tabMatchListVIew;
    NSMutableArray  <JcBetContent * >*matchList;
    NSMutableArray *dltBetList;
    NSMutableArray *groupList;
    __weak IBOutlet UIButton *btnReBuy;
    __weak IBOutlet UIButton *btnPay;
    __weak IBOutlet NSLayoutConstraint *bottomIPhoneX;
    __weak IBOutlet NSLayoutConstraint *upIPhoneX;
}

@property(nonatomic,strong)NSArray *allLotter;
@end

@implementation GYJSchemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabMatchListVIew.hidden  =YES;
    self.title = @"方案详情";
    
    matchList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    self.lotteryMan.delegate = self;
    heightZhifuView.constant = 0;
    if ([self.imageName isEqualToString:@"winning"]) {
        self.navigationController.navigationBar.barTintColor  = RGBCOLOR(249, 91, 97);
    }else{
        self.navigationController.navigationBar.barTintColor = SystemGreen;
    }
    [self loadData];
    
    bottomIPhoneX.constant = [self isIphoneX]?34:0;
    upIPhoneX.constant = [self isIphoneX]?88:64;
}


-(void)setSchemeStateImg{
    NSString *imgName =[schemeDetail getSchemeImgState];
   [imgSchemeTopView setImage:[UIImage imageNamed: imgName]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.imageName isEqualToString:@"winning"]) {
        self.navigationController.navigationBar.barTintColor  = RGBCOLOR(249, 91, 97);
    }else{
        self.navigationController.navigationBar.barTintColor = SystemGreen;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = SystemGreen;
}

-(void)setTableView{
    tabMatchListVIew.delegate = self;
    tabMatchListVIew.dataSource = self;
    
    [tabMatchListVIew registerClass:[SchemeDetailMatchViewCell class] forCellReuseIdentifier: KSchemeDetailMatchViewCell];
    [tabMatchListVIew registerClass:[SchemeDetailViewCell class] forCellReuseIdentifier:KSchemeDetailViewCell];
    [tabMatchListVIew registerClass:[SchemeInfoViewCell class] forCellReuseIdentifier:KSchemeInfoViewCell];
    [tabMatchListVIew registerNib:[UINib nibWithNibName:KCTZQWinResultCell bundle:nil] forCellReuseIdentifier:KCTZQWinResultCell];
    [tabMatchListVIew registerClass:[GYJSchemeViewCell class] forCellReuseIdentifier:KGYJSchemeViewCell];

}

-(void)loadData{
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNO}];
}

-(void)gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }

    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    if ([schemeDetail.lottery isEqualToString:@"JCGYJ"]) {
        [self.lotteryMan listJcgyjItem:nil];
    }else{
        [self.lotteryMan listJcgjItem:nil];
    }
//    NSInteger itemIndex = 1;
    
    [self setSchemeStateImg];
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
        heightZhifuView.constant = 60;
        btnPay.hidden = NO;
        btnReBuy.hidden = YES;
        
    }else{
        if ([schemeDetail.lottery isEqualToString:@"JCGYJ"] ||[schemeDetail.lottery isEqualToString:@"JCGJ"]){
            btnPay.hidden = YES;
            btnReBuy.hidden = NO;
            heightZhifuView.constant = 60;
        }else{
            heightZhifuView.constant = 0;
        }
    }
    [tabMatchListVIew reloadData];

    [self hideLoadingView];
    tabMatchListVIew.hidden = NO;
}

-(void)gotlistJcgyjItem:(NSArray *)infoArray errorMsg:(NSString *)msg{
    [self gotlistJcgjItem:infoArray errorMsg:msg];
}

- (void) gotlistJcgjItem:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    
    if (infoArray == nil) {
        return;
    }
    if (groupList == nil) {
        groupList = [NSMutableArray arrayWithCapacity:0];
    }
    [groupList removeAllObjects];
    for (int i = 0 ; i < infoArray.count; i++ ) {
        NSDictionary *itemDic = infoArray[i];
        WordCupHomeItem *model = [[WordCupHomeItem alloc]initWith:itemDic];
        [groupList addObject:model];
    }
    [tabMatchListVIew reloadData];
}

- (IBAction)actionOrderDetail:(UIButton *)sender {
    JCLQOrderDetailInfoViewController *orderDetailVC = [[JCLQOrderDetailInfoViewController alloc]init];
    orderDetailVC.schemeNO = self.schemeNO;
    orderDetailVC.lotteryCode = schemeDetail.lottery;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)actionGotoTouzhu:(id)sender {
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.schemeNo = schemeDetail.schemeNO;
    payVC.subscribed = [schemeDetail.betCost doubleValue];
    payVC.postBoyId = schemeDetail.postboyId;
    if ([schemeDetail.lottery isEqualToString:@"RJC"]){
        payVC.lotteryName = @"任选9场";
    }else if ([schemeDetail.lottery isEqualToString:@"SFC"]){
        payVC.lotteryName = @"胜负14场";
    }else if ([schemeDetail.lottery isEqualToString:@"JCGJ"]){
        payVC.lotteryName = @"冠军";
    }else if ([schemeDetail.lottery isEqualToString:@"JCGYJ"]){
        payVC.lotteryName = @"冠亚军";
    }
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0) {
            return 3;
        }else{
            return 4;
        }
    }else{
        if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0) {
            return 2;
        }else{
            return 3;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tabviewHeight.constant = tabMatchListVIew.contentSize.height;
        if (tabMatchListVIew.contentSize .height + 80 > KscreenHeight - 64) {
            mainViewHeight.constant = tabMatchListVIew.contentSize .height + 80;
        }else{
            mainViewHeight.constant = KscreenHeight - 64;
        }
        
        tabMatchListVIew.bounces = NO;
    });
    
    if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0) {
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if (indexPath.section == 2){ // 显示方案投注内容
                
                GYJSchemeViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KGYJSchemeViewCell];
                if (schemeDetail != nil) {
                    [matchCell refreshDataWith:schemeDetail];
                }
                return matchCell;
            }else if (indexPath.section == 1){
                SchemeInfoViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoViewCell];
                if (schemeDetail != nil) {
                    [infoCell loadData:schemeDetail];
                }
                cell = infoCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if (indexPath.section == 1){ // 显示方案投注内容
                
                GYJSchemeViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KGYJSchemeViewCell];
                if (schemeDetail != nil) {
                    [matchCell refreshDataWith:schemeDetail];
                }
                cell = matchCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if(indexPath.section == 1){
                CTZQWinResultCell *resultCell =[tableView dequeueReusableCellWithIdentifier:KCTZQWinResultCell];
                [resultCell refreshWithInfoGYJ:[self getGYJWinString]];
                cell = resultCell;
                
            }else if (indexPath.section == 3){ // 显示方案投注内容
                
                GYJSchemeViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KGYJSchemeViewCell];
                if (schemeDetail != nil) {
                    [matchCell refreshDataWith:schemeDetail];
                }
                return matchCell;
            }else if (indexPath.section == 2){
                SchemeInfoViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoViewCell];
                if (schemeDetail != nil) {
                    [infoCell loadData:schemeDetail];
                }
                cell = infoCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if(indexPath.section == 1){
                CTZQWinResultCell *resultCell =[tableView dequeueReusableCellWithIdentifier:KCTZQWinResultCell];
                [resultCell refreshWithInfo:[self getGYJWinString]];
                cell = resultCell;
                
            }else if (indexPath.section == 2){ // 显示方案投注内容
                
                GYJSchemeViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KGYJSchemeViewCell ];
                if (schemeDetail != nil) {
                    [matchCell refreshDataWith:schemeDetail];
                }
                cell = matchCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

-(NSString *)getGYJWinString{
    for (WordCupHomeItem *item in groupList) {
        if ([schemeDetail.winMatchIndex isEqual:item.indexNumber]) {
            
            return item.clash;
        }
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0){
        
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==2){
//                return 200;
                return [schemeDetail getGYJCellHeight];
            }else if (indexPath.section ==1){
                if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
                    return 110;
                }else{
                    
                    return 110;
                }
            }
        }else{
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==1){
                return [schemeDetail getGYJCellHeight];
            }
        }
    } else{
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==3){
                return [schemeDetail getGYJCellHeight];
            }else if (indexPath.section ==2){
                if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
                    return 110;
                }else{
                    return 110;
                }
            }else if(indexPath.section == 1){
                return 50;
            }
        }else{
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==2){
                return [schemeDetail getGYJCellHeight];
            }else if(indexPath.section == 1){
                return 50;
            }
        }
    }

    return 0;
}

-(NSString*)getContentJCZQ:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
        if ([dic[@"code"] integerValue]  == [option integerValue]) {
            return dic[@"appear"];
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0) {
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            
            if (section == 2) {
                
                if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                    return 30;
                }else{
                    return 30;
                }
                
            }else{
                return  30;
            }
        }else{
            
            if (section == 1) {
                
                if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                    return 30;
                }else{
                    return 30;
                }
                
            }else{
                return  30;
            }
        }
    }else{
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            
            if (section == 3) {
                
                if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                    return 30;
                }else{
                    return 30;
                }
                
            }else{
                return  30;
            }
        }else{
            
            if (section == 2) {
                
                if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                    return 30;
                }else{
                    return 30;
                }
                
            }else{
                return  30;
            }
        }
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderListHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"OrderListHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor = RGBCOLOR(253 , 252, 245);
    
    if (schemeDetail.winMatchIndex == nil || schemeDetail.winMatchIndex.length ==0) {
        
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (section == 0) {
                header.titleLa.text = @"方案信息";
            }else if (section == 2){
                if (![schemeDetail.costType isEqualToString:@"CASH"]) {
                    header.titleLa.text = @"方案内容";
                }else{
                    [self showMySchemeHeader:header];
                }
                
            }else if (section == 1){
                header.titleLa.text = @"认购信息";
            }
            return header;
        }else{
            
            if (section == 0) {
                header.titleLa.text = @"方案信息";
            }else if (section == 1){
                if (![schemeDetail.costType isEqualToString:@"CASH"]) {
                    header.titleLa.text = @"方案内容";
                }else{
                    [self showMySchemeHeader:header];
                }
            }
            return header;
        }
    }else{
        
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (section == 0) {
                header.titleLa.text = @"方案信息";
            }else if (section == 3){
                if (![schemeDetail.costType isEqualToString:@"CASH"]) {
                    header.titleLa.text = @"方案内容";
                }else{
                    [self showMySchemeHeader:header];
                }
                
            }else if (section == 1){
                header.titleLa.text = @"开奖信息";
            }else if (section == 2){
                header.titleLa.text = @"认购信息";
            }
            return header;
        }else{
            
            if (section == 0) {
                header.titleLa.text = @"方案信息";
            }else if (section == 2){
                if (![schemeDetail.costType isEqualToString:@"CASH"]) {
                    header.titleLa.text = @"方案内容";
                }else{
                    [self showMySchemeHeader:header];
                }
                
            }else if(section == 1){
                header.titleLa.text = @"开奖信息";
            }
            return header;
        }
    }
  
  
    
}

-(void)showMySchemeHeader:(OrderListHeaderView *)header{
    
    header.titleLa.text = @"方案内容";
    header.labLine.hidden = YES;
    header.labSpinfo.hidden = YES;
    header.labOrderDetail.hidden = YES;
    UIButton  *ticketLa = [UIButton buttonWithType:UIButtonTypeCustom];
    ticketLa.frame = CGRectMake(KscreenWidth - 80, 5, 70, 25);
    
    ticketLa.titleLabel.font = [UIFont systemFontOfSize:13];
    [ticketLa setTitleColor:SystemGreen forState:UIControlStateNormal];
    ticketLa.titleLabel.adjustsFontSizeToFitWidth = YES;
    if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 ) {
        [ticketLa setTitle:@"订单详情>" forState:UIControlStateNormal];
        header.viewPeiLvInfo.hidden = NO;
        ticketLa.enabled = YES;
    }else{
        header.viewPeiLvInfo.hidden = YES;
        ticketLa.enabled = NO;
    }
    [header addSubview:ticketLa];
    [ticketLa addTarget:self action:@selector(actionOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
    [header.btnOrderDetail addTarget:self action:@selector(actionOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)navigationBackToLastPage{
    
    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
        if ([baseVC isKindOfClass:[MyOrderListViewController class]]) {
            [self.navigationController popToViewController:baseVC animated:YES];
            return;
        }
    }
    [super navigationBackToLastPage];
}
- (IBAction)actionReBuy:(UIButton *)sender {
    GYJPlayViewController *gyjPlayVc = [[GYJPlayViewController alloc]init];
    gyjPlayVc.hidesBottomBarWhenPushed = YES;
    gyjPlayVc.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:gyjPlayVc animated:YES];
}
@end
