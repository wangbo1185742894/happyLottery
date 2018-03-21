//
//  LotteryBet.h
//  Lottery
//
//  Created by AMP on 5/25/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//
//data cell for each bet

#import <Foundation/Foundation.h>

#import "Lottery.h"
#import "LotteryXHProfile.h"

#define CostPerBet  2
typedef enum {
    BetTypeNotSet=-1,
    BetTypeNomal=1,
    BetTypePlural,
    BetTypeDanTuo
} BetType;

@interface LotteryBet : NSObject
//{
//    NSAttributedString *betNumbersDesc;
//    //NSString * betProfile;
//}
@property (nonatomic,strong) NSAttributedString *betNumbersDesc;
@property (nonatomic,strong)  NSString * betProfile;
@property (nonatomic, strong) NSArray *lotteryDetails;
@property(nonatomic,assign)CostType costType;
//lottery number_section_id:array of numbers
@property (nonatomic, strong) NSMutableDictionary *betNumbers;
@property CGFloat popViewCellHeight;
@property (nonatomic) BOOL needZhuiJia;
@property (nonatomic, strong) NSDictionary *betCellDataDic;
@property (nonatomic, strong) LotteryXHProfile *betXHProfile;
@property (nonatomic) int beiTouCount;

@property (nonatomic, strong) NSString *betLotteryIdentifier;
@property (nonatomic, strong) NSString *sectionDataLinkSymbol;
//订单详情中的投注号码。
@property (nonatomic, strong) NSString *orderBetNumberDesc;
@property (nonatomic, strong) NSString *orderBetPlayType;

@property  int betLotteryType;

- (void) updateBetInfo;
- (int) getBetCount;
- (int) getBetCost;
- (NSAttributedString *) betNumberDesc: (UIFont *) font;
- (NSString *) getCellSummaryText;
- (NSString *) getBetNumberDesc;
- (NSString *) betTypeDesc;
- (int) betType;
- (NSAttributedString *)numDescrption:(UIFont *)font;
//11.20增加BetTypeDesc
- (void)setBetTypeDesc:(NSString *)betDesc;
- (void)setBetCount:(int)totalCount;
- (void)setBetsCost:(float)totalMoney;
//2016-03-21 详情页面设置bettype;
- (void)setBetType:(int)betTypeTemp;
@end
