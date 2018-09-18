//
//  AgentManager.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "Manager.h"

@protocol AgentManagerDelegate

@optional


/**
 会员建圈申请
 */
-(void )agentApplydelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
获取当前用户的圈子信息
 */
-(void )getAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;



/**
 获取当前用户所在圈子的所有圈民列表
 */
-(void )listAgentMemberdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 获取当前登录用户的圈子可跟单方案数
 */
-(void )getAgentFollowCountdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 获取当前登录用户的圈子可跟单方案
 */
-(void )listAgentFollowdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 获取圈子的动态
 */
-(void )listAgentDynamicdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 获取当前用户的圈子信息
 */
-(void )getMyAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 佣金账户转个人账户
 */
-(void )transferAccountdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 分页获取圈主的佣金转账记录
 */
-(void )listMyTransferdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
变更圈子的头像
 */
-(void )modifyHeadUrldelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
变更圈名

 */
-(void )modifyCircleNamedelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 申请变更圈子公告
 */
-(void )modifyNoticedelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg;

/**
 获取圈子的佣金列表
 */
-(void )listMyCommissiondelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;


/**
 圈主圈民统计功能(发红包的前置查询)
 */
-(void )listAgentTotaldelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;
@end

@interface AgentManager : Manager
@property(weak,nonatomic)id<AgentManagerDelegate> delegate;

/**
 会员建圈申请

 @param param {"cardCode":"卡号","realName":"真实姓名","mobile":"手机号","qq":"qq号"}
 */
-(void )agentApply:(NSDictionary *)param;

/**
 获取当前用户的圈子信息

 @param param {"cardCode":"当前登录会员卡号"}
 */
- (void)getAgentInfo:(NSDictionary *)param;


/**
 获取当前用户所在圈子的所有圈民列表(我的圈子->我的圈友)

 @param param {"cardCode":"当前登录用户","page":"页码","pageSize":"分页"}
 */
- (void)listAgentMember:(NSDictionary *)param;


/**
 获取当前登录用户的圈子可跟单方案数

 @param param {"agentId":"当前圈子ID"}
 */
- (void)getAgentFollowCount:(NSDictionary *)param;


/**
 获取当前登录用户的圈子可跟单方案

 @param param {"agentId":"当前圈子ID","page":"xxx","pageSize":"xxx" }
 */
- (void)listAgentFollow:(NSDictionary *)param;



/**
 获取圈子的动态

 @param param {"agentId":"当前圈子ID"}
 */
- (void)listAgentDynamic:(NSDictionary *)param;


/**
 获取我的圈子

 @param param {"cardCode":"圈主卡号"}
 */
- (void)getMyAgentInfo:(NSDictionary *)param;



/**
 佣金账户转个人账户

 @param param {"agentId":"圈子ID","cardCode":"执行转账的卡号","transferCost":"转账金额"}
 */
- (void)transferAccount:(NSDictionary *)param;



/**
 分页获取圈主的佣金转账记录

 @param param  {"agentId":"圈子ID","page":"页码","pageSize":"分页记录数" }
 */
- (void)listMyTransfer:(NSDictionary *)param;


/**
 变更圈子的头像

 @param param {"agentId":"圈子ID","headUrl":"头像" }
 */
- (void)modifyHeadUrl:(NSDictionary *)param;


/**
 变更圈名

 @param param {"agentId":"圈子ID","circleName":"新的圈名" }
 */
- (void)modifyCircleName:(NSDictionary *)param;


/**
 申请变更圈子公告

 @param param {"agentId":"圈子ID","notice":"公告" }
 */
- (void)modifyNotice:(NSDictionary *)param;


/**
 * 圈主圈民统计功能(发红包的前置查询)
 * @param param  {"agentId":"圈主ID","days":查询的天数 7 或者 30, "page":"分页页码","pageSize":"每页记录数","nickName":"昵称 (只有作为查询条件才有值, 没有该查询条件时可以为空)", "mobile":"手机号后四位 (只有作为查询条件才有值, 没有该查询条件时可以为空)"}
 */
- (void)listAgentTotal:(NSDictionary *)param;


/**
 获取圈子的佣金列表 {"agentId":"xxx","page":"xxx","pageSize":"xxx" }
 */
- (void)listMyCommission:(NSDictionary *)param;

@end
