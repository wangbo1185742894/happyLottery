//
//  Enum.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#ifndef Enum_h
#define Enum_h
///**     * 没有圈子     */
//NOT_AGENT("没有圈子"),
///**     * 圈子审核中     */
//AGENT_APPLYING("圈子审核中"),
///**     * 圈子审核驳回     */
//AGENT_APPLY_REJECT("圈子审核驳回");
typedef enum : NSUInteger {
    NOT_AGENT,
    AGENT_APPLYING,
    AGENT_APPLY_REJECT,
} AgentStatus;

//BOUNS("中奖"),
//INIT_SCHEME("发单"),
//FOLLOW_SCHEME("跟单");
typedef enum : NSUInteger {
    BOUNS,
    INIT_SCHEME,
    FOLLOW_SCHEME
} AgentDynamicType;

///**     * 注册     */
//REGISTER("注册加入"),
///**     * APP填写     */
//APP_ADD("APP填写分享码加入");
typedef enum : NSUInteger {
    /**     * 注册     */
    REGISTER,
    /**     * APP填写     */
    APP_ADD
} AgentJoinType;


//COMMISSION("佣金"),
//
//TRANSFER("佣金转个人账户"),
//
//TRANSFER_REF("佣金转个人账户退款");
typedef enum : NSUInteger {
    COMMISSION,
    TRANSFER,
    TRANSFER_REF
} AgentOrderType;

typedef enum : NSUInteger {
    /**     * 待审核     */
    AUDITING,
    /**     * 审批通过     */
    AUDITED,
    /**     * 审批驳回     */
    AUDIT_REJECT
    
} ApplyStatus;

//WAIT_TRANSFER("待转账"),
//TRANSFER_SUCCEED("转账成功"),
//TRANSFER_FAILURE("转账失败");
typedef enum : NSUInteger {
    WAIT_TRANSFER,
    TRANSFER_SUCCEED,
    TRANSFER_FAILURE
} TransferStatus;
#endif /* Enum_h */
