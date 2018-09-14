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

@property(nonatomic,copy)NSString * betContent;
@property(nonatomic,copy)NSString * betCost;
@property(nonatomic,copy)NSString * units;
@property(nonatomic,copy)NSString * multiple;
@property(nonatomic,copy)NSString * issueNumber;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * lottery;
@property(nonatomic,copy)NSString * costType;
@property(nonatomic,copy)NSString * winningStatus;
@property(nonatomic,copy)NSString * ticketStatus;
@property(nonatomic,copy)NSString * schemeNO;
@property(nonatomic,copy)NSString * won;
@property(nonatomic,copy)NSString * lotteryIcon;
@property(nonatomic,copy)NSString * ticketCount;
@property(nonatomic,copy)NSString * printCount;
@property(nonatomic,copy)NSString * schemeStatus;
@property(nonatomic,copy)NSString * bonus;
@property(nonatomic,copy)NSString * finished;
@property(nonatomic,copy)NSString * deduction;
@property(nonatomic,copy)NSString * cardCode;
@property(nonatomic,copy)NSString * realSubAmounts;
@property(nonatomic,copy)NSString * useCoupon;
@property(nonatomic,copy)NSString * finishedTime;
@property(nonatomic,copy)NSString * subTime;
@property(nonatomic ,copy)NSString *ticketFailRef;
@property(nonatomic,copy)NSMutableArray <OpenResult *> * trOpenResult;
@property(nonatomic,copy)NSString * trDltOpenResult;
@property(nonatomic,copy)NSString * winMatchIndex;

@property(nonatomic,copy)NSString *virtualSp;
@property(nonatomic,copy)NSString * schemeSource;
@property(nonatomic,copy)NSString * originalContent;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString *drawCount;//开奖订单数
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

/** 方案类型 BUY_INITIATE  BUY_FOLLOW*/   
@property(nonatomic,copy)NSString * schemeType;

/** 发单是否有红包 */
@property(nonatomic,copy)NSString * hasRedPacket;

/** 红包完成状态 */
@property(nonatomic,copy)NSString * completeStatus;

/** 是否领取 */
@property(nonatomic,copy)NSString *gainRedPacket;

@property(nonatomic,copy)NSString * initiateCardCode;
@property(nonatomic,copy)NSString * trSchemeWinningStatus;
@property(nonatomic,copy)NSString * sourceSchemeNo;
@property(nonatomic,copy)NSString * trSchemeTicketStatus;
@property(nonatomic,copy)NSString * DXF;
@property(nonatomic,copy)NSString * hilo;
@property(nonatomic,copy)NSString * RFSF;
@property(nonatomic,copy)NSString * SF;
@property(nonatomic,copy)NSString * SFC;
@property(nonatomic,copy)NSString * trSchemeStatus;
@property(nonatomic,copy)NSString * trLottery;
@property(nonatomic,copy)NSString * trCostType;


-(NSString *)getSchemeImgState;

-(NSString *)getSchemeState;
-(CGFloat)getJCZQCellHeight;
-(CGFloat )getGYJCellHeight;
-(NSString *)getLotteryByName;
@end



@interface JCZQSchemeModel : BaseModel
@property(nonatomic,copy)NSString * currPage;
@property(nonatomic,copy)NSArray <JCZQSchemeItem *> * list;
@property(nonatomic,copy)NSString * pageSize;
@property(nonatomic,copy)NSString * totalCount;
@property(nonatomic,copy)NSString * totalPage;
@end




