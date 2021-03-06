//
//  API.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//
#ifndef API_h
#define API_h   //
//#define bate 1   // 用baseUrl 获取地址屏蔽宏
//#define APPSTORE 1 //appstore 版本 打开宏，  内测包 ，自由平台  屏蔽宏
#define BaseUrl @"http://t.11max.com/tbz/url.html" //获取 动态接口地址
#define NameSpaceURI @"http://webservice.onlytest.com/"


#ifdef APPSTORE
    #define APPUPDATAURL @"https://itunes.apple.com/cn/app/%E5%BD%A9%E8%BF%90%E5%AE%9D/1392832997?mt=8"
#else
    #define APPUPDATAURL @"http://t.11max.com/Tbz"
#endif
// 线上地址
//#define WSServerURL @"http://115.28.27.198:28000/services%@"  //新服务地址
#define WSServerURL @"http://tbz.xianyingcai.com:28000/services%@" // app主要地址
#define ServerAddress @"http://124.89.85.110:17085"  //资讯  轮播图 用户图像
#define H5BaseAddress @"http://tbz.xianyingcai.com:28086"
#define OmitServerURL @"http://tc.xianticai.com:17082/ms"  //新后台
//

//#define ServerAddress @"http://192.168.88.244:8086"  //资讯   轮播图   用户图像
//#define H5BaseAddress @"http://192.168.88.244:18086"
//#define WSServerURL @"http://192.168.88.244:28000/services%@"
//#define OmitServerURL @"http://192.88.244:19081/ms"

//志斌服务
//#define WSServerURL @"http://192.168.88.108:28086/services%@"
//
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
/**
 * 我的红包 获得的红包
 * @param params {"cardCode":"xxx"  ,"page":"xxx","pageSize":"xxx"} cardCode 会员卡号
 */

#define APIgainRedPacket @"gainRedPacket"

/**
 * 我的红包 发出的红包
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"} cardCode 会员卡号
 */

#define APIsendOutRedPacket @"sendOutRedPacket"

/**
 * 我发出去的红包  点击详情
 * @param params {"id":"xxx","page":"xxx","pageSize":"xxx"} 红包id
 * @return
 * @throws BizException
 */
#define APIsendOutRedPacketDetail @"sendOutRedPacketDetail"
#define SUBAPIMember              @"/member"
#define APILogin                        @"login"
#define APIRegister                    @"register"
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
#define APIrechargeOffline         @"rechargeOffline"  //线下充值
#define APIwithdrawByPostboy       @"withdrawByPostboy"  //会员提现(小哥账户)
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
#define APIgetListAttent                              @"listAttent"
#define APIGetFollowSchemeByNickName  @"getFollowSchemeByNickName"
#define APIIsAttent                   @"isAttent"   //是否关注
#define APIAttentMember             @"attentMember" //关注会员
#define APIReliefAttent             @"reliefAttent"  //解除跟单
#define APIlistRechargeHandsel      @"listRechargeHandsel"
#define API_listSubscribeDetail     @"listSubscribeDetail"
#define APIgetHotFollowSchemeNew     @"getHotFollowSchemeNew"
#define APITransferToPostboy        @"transferToPostboy"
/**
 * 分页查询会员的认购明细
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<SubscribeDetail>
 */
#define API_listSubscribeDetail     @"listSubscribeDetail"
/**
 * 分页查询会员的充值明细
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<RechargeDetail>
 */
#define API_listRechargeDetail     @"listRechargeDetail"

/**
 * 分页查询会员的中奖明细
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<BonusDetail>
 */
#define API_listBonusDetail  @"listBonusDetail"

/**
 * 分页查询会员提现明显
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<WithdrawDetail>
 */
#define API_listWithdrawDetail      @"listWithdrawDetail"


/**
 * 分页查询会员彩金明细
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<HandselDetail>
 */
#define API_listHandselDetail  @"listHandselDetail"


/**
 * 分页查询会员发单佣金明细
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 * @return List<FollowDetail>
 */
#define API_listFollowDetail        @"listFollowDetail"

/**
 * 获取返佣明细
 * @param params {"agentId":"xxx","page":"xxx","pageSize":"xxx"}
 * @return  List<AgentCommissionDetail>
 * @throws BizException
 */
#define API_listAgentCommissionDetail       @"listAgentCommissionDetail"

#define API_getChasePrepayOrderList         @"getChasePrepayOrderList"


/**
 * 红包 流水订单
 * @param params {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
*/
#define APIgetRedPacketOrderList @"getRedPacketOrderList"


#define SUBAPIDATA           @"/data"
/**
 * 跑腿小哥列表
 * @return 结果json
 */
#define APIgetLegWorkList           @"getLegWorkList"
/**
 * 门店随机显示
 * @return 结果json
 */
#define APIgetLotteryShop @"getLotteryShop"
/**
 * 快递小哥关联方案保存
 * @param params  {"legId":"xxx", "shopId":"xxx","schemeNo":"xxx"}
 *                快递小哥Id 彩票店Id 方案号
 * @return 结果json
 */
#define APIsaveLegScheme    @"saveLegScheme"
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
#define APIgetAppSign               @"getAppSign"
#define APIlistSellLottery              @"listSellLottery"
#define APIgetBootPageUrl           @"getBootPageUrl"
#define APIgetCommonSetValue            @"getCommonSetValue"
#define APIlistLotteryConfig        @"listLotteryConfig" //首页显示彩种新接口

/**
 * 获取最大可追期号(大乐透,双色球)
 * @param params {"lottery":"DLT"}
 * @return
 * @throws BizException
 */

#define APIgetMaxIssue           @"getMaxIssue"


#define SUBAPISchemeService   @"/scheme"
#define APIBetLotteryScheme         @"betLotteryScheme"
#define APIbetChaseScheme           @"betChaseScheme"
#define APISchemeCashPayment        @"schemeCashPayment"
#define APISchemeScorePayment       @"schemeScorePayment"
#define APIGetSchemeRecord          @"getSchemeRecord" //我的发单跟单列表
#define APIGetSchemeRecordBySchemeNo @"getSchemeRecordBySchemeNo" //方案详情跟发单
#define APIlistByHisGains           @"listByHisGains"
#define APIbonusOptimize            @"bonusOptimize"
#define APIlistChaseSchemeForApp    @"listChaseSchemeForApp"
#define APIgetChaseDetailForApp     @"getChaseDetailForApp"
#define APIchaseWhenStop            @"chaseWhenStop"
#define APIInitiateFollowScheme     @"initiateFollowScheme"//发单
#define APIFollowScheme             @"followScheme"//跟单
#define APIgetAttentFollowScheme    @"getAttentFollowScheme"  //获得关注人的发单
#define APIconcealSchemeBySchemeNo  @"concealSchemeBySchemeNo" //删除方案
#define APIchaseCompleteCount           @"chaseCompleteCount"
#define APISearchGreatFollow        @"searchGreatFollow" //搜索
#define APIinitiateFollowRedPacketPayment     @"initiateFollowRedPacketPayment"//发单红包支付
#define APIgetDeadLine              @"getDeadLine"  //根据方案号获取方案截期时间



#define SUBAPITicketService   @"/ticket"
#define APIGetJczqTicketOrderDetail @"getJczqTicketOrderDetail"
#define APIGetDltTicketOrderDetail  @"getDltTicketOrderDetail"
#define APIgetSfcTicketOrderDetail  @"getSfcTicketOrderDetail"
#define APIgetRjcTicketOrderDetail  @"getRjcTicketOrderDetail"
#define APIGetJcgjTicketOrderDetail   @"getJcgjTicketOrderDetail"//查询冠军订单详情
#define APIGetJcgyjTicketOrderDetail  @"getJcgyjTicketOrderDetail"//查询冠亚军订单详情
#define APIGetSsqTicketOrderDetail    @"getSsqTicketOrderDetail"//查询订单详情(双色球)
#define APIGetJclqTicketOrderDetail   @"getJclqTicketOrderDetail"// 查询订单详情(竞彩篮球
#define APIgetSD115TicketOrderDetail  @"getSD115TicketOrderDetail"
#define APIgetSX115TicketOrderDetail  @"getSX115TicketOrderDetail"
#define APIgetFollowSchemeBySchemeNo    @"getFollowSchemeBySchemeNo"


#define SUBAPIAgentService  @"/agent"

#define Agent_agentApply @"agentApply"  /** 会员建圈申请*/
#define Agent_getAgentInfo @"getAgentInfo" //获取当前用户的圈子信息()
#define Agent_listAgentMember @"listAgentMember"//获取当前用户所在圈子的所有圈民列表(我的圈子->我的圈友)
#define Agent_getAgentFollowCount @"getAgentFollowCount"//获取当前登录用户的圈子可跟单方案数
#define Agent_listAgentFollow @"listAgentFollow" //获取当前登录用户的圈子可跟单方案
#define Agent_listAgentDynamic @"listAgentDynamic" //获取圈子的动态
#define Agent_getMyAgentInfo @"getMyAgentInfo" //获取我的圈子
#define Agent_transferAccount @"transferAccount" //佣金账户转个人账户
#define Agent_listMyTransfer @"listMyTransfer" //分页获取圈主的佣金转账记录
#define Agent_modifyHeadUrl @"modifyHeadUrl" //变更圈子的头像
#define Agent_modifyCircleName @"modifyCircleName" //变更圈名
#define Agent_modifyNotice @"modifyNotice" //申请变更圈子公告
#define Agent_listMyCommission @"listMyCommission" //获取圈子的佣金列表
#define Agent_listAgentTotal @"listAgentTotal" //圈主圈民统计功能(发红包的前置查询)
#define Agent_sendAgentRedPacket @"sendAgentRedPacket" //圈主发红包


#define KcircleRegister @"/app/share/circleRegister" //圈主分享 H5BaseAddress
#define KcircleRegisterCopy @"/app/share/circleRegisterCopy"  //圈友分享 H5BaseAddress


#define SUBAPIPostboyService   @"/postboy"      // 快递小哥

#define APIGetPostboyInfoById        @"getPostboyInfoById" //根据快递小哥的id获取快递小哥信息
#define APIGetPostboyAccountList     @"getPostboyAccountList" //获取快递小哥列表加账户信息
#define APIGetMemberPostboyAccount   @"getMemberPostboyAccount" //获取用户对应某一个快递小哥余额
#define APIMemberPostboyBalanceCount @"memberPostboyBalanceCount" //预存款处的总额
#define APIRecentPostboyAccount      @"maxPostboyAccount"    //最近交易的小哥余额
#define APIListSubscribeDetailByPostboy  @"listSubscribeDetailByPostboy"  //分页查询快递小哥对应会员的认购明细
#define APIListRechargeDetailByPostboy  @"listRechargeDetailByPostboy"//分页查询小哥对应会员充值明细
#define APIListBonusDetailByPostboy     @"listBonusDetailByPostboy" //分页查询小哥对应会员的中奖明细（派奖）
#define APIListWithdrawDetailByPostboy  @"listWithdrawDetailByPostboy" //分页查询小哥对应会员提现明显
#define APIGetChasePrepayOrderListByPostboy  @"getChasePrepayOrderListByPostboy" // 获得小哥对应会员追号预付款 流水
#define APIListCommissionDetailByPostboy   @"listCommissionDetailByPostboy" //分页查询小哥对应会员发单佣金明细

#define APIListTransferByPostboy           @"listTransferByPostboy" //分页查询小哥对应会员余额转入


#endif /* API_h */
