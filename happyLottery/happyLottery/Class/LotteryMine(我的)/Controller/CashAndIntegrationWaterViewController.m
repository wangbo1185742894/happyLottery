//
//  CashAndIntegrationWaterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "CashAndIntegrationWaterViewController.h"
#import "CashAndIntegrationWaterTableViewCell.h"
#import "CashBoltter.h"

@interface CashAndIntegrationWaterViewController ()<UITableViewDataSource,UITableViewDelegate,MemberManagerDelegate>{
    NSMutableArray *listScoreBlotterArray;
      NSMutableArray *listCashBlotterArray;
     int page;
   
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;



@end

@implementation CashAndIntegrationWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.memberMan.delegate = self;
    listScoreBlotterArray = [[NSMutableArray alloc]init];
    listCashBlotterArray = [[NSMutableArray alloc]init];
    page =1;
  
   
    if (self.select == 0) {
        self.segment.selectedSegmentIndex = 0;
        self.title = @"现金明细";
        [self initCashRefresh];
       
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
    }else  if (self.select == 1) {
        self.segment.selectedSegmentIndex = 1;
         self.title = @"积分明细";
         [self initScoreRefresh];
        self.tableView2.hidden = NO;
        self.tableView1.hidden = YES;
    }
    
}
-(void)initCashRefresh{
    __weak typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getCashBlotterClient];
        [self.tableView1.mj_header endRefreshing];
    }];
    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        ///[self.tableView1.mj_footer beginRefreshing];
        [weakSelf getCashBlotterClient];
        
    }];
    // 马上进入刷新状态
    [self.tableView1.mj_header beginRefreshing];
}
-(void)initScoreRefresh{
           __weak typeof(self) weakSelf = self;
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getScoreBlotterClient];
        [self.tableView2.mj_header endRefreshing];
    }];
    self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        //[self.tableView2.mj_header beginRefreshing];
        [weakSelf getScoreBlotterClient];
        
    }];
    
    // 马上进入刷新状态
    
    [self.tableView2.mj_header beginRefreshing];
}


- (IBAction)segmentClick:(id)sender {
    switch( self.segment.selectedSegmentIndex)
    {
    case 0:
            self.title = @"现金明细";
            self.tableView1.hidden = NO;
            self.tableView2.hidden = YES;
            [listCashBlotterArray removeAllObjects];
            page=1;
            [self initCashRefresh];
           break;
    case 1:
              self.title = @"积分明细";
            self.tableView2.hidden = NO;
            self.tableView1.hidden = YES;
            [listScoreBlotterArray removeAllObjects];
            page=1;
           [self initScoreRefresh];
            break;
    default:
        break;
    }
}

-(void)getScoreBlotterClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@"10",
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getScoreBlotterSms:Info];
    }
    
}

-(void)getCashBlotterClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@"10",
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getCashBlotterSms:Info];
    }
    
}
//现金流水
-(void)getCashBlotterSms:(NSArray *)boltterInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (boltterInfo.count != 10) {
        [self.tableView1.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView1.mj_footer endRefreshing];
    }
    
    if (success == YES && boltterInfo != nil) {
        if (page == 1) {
            [listCashBlotterArray removeAllObjects];
        }
        for (NSDictionary *info in boltterInfo) {
            CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:info];
            [listCashBlotterArray addObject:cashBoltter];
        }
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
        [self.tableView1 reloadData];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}
//积分流水
-(void)getScoreBlotterSms:(NSArray *)scoreInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (scoreInfo.count != 10) {
        [self.tableView2.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView2.mj_footer endRefreshing];
    }

    if (success == YES && scoreInfo != nil) {
        if (page == 1) {
            [listScoreBlotterArray removeAllObjects];
        }
        for (NSDictionary *info in scoreInfo) {
            CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:info];
            [listScoreBlotterArray addObject:cashBoltter];
        }
        self.tableView2.hidden = NO;
        self.tableView1.hidden = YES;
        [self.tableView2 reloadData];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
            if (listScoreBlotterArray.count > 0) {
                return listScoreBlotterArray.count;
            }
    } else if (tableView ==self.tableView2) {
        if (listCashBlotterArray.count > 0) {
            return listCashBlotterArray.count;
        }
    }

    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier1 = @"TabViewCell1";
    static NSString *CellIdentifier2= @"TabViewCell2";
    //自定义cell类
  
    CashAndIntegrationWaterTableViewCell *cell ;
    if (tableView ==self.tableView1) {
 cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CashAndIntegrationWaterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listScoreBlotterArray.count > 0) {
            CashBoltter *cashBoltter = listScoreBlotterArray[indexPath.row];
            cell.nameLab.text = cashBoltter.orderType;
            cell.dateLab.text = cashBoltter.createTime;
           float amounts=[cashBoltter.amounts floatValue];
            if (amounts>0) {
                cell.priceLab.textColor = SystemGreen;
                cell.image.image = [UIImage imageNamed:@"addcrease"];
                cell.priceLab.text = [NSString stringWithFormat:@"+%.2f元",amounts];
            }else{
                cell.image.image = [UIImage imageNamed:@"lessen"];
                cell.priceLab.text = [NSString stringWithFormat:@"%.2f元",amounts];
                
            }
            float b=[cashBoltter.remBalance floatValue];
            
            cell.retainLab.text =[NSString stringWithFormat:@"余额：%.2f",b];
        }
    } else if (tableView ==self.tableView2) {
      cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CashAndIntegrationWaterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listCashBlotterArray.count > 0) {
            CashBoltter *cashBoltter = listCashBlotterArray[indexPath.row];
            cell.nameLab.text = cashBoltter.orderType;
            cell.dateLab.text = cashBoltter.createTime;
            int amounts =[cashBoltter.amounts intValue];
            if (amounts>0) {
                cell.priceLab.textColor = SystemGreen;
                cell.image.image = [UIImage imageNamed:@"increase"];
                cell.priceLab.text = [NSString stringWithFormat:@"+%@分",cashBoltter.amounts];
            }else{
                cell.image.image = [UIImage imageNamed:@"decrease"];
                cell.priceLab.text = [NSString stringWithFormat:@"%@分",cashBoltter.amounts];
            }
            float b=[cashBoltter.remBalance floatValue];
            cell.retainLab.text =[NSString stringWithFormat:@"余额：%.2f",b];
        }
    }
    
  
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
