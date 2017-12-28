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
    int currPage1;
    int pageSize1;
    int totalCount1;
    int totalPage1;
    int currPage2;
    int pageSize2;
    int totalCount2;
    int totalPage2;
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
    if (self.select == 0) {
        self.segment.selectedSegmentIndex = 0;
        self.title = @"现金明细";
         [self getCashBlotterClient];
    }else  if (self.select == 1) {
        self.segment.selectedSegmentIndex = 1;
         self.title = @"积分明细";
         [self getScoreBlotterClient];
    }
    
}

- (IBAction)segmentClick:(id)sender {
    switch( self.segment.selectedSegmentIndex)
    {
    case 0:
            self.title = @"现金明细";
            self.tableView1.hidden = NO;
            self.tableView2.hidden = YES;
            [listCashBlotterArray removeAllObjects];
            [self getCashBlotterClient];
           
    case 1:
              self.title = @"积分明细";
            self.tableView2.hidden = NO;
            self.tableView1.hidden = YES;
                [listScoreBlotterArray removeAllObjects];
            [self getScoreBlotterClient];
    default:
        break;
    }
}

-(void)getScoreBlotterClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"page":@"0",
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
        Info = @{@"cardCode":cardCode,
                 @"page":@"0",
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
-(void)getCashBlotterSms:(NSDictionary *)boltterInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
     NSLog(@"现金流水%@",boltterInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText: @"现金流水成功" hideAfterDelay: 1.7];
        if (boltterInfo != nil) {
            currPage1 =(int)[boltterInfo valueForKey:@"currPage"];
            pageSize1 = (int)[boltterInfo valueForKey:@"pageSize"];
            totalCount1 = (int)[boltterInfo valueForKey:@"totalCount"];
            totalPage1 = (int)[boltterInfo valueForKey:@"totalPage"];
            NSArray *array =[boltterInfo valueForKey:@"list"];
            if (array.count>0) {
                  [listScoreBlotterArray removeAllObjects];
                for (int i=0; i<array.count; i++) {
                    
                    CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:array[i]];
                    [listScoreBlotterArray addObject:cashBoltter];
                   
                    if (listScoreBlotterArray.count>0) {
                        self.tableView1.hidden = NO;
                        self.tableView2.hidden = YES;
                        [self.tableView1 reloadData];
                    }else{
                        // self.tvHeight.constant = 0;
                    }
                }
                
            }
        }
       
       
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}
//积分流水
-(void)getScoreBlotterSms:(NSDictionary *)scoreInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
     NSLog(@"积分流水%@",scoreInfo);
    if ([msg isEqualToString:@"执行成功"]) {
       // [self showPromptText: @"积分流水成功" hideAfterDelay: 1.7];
        if (scoreInfo != nil) {
            currPage1 =(int)[scoreInfo valueForKey:@"currPage"];
            pageSize1 = (int)[scoreInfo valueForKey:@"pageSize"];
            totalCount1 = (int)[scoreInfo valueForKey:@"totalCount"];
            totalPage1 = (int)[scoreInfo valueForKey:@"totalPage"];
            NSArray *array =[scoreInfo valueForKey:@"list"];
            if (array.count>0) {
                [listCashBlotterArray removeAllObjects];
                for (int i=0; i<array.count; i++) {
                    NSDictionary *info = array[i];
                        CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:info];
                        [listCashBlotterArray addObject:cashBoltter];
                    if (listCashBlotterArray.count>0) {
                        self.tableView2.hidden = NO;
                        self.tableView1.hidden = YES;
                        [self.tableView2 reloadData];
                    }else{
                        // self.tvHeight.constant = 0;
                    }
                }
                
            }
        }
        
        
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
         
            int amounts =[cashBoltter.amounts intValue];
            if (amounts>0) {
                cell.priceLab.textColor = SystemGreen;
                cell.image.image = [UIImage imageNamed:@"add"];
                cell.priceLab.text = [NSString stringWithFormat:@"+%@元",cashBoltter.amounts];
            }else{
                cell.image.image = [UIImage imageNamed:@"lessen"];
                cell.priceLab.text = [NSString stringWithFormat:@"%@元",cashBoltter.amounts];
            }
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
                cell.image.image = [UIImage imageNamed:@"decrease"];
                cell.priceLab.text = [NSString stringWithFormat:@"+%@元",cashBoltter.amounts];
            }else{
                cell.image.image = [UIImage imageNamed:@"increase"];
                cell.priceLab.text = [NSString stringWithFormat:@"%@元",cashBoltter.amounts];
            }
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
