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

- (void) forgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) sendForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) checkForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) resetNickSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) bandPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) resetPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) bindNameSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) addBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getBankListSms:(NSDictionary *)bankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) unBindBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg;
- (void) withdrawSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) sendUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) checkUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getSupportBankSms:(NSDictionary *)supportBankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getCashBlotterSms:(NSArray *)boltterInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getScoreBlotterSms:(NSArray *)scoreInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getMemberByCardCodeSms:(NSDictionary *)memberInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getRedPacketByStateSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) openRedPacketSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getCouponByStateSms:(NSArray *)couponInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) updateImage:(BOOL)success errorMsg:(NSString *)msg;
- (void) getQRCodeStateSms:(NSString *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) FeedBack:(BOOL)success errorMsg:(NSString *)msg;
- (void) changeLoginPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) getFeedbackListSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;

- (void) upMemberShareSmsIsSuccess:(BOOL)success result:(NSString *)result errorMsg:(NSString *)msg;

- (void) signInIsSuccess:(NSDictionary *)info isSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) gotisSignInToday:(NSString  *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) queryRecharge:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) gotAvailableCoupon:(BOOL)success andPayInfo:(NSArray *)payInfo errorMsg:(NSString *)msg;

- (void)saveVisited:(BOOL)issuccess;

- (void) FeedBackUnReadNum:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) ResetFeedBackReadStatusSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg;
- (void) gotVueHttpUrl:(NSString  *)baseUrl errorMsg:(NSString *)msg;
- (void) giveShareScore:(BOOL)success errorMsg:(NSString *)msg;
- (void) gotUserCashInfoList:(NSArray*)infoList errorMsg:(NSString *)msg;
-(void)chaseCompleteCount:(NSDictionary *)paraDic errorMsg:(NSString *)msg;
-(void)searchGreatFollow:(NSArray*)infoList errorMsg:(NSString *)msg;

@end

@interface MemberManager : Manager

@property(weak,nonatomic)id<MemberManagerDelegate> delegate;
- (void) loginCurUser:(NSDictionary *)paraDic;  
- (void) registerUser:(NSDictionary *)paraDic;
- (void) sendRegisterSms:(NSDictionary *)paraDic;
- (void) checkRegisterSms:(NSDictionary *)paraDic;
- (void) rechargeOffline:(NSDictionary *)paraDic;    //线下支付
- (void) getMemberByCardCode:(NSDictionary *)paraDic;
- (void) transferToPostboy:(NSDictionary *)paraDic;
- (void) forgetPWDSms:(NSDictionary *)paraDic;
- (void) sendForgetPWDSms:(NSDictionary *)paraDic;
- (void) checkForgetPWDSms:(NSDictionary *)paraDic;
- (void) resetNickSms:(NSDictionary *)paraDic;
- (void) bandPayPWDSms:(NSDictionary *)paraDic;
- (void) resetPayPWDSms:(NSDictionary *)paraDic;
- (void) changeLoginPWDSms:(NSDictionary *)paraDic;
- (void) bindNameSms:(NSDictionary *)paraDic;
- (void) addBankCardSms:(NSDictionary *)paraDic;
- (void) getBankListSms:(NSDictionary *)paraDic;
- (void) unBindBankCardSms:(NSDictionary *)paraDic;
- (void) rechargeSms:(NSDictionary *)paraDic;
- (void) withdrawSms:(NSDictionary *)paraDic  andAPI:(NSString *)apiName;
- (void) sendUpdatePaypwdSms:(NSDictionary *)paraDic;
- (void) checkUpdatePaypwdSms:(NSDictionary *)paraDic;
- (void) getSupportBankSms;
- (void) validatePaypwdSms:(NSDictionary *)paraDic;
- (void) getCashBlotterSms:(NSDictionary *)paraDic;
- (void) getScoreBlotterSms:(NSDictionary *)paraDic;
- (void) getMemberByCardCodeSms:(NSDictionary *)paraDic;
- (void) getRedPacketByStateSms:(NSDictionary *)paraDic;
- (void) openRedPacketSms:(NSDictionary *)paraDic;
- (void) getCouponByStateSms:(NSDictionary *)paraDic;
- (void)updateImage:(NSDictionary*)paramDic;
- (void)getQRCode:(NSDictionary*)paraDic;
- (void)FeedBack:(NSDictionary*)paraDic;
- (void) getFeedbackListSms:(NSDictionary *)paraDic;

- (void) getAvailableCoupon:(NSDictionary *)paraDic;

- (void) upMemberShareSms:(NSDictionary *)paraDic;
- (void)FeedBackUnReadNum:(NSDictionary*)paraDic;
- (void)ResetFeedBackReadStatus:(NSDictionary*)paraDic;
- (void)giveShareScore:(NSDictionary*)paraDic;


//11.23 活动公告
- (void)getActivetyMessage:(NSString *)strId;
- (void) signIn:(NSDictionary *)paraDic;
- (void) isSignInToday:(NSDictionary *)paraDic;
- (void) queryRecharge:(NSDictionary *)paraDic;
- (void)saveVisit:(NSArray  *)infoArray;

-(void)upLoadClientInfo:(NSDictionary *)clientInfo;

- (void)getVueHttpUrl;

-(void)getUserCashInfo:(NSDictionary *)paraDic andApi:(NSString *)api;
-(void)chaseCompleteCount:(NSDictionary *)paraDic;
-(void)searchGreatFollow:(NSDictionary *)paraDic;


@end

