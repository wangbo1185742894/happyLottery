//
//  JCZQSchemeModel.h
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"


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
@property(nonatomic,copy)NSMutableArray <OpenResult *> * trOpenResult;
@property(nonatomic,copy)NSString * trDltOpenResult;

@property(nonatomic,copy)NSString *virtualSp;
-(NSString *)getSchemeImgState;

-(NSString *)getSchemeState;
-(CGFloat)getJCZQCellHeight;
@end



@interface JCZQSchemeModel : BaseModel
@property(nonatomic,copy)NSString * currPage;
@property(nonatomic,copy)NSArray <JCZQSchemeItem *> * list;
@property(nonatomic,copy)NSString * pageSize;
@property(nonatomic,copy)NSString * totalCount;
@property(nonatomic,copy)NSString * totalPage;



@end




