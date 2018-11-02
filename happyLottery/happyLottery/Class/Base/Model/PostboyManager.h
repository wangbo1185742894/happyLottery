//
//  PostboyManager.h
//  happyLottery
//
//  Created by LYJ on 2018/11/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"

NS_ASSUME_NONNULL_BEGIN


@protocol PostboyManagerDelegate

@optional


-(void )getPostboyInfoByIddelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;

-(void )getPostboyAccountListdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg;

-(void )getMemberPostboyAccountdelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;

-(void )memberPostboyBalanceCountdelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;

-(void )recentPostboyAccountdelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;

- (void)gotLegUserCashInfoList:(NSArray*)infoList errorMsg:(NSString *)msg;

@end


@interface PostboyManager : Manager

@property(weak,nonatomic)id<PostboyManagerDelegate> delegate;


/**
 根据快递小哥的id获取快递小哥信息

 @param dictionary postboyId 小哥的id
 */
- (void)getPostboyInfoById:(NSDictionary *)dictionary;


/**
 获取快递小哥列表加账户信息

 @param dictionary cardCode 用户卡号
 */
- (void)getPostboyAccountList:(NSDictionary *)dictionary;


/**
 获取用户对应某一个快递小哥余额

 @param dictionary cardCode postboyId
 */
- (void)getMemberPostboyAccount:(NSDictionary *)dictionary;


/**
 预存款处的总额

 @param dictionary cardCode
 */
- (void)memberPostboyBalanceCount:(NSDictionary *)dictionary;


/**
 最近交易的小哥余额

 @param dictionary cardCode
 */
- (void)recentPostboyAccount:(NSDictionary *)dictionary;


/**
 分页查询小哥对应会员 认购  充值  中奖  提现  预付款  佣金明细

 @param paraDic {"cardCode":"xxx","postboyId":"xxxxx","page":"xxx","pageSize":"xxx"}
 @param api 接口名
 */
-(void)getLegUserCashInfo:(NSDictionary *)paraDic andApi:(NSString *)api;

@end

NS_ASSUME_NONNULL_END
