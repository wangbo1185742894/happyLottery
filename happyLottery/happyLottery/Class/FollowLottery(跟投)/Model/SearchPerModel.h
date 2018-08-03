//
//  SearchPerModel.h
//  happyLottery
//
//  Created by LYJ on 2018/8/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface SearchPerModel : BaseModel

/** 会员卡号 账号*/
@property(nonatomic,copy)NSString * cardCode;

/** 昵称 */
@property(nonatomic,copy)NSString * nickname;

/** 头像地址 */
@property(nonatomic,copy)NSString * headUrl;

/** 发起单数*/
@property(nonatomic,copy)NSString * initiateCount;

/** 中奖单数 */
@property(nonatomic,copy)NSString * winCount;

/** 总跟单数 */
@property(nonatomic,copy)NSString * followCount;

/** 总计认购金额(发起的单子的认购金额 ) */
@property(nonatomic,copy)NSString * totalCost;

/** 总计跟单金额(跟单的认购金额 ) */
@property(nonatomic,copy)NSString * totalFollowCost;

/** 总计发单中奖金额 */
@property(nonatomic,copy)NSString * totalBonus;

/** 总计佣金 */
@property(nonatomic,copy)NSString * totalCommission;

/** 最近中奖 */
@property(nonatomic,copy)NSString * recentWon;

/** 手机号 */
@property(nonatomic,copy)NSString * mobile;

/** 标签 */
@property(nonatomic,copy)NSString * labels;

@end
