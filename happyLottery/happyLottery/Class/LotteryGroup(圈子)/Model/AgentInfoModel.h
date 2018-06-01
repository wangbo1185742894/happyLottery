//
//  AgentInfoModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//


#import "BaseModel.h"
#import "Enum.h"

@interface AgentDynamic : BaseModel
@property(nonatomic,copy)NSString * agentId;
@property(nonatomic,copy)NSString * dynamic;
@end

@interface AgentInfoModel : BaseModel

/** 圈子ID*/
@property(nonatomic,copy)NSString * _id;

/** 圈主的会员ID*/
@property(nonatomic,copy)NSString * memberId;

/** 圈主的卡号 */
@property(nonatomic,copy)NSString * cardCode;

/** 圈子名称*/
@property(nonatomic,copy)NSString * circleName;

/** 圈子头像 */
@property(nonatomic,copy)NSString * headUrl;

/** 圈子公告 */
@property(nonatomic,copy)NSString * notice;

/** 竞技彩提成 */
@property(nonatomic,copy)NSString * sportsCommission;

/** 数字彩提成*/
@property(nonatomic,copy)NSString * numberCommission;

/** 佣金余额 */
@property(nonatomic,copy)NSString * commission;

/** 圈子总人数*/
@property(nonatomic,copy)NSString * memberCount;

/** 圈子总中奖 */
@property(nonatomic,copy)NSString * totalBonus;

/** 申请时间*/
@property(nonatomic,copy)NSString * createTime;

/** 圈子审核状态 这个字段判读点击圈子后进入那个页面*/
@property(nonatomic,assign) AgentStatus agentStatus;



@end
