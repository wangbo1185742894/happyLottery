//
//  LegOrderDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderDetailViewController.h"
#import "LegOrderStatusTableViewCell.h"
#import "LegOrderMoneyTableViewCell.h"
#import "LegOrderIntroTableViewCell.h"
#import "LegDetailHeaderView.h"
#import "JCZQSchemeModel.h"

#define KLegOrderStatusTableViewCell    @"LegOrderStatusTableViewCell"
#define KLegOrderMoneyTableViewCell   @"LegOrderMoneyTableViewCell"
#define KLegOrderIntroTableViewCell    @"LegOrderIntroTableViewCell"

@interface LegOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

@implementation LegOrderDetailViewController{
    LegDetailHeaderView *headerView;
    JCZQSchemeItem *schemeDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看订单";
    [self setTableView];
    self.lotteryMan.delegate = self;
    [self loadNewDate];
    headerView = [[LegDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    // Do any additional setup after loading the view from its nib.
}

-(void)setTableView{
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderStatusTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderStatusTableViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderMoneyTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderMoneyTableViewCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KLegOrderIntroTableViewCell bundle:nil] forCellReuseIdentifier:KLegOrderIntroTableViewCell];
}

- (void)loadNewDate {
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNo}];
}

- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    
    if ([schemeDetail.schemeStatus isEqualToString:@"INIT"]) { //待支付状态
        
    } else { //已支付
       
    }
}

#pragma mark  tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 1;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 74;
    }
    if (indexPath.section == 1) {
        return 121;
    }
    return 68;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LegOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderStatusTableViewCell];
        return cell;
    }
    if (indexPath.section == 1) {
        LegOrderMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderMoneyTableViewCell];
        return cell;
    }
    LegOrderIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLegOrderIntroTableViewCell];
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

