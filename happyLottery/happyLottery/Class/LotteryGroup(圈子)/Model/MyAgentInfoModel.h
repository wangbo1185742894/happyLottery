//
//  MyAgentInfoModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "Enum.h"

@interface MyAgentTotalModel : BaseModel
/** 统计日期 */
@property(nonatomic,copy)NSString *totalDay;
/** 总提成 */
@property(nonatomic,copy)NSString * totalCommission;
@end
@interface MyAgentInfoModel : BaseModel

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

/** 公告审核状态 */
@property(nonatomic,copy)NSString * noticeStatus;

/** 竞技彩提成 */
@property(nonatomic,copy)NSString * sportsCommission;


@property(nonatomic,copy)NSString * noticeRefuseReason;

/** 数字彩提成*/
@property(nonatomic,copy)NSString * numberCommission;

/** 佣金余额 */
@property(nonatomic,copy)NSString * commission;

@property(nonatomic,copy)NSString * totalSale;
/** 七日佣金统计 */
@property(nonatomic,strong) NSMutableArray  <MyAgentTotalModel *>  *agentTotalList;

@end
