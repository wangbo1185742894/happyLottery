//
//  JCZQMatchModel.h
//  happyLottery
//
//  Created by 王博 on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeYCModel.h"

@interface JCZQMatchModel : BaseModel

@property(nonatomic,copy)NSString * _id;
/** 主队全称 */
@property(nonatomic,copy)NSString * homeFullName;

/** 主队简称 */
@property(nonatomic,copy)NSString * homeName;

/** 赛事编号 */
@property(nonatomic,copy)NSString * matchKey;

/** 是否热点赛事 */
@property(nonatomic,copy)NSString * hot;

/**  客队全称 */
@property(nonatomic,copy)NSString * guestFullName;

/** 赛事序号 */
@property(nonatomic,copy)NSString * lineId;

/** 玩法的支持标志(0 单过关开售,1过关停售,2单关停售,3单过关停售.) */
@property(nonatomic,copy)NSString * openFlag;

/** 赛事日期 */
@property(nonatomic,copy)NSString * matchDate;

/** 客队简称 */
@property(nonatomic,copy)NSString * guestName;

@property(nonatomic,copy)NSString * remark;

/** 赛事截至销售时间 */
@property(nonatomic,copy)NSString * stopBuyTime;

/** 让球数 */
@property(nonatomic,copy)NSString * handicap;

/** 赛事开始时间 */
@property(nonatomic,copy)NSString * startTime;

/** 赛事状态(0=正常,1=结束,2=取消) */
@property(nonatomic,copy)NSString * status;

/** 所属的联赛ID */
@property(nonatomic,copy)NSString * leagueId;

@property(nonatomic,copy)NSString * leagueName;

//各玩法赔率
@property(nonatomic,strong)NSArray *SPF_OddArray;
@property(nonatomic,strong)NSArray *RQSPF_OddArray;
@property(nonatomic,strong)NSArray *JQS_OddArray;
@property(nonatomic,strong)NSArray *BQC_OddArray;
@property(nonatomic,strong)NSArray *BF_OddArray;

//各玩法赔率变化（未用）
@property(nonatomic,strong)NSArray *SPF_ChangeArray;
@property(nonatomic,strong)NSArray *RQSPF_ChangeArray;
@property(nonatomic,strong)NSArray *JQS_ChangeArray;
@property(nonatomic,strong)NSArray *BQC_ChangeArray;
@property(nonatomic,strong)NSArray *BF_ChangeArray;


@property(nonatomic,strong)NSMutableArray *SPF_SelectMatch;
@property(nonatomic,strong)NSMutableArray *RQSPF_SelectMatch;
@property(nonatomic,strong)NSMutableArray *JQS_SelectMatch;
@property(nonatomic,strong)NSMutableArray *BQC_SelectMatch;
@property(nonatomic,strong)NSMutableArray *BF_SelectMatch;
@property(nonatomic,assign)BOOL isDanGuan;
@property(nonatomic,assign)BOOL isSelect;

//各玩法赔率选择
@property (nonatomic , strong) NSString * odd_SPF_Select;
@property (nonatomic , strong) NSString * odd_RQSPF_Select;
@property (nonatomic , strong) NSString * odd_BF_Select;
@property (nonatomic , strong) NSString * odd_JQS_Select;
@property (nonatomic , strong) NSString * odd_BQC_Select;
@property (nonatomic , strong) NSArray * odd_max_zuhe_HHGG;


@property (nonatomic , strong) NSString * odd_SPF_Select_min;
@property (nonatomic , strong) NSString * odd_RQSPF_Select_min;
@property (nonatomic , strong) NSString * odd_BF_Select_min;
@property (nonatomic , strong) NSString * odd_JQS_Select_min;
@property (nonatomic , strong) NSString * odd_BQC_Select_min;

@property (nonatomic , strong) NSArray * odd_min_zuhe_HHGG;
@property(assign,nonatomic)BOOL isShow;  //预测信息是否可见

@property (nonatomic,strong)NSMutableArray *matchBetArray;
@property(nonatomic,strong)HomeYCModel *ycModel;

/*
 
 openFlag
 
 一场赛事5个玩法 对应 每个玩法4种状态 0 1 2 3
 
 0是单关双关都可以投注  1是 过关不能投注  2 是单关不能投注 3 是单过都不行
 
 00000  第一位是 spf  第二位jqs     第三位 bf 第四位 bqc  第五位 rqspf
 
 01230  这样就表示该场赛事 spf 过关和单关都能投注 jqs 过关不能投注 bf单关不能投注 bqc单关过关都不能投注 rqspf都可以
 */

-(id)initWith:(NSDictionary*)dic;

-(void)cleanAll;

-(NSInteger)selectItemNum;

-(NSInteger)getSinglePlayTypeNum:(NSArray *)itemArray;

-(NSString *)getTouzhuAppearTitleByTypeAndSp:(NSString *)type;

-(NSString *)getTouzhuAppearTitleByTypeNoSp:(NSString *)type;

-(CGFloat)getHeight;

-(void)refreshPrize;

-(CGFloat)getSpByMatchBet:(NSString *)bet;

-(NSString *)getBounsAppearTitleByTypeAndSp:(NSString *)type;
@end
