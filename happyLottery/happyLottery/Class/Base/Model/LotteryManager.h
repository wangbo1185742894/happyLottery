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
- (void) getJczqTicketOrderDetail:(NSDictionary *)paraDic;
- (void)getSchemeRecordBySchemeNo:(NSDictionary *)paraDic;
- (void)listByRechargeChannel:(NSDictionary *)paraDic;
- (void)collectMatch:(NSDictionary *)paraDic;
- (void)getCollectedMatchList:(NSDictionary *)paraDic;
- (void)getlistByHisGains:(NSDictionary *)paraDic;
- (void)getForecastTotal:(NSDictionary *)paraDic;
- (void)updateRecSchemeRecCount:(NSDictionary *)paraDic;


@end

