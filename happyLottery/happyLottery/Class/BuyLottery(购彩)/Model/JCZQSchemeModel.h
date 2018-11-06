//
//  JCZQSchemeModel.h
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "FollowListModel.h"


//_trOpenResult    __NSCFString *    @"[{\"RQSPF\":\"1\",\"homeScore\":1,\"guestScore\":0,\"BF\":\"--\",\"BQC\":\"33\",\"handicap\":-1,\"SPF\":\"3\",\"matchKey\":102989,\"guest\":\"普埃布拉\",\"JQS\":\"1\",\"home\":\"莫雷利亚\",\"status\":1},{\"\":\"1\",\"homeScore\":1,\"guestScore\":0,\"BF\":\"--\",\"BQC\":\"33\",\"handicap\":-1,\"SPF\":\"3\",\"matchKey\":102988,\"guest\":\"内卡萨\",\"JQS\":\"1\",\"home\":\"蒂华纳\",\"status\":1}]"    0x0000000101af79c0

@interface JcBetContent :NSObject

@property(nonatomic,copy)NSDictionary * matchInfo;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,assign) BOOL isLast;
@property(nonatomic,copy) NSString  * passTypes;
@property(nonatomic,copy) NSString  * multiple;
@property(nonatomic,copy) NSString  * virtualSp;
@end

@interface OpenResult : BaseModel
@property(nonatomic,copy)NSString * RQSPF;
@property(nonatomic,copy)NSString * homeScore;
@property(nonatomic,copy)NSString * guestScore;
@property(nonatomic,copy)NSString * BF;
@property(nonatomic,copy)NSString * BQC;
@property(nonatomic,copy)NSString * handicap;
@property(nonatomic,copy)NSString * SPF;
@property(nonatomic,copy)NSString * matchKey;
@property(nonatomic,copy)NSString * JQS;
@property(nonatomic,copy)NSString * home;
@property(nonatomic,copy)NSString * guest;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * matchStatus;
@end

@interface JCZQSchemeItem : BaseModel
/**　投注内容　*/
@property(nonatomic,copy)NSString * betContent;
/** 投注总金额 */
@property(nonatomic,copy)NSString * betCost;
/** 单倍注数 */
@property(nonatomic,copy)NSString * units;
/** 倍数 */
@property(nonatomic,copy)NSString * multiple;
/** 奖期期号 */
@property(nonatomic,copy)NSString * issueNumber;

/** 创建时间 */
@property(nonatomic,copy)NSString * createTime;
  /** 彩种 */
@property(nonatomic,copy)NSString * lottery;
/** 账户消费类型(积分或者现金) */
@property(nonatomic,copy)NSString * costType;
/** 开奖状态 (未开奖, 已开奖, 已派奖) */
@property(nonatomic,copy)NSString * winningStatus;
 /** 方案出票状态 (等待出票 ,委托中, 委托成功, 出票中, 出票成功) */
@property(nonatomic,copy)NSString * ticketStatus;
/** 自身方案编号 */
@property(nonatomic,copy)NSString * schemeNO;
/** 是否中奖 */
@property(nonatomic,copy)NSString * won;
/** 中奖详情 */
@property(nonatomic,copy)NSString * wonDetail;
@property(nonatomic,copy)NSString * lotteryIcon;
/** 总票数 */
@property(nonatomic,copy)NSString * ticketCount;
 /** 出票数 */
@property(nonatomic,copy)NSString * printCount;
 /** 方案状态 */
@property(nonatomic,copy)NSString * schemeStatus;
/** 税后奖金 */
@property(nonatomic,copy)NSString * bonus;
/** 是否完成交易 */
@property(nonatomic,copy)NSString * finished;
@property(nonatomic,copy)NSString * deduction;
/** 会员卡号 **/
@property(nonatomic,copy)NSString * cardCode;
/** 实际支付金额 */
@property(nonatomic,copy)NSString * realSubAmounts;
/** 是否使用优惠卷 */
@property(nonatomic,copy)NSString * useCoupon;
@property(nonatomic,copy)NSString * finishedTime;
/** 认购时间 */
@property(nonatomic,copy)NSString * subTime;
 /** 销售期间 出票直接返回失败时执行退款的金额 */
@property(nonatomic ,copy)NSString *ticketFailRef;
/** 中奖号码 **/
@property(nonatomic,copy)NSMutableArray <OpenResult *> * trOpenResult;
@property(nonatomic,copy)NSString * trDltOpenResult;
/** 竞彩冠军和竞彩冠亚军的开奖信息 */
@property(nonatomic,copy)NSString * winMatchIndex;
/** 虚拟赔率 */
@property(nonatomic,copy)NSString *virtualSp;
/** 投注来源类型*/
@property(nonatomic,copy)NSString * schemeSource;
/** 投注内容(原始)*/
@property(nonatomic,copy)NSString * originalContent;
/** 手机号 */
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString *drawCount;//开奖订单数
/** 方案执行截期的时间 */
@property(nonatomic,copy)NSString *sellEndTime;

/******************** 跟单发单信息 *********************/

/** JC投注内容的串关 */
 @property(nonatomic,copy)NSArray *passType;

/** 发单人昵称 */
@property(nonatomic,copy)NSString *initiateNickname;

/** 发单人头像 */
@property(nonatomic,copy)NSString * initiateUrl;

/** 实际盈利 奖金减去佣金*/
@property(nonatomic,copy)NSString * earnings;

/** 总计跟单人次 */
@property(nonatomic,copy)NSString * totalFollowCount;

/** 总计获取佣金 */
@property(nonatomic,copy)NSString * totalCommission;

/** 总计跟单金额*/
@property(nonatomic,copy)NSString *totalFollowCost;

/** 跟单列表*/
@property(nonatomic,copy)NSArray <FollowListModel *>  *followListDtos;

/** 方案类型 (自购,合买, 追号, 推荐，　发起跟单，　跟单) */
@property(nonatomic,copy)NSString * schemeType;

/** 发单是否有红包 */
@property(nonatomic,copy)NSString * hasRedPacket;

/** 红包完成状态 */
@property(nonatomic,copy)NSString * completeStatus;

/** 是否领取 */
@property(nonatomic,copy)NSString *gainRedPacket;
/** 发单人卡号 */
@property(nonatomic,copy)NSString * initiateCardCode;
@property(nonatomic,copy)NSString * trSchemeWinningStatus;
/** 来源方案号 */
@property(nonatomic,copy)NSString * sourceSchemeNo;
/** 截期时间 */
@property(nonatomic,copy)NSString * deadLine;
@property(nonatomic,copy)NSString * trSchemeTicketStatus;
@property(nonatomic,copy)NSString * DXF;
@property(nonatomic,copy)NSString * hilo;
@property(nonatomic,copy)NSString * RFSF;
@property(nonatomic,copy)NSString * SF;
@property(nonatomic,copy)NSString * SFC;
@property(nonatomic,copy)NSString * trSchemeStatus;
@property(nonatomic,copy)NSString * trLottery;
@property(nonatomic,copy)NSString * trCostType;

/** 小哥名称*/
@property(nonatomic,copy)NSString *  legName;
/** 跑腿费 */
@property(nonatomic,copy)NSString *  legCost;
/** 小哥微信号*/
@property(nonatomic,copy)NSString *  legWechatId;
/** 小哥电话号*/
@property(nonatomic,copy)NSString *  legMobile;
/** 小哥支付宝号*/
@property(nonatomic,copy)NSString *  legAlipay;

//小哥id
@property(nonatomic,copy)NSString * postboyId;


-(NSString *)getSchemeImgState;

-(NSString *)getSchemeState;
-(CGFloat)getJCZQCellHeight;
-(CGFloat )getGYJCellHeight;
-(NSString *)getLotteryByName;

-(BOOL)isHasLeg;
@end



@interface JCZQSchemeModel : BaseModel
@property(nonatomic,copy)NSString * currPage;
@property(nonatomic,copy)NSArray <JCZQSchemeItem *> * list;
@property(nonatomic,copy)NSString * pageSize;
@property(nonatomic,copy)NSString * totalCount;
@property(nonatomic,copy)NSString * totalPage;
@end




