//
//  BaseTransaction.h
//  Lottery
//
//  Created by 王博 on 17/4/12.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{//自购, 合买, 追号, 推荐
    SchemeTypeZigou = 0,
    SchemeTypeHemai = 1,
    SchemeTypeZhuihao = 2,
    SchemeTypeTuijian = 3
}SchemeType;
////方案保密类型(secretType  int  完全公开,开奖后公开,跟单人公开,完全保密   自购时不填写该值)
typedef enum{
  SecretTypeFullOpen = 0,
  SecretTypeOpenLotteryOpen = 1,
  SecretTypeFollowOpen=2,
  SecretTypeNoOpen = 3
}SecretType;

typedef enum{
    CostTypeSCORE = 0,
    CostTypeCASH
}CostType;


typedef enum{
    SchemeSourceBet = 0,
    SchemeSourceRECOMMEND,
    SchemeSourceFORECAST,
    SchemeSourceFORECAST_SCHEME,
    SchemeSourceFORECAST_SHORTCUT
}SchemeSource;

typedef enum : NSUInteger {
    JCZQPlayTypeGuoGuan = 0,
    JCZQPlayTypeDanGuan
} JCZQPlayType;



@interface BaseTransaction : NSObject

@property  (nonatomic,assign)   NSInteger betCost;
@property  (nonatomic,assign)   NSInteger betCount;

@property(nonatomic,assign)NSInteger units;

@property(assign,nonatomic)SchemeType schemeType;
@property (nonatomic,assign)NSInteger copies; // 总份数(copies int   自购的值为1)
@property (nonatomic,assign)NSInteger sponsorCopies; //  发起认购份数(sponsorCopies  int   自购的值为1)
@property (nonatomic,strong)NSString* betSource; //投注来源(betSource int  android ios)
@property (nonatomic,assign)SecretType secretType; // 方案保密类型(secretType  int  完全公开,开奖后公开,跟单人公开,完全保密   自购时不填写该值)
@property (nonatomic,assign)double baodiCost; // 保底金额(baodiCost BigDecimal自购或合买无保底时,不填写该值)
@property (nonatomic,assign)NSInteger baodiCopies; //保底份数(baodiCopies int  自购或合买无保底时,不填写该值)
@property (nonatomic,assign)double minSubCost;//单份认购金额(minSubCost BigDecimal 自购的值等于方案总金额)
@property (nonatomic,assign)double sponsorCost;//发起认购金额(sponsorCost   BigDecimal自购的值等于方案总金额)
@property (nonatomic,assign)double commissionRate;//方案发起人的提成率(commissionRate BigDecimal值应小于1  小于等于发起人认购的比例, 0表示没有提成, 自购可以不填写该值)
@property (nonatomic , strong) NSString * schemeVavleDtoList; //方案阈值设置(schemeVavleDtoList  String 没有可以不填写 具体见附录2)

@property(nonatomic,strong)NSDictionary * X115PlayType;
@property(nonatomic,assign)SchemeSource schemeSource;
@property(nonatomic,strong)NSArray *schemeTypes;
@property(nonatomic,strong)NSArray *secretTypes;
@property(nonatomic,assign)CostType costType;

@property (assign,nonatomic)CGFloat maxPrize;

-(NSMutableDictionary*)submitParaDicScheme;
- (id)lottDataScheme;

-(NSString *)getLotteryNumWithEnname:(NSString *)name;
@end
