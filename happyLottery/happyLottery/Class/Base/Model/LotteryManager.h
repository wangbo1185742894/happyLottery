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
- (void) gotAttentFollowScheme:(NSArray  *)personList  errorMsg:(NSString *)msg;//关注人的发单
- (void) gotInitiateInfo:(NSDictionary *)diction  errorMsg:(NSString *)msg;
- (void) followScheme:(NSString  *)result  errorMsg:(NSString *)msg;
- (void) gotisAttent:(NSString *)diction  errorMsg:(NSString *)msg;
- (void) gotAttentMember:(NSString *)diction  errorMsg:(NSString *)msg;
- (void) gotReliefAttent:(NSString *)diction  errorMsg:(NSString *)msg;

- (void) gotListAttent:(NSArray  *)personList  errorMsg:(NSString *)msg;
- (void) gotAppSign:(NSDictionary *)personList  errorMsg:(NSString *)msg;
- (void) listSellLottery:(NSArray *)lotteryList  errorMsg:(NSString *)msg;
- (void) listRechargeHandsel:(NSArray *)lotteryList  errorMsg:(NSString *)msg;
-(void)gotBootPageUrl:(NSString *)strUrl;
- (void) deleteSchemeByNo:(NSString *)resultStr  errorMsg:(NSString *)msg; //删除订单
-(void)gotCommonSetValue:(NSString *)strUrl;
-(void)gotCommonSetValue:(NSString *)strUrl andIndex:(NSInteger)index;
- (void) gotFollowSchemeBySchemeNo:(NSDictionary *)resultDic  errorInfo:(NSString *)msg;

- (void)initiateFollowRedPacketPayment:(NSString *)resultStr  errorMsg:(NSString *)msg;
- (void)getDeadLineDelegate:(NSString *)resultStr  errorMsg:(NSString *)msg;
- (void) gotRedPacketHis:(NSArray *)redList errorInfo:(NSString *)errMsg;
- (void) gotLegWorkList:(NSArray *)redList errorInfo:(NSString *)errMsg;
- (void) gotLotteryShop:(NSDictionary *)redList errorInfo:(NSString *)errMsg;
- (void) savedLegScheme:(BOOL )success errorInfo:(NSString *)errMsg;
- (void) sendedOutRedPacketDetail:(BOOL )success followList:(NSArray *)redList errorInfo:(NSString *)errMsg;
@end

@interface LotteryManager : Manager

@property(nonatomic,weak)id <LotteryManagerDelegate >delegate;
- (void) loadLotteryProfiles: (Lottery *) lottery;
- (NSArray *) lotteryProfilesFromData: (NSArray *) profilesArray;
- (NSString *)getStringformfeid :(EarningsType)defaultFeid;
-(void)getBootPageUrl;
- (void) getJczqMatch:(NSDictionary *)paraDic;
- (void) getJczqSp:(NSDictionary *)paraDic;
- (void) getJczqLeague:(NSDictionary *)paraDic;
- (void) betLotteryScheme:(BaseTransaction *)transcation;

// 提交购彩方案
- (void) betLotteryScheme:(BaseTransaction *)transcation andPostboyId:(NSString *)postboyId;

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
// 提交追号方案
- (void) betChaseScheme:(LotteryTransaction *)transcation andPostboyId:(NSString *)postboyId;
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

- (void)initiateFollowRedPacketPayment:(NSDictionary *)infoDic;

- (void)listGreatFollow:(NSDictionary *)infoDic;

- (void)getHotFollowScheme:(NSDictionary *)paraic;
- (void)getFollowSchemeByNickName:(NSDictionary *)paraic;
- (void)followScheme:(NSDictionary *)paraic;

- (void)getAttentFollowScheme:(NSDictionary *)paraDic;

- (void)getDeleteSchemeByNo:(NSDictionary *)paraDic;//删除订单

- (void)getInitiateInfo:(NSDictionary *)paraDic;
- (void)getListAttent:(NSDictionary *)paraDic;

- (void)isAttent:(NSDictionary *)paraDic;

- (void)attentMember:(NSDictionary *)paraDic;

- (void)reliefAttent:(NSDictionary *)paraDic;

- (void)getAppSign:(NSDictionary *)paraDic;

- (void)getListSellLottery;

- (void)listRechargeHandsel;

-(void)getCommonSetValue:(NSDictionary *)para;
- (void) betChaseSchemeZhineng:(LotteryTransaction *)transcation andchaseList:(NSArray *)chaseList;
-(void)getFollowSchemeBySchemeNo:(NSDictionary *)para;

- (void) betLotteryScheme:(BaseTransaction *)transcation andBetContentArray:(NSArray *)contents;
    
-(void)getCommonSetValue:(NSDictionary *)para andIndex:(NSInteger)index;
-(void)getRedPacketHis:(NSDictionary *)para andUrl:(NSString *)strUrl;
-(void)getLegWorkList:(NSDictionary *)para;
-(void)saveLegScheme:(NSDictionary *)para;
-(void)getLotteryShop:(NSDictionary *)para;
-(void)sendOutRedPacketDetail:(NSDictionary *)para;

/**
 * 根据方案号获取方案截期时间
 * @param params {"schemeNo":"xxxxxxx"}
 * @return
 * @throws BizException
 */
- (void)getDeadLine:(NSDictionary *)infoDic;


- (void) betChaseSchemeZhineng:(LotteryTransaction *)transcation andchaseList:(NSArray *)chaseList andpostboyId:(NSString *)postboyId;
@end

