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
@end

@interface SubscribeDetail : UserInfoBaseModel

/** 会员卡号 账号*/
@property(nonatomic,strong)NSString *  cardCode;

/** 方案号*/
@property(nonatomic,strong)NSString *  schemeNo;

/** 彩种*/
@property(nonatomic,strong)NSString *  lotteryType;

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

/** 认购时间 */
@property(nonatomic,strong)NSString * subTime;

/** 追号完成时间 */
@property(nonatomic,strong)NSString * finishedTime;

/** 备注 */
@property(nonatomic,strong)NSString *  remark;

/** 完成追期数 */
@property(nonatomic,strong)NSString * chaseCount;

/** 彩种*/
@property(nonatomic,strong)NSString *  lotteryType;
@end


