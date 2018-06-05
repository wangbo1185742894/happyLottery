//
//  AgentTransferModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "Enum.h"
@interface AgentTransferModel : BaseModel
/** 订单号*/
@property(nonatomic,copy)NSString * orderNo;

/** 转出的圈子ID*/
@property(nonatomic,copy)NSString * agentId;

/** 转入的圈主卡号*/
@property(nonatomic,copy)NSString * cardCode;

/** 转账金额 */
@property(nonatomic,copy)NSString * transferCost;

/** 审核状态 */
@property(nonatomic,assign)NSString * applyStatus; //ApplyStatus

/** 转账状态 */
@property(nonatomic,assign)NSString  * status; //TransferStatus

/** 审核人 */
@property(nonatomic,copy)NSString * applyUser;

/** 备注 */
@property(nonatomic,copy)NSString * remark;

/** 转账时间 */
@property(nonatomic,copy)NSString * createTime;

/*********************** 页面显示 ***********************/
@property(nonatomic,copy)NSString * trApplyStatus;
@property(nonatomic,copy)NSString * trTransferStatus;

/********************* 页面给的审核标识 ***************************/
@property(nonatomic,copy)NSString * applyStatusMark;

@end
