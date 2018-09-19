//
//  FollowListModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface FollowListModel : BaseModel
/** 跟单的方案号 */

@property(nonatomic,strong)NSString *selfSchemeNo;

/** 跟单的卡号 */
@property(nonatomic,strong)NSString *selfCardCode;

/** 跟单人的昵称*/
@property(nonatomic,strong)NSString *selfNickname;

/** 跟单人的头像*/
@property(nonatomic,strong)NSString *selfHeadUrl;


/** 跟单的金额 */
@property(nonatomic,strong)NSString *followCost;

/** 跟单的中奖(方案中奖金额, 这里的值没有减去佣金,不是实际收入, 实际收入需要用bonus减去佣金) */
@property(nonatomic,strong)NSString *bonus;

/** 佣金 */
@property(nonatomic,strong)NSString * commission;

/** 是否获得红包 */
@property(nonatomic,strong)NSString * gainRedPacket;

/** 红包是否打开 */
//LOCK("锁定"),
//UN_OPEN("解锁"),
//OPEN("领取"),
//INVALID("失效");openStatus
@property(nonatomic,strong)NSString * openStatus;
@property(nonatomic,strong)NSString * open;

@end
