//
//  SchemeDetailViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "JCLQSchemeDetailViewController.h"
#import "JCLQOrderDetailInfoViewController.h"
#import "LotteryXHSection.h"
#import "JCLQSchemeModel.h"
#import "PayOrderLegViewController.h"
#import "SchemeDetailMatchViewCell.h"
#import "SchemeDetailViewCell.h"
#import "TableHeaderView.h"
#import "OrderListHeaderView.h"
#import "SchemeCashPayment.h"
#import "SchemeInfoViewCell.h"
#import "MyOrderListViewController.h"

#import "JCLQPlayController.h"
#import "LegInfoViewCell.h"
#import "DLTSchemeViewCell.h"
#import "DLTTouZhuViewController.h"

#define  KSchemeDetailMatchViewCell     @"SchemeDetailMatchViewCell"
#define  KSchemeDetailViewCell          @"SchemeDetailViewCell"
#define  KTableHeaderView               @"TableHeaderView"
#define  KSchemeInfoViewCell            @"SchemeInfoViewCell"
#define  KDLTSchemeViewCell             @"DLTSchemeViewCell.h"
#define KLegInfoViewCell @"LegInfoViewCell"
@interface JCLQSchemeDetailViewController ()<LotteryManagerDelegate,UITableViewDelegate,UITableViewDataSource,SchemeDetailViewDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *heightZhifuView;
    __weak IBOutlet NSLayoutConstraint *mainViewHeight;
    __weak IBOutlet NSLayoutConstraint *tabviewHeight;
    Lottery *lottery_;
    JCLQSchemeItem *schemeDetail;
    __weak IBOutlet UIImageView *imgSchemeTopView;
    __weak IBOutlet UITableView *tabMatchListVIew;
    NSMutableArray  <JlBetContent * >*matchList;
    NSMutableArray *dltBetList;
    __weak IBOutlet UIButton *btnReBuy;
    __weak IBOutlet UIButton *btnPay;
    __weak IBOutlet NSLayoutConstraint *bottomIphoneX;
    __weak IBOutlet NSLayoutConstraint *upIPhoneX;
}

@property(nonatomic,strong)NSArray *allLotter;
@end

@implementation JCLQSchemeDetailViewController

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
    bottomIphoneX.constant = [self isIphoneX]?34:0;
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
    [tabMatchListVIew registerNib:[UINib nibWithNibName:KLegInfoViewCell bundle:nil] forCellReuseIdentifier:KLegInfoViewCell];
    [tabMatchListVIew registerClass:[SchemeDetailViewCell class] forCellReuseIdentifier:KSchemeDetailViewCell];
    [tabMatchListVIew registerClass:[SchemeInfoViewCell class] forCellReuseIdentifier:KSchemeInfoViewCell];
    [tabMatchListVIew registerClass:[DLTSchemeViewCell class] forCellReuseIdentifier:KDLTSchemeViewCell];
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
    schemeDetail = [[JCLQSchemeItem alloc]initWith:infoArray];
    
    NSInteger itemIndex = 1;
    if ([schemeDetail.lottery isEqualToString:@"JCLQ"]) {
        for (NSDictionary *matchDic in [Utility objFromJson:schemeDetail.betContent]) {
            NSArray *matchArray = [Utility objFromJson:matchDic[@"betMatches"]];
            for (int i  = 0; i < matchArray.count; i++) {
                JlBetContent *betContent = [[JlBetContent alloc]init];
                
                betContent.index = itemIndex;
                if (i == 0) {
                    if (matchArray.count == 1) {
                        betContent.isLast = YES;
                    }else{
                        betContent.isLast = NO;
                    }
                    betContent.isShow = YES;
                    betContent.multiple = matchDic[@"multiple"];
                    betContent.passTypes = matchDic[@"passTypes"];
                    itemIndex ++ ;
                }else{
                    betContent.isShow = NO;
                    if (i == matchArray.count - 1) {
                        betContent.isLast = YES;
                    }
                }
                betContent.virtualSp = schemeDetail.virtualSp;
                betContent.matchInfo = matchArray[i];
                [matchList addObject:betContent];
            }
        }
    }else if ([schemeDetail.lottery isEqualToString:@"DLT"]||[schemeDetail.lottery isEqualToString:@"SSQ"]){
        dltBetList = [Utility objFromJson: schemeDetail.betContent];
    }
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
    orderDetailVC.lqOpenResult = schemeDetail.trOpenResult;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)actionGotoTouzhu:(id)sender {
    
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.schemeNo = schemeDetail.schemeNO;
    payVC.subscribed = [schemeDetail.betCost doubleValue];
    payVC.postBoyId = schemeDetail.postboyId;
    payVC.schemeSource = schemeDetail.schemeSource;
    if ([schemeDetail.lottery isEqualToString:@"DLT"]) {
        payVC.lotteryName = @"大乐透";
    }else if ([schemeDetail.lottery isEqualToString:@"JCZQ"]){
        payVC.lotteryName = @"竞彩足球";
    }else if ([schemeDetail.lottery isEqualToString:@"GCGY"]){
        payVC.lotteryName = @"冠军";
    }else if ([schemeDetail.lottery isEqualToString:@"GCGYJ"]){
        payVC.lotteryName = @"冠亚军";
    }else if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
        payVC.lotteryName = @"竞彩篮球";
    }
    
    [self.navigationController pushViewController:payVC animated:YES];
//    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
//    schemeCashModel.cardCode = self.curUser.cardCode;
//    schemeCashModel.schemeNo =schemeDetail.schemeNO;
//    schemeCashModel.subCopies = 1;
    
//    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
//        schemeCashModel.costType = CostTypeCASH;
//        
//        schemeCashModel.subscribed = [schemeDetail.betCost integerValue];
//        schemeCashModel.realSubscribed = [schemeDetail.betCost integerValue];
//    }else{
//        schemeCashModel.costType = CostTypeSCORE;
//        
//        schemeCashModel.subscribed = [schemeDetail.betCost integerValue] /100;
//        schemeCashModel.realSubscribed = [schemeDetail.betCost integerValue]/100;
//    }
//   
//    payVC.cashPayMemt = schemeCashModel;
    
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if (section == 0) {
            return 1;
        }else if (section == 2){
            NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
            if (betContent == nil) {
                return 0;
            }
            
            return matchList.count;
            
            
        }else if (section == 1){
            return 1;
        }else if (section == 3){
            return 1;
        }
    }else{
        if (section == 0) {
            return 1;
        }else if (section == 1){
            NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
            if (betContent == nil) {
                return 0;
            }
            return matchList.count;
        }
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if ([schemeDetail isHasLeg]) {
            return 4;
        }else{
            return 3;
        }
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tabviewHeight.constant = tabMatchListVIew.contentSize.height;
        mainViewHeight.constant = tabMatchListVIew.contentSize .height + 80;
        tabMatchListVIew.bounces = NO;
    });
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if (indexPath.section == 0) { // 显示 方案信息
            SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
            [detailCell reloadDataModel:schemeDetail];
            detailCell.delegate = self;
            cell = detailCell;
        }else if (indexPath.section == 2){ // 显示方案投注内容
        if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
                 SchemeDetailMatchViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailMatchViewCell];
                if (schemeDetail != nil) {
                    [matchCell refreshDataJCLQ:matchList[indexPath.row] andResult:schemeDetail.trOpenResult];
                }
                [matchCell setBtnNumIndexShow:![self showNum]];
                 cell = matchCell;
            }
        }else if (indexPath.section == 1){
            SchemeInfoViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoViewCell];
            if (schemeDetail != nil) {
                [infoCell loadData:schemeDetail];
            }
            cell = infoCell;
        }else if (indexPath.section == 3){
            LegInfoViewCell *legCell = [tableView dequeueReusableCellWithIdentifier:KLegInfoViewCell];
            legCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [legCell LoadData:schemeDetail.legName legMobile:schemeDetail.legMobile legWechat:schemeDetail.legWechatId];
            return legCell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.section == 0) { // 显示 方案信息
            SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
            [detailCell reloadDataModel:schemeDetail];
            detailCell.delegate = self;
            cell = detailCell;
        }else if (indexPath.section == 1){ // 显示方案投注内容
                if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
                SchemeDetailMatchViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailMatchViewCell];
                if (schemeDetail != nil) {
                    [matchCell refreshDataJCLQ:matchList[indexPath.row] andResult:schemeDetail.trOpenResult];
                }
                [matchCell setBtnNumIndexShow:![self showNum]];
                cell = matchCell;
            }
            
        }else if (indexPath.section == 2){
            LegInfoViewCell *legCell = [tableView dequeueReusableCellWithIdentifier:KLegInfoViewCell];
            legCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [legCell LoadData:schemeDetail.legName legMobile:schemeDetail.legMobile legWechat:schemeDetail.legWechatId];
            return legCell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(BOOL)showNum{
    NSInteger tempNum = 0;
    for (JlBetContent *model in matchList) {
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
    
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        if (indexPath.section == 0) {
            return [schemeDetail getJCLQCellHeight];
        }else if (indexPath.section ==2){
            if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
                NSDictionary *dic = matchList[indexPath.row].matchInfo;
                NSArray *itemArray = dic[@"betPlayTypes"];
                float curY = 0;
                NSString *option;
                for (NSDictionary *itemDic in itemArray) {
                    option = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"]];
                    float height =  [option boundingRectWithSize:CGSizeMake(KscreenWidth - 110, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
                    height  = height > 25 ? height:25;
                    curY += height;
                }
                curY += 20;
                if (KscreenWidth == 0) {
                    if (matchList[indexPath.row].isShow) {
                        NSArray *passType = [Utility objFromJson:matchList[indexPath.row].passTypes];
                        ;
                        return curY + 90 + ((passType.count / 7) + 1) * 15;
                    }else{
                        
                        return curY + 40;
                    }
                }else{
                    if (matchList[indexPath.row].isShow) {
                        NSArray *passType = [Utility objFromJson:matchList[indexPath.row].passTypes];
                        ;
                        return curY + 130 + ((passType.count / 7) + 1) * 15;
                    }else{
                        return curY + 80;
                    }
                }

                
            }
            
        }else if (indexPath.section ==1){
            if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
                return 110;
            }else{
                
                return 110;
            }
        }else if (indexPath.section == 3){
            return 50;
        }
    }else{
        if (indexPath.section == 0) {
            return [schemeDetail getJCLQCellHeight];
        }else if (indexPath.section ==1){
            if ([schemeDetail.lottery isEqualToString:@"JCLQ"]){
                NSDictionary *dic = matchList[indexPath.row].matchInfo;
                NSArray *itemArray = dic[@"betPlayTypes"];
                float curY = 0;
                NSString *option;
                for (NSDictionary *itemDic in itemArray) {
                    SchemeDetailMatchViewCell * tabcell = [[SchemeDetailMatchViewCell alloc]init];;
                    JlBetContent *bet = matchList[indexPath.row];
                    NSArray *   itemArray = [Utility objFromJson:bet.virtualSp];
                    [tabcell setValue:itemArray forKey:@"itemDic"];
                    option = [tabcell reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:bet.matchInfo[@"matchKey"]];
                    float height =  [option boundingRectWithSize:CGSizeMake(KscreenWidth - 110, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
                    height  = height > 25 ? height:25;
                    curY += height;
                }
                if (KscreenWidth == 0) {
                    if (matchList[indexPath.row].isShow) {
                        NSArray *passType = [Utility objFromJson:matchList[indexPath.row].passTypes];
                        ;
                        return curY + 90 + ((passType.count / 7) + 1) * 15;
                    }else{
                        
                        return curY + 40;
                    }
                }else{
                    if (matchList[indexPath.row].isShow) {
                        NSArray *passType = [Utility objFromJson:matchList[indexPath.row].passTypes];
                        ;
                        return curY + 130 + ((passType.count / 7) + 1) * 15;
                    }else{
                        return curY + 80;
                    }
                }
                
            }
            
        }
    }
    return 0;
}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSInteger index;
    NSMutableString*content = [NSMutableString string];
    switch ([playType integerValue]) {
        case 1:
            contentArray = dic[@"SF"];
            
            break;
        case 2:
            contentArray = dic[@"RFSF"];
            
            break;
        case 4:
            contentArray = dic[@"DXF"];
            
            break;
        case 3:
            contentArray = dic[@"SFC"];
            
            break;
        default:
            break;
    }
    
    for (NSString *op in option) {
        
        NSString*type = [self getContentJCLQ:contentArray andOption:op];
        [content appendFormat:@"%@",type];
        [content appendString:@", "];
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
}

-(NSString*)getContentJCLQ:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray) {
        if (dic[option] != nil) {
            return dic[option];
        }
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        
        if (section == 2) {
            
            if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                return 60;
            }else{
                return 30;
            }
            
        }else{
            return  30;
        }
    }else{
        
        if (section == 1) {
            
            if ([NSString stringWithFormat:@"%@",schemeDetail.ticketCount].integerValue > 0 && [schemeDetail.costType isEqualToString:@"CASH"]) {
                return 60;
            }else{
                return 30;
            }
            
        }else{
            return  30;
        }
    }
   
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderListHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"OrderListHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor = RGBCOLOR(253 , 252, 245);
    
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
        }else if (section == 3){
            header.titleLa.text = @"代买信息";
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
  
    
}

-(void)showMySchemeHeader:(OrderListHeaderView *)header{
    
    header.titleLa.text = @"方案内容";
    
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

//-(void)navigationBackToLastPage{
//    
//    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
//        if ([baseVC isKindOfClass:[MyOrderListViewController class]]) {
//            [self.navigationController popToViewController:baseVC animated:YES];
//            return;
//        }
//    }
//    [super navigationBackToLastPage];
//}
- (IBAction)actionReBuy:(UIButton *)sender {
    JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
    
}

- (void)showAlert{
    ZLAlertView *alert = [[ZLAlertView alloc]initWithTitle:@"" message:@"中奖金额为方案拆票中奖之和。如有拆票订单未开奖，请稍等"];
    [alert addBtnTitle:@"确定" action:^{
        
    }];
    [alert showAlertWithSender:self];
}

@end
