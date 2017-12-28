//
//  API.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#ifndef API_h
#define API_h

#define NameSpaceURI @"http://webservice.onlytest.com/"


#define WSServerURL @"http://192.168.88.244:28000/services%@"

//#define WSServerURL @"http://192.168.88.105:28000/services%@"

//#define WSServerURL @"http://192.168.88.116:28000/services%@"

#define SUBAPIMember               @"/member"
#define SUBAPIActivity              @"/activity"

#define APILogin                   @"login"
#define APIRegister                @"register"
#define APISendRegisterSms         @"sendRegisterSms"
#define APICheckRegisterSms        @"checkRegisterSms"
#define APISendForgetPWDSms        @"sendResetPwdSms"
#define APICheckForgetPWDSms       @"checkResetPwdSms"
#define APIForgetPWDSms            @"resetMemberPwd"
#define APIResetNickSms            @"modifyNickname"
#define APIBandPayPWDSms           @"bindMemberPaypwd"
#define APIResetPayPWDSms          @"updateMemberPaypwd"
#define APIsendUpdatePaypwdSms     @"sendUpdatePaypwdSms"
#define APIcheckUpdatePaypwdSms    @"checkUpdatePaypwdSms"
#define APIgetSupportBank          @"getSupportBank"
#define APIbindName                @"bindName"
#define APIaddBankCard             @"addBankCard"
#define APIgetBankList             @"getBankList"
#define APIunBindBankCard          @"unBindBankCard"
#define APIrecharge                @"recharge"
#define APIwithdraw                @"withdraw"
#define APIvalidatePaypwd          @"validatePaypwd"
#define APIgetCashBlotter           @"getCashBlotter"
#define APIgetScoreBlotter          @"getScoreBlotter"
#define APIgetMemberByCardCode      @"getMemberByCardCode"
#define APIgetRedPacketByState      @"getRedPacketByState"
#define APIopenRedPacket            @"openRedPacket"
#define APIgetCouponByState            @"getCouponByState"

#endif /* API_h */
