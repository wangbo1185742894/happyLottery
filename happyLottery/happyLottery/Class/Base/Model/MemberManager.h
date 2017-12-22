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
- (void) forgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) sendForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) checkForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) resetNickSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) bandPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) resetPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) bindNameSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) addBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getBankListSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) unBindBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) rechargeSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) withdrawSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) sendUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) checkUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getSupportBankSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;

@end

@interface MemberManager : Manager

@property(weak,nonatomic)id<MemberManagerDelegate> delegate;
- (void) loginCurUser:(NSDictionary *)paraDic;  
- (void) registerUser:(NSDictionary *)paraDic;
- (void) sendRegisterSms:(NSDictionary *)paraDic;
- (void) checkRegisterSms:(NSDictionary *)paraDic;
- (void) forgetPWDSms:(NSDictionary *)paraDic;
- (void) sendForgetPWDSms:(NSDictionary *)paraDic;
- (void) checkForgetPWDSms:(NSDictionary *)paraDic;
- (void) resetNickSms:(NSDictionary *)paraDic;
- (void) bandPayPWDSms:(NSDictionary *)paraDic;
- (void) bindNameSms:(NSDictionary *)paraDic;
- (void) addBankCardSms:(NSDictionary *)paraDic;
- (void) getBankListSms:(NSDictionary *)paraDic;
- (void) unBindBankCardSms:(NSDictionary *)paraDic;
- (void) rechargeSms:(NSDictionary *)paraDic;
- (void) withdrawSms:(NSDictionary *)paraDic;
- (void) sendUpdatePaypwdSms:(NSDictionary *)paraDic;
- (void) checkUpdatePaypwdSms:(NSDictionary *)paraDic;
- (void) getSupportBankSms:(NSDictionary *)paraDic;

@end

