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

//244服务
#define WSServerURL @"http://192.168.88.244:28000/services%@"

//史少鹏服务
//#define WSServerURL @"http://192.168.88.116:28000/services%@"

//程家宗服务
//#define WSServerURL @"http://192.168.88.105:28000/services%@"


//#define WSServerURL @"http://192.168.88.116:28000/services%@"





#define SUBAPIActivity       @"/activity"
#define APIopenRedPacket           @"openRedPacket"
#define APIgetRedPacketByState     @"getRedPacketByState"


#define SUBAPIMember         @"/member"
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
#define APIgetCashBlotter          @"getCashBlotter"
#define APIgetScoreBlotter         @"getScoreBlotter"
#define APIgetMemberByCardCode     @"getMemberByCardCode"
#define APIgetCouponByState        @"getCouponByState"
#define APIupdateImage             @"headUrl"
#define APIgetMemberByCardCode     @"getMemberByCardCode"


#define SUBAPIDATA           @"/data"
#define APIgetJczqMatch             @"getJczqMatch"
#define APIgetJczqSp                @"getJczqSp"
#define APIgetJczqLeague            @"getJczqLeague"
#define APIgetJczqShortcut          @"getJczqShortcut"
#define APIgetForecastByMatch       @"getForecastByMatch"
#define APIgetJczqPairingMatch      @"getJczqPairingMatch"
#define APIlistByForecast           @"listByForecast"
#define APIlistByHisForecast        @"listByHisForecast"
#define APIlistByJclqScore          @"listByJclqScore"
#define APIlistByJczqScore          @"listByJczqScore"
#define APIlistByRecScheme          @"listByRecScheme"
#define APIGetBFZBInfo              @"getBFZBInfo"


#define SUBAPISchemeService   @"/scheme"
#define APIBetLotteryScheme         @"betLotteryScheme"
#define APISchemeCashPayment        @"schemeCashPayment"
#define APISchemeScorePayment       @"schemeScorePayment"
#define APIGetSchemeRecord          @"getSchemeRecord"
#define APIGetSchemeRecordBySchemeNo @"getSchemeRecordBySchemeNo"

#define SUBAPITicketService   @"/ticket"
#define APIGetJczqTicketOrderDetail @"getJczqTicketOrderDetail"




#endif /* API_h */
