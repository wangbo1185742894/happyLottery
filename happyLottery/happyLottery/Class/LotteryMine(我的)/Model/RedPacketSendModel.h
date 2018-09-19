//
//  RedPacketSendModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface RedPacketSendModel : BaseModel
/** 发单记方案号 圈子记 圈住id加时间戳  */
@property(nonatomic,copy)NSString * origin;

/** 红包总金额 */
@property(nonatomic,copy)NSString * amount;

/** 单个红包金额  */
@property(nonatomic,copy)NSString * univalent;

/** 红包个数 */
@property(nonatomic,copy)NSString * totalCount;

/** 红包剩余个数 */
@property(nonatomic,copy)NSString * surplusCount;

/** 发单人卡号  */
@property(nonatomic,copy)NSString * cardCode;

/** 红包完成状态 */
@property(nonatomic,copy)NSString * completeStatus;

/** 红包类型  随机 普通 */
@property(nonatomic,copy)NSString * randomType;

/** 退款金额 */
@property(nonatomic,copy)NSString * refundAmount;

/** 红包类型 */
@property(nonatomic,copy)NSString * packetChannel;

/** 是否可重复领取 */
@property(nonatomic,copy)NSString * repeat;

/** 发起时间 */
@property(nonatomic,copy)NSString * createTime;

//用于页面显示
@property(nonatomic,copy)NSString * trPacketChannel;

@property(nonatomic,copy)NSString * trCompleteStatus;

@property(nonatomic,copy)NSString * trRandomType;

@property(nonatomic,copy)NSString *  openSize;
@end
