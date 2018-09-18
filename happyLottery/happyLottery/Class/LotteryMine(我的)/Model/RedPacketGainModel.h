//
//  RedPacketGainModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface RedPacketGainModel : BaseModel

@property(nonatomic,copy)NSString * _id;
/** 会员卡号 账号*/
@property(nonatomic,copy)NSString * cardCode;

/** 起始有效时间 */
@property(nonatomic,copy)NSString * startValidTime;

/** 截至有效时间*/
@property(nonatomic,copy)NSString * endValidTime;

/** 红包状态 */
@property(nonatomic,copy)NSString * redPacketStatus;

/** 红包的说明描述 */
@property(nonatomic,copy)NSString * _description;

/** 是否随机红包, 如果是随机红包, 最大值是 红包的金额字段标识的值*/
@property(nonatomic,copy)NSString * randomCost;

/** 活动名称 */
@property(nonatomic,copy)NSString * activityName;

/** 红包类型 */
@property(nonatomic,copy)NSString * redPacketType;
/** 红包内容, 可能是金额, 可能是 积分,或者优惠卷的卡号 根据 redPacketType */
@property(nonatomic,copy)NSString * redPacketContent;


/** 活动ID */
@property(nonatomic,copy)NSString * activityId;

/** 红包渠道 */
@property(nonatomic,copy)NSString * redPacketChannel;

/**　打开时间　*/
@property(nonatomic,copy)NSString * openTime;

/** 使用时间 */
@property(nonatomic,copy)NSString * useTime;
/** 申请时间 */
@property(nonatomic,copy)NSString * createTime;

/** 触发打开红包触发存储过程名称  */
@property(nonatomic,copy)NSString * proName;

/** 触发打开红包触发存储过程参数列表 */
@property(nonatomic,copy)NSString * proParams;

/** 触发打开红包触发存储过程的固定参数 */
@property(nonatomic,copy)NSString * fixedParams;

/** 操作人 */
@property(nonatomic,copy)NSString * editor;

@property(nonatomic,copy)NSString * trRedPacketType;

@property(nonatomic,copy)NSString * trRedPacketStatus;

@property(nonatomic,copy)NSString * trRedPacketChannel;

@end
