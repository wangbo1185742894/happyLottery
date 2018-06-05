//
//  AgentCommissionModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface AgentCommissionModel : BaseModel

/** 圈子ID*/
@property(nonatomic,copy)NSString * agentId;

/** 圈民卡号 */
@property(nonatomic,copy)NSString * cardCode;

/** 圈民显示的昵称或者手机号*/
@property(nonatomic,copy)NSString * viewName;

/** 提成的方案号 */
@property(nonatomic,copy)NSString * schemeNo;

/** 提成的方案对应彩种 */
@property(nonatomic,copy)NSString * lottery;

/** 认购金额 */
@property(nonatomic,copy)NSString * subCost;

/** 提成比例  */
@property(nonatomic,copy)NSString * commissionRate;

/** 提成金额 */
@property(nonatomic,copy)NSString * commission;

/** 提成时间 */
@property(nonatomic,copy)NSString * createTime;
-(NSString *)lotteryIcon;
@end
