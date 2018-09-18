//
//  HotSchemeModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface HotSchemeModel : BaseModel

@property(nonatomic,copy)NSString * totalFollowCount;

/** 发卡人电话*/
@property(nonatomic,copy)NSString *  memberTel;

/** 渠道**/
@property(nonatomic,copy)NSString *  memberChannel;

/** 方案号 */
@property(nonatomic,copy)NSString *  schemeNo;

/**　发单人卡号　*/
@property(nonatomic,copy)NSString *  cardCode;

/** 发单人昵称 */
@property(nonatomic,copy)NSString *  nickName;

/** 发单人头像 */
@property(nonatomic,copy)NSString *  headUrl;

/**　跟单截至时间　*/
@property(nonatomic,copy)NSString *  deadLine;

/** 彩种 */
@property(nonatomic,copy)NSString *  lottery;

/** 保证金额 */
@property(nonatomic,copy)NSString *  pledge;

/** 串关 */
@property(nonatomic,copy)NSString *  passTypes;

/** 联赛名称*/
@property(nonatomic,copy)NSString *  leagueNames;

/** 自购金额 */
@property(nonatomic,copy)NSString *  betCost;

/** 跟单最小金额 */
@property(nonatomic,copy)NSString *  minFollowCost;

/** 统计跟单金额 */
@property(nonatomic,copy)NSString * totalFollowCost;

/** 近期中奖 */
@property(nonatomic,copy)NSString *  recent_won;

/** 标签url */
@property(nonatomic,copy)NSString *  label_urls;


/**
 奖金
 */
@property(nonatomic,copy)NSString * bonus;

/**
 服务时间用来判断改发单是否能被购买
 */
@property(nonatomic,copy)NSString * serverTime;


/**
 是否中奖
 */
@property(nonatomic,copy)NSString * won;

@property(nonatomic,copy)NSString * schemeSource;

/** 是否已经跟单 */
@property(nonatomic,copy)NSString * alreadyFollow;

/** 发单是否有红包 */
@property(nonatomic,copy)NSString * hasRedPacket;

/** 红包完成状态 */
@property(nonatomic,copy)NSString * completeStatus;

/** 是否领取 */
@property(nonatomic,copy)NSString *gainRedPacket;

-(NSString *)lotteryIcon;

-(NSString *)getContent;

-(NSString *)getDetailContent;
@end
