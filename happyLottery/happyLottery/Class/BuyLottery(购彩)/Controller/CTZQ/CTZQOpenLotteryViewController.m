//
//  CTZQOpenLotteryViewController.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQOpenLotteryViewController.h"
#import "CTZQOpenLotteryFirstView.h"
#import "CTZQOpenLotterySectionHeaderView.h"
#import "OpenLotteryCell.h"
#import "OpenLotteryResultHeaderView.h"
#import "OpenLotteryResultCell.h"
#import "CTZQOpenLotterySelectDateView.h"
#import "CTZQPlayViewController.h"
#define TABLEBOTTOM 51
@interface CTZQOpenLotteryViewController ()<UITableViewDelegate,UITableViewDataSource,CTZQOpenLotterySelectDateDelegate,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabContentlist;
@property(weak,nonatomic) CTZQOpenLotterySelectDateView* dateView;

@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
@property(strong , nonatomic)LotteryManager *lotteryMan;
@property(strong , nonatomic)NSMutableDictionary *infoDic;



- (IBAction)actionGotoPay:(UIButton *)sender;


@end

@implementation CTZQOpenLotteryViewController

- (void)viewDidLoad {
    

    [super viewDidLoad];

    self.title = @"胜负14场(任9)";
    self.tabContentlist.dataSource = self;
    self.tabContentlist.delegate = self;
    self.tabContentlist.rowHeight = 50;
    
    [self addRightButtonItem];
    
    self.lotteryMan = [[LotteryManager alloc] init];
    self.lotteryMan.delegate = self;
   
    
    [self showLoadingViewWithText:TextLoading];
    

    
    if (_isFromOpenLottery) {
        _tableBottom.constant = TABLEBOTTOM ;
        _btnView.hidden = NO;
    }else{
        _tableBottom.constant = 0 ;
        _btnView.hidden = YES;
    }
    
    [self getOpenLotteryDetail];
    
}
- (void)getOpenLotteryDetail{
     NSDictionary *lotteryInfo = @{@"issueNumber":_issueSelected};
//    [_lotteryMan getCTZQOpenLotteryDetail:lotteryInfo];
}

- (void)gotZCOpenLotteryDetail:(id)info{
//    NSLog(@"%@",info);
    [self hideLoadingView];
    if (info) {
        _infoDic = info;
        [_tabContentlist reloadData];
    }else{
        [self showPromptText:@"未获得到开奖详情" hideAfterDelay:1.7];
    }
}

-(void)addRightButtonItem{

    UIButton*rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setTitle:@"往期" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    rightItem.titleLabel.textAlignment = NSTextAlignmentRight;
    rightItem.backgroundColor = [UIColor clearColor];
    rightItem.frame = CGRectMake(0, 0, 55, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    [rightItem addTarget:self action:@selector(ActionSelectTime) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)ActionSelectTime{

    if (self.dateView == nil) {
        
       CTZQOpenLotterySelectDateView*dateView = [[CTZQOpenLotterySelectDateView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        NSMutableArray *issueArr = [[NSMutableArray alloc] init];
//        for (LotteryRound *round in _matchArray) {
//            [issueArr addObject:round.issueNumber];
//        }
        dateView.pickerDataSource = _matchArray;
        dateView.selected = _issueSelected;
        dateView.delegate = self;
        [self.view.window addSubview:dateView];
        [dateView configShow];
        self.dateView = dateView;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableView 代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger headerHeight = 0;
    switch (section) {
        case 0:
            
            headerHeight = 90;
            break;
        case 1:
        case 2:
        case 3:
            headerHeight = 50;
            break;
            
        default:
            break;
    }

    return headerHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 10;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRow = 0;
    switch (section) {
        case 0:
            numberOfRow = 0;
            break;
        case 1:
            numberOfRow = 2;
            break;
        case 2:
            numberOfRow = 1;
            break;
        case 3:
            numberOfRow = 14;
            
            break;
    }
    return numberOfRow;

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    
    UIView *foot = [[[NSBundle mainBundle]loadNibNamed:@"OpenLotteryFooter" owner:nil options:nil] lastObject];
    foot.frame = CGRectMake(0, 0, KscreenWidth, 10);
    
    
    return foot;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header;
    switch (section) {
        case 0:
        {
            NSArray *resultArr = [_infoDic[@"openResult"] componentsSeparatedByString:@","];
            
            header = [[CTZQOpenLotteryFirstView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 90)];
            
           CTZQOpenLotteryFirstView *head = (CTZQOpenLotteryFirstView*)header;
            NSString *issueNum = [Utility legalString:_infoDic[@"issueNumber"]];
            NSString *timeStr = _infoDic[@"openTime"];
            CGFloat time = [timeStr doubleValue] / 1000;
            if (time == 0) {
                timeStr = @"";
            }else{
                timeStr = [Utility timeStringFromFormat:@"yyyy-MM-dd" withTI:time];
            }
            
            head.labTime.text = [NSString stringWithFormat:@"第%@期 %@",issueNum,timeStr];
            CGFloat cellWidth = (KscreenWidth - 20)/14.0;
            for (int i = 0; i < 14; i++) {
                UILabel *cellLab = [[UILabel alloc]initWithFrame:CGRectMake(i*cellWidth, 0, cellWidth-2, 25)];
                [head.viewContentResult addSubview:cellLab];
                if ([resultArr[i] isEqualToString:@"--"]) {
                    cellLab.text = @"*";
                }else{
                    cellLab.text = [NSString stringWithFormat:@"%@",[Utility legalString:resultArr[i]]];
                }
                
                cellLab.layer.backgroundColor = [Utility colorFromHexString:@"249053"].CGColor;
                cellLab.textAlignment = NSTextAlignmentCenter;
                cellLab.textColor = [UIColor whiteColor];
//                cellLab.font = [UIFont systemFontOfSize:15];
                
//                cellLab.text = @""  根据model的resultArray
                
            }
            header = head;
        }
            break;
        case 1:
        case 2:
        {
            header = [[CTZQOpenLotterySectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
            CTZQOpenLotterySectionHeaderView *headerView = (CTZQOpenLotterySectionHeaderView *)header;
            NSString *lotteryName;
            NSString *totalSale;
            if (section == 1) {
                lotteryName = @"胜负彩14场";
                totalSale = [NSString stringWithFormat:@"%.0f",[[Utility legalString:_infoDic[@"sfcSalesAmount"]] floatValue]];
            }else{
                lotteryName = @"任选9场";
                totalSale = [NSString stringWithFormat:@"%.0f",[[Utility legalString:_infoDic[@"rjcSalesAmount"]] floatValue]];
                
            }
            headerView.labLotteryName.text = lotteryName;
            headerView.labTotal.text = [NSString stringWithFormat:@"销售%@",totalSale];
        }
            break;
        case 3:
        {
            header = [[OpenLotteryResultHeaderView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
            
        }
            break;
        
    }
    
return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            
            break;
          
        case 1:
        case 2:
        {
            NSString *rankStr;
            NSString *countStr;
            NSString *eachMoneyStr;
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    rankStr = @"一等奖";
                    countStr = [NSString stringWithFormat:@"%@",[Utility legalString:_infoDic[@"sfcWinUnit"]]];
                    eachMoneyStr = [NSString stringWithFormat:@"%.2f",[[Utility legalString:_infoDic[@"sfcWinPrize"]] floatValue]];
                }else if(indexPath.row == 1){
                    rankStr = @"二等奖";
                    countStr = [NSString stringWithFormat:@"%@",[Utility legalString:_infoDic[@"sfcWin2Unit"]]];
                    eachMoneyStr = [NSString stringWithFormat:@"%.2f",[[Utility legalString:_infoDic[@"sfcWin2Prize"]] floatValue]];
                }
                
                
            }else{
                rankStr = @"一等奖";
                
                countStr = [NSString stringWithFormat:@"%@",[Utility legalString:_infoDic[@"rjcWinUnit"]]];
                eachMoneyStr = [NSString stringWithFormat:@"%.2f",[[Utility legalString:_infoDic[@"rjcWinPrize"]] floatValue]];
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"OpenLotteryCell"];
            if (cell == nil) {
                cell = [[OpenLotteryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OpenLotteryCell" ];
                
            }
            cell.frame = CGRectMake(0, 0, KscreenWidth, 50);
            
            OpenLotteryCell *openCell = (OpenLotteryCell *)cell;
            openCell.labPrizeRank.text = rankStr;
            openCell.labPrizeCount.text = countStr;
            openCell.labPrizeEachTotal.text = eachMoneyStr;
        }
            break;
       
        case 3:
        {
            NSArray *temp =_infoDic[@"matchs"];
            NSDictionary *matchInfoDic;
            
           
            cell = [tableView dequeueReusableCellWithIdentifier:@"OpenLotteryResultCell"];
            if (cell == nil) {
                cell = [[OpenLotteryResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OpenLotteryResultCell"];
            }
            cell.frame = CGRectMake(0, 0, KscreenWidth, 50);
            OpenLotteryResultCell *matchCell = (OpenLotteryResultCell *) cell;
            if (temp.count != 0) {
                 matchInfoDic = temp[indexPath.row];
                [matchCell refreshWithMatchInfo:matchInfoDic];
            }
            
//             - (void)refreshWithMatchInfo:(NSDictionary*)match;
        }
            break;
        default:
            break;
    }
    
    {
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
        selectedView.backgroundColor = SEPCOLOR;
        
        CGRect frame = cell.bounds;
        frame.origin.y = 0;
        frame.size.height -= 0;
        if (indexPath.row == 0) {
            frame.origin.y = SEPHEIGHT;
            frame.size.height -= SEPHEIGHT;
        }
        UIView *selectedViewGray = [[UIView alloc] initWithFrame:frame];
        selectedViewGray.backgroundColor = CellSelectedColor;
        [selectedView addSubview:selectedViewGray];
        
        
        cell.selectedBackgroundView = selectedView;
        //        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view;
        
        if ([cell subviews].count>1) {
            view = [cell subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        
        for (UIView *view in [cell subviews]) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        }else{
            downLineFrame.origin.y = 50 - SEPHEIGHT;
        }
        
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine.frame = downLineFrame;
        [cell addSubview:downLine];
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cell addSubview:upLine];
            
        }
        
        
    }
    
    return cell;

}

#pragma 期数选择代理方法
-(void)actionSubmitDate:(NSInteger)index{
    LotteryRound *round =  _dateView.pickerDataSource[index];
    _issueSelected = round.issueNumber;
    NSLog(@"%zd",index);
    [self getOpenLotteryDetail];
}

- (IBAction)actionGotoPay:(UIButton *)sender {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CTZQPlayViewController *plVC = [[CTZQPlayViewController alloc] initWithNibName:@"CTZQPlayViewController" bundle:nil];
    plVC.lottery = _lottery;
    [self.navigationController pushViewController:plVC animated:YES];
        
    
}
@end
