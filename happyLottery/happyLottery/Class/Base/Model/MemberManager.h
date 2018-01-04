//
//  MemberManager.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"
@protocol MemberManagerDelegate
@optional
- (void) registerUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) sendRegisterSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) checkRegisterSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) gotMemberByCardCode:(NSDictionary*)userInfo errorMsg:(NSString *)msg;
@end

@interface MemberManager : Manager

@property(weak,nonatomic)id<MemberManagerDelegate> delegate;
- (void) loginCurUser:(NSDictionary *)paraDic;  
- (void) registerUser:(NSDictionary *)paraDic;
- (void) sendRegisterSms:(NSDictionary *)paraDic;
- (void) checkRegisterSms:(NSDictionary *)paraDic;
- (void) getMemberByCardCode:(NSDictionary *)paraDic;
@end

