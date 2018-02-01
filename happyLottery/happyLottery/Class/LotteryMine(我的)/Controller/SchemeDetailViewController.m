//
//  SchemeDetailViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeDetailViewController.h"
#import "JCLQOrderDetailInfoViewController.h"

#import "JCZQSchemeModel.h"
#import "PayOrderViewController.h"
#import "SchemeDetailMatchViewCell.h"
#import "SchemeDetailViewCell.h"
#import "TableHeaderView.h"
#import "OrderListHeaderView.h"
#import "SchemeCashPayment.h"
#import "SchemeInfoViewCell.h"
#import "MyOrderListViewController.h"


#define  KSchemeDetailMatchViewCell     @"SchemeDetailMatchViewCell"
#define  KSchemeDetailViewCell          @"SchemeDetailViewCell"
#define  KTableHeaderView               @"TableHeaderView"
#define  KSchemeInfoViewCell            @"SchemeInfoViewCell"
@interface SchemeDetailViewController ()<LotteryManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet NSLayoutConstraint *heightZhifuView;
    __weak IBOutlet NSLayoutConstraint *mainViewHeight;
    __weak IBOutlet NSLayoutConstraint *tabviewHeight;
    __weak IBOutlet UITableView *tabSchemeDetailList;
    JCZQSchemeItem *schemeDetail;
    __weak IBOutlet UIImageView *imgSchemeTopView;
    __weak IBOutlet UITableView *tabMatchListVIew;
}
@end

@implementation SchemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"方案详情";
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

}

-(void)loadData{
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNO}];
}

-(void)gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }

    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    [self setSchemeStateImg];
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
        heightZhifuView.constant = 60;
    }else{
        heightZhifuView.constant = 0;
    }
    [tabMatchListVIew reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        tabviewHeight.constant = tabMatchListVIew.contentSize.height;
        mainViewHeight.constant = tabMatchListVIew.contentSize .height + 80;
        tabMatchListVIew.bounces = NO;
    });
}

- (IBAction)actionOrderDetail:(UIButton *)sender {
    JCLQOrderDetailInfoViewController *orderDetailVC = [[JCLQOrderDetailInfoViewController alloc]init];
    orderDetailVC.schemeNO = self.schemeNO;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)actionGotoTouzhu:(id)sender {
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo =schemeDetail.schemeNO;
    schemeCashModel.subCopies = 1;
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
    if (section == 0) {
        return 1;
    }else if (section == 1){
        NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
        if (betContent == nil) {
            return 0;
        }
        NSArray *betMatches = betContent[@"betMatches"];
        return betMatches.count;
    }else if (section == 2){
        return 1;
    }
    return 0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([schemeDetail.costType isEqualToString:@"CASH"]) {
        return 3;

    }else{
        
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // 显示 方案信息
        SchemeDetailViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailViewCell];
        [detailCell reloadDataModel:schemeDetail];
        cell = detailCell;
    }else if (indexPath.section == 1){ // 显示方案投注内容
        SchemeDetailMatchViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:KSchemeDetailMatchViewCell];
        NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
        if (schemeDetail != nil) {
            NSArray *betMatches = betContent[@"betMatches"];
            [matchCell refreshData:betMatches[indexPath.row] andResult:schemeDetail.trOpenResult];
        }
        cell = matchCell;
    }else if (indexPath.section == 2){
        SchemeInfoViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoViewCell];
        if (schemeDetail != nil) {
            [infoCell loadData:schemeDetail];
        }
        cell = infoCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return [schemeDetail getJCZQCellHeight];
        
        
    }else if (indexPath.section ==1){
        NSDictionary *betContent = [Utility objFromJson: schemeDetail.betContent];
        NSArray *betMatches = betContent[@"betMatches"];
        NSDictionary *dic = betMatches[indexPath.row];
        NSArray *itemArray = dic[@"betPlayTypes"];
        float curY = 0;
        NSString *option;
        for (NSDictionary *itemDic in itemArray) {
            option = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"]];
            float height =  [option boundingRectWithSize:CGSizeMake(KscreenWidth - 90, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            height  = height > 25 ? height:25;
            curY += height;
        }
        if (KscreenWidth == 667) {
             return curY + 60;
        }else{
             return curY + 100;
        }
       
    }else if (indexPath.section ==2){
        if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) {
            return 60;
        }else{
            
            return 110;
        }
    }
    return 0;
}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSInteger index;
    NSMutableString*content = [NSMutableString string];
    switch ([playType integerValue]) {
        case 1:
            index = 100;
            contentArray = dic[@"SPF"];
            
            break;
        case 5:
            index = 200;
            contentArray = dic[@"RQSPF"];
            
            break;
        case 4:
            index = 400;
            contentArray = dic[@"BQC"];
            
            break;
        case 2:
            index = 500;
            contentArray = dic[@"JQS"];
            
            break;
        case 3:
            index = 300;
            contentArray = dic[@"BF"];
            
            break;
        default:
            break;
    }
    
    for (NSString *op in option) {
        
        NSString*type = [self getContentJCZQ:contentArray andOption:op];
        [content appendFormat:@"%@",type];
        [content appendString:@", "];
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderListHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"OrderListHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor = RGBCOLOR(253 , 252, 245);
    if (section == 0) {
        header.titleLa.text = @"方案信息";
    }else if (section == 1){
        if (![schemeDetail.costType isEqualToString:@"CASH"]) {
            header.titleLa.text = @"方案内容";
        }else{
            [self showMySchemeHeader:header];
        }
        
    }else if (section == 2){
        header.titleLa.text = @"认购信息";
    }
    return header;
    
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

-(void)navigationBackToLastPage{
    
    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
        if ([baseVC isKindOfClass:[MyOrderListViewController class]]) {
            [self.navigationController popToViewController:baseVC animated:YES];
            return;
        }
    }
    [super navigationBackToLastPage];
}

@end
