//
//  SchemeDetailViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "DLTSchemeDetailViewController.h"
#import "JCLQOrderDetailInfoViewController.h"
#import "LotteryXHSection.h"
#import "JCZQSchemeModel.h"
#import "WinResultTableCell.h"
#import "PayOrderViewController.h"
#import "SchemeDetailMatchViewCell.h"
#import "SchemeDetailViewCell.h"
#import "TableHeaderView.h"
#import "OrderListHeaderView.h"
#import "SchemeCashPayment.h"
#import "SchemeInfoViewCell.h"
#import "MyOrderListViewController.h"
#import "DLTPlayViewController.h"

#import "DLTSchemeViewCell.h"
#import "DLTTouZhuViewController.h"

#import "SSQPlayViewController.h"

#define  KSchemeDetailMatchViewCell     @"SchemeDetailMatchViewCell"
#define  KSchemeDetailViewCell          @"SchemeDetailViewCell"
#define  KTableHeaderView               @"TableHeaderView"
#define  KSchemeInfoViewCell            @"SchemeInfoViewCell"
#define  KDLTSchemeViewCell             @"DLTSchemeViewCell"
#define KWinResultTableCell             @"WinResultTableCell"
@interface DLTSchemeDetailViewController ()<LotteryManagerDelegate,UITableViewDelegate,UITableViewDataSource>
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
    __weak IBOutlet UIButton *btnReBuy;
    __weak IBOutlet UIButton *btnPay;
}

@property(nonatomic,strong)NSArray *allLotter;
@end

@implementation DLTSchemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabMatchListVIew.hidden  =YES;
    self.title = @"方案详情";
    _allLotter = [self.lotteryMan getAllLottery];
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
    [tabMatchListVIew registerClass:[DLTSchemeViewCell class] forCellReuseIdentifier:KDLTSchemeViewCell];
    [tabMatchListVIew registerNib:[UINib nibWithNibName:KWinResultTableCell bundle:nil] forCellReuseIdentifier:KWinResultTableCell];

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
    NSInteger itemIndex = 1;
    
    dltBetList = [Utility objFromJson: schemeDetail.betContent];
        
 

    
    [self setSchemeStateImg];
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
        heightZhifuView.constant = 60;
        btnPay.hidden = NO;
        btnReBuy.hidden = YES;
        
    }else{
        
            btnPay.hidden = YES;
            btnReBuy.hidden = NO;
            heightZhifuView.constant = 60;
        
    }
    [tabMatchListVIew reloadData];

    [self hideLoadingView];
    tabMatchListVIew.hidden = NO;
}

- (IBAction)actionOrderDetail:(UIButton *)sender {
    JCLQOrderDetailInfoViewController *orderDetailVC = [[JCLQOrderDetailInfoViewController alloc]init];
    orderDetailVC.schemeNO = self.schemeNO;
    orderDetailVC.lotteryCode = schemeDetail.lottery;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)actionGotoTouzhu:(id)sender {
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo =schemeDetail.schemeNO;
    schemeCashModel.subCopies = 1;
    if ([schemeDetail.lottery isEqualToString:@"DLT"]) {
        schemeCashModel.lotteryName = @"大乐透";
    } else {
        schemeCashModel.lotteryName = @"双色球";
    }
    
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        schemeCashModel.costType = CostTypeCASH;
        
        schemeCashModel.subscribed = [schemeDetail.betCost integerValue];
        schemeCashModel.realSubscribed = [schemeDetail.betCost integerValue];
    }else{
        schemeCashModel.costType = CostTypeSCORE;
        
        schemeCashModel.subscribed = [schemeDetail.betCost integerValue] /100;
        schemeCashModel.realSubscribed = [schemeDetail.betCost integerValue]/100;
    }
   
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0){
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (section == 2){
                NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
                if (betContent == nil) {
                    return 0;
                }
                
                return dltBetList.count;
            }else{
                return 1;
            }
        }else{
            if (section == 1){
                NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
                if (betContent == nil) {
                    return 0;
                }
                
                return dltBetList.count;
            }else{
                return 1;
            }
        }
    }else{
        
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (section == 3){
                NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
                if (betContent == nil) {
                    return 0;
                }
                
                return dltBetList.count;
            }else{
                return 1;
            }
        }else{
            if (section == 2){
                NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
                if (betContent == nil) {
                    return 0;
                }
                
                return dltBetList.count;
            }else{
                return 1;
            }
        }
    }


    return 0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0) {
            return 3;
        }else{
            return 4;
        }
    }else{
        if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0) {
            return 2;
        }else{
            return 3;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tabviewHeight.constant = tabMatchListVIew.contentSize.height;
        mainViewHeight.constant = tabMatchListVIew.contentSize .height + 80;
        tabMatchListVIew.bounces = NO;
    });
    
    if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0){
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if (indexPath.section == 2){ // 显示方案投注内容
                
                DLTSchemeViewCell *dltCell = [tableView dequeueReusableCellWithIdentifier:KDLTSchemeViewCell];
                if (schemeDetail != nil) {
                    [dltCell refreshDataWith:dltBetList[indexPath.row] andOpenResult:schemeDetail.trDltOpenResult andLotteryType:schemeDetail.lottery];
                }
                [dltCell setNumIndex:[NSString stringWithFormat:@"%ld",indexPath.row + 1] andIsShow:dltBetList.count == 1];
                cell = dltCell;
                
                
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
                
                DLTSchemeViewCell *dltCell = [tableView dequeueReusableCellWithIdentifier:KDLTSchemeViewCell];
                if (schemeDetail != nil) {
                    [dltCell refreshDataWith:dltBetList[indexPath.row] andOpenResult:schemeDetail.trDltOpenResult andLotteryType:schemeDetail.lottery];
                }
                [dltCell setNumIndex:[NSString stringWithFormat:@"%ld",indexPath.row] andIsShow:dltBetList.count == 1];
                cell = dltCell;
                
                
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
            }else if (indexPath.section == 3){ // 显示方案投注内容
                
                DLTSchemeViewCell *dltCell = [tableView dequeueReusableCellWithIdentifier:KDLTSchemeViewCell];
                if (schemeDetail != nil) {
                    [dltCell refreshDataWith:dltBetList[indexPath.row] andOpenResult:schemeDetail.trDltOpenResult andLotteryType:schemeDetail.lottery];
                }
                [dltCell setNumIndex:[NSString stringWithFormat:@"%ld",indexPath.row + 1] andIsShow:dltBetList.count == 1];
                cell = dltCell;
                
                
            }else if (indexPath.section == 2){
                SchemeInfoViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoViewCell];
                if (schemeDetail != nil) {
                    [infoCell loadData:schemeDetail];
                }
                cell = infoCell;
            }else if(indexPath.section == 1){
                WinResultTableCell * winCell = [tableView dequeueReusableCellWithIdentifier:KWinResultTableCell];
                [winCell refreshWithInfo:schemeDetail.trDltOpenResult];
                cell = winCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.section == 0) { // 显示 方案信息
                SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
                [detailCell reloadDataModel:schemeDetail];
                cell = detailCell;
            }else if (indexPath.section == 2){ // 显示方案投注内容
                
                DLTSchemeViewCell *dltCell = [tableView dequeueReusableCellWithIdentifier:KDLTSchemeViewCell];
                if (schemeDetail != nil) {
                 [dltCell refreshDataWith:dltBetList[indexPath.row] andOpenResult:schemeDetail.trDltOpenResult andLotteryType:schemeDetail.lottery];
                }
                [dltCell setNumIndex:[NSString stringWithFormat:@"%ld",indexPath.row] andIsShow:dltBetList.count == 1];
                cell = dltCell;
 
            }else if(indexPath.section ==  1){
                WinResultTableCell * winCell = [tableView dequeueReusableCellWithIdentifier:KWinResultTableCell];
                [winCell refreshWithInfo:schemeDetail.trDltOpenResult];
                cell = winCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
   

}

-(BOOL)showNum{
    NSInteger tempNum = 0;
    for (JcBetContent *model in matchList) {
        if (model.isShow == YES) {
            tempNum ++;
        }
    }
    if (tempNum == 1) {
        return NO;
    }else{
        return YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0){
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==2){
                
                DLTSchemeViewCell *temp = [[DLTSchemeViewCell alloc]init];
                return [temp getCellHeightWith:dltBetList[indexPath.row]];
                
                
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
                
                DLTSchemeViewCell *temp = [[DLTSchemeViewCell alloc]init];
                return [temp getCellHeightWith:dltBetList[indexPath.row]];
            }
        }
    }else{
        if ([schemeDetail.costType isEqualToString:@"CASH"]) {
            if (indexPath.section == 0) {
                return [schemeDetail getJCZQCellHeight];
            }else if (indexPath.section ==3){
                
                DLTSchemeViewCell *temp = [[DLTSchemeViewCell alloc]init];
                return [temp getCellHeightWith:dltBetList[indexPath.row]];
                
                
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
                
                DLTSchemeViewCell *temp = [[DLTSchemeViewCell alloc]init];
                return [temp getCellHeightWith:dltBetList[indexPath.row]];
            }else if(indexPath.section == 1){
                return 50;
            }
        }
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0) {
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
    
    if (schemeDetail.trDltOpenResult == nil || schemeDetail.trDltOpenResult.length ==0) {
        
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
    if ([schemeDetail.lottery isEqualToString:@"DLT"]||[schemeDetail.lottery isEqualToString:@"SSQ"]) {
        for (Lottery  *lottery in _allLotter) {
            if ([lottery.identifier isEqualToString:schemeDetail.lottery]) {
                lottery_  = lottery;
                
            }
        }
        
        _lotteryTransaction = [[LotteryTransaction alloc] init];
        
        _lotteryTransaction.beiTouCount = 1;
        _lotteryTransaction.qiShuCount = 1;
        _lotteryTransaction.lottery = lottery_;
        
        NSArray * betcontent = [Utility objFromJson: schemeDetail.betContent];
        NSString * strbBetType;
        for (NSDictionary *betDic in betcontent) {
            
            
            
            
            LotteryBet * Bet = [[LotteryBet alloc] init];
            
            
            Bet.sectionDataLinkSymbol = lottery_.dateSectionLinkSymbol;
            
            NSInteger cost = 2;
            Bet.betType = 0;
   
            strbBetType = @"0";
            if ([lottery_.identifier isEqualToString:@"DLT"]||[lottery_.identifier isEqualToString:@"SSQ"]){
                Bet.betType = 101 + (int )[betDic[@"betType"] integerValue];
                cost = 2;
                switch ([betDic[@"betType"] integerValue]) {
                    case 0:
                    Bet.betTypeDesc = @"单式";
                    break;
                    case 1:
                    Bet.betTypeDesc = @"复式";
                    break;
                    case 2:
                    Bet.betTypeDesc = @"胆拖";
                    break;
                    default:
                    break;
                }
                NSArray *redList = betDic[@"redList"];
                NSArray *redDanList = betDic[@"redDanList"];
                NSArray *blueList = betDic[@"blueList"];
                NSArray *blueDanList = betDic[@"blueDanList"];
                NSString *strRedList = [redList componentsJoinedByString:@","];
                NSString *strRedDanlist =[NSString stringWithFormat:@"[胆:%@]",[redDanList componentsJoinedByString:@","]] ;
                NSString *strBlueList = [blueList componentsJoinedByString:@","];
                NSString *strBlueDanList =[NSString stringWithFormat:@"[胆:%@]",[blueDanList componentsJoinedByString:@","]] ;
                NSString *betNumDesc = [NSString stringWithFormat:@"%@%@\n%@%@",strRedDanlist.length == 4?@"":strRedDanlist,strRedList,strBlueDanList.length == 4?@"":strBlueDanList,strBlueList];
                
                NSMutableAttributedString *numberAttributedString;
                numberAttributedString = [[NSMutableAttributedString alloc]initWithString:betNumDesc];
                [numberAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:SystemRed} range:NSMakeRange(0, strRedList.length + (strRedDanlist.length== 4?0:strRedDanlist.length))];
                [numberAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:SystemBlue} range:NSMakeRange(strRedList.length + (strRedDanlist.length == 4?0:strRedDanlist.length) , (strBlueDanList.length== 4?0:strBlueDanList.length) + strBlueList.length +1)];
                Bet.betNumbersDesc = numberAttributedString;
                LotteryXHSection *l1 = [[LotteryXHSection alloc]init];
                l1.sectionID = @"1";
                LotteryXHSection *l2 = [[LotteryXHSection alloc]init];
                l2.sectionID = @"2";
                if (Bet.lotteryDetails == nil) {
                    Bet.lotteryDetails = @[l1,l2];
                }
                
                
                Bet.betNumbers = [@{@"1":@{@"numberselected":redList,@"numberdanhao":redDanList},@"2":@{@"numberselected":blueList,@"numberdanhao":blueDanList}} mutableCopy];
                
            }
            
            [Bet setBetCount:(int )[betDic[@"units"] integerValue]];
            [Bet setBetsCost:[betDic[@"units"] integerValue] * cost];
            
            if (betcontent.count >1) {
                
                [self.lotteryTransaction addBet:Bet];
            }
            
        }
        
        if (betcontent.count == 1) {
            
            DLTPlayViewController *lpVC = [[DLTPlayViewController alloc] init];
            lpVC.isReBuy = YES;
            if ([schemeDetail.lottery isEqualToString:@"DLT"]||[schemeDetail.lottery isEqualToString:@"SSQ"]){
                lpVC.selectedNumber =betcontent;
            }
            
            
            lpVC.lottery = lottery_;
            [self.navigationController pushViewController:lpVC animated:YES];
        }else{
            if ([schemeDetail.lottery isEqualToString:@"DLT"]) {
                DLTPlayViewController *lpVC = [[DLTPlayViewController alloc] init];
                lpVC.isReBuy = NO;
                lpVC.lotteryTransaction = _lotteryTransaction;
                lpVC.lottery = lottery_;
                [self.navigationController pushViewController:lpVC animated:NO];
            } else {
                SSQPlayViewController *lpVC = [[SSQPlayViewController alloc] init];
                lpVC.isReBuy = NO;
                lpVC.lotteryTransaction = _lotteryTransaction;
                lpVC.lottery = lottery_;
                [self.navigationController pushViewController:lpVC animated:NO];
            }
            
        }
        
    }
}

@end
