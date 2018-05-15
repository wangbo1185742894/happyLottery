//
//  API.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//
#ifndef API_h
#define API_h

//#define APPSTORE 1 //appstore 版本 打开宏，  内测包 ，自由平台  屏蔽宏

#define NameSpaceURI @"http://webservice.onlytest.com/"

#ifdef APPSTORE
    #define APPUPDATAURL @"https://itunes.apple.com/cn/app/%E5%BD%A9%E8%BF%90%E5%AE%9D/id1334494277?mt=8"
#else
    #define APPUPDATAURL @"http://t.11max.com/Tbz"
#endif

//#define WSServerURL @"http://118.190.43.29:28000/services%@"
//#define ServerAddress @"http://124.89.85.110:17085"  //资讯  轮播图 用户图像
//#define H5BaseAddress @"http://118.190.43.29:28086"

#define ServerAddress @"http://192.168.88.244:8086"  //资讯  轮播图 用户图像
#define H5BaseAddress @"http://192.168.88.244:18086"
#define WSServerURL @"http://192.168.88.244:28000/services%@"


//#define H5BaseAddress @"http://192.168.88.193:18086"  //谢青服务
//#define H5BaseAddress @"http://192.168.88.116:18086"  //史少鹏服务
//杨芳本地
//#define ServerAddress @"http://192.168.88.109:8086"

//史少鹏服务
//#define WSServerURL @"http://192.168.88.116:28000/services%@"
//程家宗服务
//#define WSServerURL @"http://192.168.88.105:28000/services%@"
//#define WSServerURL @"http://192.168.88.116:28000/services%@"


//杨芳
//#define WSServerURL @"http://192.168.88.109:28000/services%@"

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
#define APIfeedBackUnReadNum         @"feedBackUnReadNum"
#define APIresetFeedBackReadStatus   @"resetFeedBackReadStatus"
#define APIgiveShareScore            @"giveShareScore"
#define APIattentMember              @"attentMember" //关注会员
#define APIlistGeniusDto             @"listGeniusDto" //获取牛人榜
#define APIRedManList                 @"redManList"  //获取红人榜
#define APIRedSchemeList            @"redSchemeList" //获取红单榜
#define APIlistGreatFollow           @"listGreatFollow" //跟单首页可跟单大师列表
#define APIGetHotFollowScheme        @"getHotFollowScheme"  // 获取热门发单
#define APIGetInitiateInfo           @"getInitiateInfo"  //获取发单会员详细信息

#define APIGetFollowSchemeByNickName  @"getFollowSchemeByNickName"
#define APIIsAttent                   @"isAttent"   //是否关注
#define APIAttentMember             @"attentMember" //关注会员
#define APIReliefAttent             @"reliefAttent"  //解除跟单

#define SUBAPIDATA           @"/data"
#define APISaveClientInfo           @"saveClientInfo"
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
#define APIsaveVisit                @"saveVisit"
#define APIgetForecastTotal         @"getForecastTotal"
#define APIGetVueHttpUrl            @"getVueHttpUrl"
#define APIupdateRecSchemeRecCount  @"updateRecSchemeRecCount"
#define APIgetSellIssueList         @"getSellIssueList"
#define APIlistZcMatchSp            @"listZcMatchSp"
#define APIListHisIssue             @"listHisIssue"
#define APIlistHisPageIssue         @"listHisPageIssue"
#define APIlistJcgjSellItem           @"listJcgjSellItem" //获取冠军选项
#define APIlistJcgyjSellItem          @"listJcgyjSellItem"//获取冠亚军选项
#define APIlistJcgjItem               @"listJcgjItem"//获取冠军选项（包含不在售的）
#define APIlistJcgyjItem              @"listJcgyjItem"//获取冠亚军选项（包含不在售的）
#define APIgetJclqMatch               @"getJclqMatch" //获取竞彩篮球在售赛事
#define APIgetJclqSp                  @"getJclqSp"  //获取竞彩篮球的sp

#define SUBAPISchemeService   @"/scheme"
#define APIBetLotteryScheme         @"betLotteryScheme"
#define APIbetChaseScheme           @"betChaseScheme"
#define APISchemeCashPayment        @"schemeCashPayment"
#define APISchemeScorePayment       @"schemeScorePayment"
#define APIGetSchemeRecord          @"getSchemeRecord"
#define APIGetSchemeRecordBySchemeNo @"getSchemeRecordBySchemeNo"
#define APIlistByHisGains           @"listByHisGains"
#define APIbonusOptimize            @"bonusOptimize"
#define APIlistChaseSchemeForApp    @"listChaseSchemeForApp"
#define APIgetChaseDetailForApp     @"getChaseDetailForApp"
#define APIchaseWhenStop            @"chaseWhenStop"
#define APIInitiateFollowScheme     @"initiateFollowScheme"//发单
#define APIFollowScheme             @"followScheme"//跟单
#define APIgetAttentFollowScheme    @"getAttentFollowScheme"  //获得关注人的发单


#define SUBAPITicketService   @"/ticket"
#define APIGetJczqTicketOrderDetail @"getJczqTicketOrderDetail"
#define APIGetDltTicketOrderDetail  @"getDltTicketOrderDetail"
#define APIgetSfcTicketOrderDetail  @"getSfcTicketOrderDetail"
#define APIgetRjcTicketOrderDetail  @"getRjcTicketOrderDetail"

#define APIGetJcgjTicketOrderDetail   @"getJcgjTicketOrderDetail"//查询冠军订单详情
#define APIGetJcgyjTicketOrderDetail  @"getJcgyjTicketOrderDetail"//查询冠亚军订单详情
#define APIGetSsqTicketOrderDetail    @"getSsqTicketOrderDetail"//查询订单详情(双色球)
#define APIGetJclqTicketOrderDetail   @"getJclqTicketOrderDetail"// 查询订单详情(竞彩篮球)

#endif /* API_h */
