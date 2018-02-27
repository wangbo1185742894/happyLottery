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
@property (weak, nonatomic) IBOutlet UITableView *tabCashList;
@property (weak, nonatomic) IBOutlet UITableView *tabScoreList;



@end

@implementation CashAndIntegrationWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.tabCashList.delegate = self;
    self.tabCashList.dataSource = self;
    self.tabScoreList.delegate = self;
    self.tabScoreList.dataSource = self;
    self.memberMan.delegate = self;
    listScoreBlotterArray = [[NSMutableArray alloc]init];
    listCashBlotterArray = [[NSMutableArray alloc]init];
  
    [self initCashRefresh];
    [self initScoreRefresh];
    
    if (self.select == 0) {
        self.segment.selectedSegmentIndex = 0;
        self.title = @"现金明细";
        self.tabCashList.hidden = NO;
        self.tabScoreList.hidden = YES;
        [self getCashNewData];
    }else  if (self.select == 1) {
        self.segment.selectedSegmentIndex = 1;
         self.title = @"积分明细";
        
        self.tabScoreList.hidden = NO;
        self.tabCashList.hidden = YES;
        [self getScoreNewData];
    }
}
-(void)initCashRefresh{
    
    [UITableView refreshHelperWithScrollView:self.tabCashList target:self loadNewData:@selector(getCashNewData) loadMoreData:@selector(getCashMoreData) isBeginRefresh:NO];
}
-(void)initScoreRefresh{
     [UITableView refreshHelperWithScrollView:self.tabScoreList target:self loadNewData:@selector(getScoreNewData) loadMoreData:@selector(getScoreMoreData) isBeginRefresh:NO];
}


- (IBAction)segmentClick:(id)sender {
    switch( self.segment.selectedSegmentIndex)
    {
    case 0:
            self.title = @"现金明细";
            self.tabCashList.hidden = NO;
            self.tabScoreList.hidden = YES;
            
            [self getCashNewData];
           break;
    case 1:
              self.title = @"积分明细";
            self.tabScoreList.hidden = NO;
            self.tabCashList.hidden = YES;

            [self getScoreNewData];
           
            break;
    default:
        break;
    }
}

-(void)getScoreNewData{
    page = 1;
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize),
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        return;
    }

    [self.memberMan getScoreBlotterSms:Info];
    
}

-(void)getScoreMoreData{
    page++;
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize),
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getScoreBlotterSms:Info];
    
}

-(void)getCashNewData{
    NSDictionary *Info;
    page = 1;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize),
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getCashBlotterSms:Info];
}

-(void)getCashMoreData{
    page ++;
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize),
                 @"type":@" "
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getCashBlotterSms:Info];
}
//现金流水
-(void)getCashBlotterSms:(NSArray *)boltterInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.tabCashList tableViewEndRefreshCurPageCount:boltterInfo.count];
    
    if (success == YES && boltterInfo != nil) {
        if (page == 1) {
            [listCashBlotterArray removeAllObjects];
        }
        for (NSDictionary *info in boltterInfo) {
            CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:info];
            [listCashBlotterArray addObject:cashBoltter];
        }
        self.tabCashList.hidden = NO;
        self.tabScoreList.hidden = YES;
        [self.tabCashList reloadData];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}
//积分流水
-(void)getScoreBlotterSms:(NSArray *)scoreInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.tabScoreList tableViewEndRefreshCurPageCount:scoreInfo.count];

    if (success == YES && scoreInfo != nil) {
        if (page == 1) {
            [listScoreBlotterArray removeAllObjects];
        }
        for (NSDictionary *info in scoreInfo) {
            CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:info];
            [listScoreBlotterArray addObject:cashBoltter];
        }
        self.tabScoreList.hidden = NO;
        self.tabCashList.hidden = YES;
        [self.tabScoreList reloadData];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tabScoreList) {
            if (listScoreBlotterArray.count > 0) {
                return listScoreBlotterArray.count;
            }
    } else if (tableView ==self.tabCashList) {
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
    if (tableView ==self.tabScoreList) {
    cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CashAndIntegrationWaterTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.retainLab.adjustsFontSizeToFitWidth = YES;
        cell.priceLab.adjustsFontSizeToFitWidth = YES;
        
        if (listScoreBlotterArray.count > 0) {
            CashBoltter *cashBoltter = listScoreBlotterArray[indexPath.row];
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
            
            cell.retainLab.text =[NSString stringWithFormat:@"积分：%@",cashBoltter.remBalance];
        }
    } else if (tableView ==self.tabCashList) {
      cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CashAndIntegrationWaterTableViewCell" owner:self options:nil] lastObject];
        }
    
        cell.retainLab.adjustsFontSizeToFitWidth = YES;
        cell.priceLab.adjustsFontSizeToFitWidth = YES;
        if (listCashBlotterArray.count > 0) {
            CashBoltter *cashBoltter = listCashBlotterArray[indexPath.row];
            cell.nameLab.text = cashBoltter.orderType;
            cell.dateLab.text = cashBoltter.createTime;
            double amounts=[cashBoltter.amounts doubleValue];
            if (amounts>0) {
                cell.priceLab.textColor = SystemGreen;
                cell.image.image = [UIImage imageNamed:@"addcrease"];
                cell.priceLab.text = [NSString stringWithFormat:@"+%.2f元",amounts];
            }else{
                cell.image.image = [UIImage imageNamed:@"lessen"];
                cell.priceLab.text = [NSString stringWithFormat:@"%.2f元",amounts];
                
            }
            double b=[cashBoltter.remBalance doubleValue];
            
            cell.retainLab.text =[NSString stringWithFormat:@"余额:%.2f",b];
        }
    }
    cell.dateLab.adjustsFontSizeToFitWidth = YES;
    return cell;
}


#pragma UITableViewDelegate methods
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
