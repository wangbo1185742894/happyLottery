//
//  OmitEnquiriesViewController.h
//  Lottery
//
//  Created by only on 16/11/8.
//  Copyright © 2016年 AMP. All rights reserved.
//

//11选5遗漏查询
#import "BaseViewController.h"
#import "LotteryPhaseInfoView.h"



@interface OmitEnquiriesViewController : BaseViewController
@property(nonatomic,strong)LotteryPhaseInfoView *touzhuphaseInfoView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString * titleString;
@property (nonatomic, assign) BOOL isQmit;
@property (nonatomic, strong) Lottery * lottery;
@property(nonatomic,strong)NSString *sd115MissUrl;
//传过来的号
//@property (nonatomic, copy) NSString * searchCode;
@property (weak, nonatomic) IBOutlet UILabel *labBeySummary;
@property (nonatomic, strong) NSMutableArray *searchCodeArray;
@property (nonatomic, strong) LotteryTransaction * lotteryTransaction;
@property(nonatomic,strong)NSString *isOmit;
@end
