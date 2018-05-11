//
//  LotteryManager.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCZQTranscation.h"
#import "BaseTransaction.h"
#import "LotteryTransaction.h"
typedef enum EarningsType{
    EarningsTypeSTEADY,
    EarningsTypeLOW_RISK,
    EarningsTypeHIGH_RISK,
}EarningsType;
@protocol LotteryManagerDelegate
@optional
- (void) gotJczqMatch:(NSArray *)dataArray errorMsg:(NSString *)msg;
- (void) gotJczqSp:(NSArray *)dataArray errorMsg:(NSString *)msg;
- (void) gotJczqLeague:(NSArray *)dataArray errorMsg:(NSString *)msg;
- (void) betedLotteryScheme:(NSString   *)schemeNO errorMsg:(NSString *)msg;
- (void) gotSchemeCashPayment:(BOOL )isSuccess errorMsg:(NSString *)msg;
- (void) gotSchemeScorePayment:(BOOL )isSuccess errorMsg:(NSString *)msg;
- (void) gotJczqShortcut:(NSArray *)dataArray errorMsg:(NSString *)msg;
- (void) gotlistByForecast:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotForecastByMatch:(NSDictionary *)resDic  errorMsg:(NSString *)msg;
- (void) gotJczqPairingMatch:(NSDictionary *)infoDic  errorMsg:(NSString *)msg;
- (void) gotjcycScoreZhibo:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotListByRecScheme:(NSArray *)infoArr errorMsg:(NSString *)errorMsg;
- (void) gotBFZBInfo:(NSArray*)dataArray;
- (void) gotSchemeRecord:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void) gotJczqTicketOrderDetail:(NSDictionary *)infoArray  errorMsg:(NSString *)msg;
- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg;
- (void) gotListByRechargeChannel:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) collectedMatch:(BOOL )isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect;
- (void) gotCollectedMatchList:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotlistByHisGains:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotForecastTotal:(NSDictionary *)infoDic  errorMsg:(NSString *)msg;
- (void) gotbonusOptimize:(NSArray *)infoList  errorMsg:(NSString *)msg;

- (void) gotSellIssueList:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void) gotListZcMatchSp:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void) listChaseSchemeForApp:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void) betedChaseScheme:(NSString *)schemeNO errorMsg:(NSString *)msg;
- (void) gotChaseDetailForApp:(NSDictionary *)infoDic errorMsg:(NSString *)msg;
- (void) gotListHisIssue:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void) gotListHisPageIssue:(NSArray *)infoDic  errorMsg:(NSString *)msg;
- (void)gotStopChaseScheme:(BOOL)isSuccess errorMsg:(NSString *)errorMsg;

- (void) gotlistJcgjSellItem:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotlistJcgyjSellItem:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotlistJcgjItem:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotlistJcgyjItem:(NSArray *)infoArray  errorMsg:(NSString *)msg;
- (void) gotJcgjTicketOrderDetail:(NSDictionary *)infoArray  errorMsg:(NSString *)msg;
- (void) gotJcgyjTicketOrderDetail:(NSDictionary *)infoArray  errorMsg:(NSString *)msg;
- (void) gotJclqMatch:(NSArray *)infoArray  errorMsg:(NSString *)msg;//篮球在售赛事
- (void) gotJclqSp:(NSArray *)infoArray  errorMsg:(NSString *)msg;//篮球的sp
- (void) gotSsqTicketOrderDetail:(NSDictionary *)infoArray  errorMsg:(NSString *)msg;//双色球
- (void) gotJclqTicketOrderDetail:(NSDictionary *)infoArray  errorMsg:(NSString *)msg;//竞彩篮球
- (void) gotlistRecommend:(NSArray *)infoArray  errorMsg:(NSString *)msg;//牛人，红人，红单榜
- (void) initiateFollowScheme:(NSString *)resultStr  errorMsg:(NSString *)msg;
- (void) listGreatFollow:(NSArray  *)personList  errorMsg:(NSString *)msg;
- (void) getHotFollowScheme:(NSArray  *)personList  errorMsg:(NSString *)msg;
- (void) followScheme:(NSString  *)result  errorMsg:(NSString *)msg;


@end

@interface LotteryManager : Manager

@property(nonatomic,weak)id <LotteryManagerDelegate >delegate;

- (NSString *)getStringformfeid :(EarningsType)defaultFeid;

- (void) getJczqMatch:(NSDictionary *)paraDic;
- (void) getJczqSp:(NSDictionary *)paraDic;
- (void) getJczqLeague:(NSDictionary *)paraDic;
- (void) betLotteryScheme:(BaseTransaction *)transcation;
- (void) schemeCashPayment:(NSDictionary *)paraDic;
- (void) schemeScorePayment:(NSDictionary *)paraDic;
- (void) getJczqShortcut;
- (void) listByForecast:(NSDictionary *)infoDic isHis:(BOOL)isHis;
- (void) getForecastByMatch:(NSDictionary *)infoDic;
- (void) getJczqPairingMatch:(NSDictionary *)infoDic;
- (void) jcycScoreZhibo:(NSDictionary *)infoDic isJCZQ:(BOOL)isJCZQ;
- (void) getListByRecScheme:(NSDictionary *)infoDic;
- (void) getBFZBInfo;
- (void) getSchemeRecord:(NSDictionary *)paraDic;
- (void) getJczqTicketOrderDetail:(NSDictionary *)paraDic andLottery:(NSString *)lotteryCode;
- (void)getSchemeRecordBySchemeNo:(NSDictionary *)paraDic;
- (void)listByRechargeChannel:(NSDictionary *)paraDic;
- (void)collectMatch:(NSDictionary *)paraDic;
- (void)getCollectedMatchList:(NSDictionary *)paraDic;
- (void)getlistByHisGains:(NSDictionary *)paraDic;
- (void)getForecastTotal:(NSDictionary *)paraDic;
- (void)updateRecSchemeRecCount:(NSDictionary *)paraDic;
- (void)getbonusOptimize:(BaseTransaction *)transcation;
- (void) betLotterySchemeOpti:(NSArray *)schemeList;
- (void) betLotterySchemeOpti:(BaseTransaction *)transcation schemeList:(NSArray *)schemeList;
- (void) lotteryTouZhuScheme: (Lottery *) lottery transaction: (BaseTransaction*) transaction;
- (NSArray*) getAllLottery ;
- (void)getSellIssueList:(NSDictionary *)paraDic;
- (void)getListZcMatchSp:(NSDictionary *)paraDic;
- (void) betChaseScheme:(LotteryTransaction *)transcation;
- (void)listChaseSchemeForApp:(NSDictionary *)paraDic;
- (void)getChaseDetailForApp:(NSDictionary *)paraDic;
- (void)getListHisIssue:(NSDictionary *)paraDic;
- (void)getListHisPageIssue:(NSDictionary *)paraDic;
- (void)getStopChaseScheme:(NSDictionary *)paraDic;
#pragma mark 竞猜冠亚军
- (void)listJcgjSellItem:(NSDictionary *)infoDic; //获取冠军选项
- (void)listJcgyjSellItem:(NSDictionary *)infoDic; //获取冠亚军选项
- (void)listJcgjItem:(NSDictionary *)infoDic; //获取冠军选项（包含不在售的）
- (void)listJcgyjItem:(NSDictionary *)infoDic; //获取冠亚军选项（包含不在售的）
- (void)getJcgjTicketOrderDetail:(NSDictionary *)paraDic;//查询冠军订单详情
- (void)getJcgyjTicketOrderDetail:(NSDictionary *)paraDic;//查询冠亚军订单详情

#pragma mark 双色球
- (void)getSsqTicketOrderDetail:(NSDictionary *)paraDic;//查询订单详情(双色球)

#pragma mark 竞彩篮球

- (void)getJclqMatch:(NSDictionary *)infoDic;//获取竞彩篮球在售赛事
- (void)getJclqSp:(NSDictionary *)infoDic;//获取竞彩篮球的sp
- (void)getJclqTicketOrderDetail:(NSDictionary *)paraDic;//查询订单详情(竞彩篮球)

#pragma mark 发单跟单
- (void)listRecommendPer:(NSDictionary *)infoDic categoryCode:(NSString *)categoryCode;//获取牛人，红人，红单榜

- (void)initiateFollowScheme:(NSDictionary *)infoDic;

- (void)listGreatFollow:(NSDictionary *)infoDic;

- (void)getHotFollowScheme;
- (void)getFollowSchemeByNickName:(NSDictionary *)paraic;
- (void)followScheme:(NSDictionary *)paraic;

@end

