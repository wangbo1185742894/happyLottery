//
//  Lottery.h
//  Lottery
//
//  Created by AMP on 5/15/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotteryXHProfile.h"
#import "LotteryRound.h"

typedef enum {
    //大乐透
    LotteryTypeDaLeTou = 0,
    //七星彩
    LotteryTypeQiXingCai = 1,
    //排列三
    LotteryTypePaiLieSan = 2,
    //排列五
    LotteryTypePaiLieWu = 3,
    //11 选 5
    LotteryTypeShiYiXuanWu = 4,
    //足球彩票
    LotteryTypeFootBall = 5,
    //竞彩足球
    LotteryTypeJingCaiFootBall = 9,/*1007->9*/
    //竞彩篮球
    LotteryTypeJingCaiBasketball = 10,
    //冠军
    LotteryTypeJingCaiGuanJun = 11,
    //冠亚军
    LotteryTypeJingCaiGuanYaJun = 12,
} LotteryType;

@interface Lottery : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarPictureName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ruleDesc;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *needSectionRandom;
@property (nonatomic, strong) NSNumber *danTuo;
@property LotteryType type;
@property (nonatomic, strong) NSNumber *active;
@property (nonatomic, strong) NSString *dateSectionLinkSymbol;
//a set of LotteryNumber
@property (nonatomic, strong) NSArray *profiles;
@property (nonatomic, strong) LotteryXHProfile *activeProfile;


// x115 趋势图显示的profile
@property (nonatomic, strong) LotteryXHProfile *activeProfileForExtrend;

@property BOOL stoppedSelling;
@property (nonatomic, strong) LotteryRound *currentRound;
@property (nonatomic, strong) NSArray *allRoundsInfo;

@property (nonatomic, strong) NSString *orderNumber;

- (NSString *) textForTanTuoDesc;
@end
