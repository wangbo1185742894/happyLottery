//
//  OrderProfile.h
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotteryBetObj.h"

@interface OrderProfile : BaseModel

@property(nonatomic,copy)NSString * _id;
@property(nonatomic,copy)NSString * version;
@property(nonatomic,copy)NSString * trOrderStatus;
@property(nonatomic,copy)NSString * trBonus;
@property(nonatomic,copy)NSString * itemStatus;
@property(nonatomic,copy)NSString * trSumSub;
@property(nonatomic,copy)NSString * schemeNO;
@property(nonatomic,copy)NSString * lastModifyTime;
@property(nonatomic,copy)NSString * sumSub;
@property(nonatomic,copy)NSString * sumDraw;
@property(nonatomic,copy)NSString *leShanCode;
@property (nonatomic , strong) NSString *postboyId;  //小哥id
@property (nonatomic , strong) NSString * chaseSchemeNo;        // 追加
@property (nonatomic , strong) NSString * cardCode;         //
@property (nonatomic , strong) NSString * lotteryCode;      // 奖期
@property (nonatomic , strong) NSString * playType;      // 彩种
@property (nonatomic , strong) NSString * betType;      // 订单选号
@property (nonatomic , strong) NSString * catchContent;   // 订单状态
@property (nonatomic , strong) NSString * beginIssue;
@property (nonatomic , strong) NSString * totalCatch;       //订单金额
@property (nonatomic , strong) NSString * catchIndex;
@property (nonatomic , strong) NSString * winStopStatus;
@property (nonatomic , strong) NSString * channelCode;        // 出票点
@property (nonatomic , strong) NSString * winStatus;  // 开奖号
@property (nonatomic , strong) NSString * chaseStatus;          // 奖金
@property(nonatomic,strong)NSString *catchSchemeId;
@property(nonatomic,strong)NSString *trOpenResult;

@property (nonatomic , strong) NSString * addtional;        // 追加
@property (nonatomic , strong) NSString * cardtype;         //
@property (nonatomic , strong) NSString * issueNumber;      // 奖期
@property (nonatomic , strong) NSString * lotteryType;      // 彩种
@property (nonatomic , strong) NSString * orderNumber;      // 订单选号
@property (nonatomic , strong) NSString * orderStatus;   // 订单状态
@property (nonatomic , strong) NSString * orderTime;
@property (nonatomic , strong) NSString * orderbonus;       //订单金额
@property (nonatomic , strong) NSString * ordercount;
@property (nonatomic , strong) NSString * winningStatus;
@property (nonatomic , strong) NSString * orgName;        // 出票点
@property (nonatomic , strong) NSString * lotteryNumber;  // 开奖号
@property (nonatomic , strong) NSString * bonus;          // 奖金
@property (nonatomic , strong) NSString * betSource;          // 来源

//0924
//@property (nonatomic , strong) NSString * betSource;
//@property (nonatomic , strong) NSString * bonus;

@property (nonatomic , strong) NSString * catchStatus; //追号订单状态
@property (nonatomic , strong) NSString * catchType;
@property (nonatomic , strong) NSString * createTime;//下单时间
@property (nonatomic , strong) id ZHlotteryNumberDesc;
@property (nonatomic , strong) NSString * lottery;//x115
@property (nonatomic , strong) NSString * modifyTime;
@property (nonatomic , strong) NSString * orderBonus;//订单金额
//@property (nonatomic , strong) NSString * playType;
@property (nonatomic , strong) NSString * StopBonus;
@property (nonatomic , strong) NSString * catchResult;
//11.12
@property (nonatomic , strong) NSString * typebet;//！2=任选2  2=任选2胆拖 

@property (nonatomic , strong) NSString * catchplaytype;

//11.23
@property (nonatomic , strong) NSString * WINST;





@property (nonatomic , strong) NSString * multiple;
@property (nonatomic , strong) id  lotteryNumberDesc;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSString * iconName;
@property (nonatomic , strong) NSString * winningAppear;
@property (nonatomic , strong) NSString * stateAppear;

@property (nonatomic , strong) NSArray * betObjArray;
@property (nonatomic , strong) NSString * descToAppear;

//  竞彩
@property (nonatomic , strong) NSDictionary * lotteryNumberDic;  // 开奖号
@property (nonatomic , strong) NSDictionary * wonInfoDic;
@property (nonatomic , strong) NSString * passModel;
@property (nonatomic , strong) NSString * guanKaStatue;
@property (nonatomic , strong) NSDictionary * winDictionary;
@property (nonatomic , strong) NSString * passType;//过关方式
- (NSString *)playTypeAndGuanKa:(NSString *)valueCode;



@property(nonatomic) BOOL isHeMai; // 是否合买
@property(nonatomic) BOOL isZhuiHao; // 是否追号

-(void)setPropertys:(NSDictionary *)orderInfo;


// 10.16 追号详情
//@property (nonatomic , strong) NSString * bonus; //单条中奖金额
//@property (nonatomic , strong) NSString * catchIndex;  //追号期次
//@property (nonatomic , strong) NSString * catchStatus; //追号状态
//@property (nonatomic , strong) NSString * lotteryNumber; //开奖号码
@property (nonatomic , strong) NSString * payStatus ; //支付状态
@property (nonatomic , strong) NSString * subscription ;//每期追号定金
//@property (nonatomic , strong) NSString * winningStatus ;//中奖状态
@property (nonatomic , strong) NSString * mutiple;//倍数
@property (nonatomic , strong) NSString * units;//注数
@property (nonatomic , strong) NSString * openResult;//开奖号码
@property (nonatomic , strong) NSString * remark;//未支付原因
@property (nonatomic , strong) NSString * ticketRemark; // 当remark为空时候显示这个


/** 派奖时间  */
@property (nonatomic , strong) NSString * prizeTime;

/**  开奖时间  */
@property (nonatomic , strong) NSString * drawTime;

/** 开始出票时间  */
@property (nonatomic , strong) NSString * ticketTime;

/** 完成出票时间 */
@property (nonatomic , strong) NSString * commitTime;



@end
