//
//  API.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#ifndef API_h
#define API_h
#define ServerAddress @"http://192.168.88.244:8086"  //资讯  轮播图 用户图像
//杨芳本地
//#define ServerAddress @"http://192.168.88.109:8086"
#define NameSpaceURI @"http://webservice.onlytest.com/"

//244服务
#define WSServerURL @"http://192.168.88.244:28000/services%@"

//史少鹏服务
//#define WSServerURL @"http://192.168.88.116:28000/services%@"

//程家宗服务
//#define WSServerURL @"http://192.168.88.105:28000/services%@"


//#define WSServerURL @"http://192.168.88.116:28000/services%@"


//杨芳
//#define WSServerURL @"http://192.168.88.109:28000/services%@"

#define APPUPDATAURL @"http://t.11max.com/altc/"



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
#define APIChangeLoginPWDSms       @"updateMemberPwd"
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
#define APIsignIn                  @"signIn"
#define APIisSignInToday           @"isSignInToday"
#define APIgetCashBlotter          @"getCashBlotter"
#define APIgetScoreBlotter         @"getScoreBlotter"
#define APIgetMemberByCardCode     @"getMemberByCardCode"
#define APIgetRedPacketByState     @"getRedPacketByState"
#define APIopenRedPacket           @"openRedPacket"
#define APIgetCouponByState        @"getCouponByState"
#define APIupdateImage             @"modifyHeadUrl"
#define APIfeedBack                @"feedBack"
#define APIgetFeedbackList         @"getFeedbackList"
#define APIqueryRecharge           @"queryRecharge"
#define APIgetAvailableCoupon      @"getAvailableCoupon"
#define APIgetFeedbackList           @"getFeedbackList"
#define APIMemberShare               @"memberShare"




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
#define APIlistByRechargeChannel    @"listByRechargeChannel"
#define APICollectMatch             @"collectMatch"
#define APIGetCollectedMatchList    @"getCollectedMatchList"
#define APIgetClientDownLoadUrl     @"getClientDownLoadUrl"


#define SUBAPISchemeService   @"/scheme"
#define APIBetLotteryScheme         @"betLotteryScheme"
#define APISchemeCashPayment        @"schemeCashPayment"
#define APISchemeScorePayment       @"schemeScorePayment"
#define APIGetSchemeRecord          @"getSchemeRecord"
#define APIGetSchemeRecordBySchemeNo @"getSchemeRecordBySchemeNo"
#define APIlistByHisGains           @"listByHisGains"


#define SUBAPITicketService   @"/ticket"
#define APIGetJczqTicketOrderDetail @"getJczqTicketOrderDetail"




#endif /* API_h */
