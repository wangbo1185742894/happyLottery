//
//  UserInfoBaseModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoBaseModel : BaseModel
-(NSString *)get1Name;
-(NSString *)get2Name;
-(NSString *)getRemark;
-(NSString *)get3Name;
-(NSString *)get4Name;

-(NSString *)getLeftTitle;
-(NSString *)getRightTitle;
@end

@interface BonusDetail : UserInfoBaseModel
/** 方案号 */
@property(nonatomic,strong)NSString * schemeNo;

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString * cardCode;

/** 认购分配的奖金*/
@property(nonatomic,strong)NSString * subBonus;

/** 派奖时间 */
@property(nonatomic,strong)NSString * prizeTime;

//-----------快递小哥-------------//
/** 小哥ID*/
@property(nonatomic,strong)NSString *  postboyId;

@end


@interface FollowDetail : UserInfoBaseModel


/** 发起的方案号 */
@property(nonatomic,strong)NSString * followSchemeNo;

/** 佣金  */
@property(nonatomic,strong)NSString * commission;

/** 创建时间 */
@property(nonatomic,strong)NSString * createTime;

@end

@interface HandselDetail : UserInfoBaseModel

/** 订单号*/
@property(nonatomic,strong)NSString * orderNo;

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString * cardCode;

/** 彩金来源 */
@property(nonatomic,strong)NSString * handselSource;

/** 彩金金额*/
@property(nonatomic,strong)NSString * amounts;

/** 时间 */
@property(nonatomic,strong)NSString * createTime;
@end

@interface RechargeDetail : UserInfoBaseModel

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString *  cardCode;

/** 充值金额 */
@property(nonatomic,strong)NSString *  amounts;

/** 支付状态 */
@property(nonatomic,strong)NSString *  status;

/** 成功时间 */
@property(nonatomic,strong)NSString *  successTime;

//-----------快递小哥-------------//
/** 小哥ID*/
@property(nonatomic,strong)NSString *  postboyId;

@end

@interface SubscribeDetail : UserInfoBaseModel

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString *  cardCode;

/** 方案号*/
@property(nonatomic,strong)NSString *  schemeNo;

/** 彩种*/
@property(nonatomic,strong)NSString *  lotteryType;

/** 消费类型*/
@property(nonatomic,strong)NSString * consumeType;

/** 认购总金额 */
@property(nonatomic,strong)NSString *  subAmounts;

/** 退款总金额 */
@property(nonatomic,strong)NSString *  refundAmounts ;

/** 认购时间*/
@property(nonatomic,strong)NSString *  subTime;

/** 是否使用优惠卷*/
@property(nonatomic,strong)NSString *  useCoupon;

/** 抵扣金额 */
@property(nonatomic,strong)NSString *  deduction;

/** 实际支付金额 */
@property(nonatomic,strong)NSString *  realSubAmounts;

//-----------快递小哥-------------//

/** 是否完成交易 */
@property(nonatomic,strong)NSString *  finished;

/** 小哥ID*/
@property(nonatomic,strong)NSString *  postboyId;

/** 完成交易时间(完成出票时间) */
@property(nonatomic,strong)NSString *  finishedTime;

/** 备注 */
@property(nonatomic,strong)NSString *  remark;

@end

@interface WithdrawDetail : UserInfoBaseModel

/** 会员卡号 账号*/
/** 方案号 */
@property(nonatomic,strong)NSString * orderNo;

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString * cardCode;

/** 金额*/
@property(nonatomic,strong)NSString * amounts;

/** 订单状态 */
@property(nonatomic,strong)NSString * orderStatus;

/** 成功时间  如果是成功状态显示这个时间*/
@property(nonatomic,strong)NSString * successTime;

/** 提现时间 */
@property(nonatomic,strong)NSString * createTime;

/** 备注 */
@property(nonatomic,strong)NSString * remark;

//-----------快递小哥-------------//
/** 小哥ID*/
@property(nonatomic,strong)NSString *  postboyId;

@end

@interface AgentCommissionDetail : UserInfoBaseModel

@property(nonatomic,strong)NSString * cardCode;

/** 佣金  */
@property(nonatomic,strong)NSString * commission;

/** 创建时间 */
@property(nonatomic,strong)NSString * createTime;
@end

@interface ChasePrepayModel : UserInfoBaseModel

/** 订单号*/
@property(nonatomic,strong)NSString * orderNo;

/** 会员卡号 */
@property(nonatomic,strong)NSString * cardCode;

/** 追号方案号*/
@property(nonatomic,strong)NSString * chaseSchemeNo;

/** 认购总金额 */
@property(nonatomic,strong)NSString * subAmounts;

/** 退款总金额 */
@property(nonatomic,strong)NSString * refundAmounts;

/** 异常追号退款 */
@property(nonatomic,strong)NSString *  chaseExceptionRefund;

/** 认购时间 */
@property(nonatomic,strong)NSString * subTime;

/** 追号完成时间 */
@property(nonatomic,strong)NSString * finishedTime;

/** 备注 */
@property(nonatomic,strong)NSString *  remark;

/** 完成追期数 */
@property(nonatomic,strong)NSString * chaseCount;

/** 彩种*/
@property(nonatomic,strong)NSString *  lotteryCode;


/** 当前期 */
@property(nonatomic,strong)NSString *  catchIndex;

/** 总期数 */
@property(nonatomic,strong)NSString *  totalCatch;

//-----------快递小哥-------------//
/** 小哥ID*/
@property(nonatomic,strong)NSString *  postboyId;


@end

@interface MemberRedPacketOrderModel : UserInfoBaseModel
@property(nonatomic,strong)NSString * orderNo;

/** 来源  发出显示 memberRedPacket 的 id   打开的显示 redPacket的Id */
@property(nonatomic,strong)NSString * origin;

/** 卡号 */
@property(nonatomic,strong)NSString * cardCode;

//FOLLOW_INITIATE("送出发单红包"),
//
//FOLLOW_FOLLOW("收到跟单红包"),
//
//CIRCLE_GIVEN("送出圈子红包"),
//
//CIRCLE_RECEIVE("收到圈子红包");
/** 红包流水类型 */
@property(nonatomic,strong)NSString * orderType;

/** 金额 */
@property(nonatomic,strong)NSString * amount;

/** 收支类型 */
@property(nonatomic,strong)NSString * budgetType;

/** 退款金额 */
@property(nonatomic,strong)NSString * refund;

/** 备注 */
@property(nonatomic,strong)NSString * remark;

/** 创建时间 */
@property(nonatomic,strong)NSString * createTime;

/** 方案号 */
@property(nonatomic,strong)NSString * schemeNo;

@property(nonatomic,copy)NSString * trOrderType;
@property(nonatomic,copy)NSString * trBudgetType;

@end


/**
 小哥对应用户佣金流水
 */
@interface PostboyBlotterDetailModel : UserInfoBaseModel

/** 所有业务的订单号*/
@property(nonatomic,strong)NSString * orderNo;

/** 所属的小哥ID */
@property(nonatomic,strong)NSString * postboyId;

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString * cardCode;

/** 会员的订单类型(现金) */
@property(nonatomic,strong)NSString * orderType;

/** 金额类型(现金) */
@property(nonatomic,strong)NSString * subType;

/** 变化后总余额 */
@property(nonatomic,strong)NSString * remBalance;

/** 备注 */
@property(nonatomic,strong)NSString * remark;

/** 账户交易金额(佣金)  */
@property(nonatomic,strong)NSString * amounts;

/** 创建时间 */
@property(nonatomic,strong)NSString * createTime;

@end
