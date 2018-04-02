//
//  LotteryTransaction.h
//  Lottery
//
//  Created by AMP on 5/27/15.
//  Copyright (c) 2015 AMP. All rights reserved.

// for each bet transaction, could have multiple LotteryBet objects

#import <Foundation/Foundation.h>
#import "LotteryBet.h"
#import "Lottery.h"
#import "BaseTransaction.h"
typedef enum {
    NOTSTOP = 0,
    WINSTOP
}WinStopStatus;

@interface LotteryTransaction : BaseTransaction
@property (nonatomic) BOOL needZhuiJia;
@property (nonatomic) int beiTouCount;
@property (nonatomic) int qiShuCount;
@property(nonatomic,strong)Lottery *lottery;
@property(nonatomic,assign)WinStopStatus winStopStatus;
@property (nonatomic, strong) NSDictionary *lotteryRoundInfo;

- (void) addBet: (LotteryBet*) bet;
- (NSUInteger) betCount;
- (NSArray *) allBets;
- (NSAttributedString *) getAttributedSummaryText;
- (void) removeBet: (LotteryBet *) bet;
- (void) removeAllBets;
- (int) getBetsTotalCount;
- (int) getBetsCostTotalAmount;
- (NSAttributedString *) getTouZhuSummaryText;
- (NSAttributedString *) getTouZhuSummaryText1;
- (NSAttributedString *) getTouZhuSummaryText2;
- (NSMutableDictionary *) submitParamDic;
- (NSArray *) lottData;
- (NSString *)couldTouzhu;

-(NSMutableDictionary *)getDLTChaseScheme;

@end
