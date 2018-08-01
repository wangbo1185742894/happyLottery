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
@property(nonatomic,copy)NSString * homeFullName;
@property(nonatomic,copy)NSString * homeName;
@property(nonatomic,copy)NSString * matchKey;
@property(nonatomic,copy)NSString * hot;
@property(nonatomic,copy)NSString * guestFullName;
@property(nonatomic,copy)NSString * lineId;
@property(nonatomic,copy)NSString * openFlag;
@property(nonatomic,copy)NSString * matchDate;
@property(nonatomic,copy)NSString * guestName;
@property(nonatomic,copy)NSString * remark;
@property(nonatomic,copy)NSString * stopBuyTime;
@property(nonatomic,copy)NSString * handicap;
@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * leagueId;
@property(nonatomic,copy)NSString * leagueName;

@property(nonatomic,strong)NSArray *SPF_OddArray;
@property(nonatomic,strong)NSArray *RQSPF_OddArray;
@property(nonatomic,strong)NSArray *JQS_OddArray;
@property(nonatomic,strong)NSArray *BQC_OddArray;
@property(nonatomic,strong)NSArray *BF_OddArray;

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
@property(assign,nonatomic)BOOL isShow;

@property (nonatomic,strong)NSMutableArray *matchBetArray;
@property(nonatomic,strong)HomeYCModel *ycModel;

/*
 一场赛事5个玩法 对应 每个玩法4种状态 0 1 2 3
 
 00000  第一位是 spf  第二位jqs     第三位 bf 第四位 bqc  第五位 rqspf
 
 0是单关双关都可以投注  1是 过关不能投注  2 是单关不能投注 3 是单过都不行
 
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
